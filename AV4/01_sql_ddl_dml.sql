-- Alterações de estrutura e de dados da AV4.
-- Rodar depois do 01_ddl_criacao.sql e do 02_dml_povoamento.sql da AV3.
--
-- Checklist SQL coberto aqui: ALTER TABLE, CREATE INDEX, INSERT INTO, UPDATE,
-- DELETE e CREATE VIEW.


-- 1. ALTER TABLE: situação do evento
-- O evento passa a ter status. ATIVO vende normalmente, ENCERRADO já aconteceu
-- e CANCELADO foi suspenso pelo criador. O trigger trg_ingresso_venda (script 06)
-- usa essa coluna para bloquear venda de evento que não está ativo.
ALTER TABLE Evento ADD (status VARCHAR2(10) DEFAULT 'ATIVO' NOT NULL);

ALTER TABLE Evento ADD CONSTRAINT ck_evento_status
    CHECK (status IN ('ATIVO', 'ENCERRADO', 'CANCELADO'));


-- 2. CREATE INDEX
-- FK composta de Ingresso para Oferta. É a junção usada em quase todos os
-- relatórios de venda e no cursor de compra da package.
CREATE INDEX idx_ingresso_oferta ON Ingresso (id_evento, id_setor, id_lote);

-- Data do pedido, usada nos filtros por período (consulta 3 do script 02).
CREATE INDEX idx_pedido_data ON Pedido (dt_realizacao);


-- 3. UPDATE: eventos que já aconteceram passam a ENCERRADO
-- Rodando em outubro de 2026, são 7 eventos (os 3 restantes seguem ATIVO).
UPDATE Evento
   SET status = 'ENCERRADO'
 WHERE dt_realizacao < TRUNC(SYSDATE);


-- 4. INSERT INTO: nova usuária, indicada pela Ana Beatriz
-- dt_cadastro fica com o DEFAULT SYSDATE da tabela.
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, cpf_indicador, dt_indicacao)
VALUES ('52816049372', 'Yasmin', 'Correia', 'yasmin.correia@gmail.com', DATE '2000-04-18',
        '04812367091', TRUNC(SYSDATE));

INSERT INTO Telefone (cpf, telefone) VALUES ('52816049372', '81994455667');

-- INSERT com SELECT: abre o Segundo Lote do Réveillon copiando os setores do
-- Primeiro Lote, com 25% de reajuste e venda a partir de hoje.
-- Os ingressos dessas ofertas são emitidos depois pela package (script 07).
INSERT INTO Oferta (id_evento, id_setor, id_lote, preco, dt_abertura_venda)
SELECT o.id_evento,
       o.id_setor,
       (SELECT id_lote FROM Lote WHERE nome = 'Segundo Lote'),
       ROUND(o.preco * 1.25, -1),
       TRUNC(SYSDATE)
  FROM Oferta o
 WHERE o.id_evento = (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027')
   AND o.id_lote   = (SELECT id_lote   FROM Lote   WHERE nome = 'Primeiro Lote');


-- 5. DELETE: telefone fixo de quem já tem celular
-- O ingresso é enviado por mensagem, então o fixo só fica para quem não tem
-- outro número. Remove 4 telefones.
DELETE FROM Telefone t
 WHERE LENGTH(t.telefone) = 10
   AND EXISTS (SELECT 1
                 FROM Telefone c
                WHERE c.cpf = t.cpf
                  AND LENGTH(c.telefone) = 11);


-- 6. CREATE VIEW
-- Um ingresso vendido por linha, já com evento, local, setor, lote e pedido.
-- Base das consultas de receita do script 02.
CREATE OR REPLACE VIEW vw_venda_ingresso AS
SELECT i.id_evento,
       e.nome            AS evento,
       e.dt_realizacao   AS dt_evento,
       e.status,
       en.cidade,
       en.uf,
       s.nome            AS setor,
       l.nome            AS lote,
       l.ordem           AS ordem_lote,
       i.num_ingresso,
       i.preco_pago,
       p.id_pedido,
       p.dt_realizacao   AS dt_pedido,
       p.cpf_usuario
  FROM Ingresso i
  JOIN Pedido   p  ON p.id_pedido = i.id_pedido
  JOIN Evento   e  ON e.id_evento = i.id_evento
  JOIN Endereco en ON en.cep      = e.cep
  JOIN Setor    s  ON s.id_setor  = i.id_setor
  JOIN Lote     l  ON l.id_lote   = i.id_lote;

-- Resumo por evento: criador, ingressos emitidos e vendidos, receita.
-- O nome do criador vem de Empresa ou de Usuario, conforme a subclasse.
-- Receita sem venda vira 0 e não NULL, para a comparação com ALL da
-- consulta 12 do script 02 funcionar.
CREATE OR REPLACE VIEW vw_resumo_evento AS
SELECT e.id_evento,
       e.nome                                         AS evento,
       e.dt_realizacao,
       e.status,
       c.tipo_criador,
       COALESCE(em.nome, u.primeiro_nome || ' ' || u.sobrenome) AS criador,
       COUNT(i.num_ingresso)                          AS emitidos,
       COUNT(i.id_pedido)                             AS vendidos,
       NVL(SUM(i.preco_pago), 0)                      AS receita
  FROM Evento e
  JOIN Criador c       ON c.id_criador  = e.id_criador
  LEFT JOIN Empresa em ON em.id_criador = c.id_criador
  LEFT JOIN Produtor pr ON pr.id_criador = c.id_criador
  LEFT JOIN Usuario u  ON u.cpf         = pr.cpf
  LEFT JOIN Ingresso i ON i.id_evento   = e.id_evento
 GROUP BY e.id_evento, e.nome, e.dt_realizacao, e.status, c.tipo_criador,
          em.nome, u.primeiro_nome, u.sobrenome;

COMMIT;
