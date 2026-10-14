-- Testes da parte PL. Rodar depois do 06_pl_triggers.sql, como script inteiro.
--
-- Cada bloco anônimo usa os objetos dos scripts 04 a 06 e imprime o resultado
-- com DBMS_OUTPUT. O teste 5 segue o padrão do 04_teste_restricoes.sql da AV3:
-- cada linha começa com OK quando o erro esperado aconteceu e FALHA quando não.


-- Teste 1. Emissão dos ingressos do Segundo Lote do Réveillon
-- As 3 ofertas foram criadas pelo INSERT com SELECT do script 01, ainda sem
-- ingressos. A quantidade depende do setor.
DECLARE
    v_qtd PLS_INTEGER;
BEGIN
    FOR o IN (SELECT o.id_evento, o.id_setor, o.id_lote, s.nome AS setor
                FROM Oferta o
                JOIN Evento e ON e.id_evento = o.id_evento
                JOIN Setor  s ON s.id_setor  = o.id_setor
                JOIN Lote   l ON l.id_lote   = o.id_lote
               WHERE e.nome = 'Réveillon Orla de Boa Viagem 2027'
                 AND l.nome = 'Segundo Lote'
               ORDER BY s.nome)
    LOOP
        v_qtd := CASE o.setor
                     WHEN 'Pista'         THEN 30
                     WHEN 'Pista Premium' THEN 12
                     ELSE 8
                 END;
        pkg_vendas.emitir_ingressos(o.id_evento, o.id_setor, o.id_lote, v_qtd);
        DBMS_OUTPUT.PUT_LINE('Emitidos ' || v_qtd || ' ingressos: ' || o.setor || ' / Segundo Lote');
    END LOOP;
END;
/


-- Teste 2. Compra em duas etapas no mesmo pedido
-- Yasmin (inserida no script 01) compra 2 Pista e depois acrescenta 1 VIP ao
-- mesmo pedido. Na primeira chamada v_pedido vai nulo e volta preenchido
-- (parâmetro IN OUT); na segunda vai preenchido.
DECLARE
    v_evento  Evento.id_evento%TYPE;
    v_pista   Setor.id_setor%TYPE;
    v_vip     Setor.id_setor%TYPE;
    v_lote    Lote.id_lote%TYPE;
    v_pedido  Pedido.id_pedido%TYPE;
    v_valor   NUMBER;
BEGIN
    SELECT id_evento INTO v_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027';
    SELECT id_setor  INTO v_pista  FROM Setor  WHERE nome = 'Pista';
    SELECT id_setor  INTO v_vip    FROM Setor  WHERE nome = 'VIP';
    SELECT id_lote   INTO v_lote   FROM Lote   WHERE nome = 'Segundo Lote';

    pkg_vendas.realizar_compra('52816049372', v_evento, v_pista, v_lote, 2, 'PIX', v_pedido, v_valor);
    DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido || ' criado: 2 x Pista = R$ ' || v_valor);

    pkg_vendas.realizar_compra('52816049372', v_evento, v_vip, v_lote, 1, 'CARTAO_CREDITO', v_pedido, v_valor);
    DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido || ' recebeu: 1 x VIP = R$ ' || v_valor);

    DBMS_OUTPUT.PUT_LINE('Total do pedido: R$ ' || pkg_vendas.valor_pedido(v_pedido));
    -- Esperado: 2 x 400 + 1 x 1130 = 1930
END;
/


-- Teste 3. Histórico de compras (RECORD e TABLE da package)
-- Esperado para Henrique Duarte: 3 pedidos, 24 ingressos, R$ 3410,00.
DECLARE
    v_compras  pkg_vendas.t_tab_compras;
    v_compra   pkg_vendas.t_compra;
    v_total    NUMBER := 0;
    v_qtd      PLS_INTEGER := 0;
BEGIN
    pkg_vendas.historico_cliente('75430918246', v_compras);

    DBMS_OUTPUT.PUT_LINE('Compras de Henrique Duarte:');
    FOR i IN 1 .. v_compras.COUNT LOOP
        v_compra := v_compras(i);
        DBMS_OUTPUT.PUT_LINE('  ' || TO_CHAR(v_compra.dt_pedido, 'DD/MM/YYYY')
                             || ' | pedido ' || v_compra.id_pedido
                             || ' | ' || RPAD(v_compra.nome_evento, 30)
                             || ' | ' || LPAD(v_compra.ingressos, 2) || ' ingressos'
                             || ' | R$ ' || v_compra.valor);
        v_total := v_total + v_compra.valor;
        v_qtd   := v_qtd + v_compra.ingressos;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('  ' || v_compras.COUNT || ' pedidos, ' || v_qtd || ' ingressos, R$ ' || v_total);
END;
/


-- Teste 4. Relatório de evento (procedure avulsa)
-- Um evento encerrado, o Réveillon com o lote novo e um id que não existe.
DECLARE
    v_id Evento.id_evento%TYPE;
BEGIN
    SELECT id_evento INTO v_id FROM Evento WHERE nome = 'Festival Maré Viva 2025';
    pr_relatorio_evento(v_id);
    DBMS_OUTPUT.PUT_LINE('');

    SELECT id_evento INTO v_id FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027';
    pr_relatorio_evento(v_id);
    DBMS_OUTPUT.PUT_LINE('');

    pr_relatorio_evento(-1);
END;
/


-- Teste 5. Operações que têm que ser recusadas
-- No fim confere que nenhuma compra recusada deixou pedido gravado.
DECLARE
    v_reveillon  Evento.id_evento%TYPE;
    v_mare       Evento.id_evento%TYPE;
    v_copa       Evento.id_evento%TYPE;
    v_pista      Setor.id_setor%TYPE;
    v_camarote   Setor.id_setor%TYPE;
    v_arquib     Setor.id_setor%TYPE;
    v_lote2      Lote.id_lote%TYPE;
    v_ped_yasmin Pedido.id_pedido%TYPE;
    v_pedido     Pedido.id_pedido%TYPE;
    v_valor      NUMBER;
    v_antes      PLS_INTEGER;
    v_depois     PLS_INTEGER;

    -- Imprime só a primeira linha do erro; erros vindos de trigger trazem
    -- também a pilha (ORA-06512) nas linhas seguintes.
    PROCEDURE resultado (p_teste IN VARCHAR2, p_esperado IN NUMBER, p_code IN NUMBER, p_msg IN VARCHAR2) IS
        v_msg VARCHAR2(200) := SUBSTR(p_msg, 1, INSTR(p_msg || CHR(10), CHR(10)) - 1);
    BEGIN
        IF p_code = p_esperado THEN
            DBMS_OUTPUT.PUT_LINE('OK    | ' || p_teste || ' | ' || v_msg);
        ELSE
            DBMS_OUTPUT.PUT_LINE('FALHA | ' || p_teste || ' | erro inesperado: ' || v_msg);
        END IF;
    END resultado;

    PROCEDURE aceito (p_teste IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FALHA | ' || p_teste || ' | o comando foi aceito');
    END aceito;
BEGIN
    SELECT id_evento INTO v_reveillon FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027';
    SELECT id_evento INTO v_mare      FROM Evento WHERE nome = 'Festival Maré Viva 2025';
    SELECT id_evento INTO v_copa      FROM Evento WHERE nome = 'Copa Nordeste de Futevôlei';
    SELECT id_setor  INTO v_pista     FROM Setor  WHERE nome = 'Pista';
    SELECT id_setor  INTO v_camarote  FROM Setor  WHERE nome = 'Camarote';
    SELECT id_setor  INTO v_arquib    FROM Setor  WHERE nome = 'Arquibancada';
    SELECT id_lote   INTO v_lote2     FROM Lote   WHERE nome = 'Segundo Lote';
    SELECT MAX(id_pedido) INTO v_ped_yasmin FROM Pedido WHERE cpf_usuario = '52816049372';
    SELECT COUNT(*) INTO v_antes FROM Pedido;

    -- 01: mais ingressos do que a oferta tem livres
    BEGIN
        v_pedido := NULL;
        pkg_vendas.realizar_compra('36705298414', v_reveillon, v_pista, v_lote2, 100, 'PIX', v_pedido, v_valor);
        aceito('01 compra acima do estoque');
    EXCEPTION
        WHEN pkg_vendas.e_estoque_insuficiente THEN
            DBMS_OUTPUT.PUT_LINE('OK    | 01 compra acima do estoque | pkg_vendas.e_estoque_insuficiente');
        WHEN OTHERS THEN
            resultado('01 compra acima do estoque', 1, SQLCODE, SQLERRM);
    END;

    -- 02: evento encerrado; o pedido chega a ser criado e o trigger desfaz a venda
    BEGIN
        v_pedido := NULL;
        pkg_vendas.realizar_compra('36705298414', v_mare, v_pista, v_lote2, 1, 'PIX', v_pedido, v_valor);
        aceito('02 compra em evento encerrado (trg_ingresso_venda)');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('02 compra em evento encerrado (trg_ingresso_venda)', -20031, SQLCODE, SQLERRM);
    END;

    -- 03: oferta que não existe (o Réveillon não tem Camarote)
    BEGIN
        v_pedido := NULL;
        pkg_vendas.realizar_compra('36705298414', v_reveillon, v_camarote, v_lote2, 1, 'PIX', v_pedido, v_valor);
        aceito('03 oferta inexistente (fn_ingressos_disponiveis)');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('03 oferta inexistente (fn_ingressos_disponiveis)', -20010, SQLCODE, SQLERRM);
    END;

    -- 04: acrescentar ingresso no pedido de outra pessoa
    BEGIN
        v_pedido := v_ped_yasmin;
        pkg_vendas.realizar_compra('36705298414', v_reveillon, v_pista, v_lote2, 1, 'PIX', v_pedido, v_valor);
        aceito('04 compra no pedido de outro usuario');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('04 compra no pedido de outro usuario', -20022, SQLCODE, SQLERRM);
    END;

    -- 05: evento cancelado; cancela a Copa só para o teste e depois reativa
    UPDATE Evento SET status = 'CANCELADO' WHERE id_evento = v_copa;
    BEGIN
        v_pedido := NULL;
        pkg_vendas.realizar_compra('36705298414', v_copa, v_arquib, v_lote2, 1, 'PIX', v_pedido, v_valor);
        aceito('05 compra em evento cancelado (trg_ingresso_venda)');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('05 compra em evento cancelado (trg_ingresso_venda)', -20030, SQLCODE, SQLERRM);
    END;
    UPDATE Evento SET status = 'ATIVO' WHERE id_evento = v_copa;

    -- 06: venda por UPDATE direto, sem passar pela package
    BEGIN
        UPDATE Ingresso
           SET id_pedido = v_ped_yasmin
         WHERE id_evento = v_mare
           AND id_pedido IS NULL
           AND ROWNUM = 1;
        aceito('06 UPDATE direto em ingresso de evento encerrado');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('06 UPDATE direto em ingresso de evento encerrado', -20031, SQLCODE, SQLERRM);
    END;

    -- 07: excluir pedido
    BEGIN
        DELETE FROM Pedido WHERE id_pedido = v_ped_yasmin;
        aceito('07 exclusao de pedido (trg_pedido_sem_exclusao)');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('07 exclusao de pedido (trg_pedido_sem_exclusao)', -20040, SQLCODE, SQLERRM);
    END;

    -- 08: quantidade zero
    BEGIN
        v_pedido := NULL;
        pkg_vendas.realizar_compra('36705298414', v_reveillon, v_pista, v_lote2, 0, 'PIX', v_pedido, v_valor);
        aceito('08 compra com quantidade zero');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('08 compra com quantidade zero', -20020, SQLCODE, SQLERRM);
    END;

    -- 09: emitir ingresso para evento encerrado
    BEGIN
        pkg_vendas.emitir_ingressos(v_mare, v_pista, v_lote2, 10);
        aceito('09 emissao em evento encerrado');
    EXCEPTION
        WHEN OTHERS THEN
            resultado('09 emissao em evento encerrado', -20011, SQLCODE, SQLERRM);
    END;

    SELECT COUNT(*) INTO v_depois FROM Pedido;
    IF v_antes = v_depois THEN
        DBMS_OUTPUT.PUT_LINE('OK    | nenhum pedido ficou gravado pelas compras recusadas (' || v_depois || ' pedidos)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FALHA | pedidos antes: ' || v_antes || ', depois: ' || v_depois);
    END IF;
END;
/


-- Teste 6. Trigger de linha x trigger de comando
-- Reajuste de 10% nas 4 ofertas do Festival de Jazz com um único UPDATE.
-- Esperado: 4 linhas novas em Historico_Preco e 1 em Log_Operacao.
DECLARE
    v_hist_antes  PLS_INTEGER;
    v_log_antes   PLS_INTEGER;
    v_hist_depois PLS_INTEGER;
    v_log_depois  PLS_INTEGER;
    v_linhas      PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_hist_antes FROM Historico_Preco;
    SELECT COUNT(*) INTO v_log_antes  FROM Log_Operacao;

    UPDATE Oferta
       SET preco = ROUND(preco * 1.10, 2)
     WHERE id_evento = (SELECT id_evento FROM Evento WHERE nome = 'Festival de Jazz de Salvador');
    v_linhas := SQL%ROWCOUNT;

    SELECT COUNT(*) INTO v_hist_depois FROM Historico_Preco;
    SELECT COUNT(*) INTO v_log_depois  FROM Log_Operacao;

    DBMS_OUTPUT.PUT_LINE('Ofertas reajustadas: ' || v_linhas);
    DBMS_OUTPUT.PUT_LINE('trg_oferta_historico_preco (linha):  ' || (v_hist_depois - v_hist_antes) || ' registros');
    DBMS_OUTPUT.PUT_LINE('trg_oferta_log (comando):            ' || (v_log_depois - v_log_antes) || ' registro');
END;
/


-- Conferência do que os triggers gravaram
SELECT e.nome AS evento, s.nome AS setor, l.nome AS lote,
       h.preco_antigo, h.preco_novo, h.dt_alteracao
  FROM Historico_Preco h
  JOIN Evento e ON e.id_evento = h.id_evento
  JOIN Setor  s ON s.id_setor  = h.id_setor
  JOIN Lote   l ON l.id_lote   = h.id_lote
 ORDER BY h.id_historico;

SELECT id_log, tabela, operacao, usuario_bd, dt_operacao
  FROM Log_Operacao
 ORDER BY id_log;

-- Pergunta 22 com a função dentro do SELECT: ingressos livres das ofertas
-- de eventos que ainda estão vendendo.
SELECT e.nome AS evento, s.nome AS setor, l.nome AS lote, o.preco,
       fn_ingressos_disponiveis(o.id_evento, o.id_setor, o.id_lote) AS disponiveis
  FROM Oferta o
  JOIN Evento e ON e.id_evento = o.id_evento
  JOIN Setor  s ON s.id_setor  = o.id_setor
  JOIN Lote   l ON l.id_lote   = o.id_lote
 WHERE e.status = 'ATIVO'
 ORDER BY e.dt_realizacao, l.ordem, s.nome;

COMMIT;
