-- Conferência do povoamento. Rodar depois do 01 e do 02.
-- As consultas 2 a 7 checam regras que não dá para declarar com constraint
-- (especialização de Criador e participações totais). O resultado esperado
-- está no comentário de cada uma.

-- 1. Linhas por tabela
-- Esperado: USUARIO 30, TELEFONE 40, CRIADOR 12, PRODUTOR 8, EMPRESA 4,
-- ENDERECO 12, EVENTO 10, CATEGORIA_EVENTO 19, SETOR 6, LOTE 5, FUNCAO 8,
-- OFERTA 40, PEDIDO 57, FORMA_PAGAMENTO 64, INGRESSO 831, VINCULO 10,
-- ATUACAO 12, DESEMPENHA 18.
SELECT 'USUARIO' AS tabela, COUNT(*) AS qtd FROM Usuario UNION ALL
SELECT 'TELEFONE', COUNT(*) FROM Telefone UNION ALL
SELECT 'CRIADOR', COUNT(*) FROM Criador UNION ALL
SELECT 'PRODUTOR', COUNT(*) FROM Produtor UNION ALL
SELECT 'EMPRESA', COUNT(*) FROM Empresa UNION ALL
SELECT 'ENDERECO', COUNT(*) FROM Endereco UNION ALL
SELECT 'EVENTO', COUNT(*) FROM Evento UNION ALL
SELECT 'CATEGORIA_EVENTO', COUNT(*) FROM Categoria_Evento UNION ALL
SELECT 'SETOR', COUNT(*) FROM Setor UNION ALL
SELECT 'LOTE', COUNT(*) FROM Lote UNION ALL
SELECT 'FUNCAO', COUNT(*) FROM Funcao UNION ALL
SELECT 'OFERTA', COUNT(*) FROM Oferta UNION ALL
SELECT 'PEDIDO', COUNT(*) FROM Pedido UNION ALL
SELECT 'FORMA_PAGAMENTO', COUNT(*) FROM Forma_Pagamento UNION ALL
SELECT 'INGRESSO', COUNT(*) FROM Ingresso UNION ALL
SELECT 'VINCULO', COUNT(*) FROM Vinculo UNION ALL
SELECT 'ATUACAO', COUNT(*) FROM Atuacao UNION ALL
SELECT 'DESEMPENHA', COUNT(*) FROM Desempenha;

-- 2. Especialização de Criador: totalidade (esperado: 0 linhas)
SELECT c.id_criador
  FROM Criador c
 WHERE NOT EXISTS (SELECT 1 FROM Produtor p WHERE p.id_criador = c.id_criador)
   AND NOT EXISTS (SELECT 1 FROM Empresa e  WHERE e.id_criador = c.id_criador);

-- 3. Especialização de Criador: disjunção (esperado: 0 linhas)
SELECT c.id_criador
  FROM Criador c
 WHERE EXISTS (SELECT 1 FROM Produtor p WHERE p.id_criador = c.id_criador)
   AND EXISTS (SELECT 1 FROM Empresa e  WHERE e.id_criador = c.id_criador);

-- 4. tipo_criador coerente com a subclasse (esperado: 0 linhas)
SELECT c.id_criador, c.tipo_criador
  FROM Criador c
 WHERE (c.tipo_criador = 'PRODUTOR' AND NOT EXISTS (SELECT 1 FROM Produtor p WHERE p.id_criador = c.id_criador))
    OR (c.tipo_criador = 'EMPRESA'  AND NOT EXISTS (SELECT 1 FROM Empresa e  WHERE e.id_criador = c.id_criador));

-- 5. Todo evento tem ao menos uma oferta (esperado: 0 linhas)
SELECT e.id_evento, e.nome
  FROM Evento e
 WHERE NOT EXISTS (SELECT 1 FROM Oferta o WHERE o.id_evento = e.id_evento);

-- 6. Todo pedido contém ao menos um ingresso (esperado: 0 linhas)
SELECT p.id_pedido
  FROM Pedido p
 WHERE NOT EXISTS (SELECT 1 FROM Ingresso i WHERE i.id_pedido = p.id_pedido);

-- 7. Toda atuação tem ao menos uma função (esperado: 0 linhas)
SELECT a.id_produtor, a.id_evento, a.dt_inicio
  FROM Atuacao a
 WHERE NOT EXISTS (SELECT 1 FROM Desempenha d
                    WHERE d.id_produtor = a.id_produtor AND d.id_evento = a.id_evento AND d.dt_inicio = a.dt_inicio);

-- 8. Compras dentro do período de venda (esperado: 0 linhas)
-- Pedido não pode ser anterior a abertura da oferta, nem posterior ao evento,
-- nem anterior ao cadastro do comprador.
SELECT DISTINCT p.id_pedido
  FROM Pedido p
  JOIN Ingresso i ON i.id_pedido = p.id_pedido
  JOIN Oferta   o ON o.id_evento = i.id_evento AND o.id_setor = i.id_setor AND o.id_lote = i.id_lote
  JOIN Evento   e ON e.id_evento = i.id_evento
  JOIN Usuario  u ON u.cpf = p.cpf_usuario
 WHERE p.dt_realizacao < o.dt_abertura_venda
    OR p.dt_realizacao > e.dt_realizacao
    OR p.dt_realizacao < u.dt_cadastro;

-- 9. Indicador cadastrado antes do indicado (esperado: 0 linhas)
SELECT i.cpf AS indicado, d.cpf AS indicador
  FROM Usuario i
  JOIN Usuario d ON d.cpf = i.cpf_indicador
 WHERE d.dt_cadastro > i.dt_cadastro;

-- 10. Vínculos sobrepostos do mesmo produtor na mesma empresa (esperado: 0)
SELECT a.id_produtor, a.id_empresa, a.dt_inicio
  FROM Vinculo a
  JOIN Vinculo b ON b.id_produtor = a.id_produtor AND b.id_empresa = a.id_empresa AND b.dt_inicio > a.dt_inicio
 WHERE a.dt_fim IS NULL OR a.dt_fim >= b.dt_inicio;

-- 11. Ingressos vendidos por oferta e taxa de esgotamento
-- Esperado: 40 linhas. Ofertas com 100,0 por cento: Maré Viva (Pista, Lote
-- Promocional), Forró (Pista, Primeiro Lote), Tech Summit (Plateia, Lote
-- Promocional), Rock na Praça (Pista, Lote Promocional) e Réveillon (Pista,
-- Lote Promocional).
SELECT e.nome AS evento, s.nome AS setor, l.nome AS lote,
       COUNT(*) AS emitidos, COUNT(i.id_pedido) AS vendidos,
       ROUND(100 * COUNT(i.id_pedido) / COUNT(*), 1) AS pct_vendido
  FROM Ingresso i
  JOIN Evento e ON e.id_evento = i.id_evento
  JOIN Setor  s ON s.id_setor  = i.id_setor
  JOIN Lote   l ON l.id_lote   = i.id_lote
 GROUP BY e.nome, s.nome, l.nome, l.ordem
 ORDER BY e.nome, l.ordem, s.nome;

-- 12. Ingressos cujo preco_pago difere do preço atual da oferta
-- Esperado: ingressos de 3 ofertas reajustadas depois da venda (Sabores, Pista,
-- Segundo Lote; Réveillon, Pista, Primeiro Lote; Tech Summit, Plateia, Segundo Lote).
SELECT e.nome AS evento, s.nome AS setor, l.nome AS lote,
       o.preco AS preco_atual, i.preco_pago, COUNT(*) AS qtd
  FROM Ingresso i
  JOIN Oferta o ON o.id_evento = i.id_evento AND o.id_setor = i.id_setor AND o.id_lote = i.id_lote
  JOIN Evento e ON e.id_evento = i.id_evento
  JOIN Setor  s ON s.id_setor  = i.id_setor
  JOIN Lote   l ON l.id_lote   = i.id_lote
 WHERE i.preco_pago <> o.preco
 GROUP BY e.nome, s.nome, l.nome, o.preco, i.preco_pago
 ORDER BY e.nome;

-- 13. Eventos sem produtor registrado (pergunta 16 do minimundo)
-- Esperado: Stand-up, Teatro, Jazz de Salvador e Futevôlei.
SELECT e.nome
  FROM Evento e
 WHERE NOT EXISTS (SELECT 1 FROM Atuacao a WHERE a.id_evento = e.id_evento);

-- 14. Produtor com mais de uma atuação no mesmo evento (pergunta 15)
-- Esperado: Thiago Barros em Festival Maré Viva 2025 (2 atuações).
SELECT u.primeiro_nome, u.sobrenome, e.nome AS evento, COUNT(*) AS atuacoes
  FROM Atuacao a
  JOIN Produtor p ON p.id_criador = a.id_produtor
  JOIN Usuario  u ON u.cpf = p.cpf
  JOIN Evento   e ON e.id_evento = a.id_evento
 GROUP BY u.primeiro_nome, u.sobrenome, e.nome
HAVING COUNT(*) > 1;

-- 15. Produtor que publica eventos sem vínculo com empresa (pergunta 8)
-- Esperado: Fernanda Siqueira.
SELECT DISTINCT u.primeiro_nome, u.sobrenome
  FROM Evento e
  JOIN Produtor p ON p.id_criador = e.id_criador
  JOIN Usuario  u ON u.cpf = p.cpf
 WHERE NOT EXISTS (SELECT 1 FROM Vinculo v WHERE v.id_produtor = p.id_criador);
