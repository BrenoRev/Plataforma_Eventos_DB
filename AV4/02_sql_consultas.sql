-- Consultas da AV4. Rodar depois do 01_sql_ddl_dml.sql.
--
-- Cada consulta responde a uma pergunta (seção 5) ou a um relatório (seção 6)
-- do minimundo. O cabeçalho diz qual é e quais itens do checklist SQL ela usa.


-- 1. Perguntas 1 e 2: quem indicou cada usuário cadastrado a partir de 2025,
-- em que data, e a idade do indicado.
-- Checklist: SELECT-FROM-WHERE (junção escrita no WHERE), ORDER BY
SELECT ind.primeiro_nome || ' ' || ind.sobrenome      AS usuario,
       TRUNC(MONTHS_BETWEEN(SYSDATE, ind.dt_nascimento) / 12) AS idade,
       quem.primeiro_nome || ' ' || quem.sobrenome    AS indicado_por,
       ind.dt_indicacao
  FROM Usuario ind, Usuario quem
 WHERE quem.cpf = ind.cpf_indicador
   AND ind.dt_cadastro >= DATE '2025-01-01'
 ORDER BY ind.dt_indicacao;


-- 2. Relatório 13: programa de indicação. Para cada indicador, quantos
-- indicados trouxe, quantos deles já compraram e quanto os indicados gastaram.
-- O LEFT JOIN mantém o indicado que nunca fez pedido.
-- Checklist: INNER JOIN, LEFT JOIN, COUNT, GROUP BY, ORDER BY
SELECT quem.primeiro_nome || ' ' || quem.sobrenome AS indicador,
       COUNT(DISTINCT ind.cpf)                     AS indicados,
       COUNT(DISTINCT p.cpf_usuario)               AS indicados_compradores,
       NVL(SUM(i.preco_pago), 0)                   AS receita_dos_indicados
  FROM Usuario quem
 INNER JOIN Usuario ind ON ind.cpf_indicador = quem.cpf
  LEFT JOIN Pedido p    ON p.cpf_usuario = ind.cpf
  LEFT JOIN Ingresso i  ON i.id_pedido   = p.id_pedido
 GROUP BY quem.cpf, quem.primeiro_nome, quem.sobrenome
 ORDER BY indicados DESC, receita_dos_indicados DESC;


-- 3. Relatório 8: receita por mês no primeiro semestre de 2026, pela data do pedido.
-- Checklist: BETWEEN, INNER JOIN, COUNT, GROUP BY, ORDER BY
SELECT TO_CHAR(p.dt_realizacao, 'YYYY-MM') AS mes,
       COUNT(DISTINCT p.id_pedido)         AS pedidos,
       COUNT(*)                            AS ingressos,
       SUM(i.preco_pago)                   AS receita
  FROM Pedido p
 INNER JOIN Ingresso i ON i.id_pedido = p.id_pedido
 WHERE p.dt_realizacao BETWEEN DATE '2026-01-01' AND DATE '2026-06-30'
 GROUP BY TO_CHAR(p.dt_realizacao, 'YYYY-MM')
 ORDER BY mes;


-- 4. Relatório 9: vendas por cidade nos estados do Nordeste.
-- Usa a view vw_venda_ingresso, que já traz cidade e UF do local do evento.
-- Checklist: IN, COUNT, GROUP BY, ORDER BY
SELECT uf,
       cidade,
       COUNT(DISTINCT id_evento) AS eventos,
       COUNT(*)                  AS ingressos_vendidos,
       SUM(preco_pago)           AS receita
  FROM vw_venda_ingresso
 WHERE uf IN ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE')
 GROUP BY uf, cidade
 ORDER BY receita DESC;


-- 5. Pergunta 13: busca de eventos por palavra (como a busca do site),
-- mostrando as categorias de cada um numa linha só.
-- Checklist: LIKE, INNER JOIN, GROUP BY, ORDER BY
SELECT e.nome,
       e.dt_realizacao,
       en.cidade,
       LISTAGG(ce.categoria, ', ') WITHIN GROUP (ORDER BY ce.categoria) AS categorias
  FROM Evento e
 INNER JOIN Endereco en         ON en.cep       = e.cep
 INNER JOIN Categoria_Evento ce ON ce.id_evento = e.id_evento
 WHERE UPPER(e.nome)      LIKE '%FESTIVAL%'
    OR UPPER(e.descricao) LIKE '%MUSICA%'
 GROUP BY e.id_evento, e.nome, e.dt_realizacao, en.cidade
 ORDER BY e.dt_realizacao;


-- 6. Pergunta 10 e relatório 11: produtores vinculados hoje a cada empresa
-- (dt_fim nulo), com cargo e há quantos meses estão nele.
-- Checklist: IS NULL, INNER JOIN, ORDER BY
SELECT em.nome                                AS empresa,
       u.primeiro_nome || ' ' || u.sobrenome  AS produtor,
       f.nome                                 AS cargo,
       v.dt_inicio,
       TRUNC(MONTHS_BETWEEN(SYSDATE, v.dt_inicio)) AS meses_no_cargo
  FROM Vinculo v
 INNER JOIN Empresa em  ON em.id_criador = v.id_empresa
 INNER JOIN Produtor pr ON pr.id_criador = v.id_produtor
 INNER JOIN Usuario u   ON u.cpf         = pr.cpf
 INNER JOIN Funcao f    ON f.id_funcao   = v.id_funcao
 WHERE v.dt_fim IS NULL
 ORDER BY em.nome, meses_no_cargo DESC;


-- 7. Relatório 15: preço pago por evento e setor. Menor, maior e médio
-- mostram quanto o preço variou entre os lotes do mesmo setor.
-- Checklist: MIN, MAX, AVG, COUNT, GROUP BY, ORDER BY
SELECT evento,
       setor,
       COUNT(*)                         AS vendidos,
       MIN(preco_pago)                  AS menor_preco,
       MAX(preco_pago)                  AS maior_preco,
       ROUND(AVG(preco_pago), 2)        AS ticket_medio,
       MAX(preco_pago) - MIN(preco_pago) AS variacao
  FROM vw_venda_ingresso
 GROUP BY evento, setor
 ORDER BY evento, ticket_medio DESC;


-- 8. Relatório 3: ofertas encalhadas. Ofertas de eventos já encerrados que
-- venderam menos da metade dos ingressos emitidos.
-- Checklist: INNER JOIN, COUNT, GROUP BY, HAVING, ORDER BY
SELECT e.nome                                       AS evento,
       s.nome                                       AS setor,
       l.nome                                       AS lote,
       COUNT(*)                                     AS emitidos,
       COUNT(i.id_pedido)                           AS vendidos,
       COUNT(*) - COUNT(i.id_pedido)                AS sobra,
       ROUND(100 * COUNT(i.id_pedido) / COUNT(*), 1) AS pct_vendido
  FROM Ingresso i
 INNER JOIN Evento e ON e.id_evento = i.id_evento
 INNER JOIN Setor s  ON s.id_setor  = i.id_setor
 INNER JOIN Lote l   ON l.id_lote   = i.id_lote
 WHERE e.status = 'ENCERRADO'
 GROUP BY e.nome, s.nome, l.nome
HAVING COUNT(i.id_pedido) < 0.5 * COUNT(*)
 ORDER BY pct_vendido;


-- 9. Pergunta 24: clientes que gastaram mais que a média dos compradores,
-- com quantos pedidos fizeram.
-- A subconsulta calcula o gasto de cada comprador e tira a média.
-- Checklist: SUBCONSULTA COM OPERADOR RELACIONAL, HAVING, AVG, COUNT, GROUP BY
SELECT u.primeiro_nome || ' ' || u.sobrenome AS cliente,
       COUNT(DISTINCT p.id_pedido)           AS pedidos,
       SUM(i.preco_pago)                     AS total_gasto
  FROM Usuario u
 INNER JOIN Pedido p   ON p.cpf_usuario = u.cpf
 INNER JOIN Ingresso i ON i.id_pedido   = p.id_pedido
 GROUP BY u.cpf, u.primeiro_nome, u.sobrenome
HAVING SUM(i.preco_pago) > (SELECT AVG(gasto)
                              FROM (SELECT SUM(i2.preco_pago) AS gasto
                                      FROM Pedido p2
                                      JOIN Ingresso i2 ON i2.id_pedido = p2.id_pedido
                                     GROUP BY p2.cpf_usuario))
 ORDER BY total_gasto DESC;


-- 10. Lista de divulgação do Festival de Jazz: quem já comprou ingresso para
-- algum evento da categoria FESTIVAL e ainda não comprou para o Jazz.
-- Checklist: SUBCONSULTA COM IN (e NOT IN), ORDER BY
SELECT u.primeiro_nome || ' ' || u.sobrenome AS usuario,
       u.email
  FROM Usuario u
 WHERE u.cpf IN (SELECT p.cpf_usuario
                   FROM Pedido p
                  WHERE p.id_pedido IN (SELECT i.id_pedido
                                          FROM Ingresso i
                                         WHERE i.id_evento IN (SELECT ce.id_evento
                                                                 FROM Categoria_Evento ce
                                                                WHERE ce.categoria = 'FESTIVAL')))
   AND u.cpf NOT IN (SELECT p.cpf_usuario
                       FROM Pedido p
                       JOIN Ingresso i ON i.id_pedido = p.id_pedido
                       JOIN Evento e   ON e.id_evento = i.id_evento
                      WHERE e.nome = 'Festival de Jazz de Salvador')
 ORDER BY usuario;


-- 11. Sobreposição de faixas de preço: ofertas de Pista que custam mais do que
-- pelo menos uma oferta VIP da plataforma.
-- Checklist: SUBCONSULTA COM ANY, INNER JOIN, ORDER BY
SELECT e.nome  AS evento,
       l.nome  AS lote,
       o.preco AS preco_pista
  FROM Oferta o
 INNER JOIN Evento e ON e.id_evento = o.id_evento
 INNER JOIN Setor s  ON s.id_setor  = o.id_setor
 INNER JOIN Lote l   ON l.id_lote   = o.id_lote
 WHERE s.nome = 'Pista'
   AND o.preco > ANY (SELECT o2.preco
                        FROM Oferta o2
                        JOIN Setor s2 ON s2.id_setor = o2.id_setor
                       WHERE s2.nome = 'VIP')
 ORDER BY o.preco DESC;


-- 12. Relatório 6: evento de maior receita entre os de empresas e entre os de
-- produtores. A subconsulta é correlacionada pelo tipo de criador.
-- Checklist: SUBCONSULTA COM ALL, uso da VIEW vw_resumo_evento, ORDER BY
SELECT r.tipo_criador,
       r.evento,
       r.criador,
       r.vendidos,
       r.receita
  FROM vw_resumo_evento r
 WHERE r.receita >= ALL (SELECT r2.receita
                           FROM vw_resumo_evento r2
                          WHERE r2.tipo_criador = r.tipo_criador)
 ORDER BY r.tipo_criador;


-- 13. Pergunta 11: funções que são usadas como cargo em empresa e também como
-- papel em atuação de evento.
-- Checklist: INTERSECT, ORDER BY
SELECT f.nome AS funcao
  FROM Funcao f
  JOIN Vinculo v ON v.id_funcao = f.id_funcao
INTERSECT
SELECT f.nome
  FROM Funcao f
  JOIN Desempenha d ON d.id_funcao = f.id_funcao
 ORDER BY funcao;


-- 14. Usuários cadastrados que nunca fizeram pedido (público de campanha).
-- Checklist: MINUS, ORDER BY
SELECT u.cpf, u.primeiro_nome || ' ' || u.sobrenome AS nome, u.dt_cadastro
  FROM Usuario u
MINUS
SELECT u.cpf, u.primeiro_nome || ' ' || u.sobrenome, u.dt_cadastro
  FROM Usuario u
  JOIN Pedido p ON p.cpf_usuario = u.cpf
 ORDER BY dt_cadastro;


-- 15. Pergunta 17 e relatório 12: uso de cada função como cargo (Vinculo) e
-- como papel em evento (Desempenha). O FULL OUTER JOIN mantém a função que só
-- aparece de um dos lados.
-- Checklist: FULL OUTER JOIN, COUNT, GROUP BY, ORDER BY
SELECT COALESCE(cg.funcao, pp.funcao) AS funcao,
       NVL(cg.qtd, 0)                 AS vezes_como_cargo,
       NVL(pp.qtd, 0)                 AS vezes_em_eventos
  FROM (SELECT f.nome AS funcao, COUNT(*) AS qtd
          FROM Vinculo v
          JOIN Funcao f ON f.id_funcao = v.id_funcao
         GROUP BY f.nome) cg
  FULL OUTER JOIN
       (SELECT f.nome AS funcao, COUNT(*) AS qtd
          FROM Desempenha d
          JOIN Funcao f ON f.id_funcao = d.id_funcao
         GROUP BY f.nome) pp
    ON pp.funcao = cg.funcao
 ORDER BY vezes_em_eventos DESC, vezes_como_cargo DESC;


-- 16. Pergunta 20: reajuste de um lote para o seguinte no mesmo setor do mesmo
-- evento. Oferta aparece duas vezes, uma para cada lote.
-- Checklist: INNER JOIN (auto-junção), ORDER BY
SELECT e.nome                                         AS evento,
       s.nome                                         AS setor,
       l1.nome                                        AS de_lote,
       l2.nome                                        AS para_lote,
       o1.preco                                       AS preco_antes,
       o2.preco                                       AS preco_depois,
       ROUND(100 * (o2.preco - o1.preco) / o1.preco, 1) AS pct_aumento
  FROM Oferta o1
 INNER JOIN Oferta o2 ON o2.id_evento = o1.id_evento AND o2.id_setor = o1.id_setor
 INNER JOIN Lote l1   ON l1.id_lote   = o1.id_lote
 INNER JOIN Lote l2   ON l2.id_lote   = o2.id_lote
 INNER JOIN Evento e  ON e.id_evento  = o1.id_evento
 INNER JOIN Setor s   ON s.id_setor   = o1.id_setor
 WHERE l2.ordem = l1.ordem + 1
 ORDER BY pct_aumento DESC;


-- 17. Pergunta 18: atuações que começaram antes do evento e terminaram depois
-- dele. dt_fim nulo é atuação ainda em aberto e também entra.
-- Checklist: IS NULL, INNER JOIN, ORDER BY
SELECT u.primeiro_nome || ' ' || u.sobrenome AS produtor,
       e.nome                                AS evento,
       e.dt_realizacao,
       a.dt_inicio,
       a.dt_fim
  FROM Atuacao a
 INNER JOIN Evento e    ON e.id_evento   = a.id_evento
 INNER JOIN Produtor pr ON pr.id_criador = a.id_produtor
 INNER JOIN Usuario u   ON u.cpf         = pr.cpf
 WHERE a.dt_inicio < e.dt_realizacao
   AND (a.dt_fim > e.dt_realizacao OR a.dt_fim IS NULL)
 ORDER BY e.dt_realizacao, produtor;
