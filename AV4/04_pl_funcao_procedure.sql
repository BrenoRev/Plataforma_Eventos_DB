-- Função e procedure avulsas. Rodar depois do 01_sql_ddl_dml.sql.
-- A função é usada pela package do script 05, então este script vem antes.


-- fn_ingressos_disponiveis: pergunta 22 do minimundo.
-- Quantos ingressos de uma oferta ainda não foram vendidos.
-- Se a oferta não existe, o SELECT com GROUP BY não devolve linha e cai no
-- NO_DATA_FOUND. Pode ser chamada de dentro de um SELECT (script 07).
CREATE OR REPLACE FUNCTION fn_ingressos_disponiveis (
    p_id_evento IN Oferta.id_evento%TYPE,
    p_id_setor  IN Oferta.id_setor%TYPE,
    p_id_lote   IN Oferta.id_lote%TYPE
) RETURN NUMBER
IS
    v_disponiveis NUMBER;
BEGIN
    SELECT COUNT(i.num_ingresso) - COUNT(i.id_pedido)
      INTO v_disponiveis
      FROM Oferta o
      LEFT JOIN Ingresso i
        ON i.id_evento = o.id_evento AND i.id_setor = o.id_setor AND i.id_lote = o.id_lote
     WHERE o.id_evento = p_id_evento
       AND o.id_setor  = p_id_setor
       AND o.id_lote   = p_id_lote
     GROUP BY o.id_evento, o.id_setor, o.id_lote;

    RETURN v_disponiveis;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Oferta inexistente (evento ' || p_id_evento
                                || ', setor ' || p_id_setor || ', lote ' || p_id_lote || ')');
END fn_ingressos_disponiveis;
/


-- pr_relatorio_evento: relatório 3 do minimundo para um evento.
-- Imprime os dados do evento e, para cada oferta, emitidos, vendidos, receita
-- e a situação da oferta.
CREATE OR REPLACE PROCEDURE pr_relatorio_evento (
    p_id_evento IN Evento.id_evento%TYPE
)
IS
    v_evento    Evento%ROWTYPE;
    v_local     Endereco%ROWTYPE;
    v_criador   VARCHAR2(200);
    v_pct       NUMBER(5,1);
    v_situacao  VARCHAR2(20);
    v_vendidos  NUMBER := 0;
    v_receita   NUMBER := 0;

    CURSOR c_ofertas IS
        SELECT s.nome                    AS setor,
               l.nome                    AS lote,
               o.preco,
               COUNT(i.num_ingresso)     AS emitidos,
               COUNT(i.id_pedido)        AS vendidos,
               NVL(SUM(i.preco_pago), 0) AS receita
          FROM Oferta o
          JOIN Setor s ON s.id_setor = o.id_setor
          JOIN Lote  l ON l.id_lote  = o.id_lote
          LEFT JOIN Ingresso i
            ON i.id_evento = o.id_evento AND i.id_setor = o.id_setor AND i.id_lote = o.id_lote
         WHERE o.id_evento = p_id_evento
         GROUP BY s.nome, l.nome, l.ordem, o.preco
         ORDER BY l.ordem, s.nome;
BEGIN
    SELECT * INTO v_evento FROM Evento   WHERE id_evento = p_id_evento;
    SELECT * INTO v_local  FROM Endereco WHERE cep = v_evento.cep;

    SELECT COALESCE(em.nome, u.primeiro_nome || ' ' || u.sobrenome)
      INTO v_criador
      FROM Criador c
      LEFT JOIN Empresa  em ON em.id_criador = c.id_criador
      LEFT JOIN Produtor pr ON pr.id_criador = c.id_criador
      LEFT JOIN Usuario  u  ON u.cpf         = pr.cpf
     WHERE c.id_criador = v_evento.id_criador;

    DBMS_OUTPUT.PUT_LINE('=== ' || v_evento.nome || ' ===');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_evento.dt_realizacao, 'DD/MM/YYYY') || ' | '
                         || v_local.cidade || '/' || v_local.uf || ' | ' || v_evento.status);
    DBMS_OUTPUT.PUT_LINE('Criador: ' || v_criador);

    FOR r IN c_ofertas LOOP
        IF r.emitidos = 0 THEN
            v_pct := 0;
        ELSE
            v_pct := ROUND(100 * r.vendidos / r.emitidos, 1);
        END IF;

        CASE
            WHEN r.emitidos = 0 THEN
                v_situacao := 'SEM INGRESSOS';
            WHEN r.vendidos = r.emitidos THEN
                v_situacao := 'ESGOTADA';
            WHEN v_evento.status <> 'ATIVO' AND v_pct < 50 THEN
                v_situacao := 'ENCALHADA';
            WHEN v_evento.status <> 'ATIVO' THEN
                v_situacao := 'VENDA PARCIAL';
            WHEN v_pct >= 70 THEN
                v_situacao := 'QUASE ESGOTADA';
            ELSE
                v_situacao := 'EM VENDA';
        END CASE;

        DBMS_OUTPUT.PUT_LINE('  ' || RPAD(r.setor || ' / ' || r.lote, 32)
                             || ' R$ ' || LPAD(TO_CHAR(r.preco, 'FM9990.00'), 8)
                             || ' | ' || LPAD(r.vendidos, 3) || '/' || RPAD(r.emitidos, 3)
                             || ' (' || LPAD(TO_CHAR(v_pct, 'FM990.0'), 5) || '%) | '
                             || v_situacao);

        v_vendidos := v_vendidos + r.vendidos;
        v_receita  := v_receita + r.receita;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  Total: ' || v_vendidos || ' ingressos vendidos, receita R$ '
                         || TO_CHAR(v_receita, 'FM999G990D00'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Evento ' || p_id_evento || ' nao encontrado.');
END pr_relatorio_evento;
/
