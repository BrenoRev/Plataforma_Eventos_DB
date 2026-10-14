-- Package de vendas. Rodar depois do 04_pl_funcao_procedure.sql.
--
-- Reúne o que a aplicação precisa para vender: emitir ingressos de uma oferta,
-- registrar a compra e consultar pedidos. Na AV3 a venda era feita por
-- procedures locais do script de povoamento; aqui ela vira um objeto do banco.


CREATE OR REPLACE PACKAGE pkg_vendas AS

    -- Uma linha do histórico de compras de um cliente: um pedido em um evento.
    TYPE t_compra IS RECORD (
        id_pedido  Pedido.id_pedido%TYPE,
        dt_pedido  Pedido.dt_realizacao%TYPE,
        -- O campo não pode se chamar evento: o nome esconderia a tabela
        -- Evento e o %TYPE apontaria para o próprio campo (PLS-00320).
        nome_evento Evento.nome%TYPE,
        ingressos  PLS_INTEGER,
        valor      NUMBER(12,2)
    );

    TYPE t_tab_compras IS TABLE OF t_compra INDEX BY PLS_INTEGER;

    -- Fica na especificação para quem chama poder tratar pelo nome.
    e_estoque_insuficiente EXCEPTION;

    -- Emite p_qtd ingressos para a oferta, continuando a numeração do evento.
    PROCEDURE emitir_ingressos (
        p_id_evento IN Oferta.id_evento%TYPE,
        p_id_setor  IN Oferta.id_setor%TYPE,
        p_id_lote   IN Oferta.id_lote%TYPE,
        p_qtd       IN PLS_INTEGER
    );

    -- Vende p_qtd ingressos da oferta para o usuário.
    -- p_id_pedido (IN OUT): se vier nulo, cria um pedido novo e devolve o id;
    -- se vier preenchido, acrescenta os ingressos a esse pedido, o que permite
    -- um pedido com ingressos de setores diferentes.
    -- p_valor (OUT): quanto custaram os ingressos desta chamada.
    PROCEDURE realizar_compra (
        p_cpf       IN     Usuario.cpf%TYPE,
        p_id_evento IN     Oferta.id_evento%TYPE,
        p_id_setor  IN     Oferta.id_setor%TYPE,
        p_id_lote   IN     Oferta.id_lote%TYPE,
        p_qtd       IN     PLS_INTEGER,
        p_forma     IN     Forma_Pagamento.forma_pagamento%TYPE,
        p_id_pedido IN OUT Pedido.id_pedido%TYPE,
        p_valor     OUT    NUMBER
    );

    -- Valor total de um pedido. Devolve NULL se o pedido não existe.
    FUNCTION valor_pedido (p_id_pedido IN Pedido.id_pedido%TYPE) RETURN NUMBER;

    -- Pergunta 24: pedidos de um cliente, com evento, quantidade e valor.
    PROCEDURE historico_cliente (
        p_cpf     IN  Usuario.cpf%TYPE,
        p_compras OUT t_tab_compras
    );

END pkg_vendas;
/


CREATE OR REPLACE PACKAGE BODY pkg_vendas AS

    PROCEDURE emitir_ingressos (
        p_id_evento IN Oferta.id_evento%TYPE,
        p_id_setor  IN Oferta.id_setor%TYPE,
        p_id_lote   IN Oferta.id_lote%TYPE,
        p_qtd       IN PLS_INTEGER
    ) IS
        v_status   Evento.status%TYPE;
        v_ultimo   Ingresso.num_ingresso%TYPE;
        v_emitidos PLS_INTEGER := 0;
    BEGIN
        SELECT e.status
          INTO v_status
          FROM Oferta o
          JOIN Evento e ON e.id_evento = o.id_evento
         WHERE o.id_evento = p_id_evento
           AND o.id_setor  = p_id_setor
           AND o.id_lote   = p_id_lote;

        IF v_status <> 'ATIVO' THEN
            RAISE_APPLICATION_ERROR(-20011, 'Evento ' || v_status || ': nao e possivel emitir ingressos');
        ELSIF p_qtd IS NULL OR p_qtd <= 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Quantidade de emissao invalida: ' || p_qtd);
        END IF;

        SELECT NVL(MAX(num_ingresso), 0)
          INTO v_ultimo
          FROM Ingresso
         WHERE id_evento = p_id_evento;

        WHILE v_emitidos < p_qtd LOOP
            v_emitidos := v_emitidos + 1;
            INSERT INTO Ingresso (id_evento, num_ingresso, preco_pago, id_setor, id_lote, id_pedido)
            VALUES (p_id_evento, v_ultimo + v_emitidos, NULL, p_id_setor, p_id_lote, NULL);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Oferta inexistente (evento ' || p_id_evento
                                    || ', setor ' || p_id_setor || ', lote ' || p_id_lote || ')');
    END emitir_ingressos;


    PROCEDURE realizar_compra (
        p_cpf       IN     Usuario.cpf%TYPE,
        p_id_evento IN     Oferta.id_evento%TYPE,
        p_id_setor  IN     Oferta.id_setor%TYPE,
        p_id_lote   IN     Oferta.id_lote%TYPE,
        p_qtd       IN     PLS_INTEGER,
        p_forma     IN     Forma_Pagamento.forma_pagamento%TYPE,
        p_id_pedido IN OUT Pedido.id_pedido%TYPE,
        p_valor     OUT    NUMBER
    ) IS
        -- Ingressos livres da oferta, do menor número para o maior.
        -- FOR UPDATE trava as linhas para duas compras simultâneas não
        -- venderem o mesmo ingresso.
        CURSOR c_livres IS
            SELECT num_ingresso
              FROM Ingresso
             WHERE id_evento = p_id_evento
               AND id_setor  = p_id_setor
               AND id_lote   = p_id_lote
               AND id_pedido IS NULL
             ORDER BY num_ingresso
               FOR UPDATE;

        v_num         Ingresso.num_ingresso%TYPE;
        v_preco_pago  Ingresso.preco_pago%TYPE;
        v_dono        Pedido.cpf_usuario%TYPE;
        v_disponiveis NUMBER;
        v_usuario     PLS_INTEGER;
        v_ja_tem      PLS_INTEGER;
        v_vendidos    PLS_INTEGER := 0;
    BEGIN
        -- Se algo falhar no meio, volta até aqui e não fica pedido sem ingresso.
        SAVEPOINT sp_compra;
        p_valor := 0;

        SELECT COUNT(*) INTO v_usuario FROM Usuario WHERE cpf = p_cpf;
        v_disponiveis := fn_ingressos_disponiveis(p_id_evento, p_id_setor, p_id_lote);

        IF p_qtd IS NULL OR p_qtd <= 0 THEN
            RAISE_APPLICATION_ERROR(-20020, 'Quantidade invalida: ' || p_qtd);
        ELSIF v_usuario = 0 THEN
            RAISE_APPLICATION_ERROR(-20021, 'Usuario ' || p_cpf || ' nao cadastrado');
        ELSIF v_disponiveis < p_qtd THEN
            RAISE e_estoque_insuficiente;
        END IF;

        IF p_id_pedido IS NULL THEN
            INSERT INTO Pedido (id_pedido, dt_realizacao, cpf_usuario)
            VALUES (seq_pedido.NEXTVAL, SYSDATE, p_cpf)
            RETURNING id_pedido INTO p_id_pedido;

            INSERT INTO Forma_Pagamento (id_pedido, forma_pagamento)
            VALUES (p_id_pedido, p_forma);
        ELSE
            SELECT cpf_usuario INTO v_dono FROM Pedido WHERE id_pedido = p_id_pedido;
            IF v_dono <> p_cpf THEN
                RAISE_APPLICATION_ERROR(-20022, 'Pedido ' || p_id_pedido || ' pertence a outro usuario');
            END IF;

            SELECT COUNT(*) INTO v_ja_tem
              FROM Forma_Pagamento
             WHERE id_pedido = p_id_pedido AND forma_pagamento = p_forma;
            IF v_ja_tem = 0 THEN
                INSERT INTO Forma_Pagamento (id_pedido, forma_pagamento)
                VALUES (p_id_pedido, p_forma);
            END IF;
        END IF;

        -- Só o id_pedido é gravado. O trigger trg_ingresso_venda confere se o
        -- evento pode vender e preenche o preco_pago com o preço atual da oferta.
        OPEN c_livres;
        LOOP
            EXIT WHEN v_vendidos = p_qtd;
            FETCH c_livres INTO v_num;
            EXIT WHEN c_livres%NOTFOUND;

            UPDATE Ingresso
               SET id_pedido = p_id_pedido
             WHERE CURRENT OF c_livres;

            -- O Oracle não aceita RETURNING com WHERE CURRENT OF, então o
            -- preço gravado pelo trigger é lido de volta pela chave.
            SELECT preco_pago INTO v_preco_pago
              FROM Ingresso
             WHERE id_evento = p_id_evento AND num_ingresso = v_num;

            v_vendidos := v_vendidos + 1;
            p_valor    := p_valor + v_preco_pago;
        END LOOP;
        CLOSE c_livres;

        -- Outra sessão pode ter vendido entre a contagem e o cursor.
        IF v_vendidos < p_qtd THEN
            RAISE e_estoque_insuficiente;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            IF c_livres%ISOPEN THEN
                CLOSE c_livres;
            END IF;
            ROLLBACK TO sp_compra;
            RAISE;
    END realizar_compra;


    FUNCTION valor_pedido (p_id_pedido IN Pedido.id_pedido%TYPE) RETURN NUMBER IS
        v_total NUMBER(12,2);
    BEGIN
        SELECT NVL(SUM(i.preco_pago), 0)
          INTO v_total
          FROM Pedido p
          LEFT JOIN Ingresso i ON i.id_pedido = p.id_pedido
         WHERE p.id_pedido = p_id_pedido
         GROUP BY p.id_pedido;

        RETURN v_total;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END valor_pedido;


    PROCEDURE historico_cliente (
        p_cpf     IN  Usuario.cpf%TYPE,
        p_compras OUT t_tab_compras
    ) IS
        v_i PLS_INTEGER := 0;
    BEGIN
        FOR r IN (SELECT p.id_pedido,
                         p.dt_realizacao,
                         e.nome            AS evento,
                         COUNT(*)          AS ingressos,
                         SUM(i.preco_pago) AS valor
                    FROM Pedido p
                    JOIN Ingresso i ON i.id_pedido = p.id_pedido
                    JOIN Evento e   ON e.id_evento = i.id_evento
                   WHERE p.cpf_usuario = p_cpf
                   GROUP BY p.id_pedido, p.dt_realizacao, e.nome
                   ORDER BY p.dt_realizacao, p.id_pedido)
        LOOP
            v_i := v_i + 1;
            p_compras(v_i).id_pedido := r.id_pedido;
            p_compras(v_i).dt_pedido := r.dt_realizacao;
            p_compras(v_i).nome_evento := r.evento;
            p_compras(v_i).ingressos := r.ingressos;
            p_compras(v_i).valor     := r.valor;
        END LOOP;
    END historico_cliente;

END pkg_vendas;
/
