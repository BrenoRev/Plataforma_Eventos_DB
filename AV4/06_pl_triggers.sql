-- Triggers. Rodar depois do 05_pl_package.sql.
--
-- Dois de comando (disparam uma vez por instrução) e dois de linha (disparam
-- uma vez para cada linha afetada). O teste 6 do script 07 faz um UPDATE de 4
-- ofertas e mostra a diferença: 4 registros de histórico e 1 de log.


-- Tabelas de apoio dos triggers. Apaga antes para o script poder rodar de novo.
BEGIN
    FOR t IN (SELECT table_name FROM user_tables
               WHERE table_name IN ('HISTORICO_PRECO', 'LOG_OPERACAO'))
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences
               WHERE sequence_name IN ('SEQ_HISTORICO_PRECO', 'SEQ_LOG_OPERACAO'))
    LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

CREATE SEQUENCE seq_historico_preco START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_log_operacao    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Histórico de preço de cada oferta (pergunta 25: explica por que o preco_pago
-- de um ingresso pode ser diferente do preço atual).
-- Sem FK para Oferta, para o histórico continuar existindo se a oferta for apagada.
CREATE TABLE Historico_Preco (
    id_historico  INTEGER       NOT NULL,
    id_evento     INTEGER       NOT NULL,
    id_setor      INTEGER       NOT NULL,
    id_lote       INTEGER       NOT NULL,
    preco_antigo  NUMBER(10,2)  NOT NULL,
    preco_novo    NUMBER(10,2)  NOT NULL,
    dt_alteracao  TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_historico_preco PRIMARY KEY (id_historico)
);

-- Log de comandos executados nas tabelas monitoradas.
CREATE TABLE Log_Operacao (
    id_log       INTEGER       NOT NULL,
    tabela       VARCHAR2(30)  NOT NULL,
    operacao     VARCHAR2(6)   NOT NULL,
    usuario_bd   VARCHAR2(128) NOT NULL,
    dt_operacao  TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_log_operacao PRIMARY KEY (id_log),
    CONSTRAINT ck_log_operacao_tipo CHECK (operacao IN ('INSERT', 'UPDATE', 'DELETE'))
);


-- 1. Trigger de comando: log de alterações em Oferta.
-- Grava uma linha por instrução, não importa quantas ofertas ela mudou.
CREATE OR REPLACE TRIGGER trg_oferta_log
AFTER INSERT OR UPDATE OR DELETE ON Oferta
DECLARE
    v_operacao Log_Operacao.operacao%TYPE;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSE
        v_operacao := 'DELETE';
    END IF;

    INSERT INTO Log_Operacao (id_log, tabela, operacao, usuario_bd, dt_operacao)
    VALUES (seq_log_operacao.NEXTVAL, 'OFERTA', v_operacao, USER, SYSTIMESTAMP);
END trg_oferta_log;
/


-- 2. Trigger de comando: pedido não pode ser excluído.
-- O pedido é o registro da venda; apagar faria o ingresso perder o comprador.
-- Dispara antes do DELETE, mesmo que nenhuma linha atenda ao WHERE.
CREATE OR REPLACE TRIGGER trg_pedido_sem_exclusao
BEFORE DELETE ON Pedido
BEGIN
    RAISE_APPLICATION_ERROR(-20040, 'Pedido e registro de venda e nao pode ser excluido');
END trg_pedido_sem_exclusao;
/


-- 3. Trigger de linha: histórico de preço.
-- Para cada oferta cujo preço mudou, guarda o valor antigo e o novo.
CREATE OR REPLACE TRIGGER trg_oferta_historico_preco
AFTER UPDATE OF preco ON Oferta
FOR EACH ROW
WHEN (NEW.preco <> OLD.preco)
BEGIN
    INSERT INTO Historico_Preco (id_historico, id_evento, id_setor, id_lote,
                                 preco_antigo, preco_novo, dt_alteracao)
    VALUES (seq_historico_preco.NEXTVAL, :OLD.id_evento, :OLD.id_setor, :OLD.id_lote,
            :OLD.preco, :NEW.preco, SYSTIMESTAMP);
END trg_oferta_historico_preco;
/


-- 4. Trigger de linha: regras da venda de um ingresso.
-- Dispara quando um ingresso livre recebe pedido, venha a venda da package ou
-- de um UPDATE direto. Bloqueia evento cancelado ou já realizado e pedido feito
-- antes da abertura da oferta. Depois grava em preco_pago o preço atual da
-- oferta (minimundo: o preço pago é o da oferta no dia da compra).
-- Lê Evento, Oferta e Pedido, nunca Ingresso, então não cai em tabela mutante.
CREATE OR REPLACE TRIGGER trg_ingresso_venda
BEFORE UPDATE OF id_pedido ON Ingresso
FOR EACH ROW
WHEN (OLD.id_pedido IS NULL AND NEW.id_pedido IS NOT NULL)
DECLARE
    v_status     Evento.status%TYPE;
    v_dt_evento  Evento.dt_realizacao%TYPE;
    v_preco      Oferta.preco%TYPE;
    v_abertura   Oferta.dt_abertura_venda%TYPE;
    v_dt_pedido  Pedido.dt_realizacao%TYPE;
BEGIN
    SELECT e.status, e.dt_realizacao, o.preco, o.dt_abertura_venda
      INTO v_status, v_dt_evento, v_preco, v_abertura
      FROM Oferta o
      JOIN Evento e ON e.id_evento = o.id_evento
     WHERE o.id_evento = :NEW.id_evento
       AND o.id_setor  = :NEW.id_setor
       AND o.id_lote   = :NEW.id_lote;

    SELECT dt_realizacao INTO v_dt_pedido FROM Pedido WHERE id_pedido = :NEW.id_pedido;

    IF v_status = 'CANCELADO' THEN
        RAISE_APPLICATION_ERROR(-20030, 'Evento cancelado: venda bloqueada');
    ELSIF v_status = 'ENCERRADO' OR TRUNC(v_dt_pedido) > v_dt_evento THEN
        RAISE_APPLICATION_ERROR(-20031, 'Evento ja realizado: venda encerrada');
    ELSIF TRUNC(v_dt_pedido) < v_abertura THEN
        RAISE_APPLICATION_ERROR(-20032, 'Venda desta oferta abre em ' || TO_CHAR(v_abertura, 'DD/MM/YYYY'));
    END IF;

    :NEW.preco_pago := v_preco;
END trg_ingresso_venda;
/
