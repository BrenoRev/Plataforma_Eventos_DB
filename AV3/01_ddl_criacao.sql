-- Criação das tabelas. Rodar antes do 02_dml_povoamento.sql.
--
-- Nomes das constraints: pk_<tabela>, uk_<tabela>_<coluna>,
-- fk_<tabela>_<tabela referenciada>, ck_<tabela>_<regra>.
-- CategoriaEvento e FormaPagamento da AV2 viraram Categoria_Evento e Forma_Pagamento.

-- Apaga o que já existir, para o script poder rodar de novo.
BEGIN
    FOR t IN (SELECT table_name FROM user_tables
               WHERE table_name IN ('DESEMPENHA','ATUACAO','VINCULO','INGRESSO','FORMA_PAGAMENTO',
                                    'PEDIDO','OFERTA','FUNCAO','LOTE','SETOR','CATEGORIA_EVENTO',
                                    'EVENTO','EMPRESA','ENDERECO','PRODUTOR','CRIADOR','TELEFONE','USUARIO'))
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences
               WHERE sequence_name IN ('SEQ_CRIADOR','SEQ_EVENTO','SEQ_PEDIDO','SEQ_FUNCAO','SEQ_SETOR','SEQ_LOTE'))
    LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

-- Sequences das 6 chaves substitutas. O Oracle não tem auto incremento:
-- o INSERT usa <sequence>.NEXTVAL.
CREATE SEQUENCE seq_criador START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_evento  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_pedido  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_funcao  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_setor   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_lote    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Tabelas, na ordem das dependências (a referenciada vem antes).

-- R1 Usuario
-- cpf_indicador é o auto-relacionamento "indica". dt_indicacao só existe se houver indicador.
CREATE TABLE Usuario (
    cpf            VARCHAR2(11)   NOT NULL,
    primeiro_nome  VARCHAR2(50)   NOT NULL,
    sobrenome      VARCHAR2(100)  NOT NULL,
    email          VARCHAR2(120)  NOT NULL,
    dt_nascimento  DATE           NOT NULL,
    dt_cadastro    DATE           DEFAULT SYSDATE NOT NULL,
    cpf_indicador  VARCHAR2(11),
    dt_indicacao   DATE,
    CONSTRAINT pk_usuario PRIMARY KEY (cpf),
    CONSTRAINT uk_usuario_email UNIQUE (email),
    CONSTRAINT fk_usuario_indicador FOREIGN KEY (cpf_indicador) REFERENCES Usuario (cpf),
    CONSTRAINT ck_usuario_cpf CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$')),
    CONSTRAINT ck_usuario_email CHECK (REGEXP_LIKE(email, '^[^@ ]+@[^@ ]+\.[^@ ]+$')),
    CONSTRAINT ck_usuario_nascimento CHECK (dt_nascimento <= dt_cadastro),
    CONSTRAINT ck_usuario_autoindicacao CHECK (cpf_indicador IS NULL OR cpf_indicador <> cpf),
    CONSTRAINT ck_usuario_indicacao CHECK ((cpf_indicador IS NULL AND dt_indicacao IS NULL)
                                        OR (cpf_indicador IS NOT NULL AND dt_indicacao IS NOT NULL))
);

-- R2 Telefone (multivalorado de Usuario)
CREATE TABLE Telefone (
    cpf       VARCHAR2(11) NOT NULL,
    telefone  VARCHAR2(11) NOT NULL,
    CONSTRAINT pk_telefone PRIMARY KEY (cpf, telefone),
    CONSTRAINT fk_telefone_usuario FOREIGN KEY (cpf) REFERENCES Usuario (cpf) ON DELETE CASCADE,
    CONSTRAINT ck_telefone_formato CHECK (REGEXP_LIKE(telefone, '^[0-9]{10,11}$'))
);

-- R3 Criador (superclasse; especialização total e disjunta)
CREATE TABLE Criador (
    id_criador    INTEGER      NOT NULL,
    agencia       VARCHAR2(4)  NOT NULL,
    num_conta     VARCHAR2(12) NOT NULL,
    tipo_criador  VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_criador PRIMARY KEY (id_criador),
    CONSTRAINT uk_criador_conta UNIQUE (agencia, num_conta),
    CONSTRAINT ck_criador_tipo CHECK (tipo_criador IN ('PRODUTOR', 'EMPRESA')),
    CONSTRAINT ck_criador_agencia CHECK (REGEXP_LIKE(agencia, '^[0-9]{4}$')),
    CONSTRAINT ck_criador_conta CHECK (REGEXP_LIKE(num_conta, '^[0-9]{1,11}-[0-9X]$'))
);

-- R4 Produtor (subclasse de Criador e de Usuario)
-- PK é o id_criador herdado de Criador; o cpf herdado de Usuario é chave alternativa.
CREATE TABLE Produtor (
    id_criador  INTEGER      NOT NULL,
    cpf         VARCHAR2(11) NOT NULL,
    CONSTRAINT pk_produtor PRIMARY KEY (id_criador),
    CONSTRAINT uk_produtor_cpf UNIQUE (cpf),
    CONSTRAINT fk_produtor_criador FOREIGN KEY (id_criador) REFERENCES Criador (id_criador),
    CONSTRAINT fk_produtor_usuario FOREIGN KEY (cpf) REFERENCES Usuario (cpf)
);

-- R6 Endereco (saiu da 3FN: cep -> logradouro, bairro, cidade, uf)
CREATE TABLE Endereco (
    cep         VARCHAR2(8)   NOT NULL,
    logradouro  VARCHAR2(120) NOT NULL,
    bairro      VARCHAR2(60)  NOT NULL,
    cidade      VARCHAR2(60)  NOT NULL,
    uf          CHAR(2)       NOT NULL,
    CONSTRAINT pk_endereco PRIMARY KEY (cep),
    CONSTRAINT ck_endereco_cep CHECK (REGEXP_LIKE(cep, '^[0-9]{8}$')),
    CONSTRAINT ck_endereco_uf CHECK (uf IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG',
                                            'PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'))
);

-- R5 Empresa (subclasse de Criador)
CREATE TABLE Empresa (
    id_criador   INTEGER       NOT NULL,
    cnpj         VARCHAR2(14)  NOT NULL,
    nome         VARCHAR2(120) NOT NULL,
    cep          VARCHAR2(8)   NOT NULL,
    numero       VARCHAR2(10)  NOT NULL,
    complemento  VARCHAR2(60),
    CONSTRAINT pk_empresa PRIMARY KEY (id_criador),
    CONSTRAINT uk_empresa_cnpj UNIQUE (cnpj),
    CONSTRAINT fk_empresa_criador FOREIGN KEY (id_criador) REFERENCES Criador (id_criador),
    CONSTRAINT fk_empresa_endereco FOREIGN KEY (cep) REFERENCES Endereco (cep),
    CONSTRAINT ck_empresa_cnpj CHECK (REGEXP_LIKE(cnpj, '^[0-9]{14}$'))
);

-- R7 Evento
CREATE TABLE Evento (
    id_evento      INTEGER       NOT NULL,
    nome           VARCHAR2(120) NOT NULL,
    descricao      VARCHAR2(400),
    dt_realizacao  DATE          NOT NULL,
    cep            VARCHAR2(8)   NOT NULL,
    numero         VARCHAR2(10)  NOT NULL,
    complemento    VARCHAR2(60),
    id_criador     INTEGER       NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_endereco FOREIGN KEY (cep) REFERENCES Endereco (cep),
    CONSTRAINT fk_evento_criador FOREIGN KEY (id_criador) REFERENCES Criador (id_criador)
);

-- R8 Categoria_Evento (multivalorado de Evento)
-- Lista fechada para a categoria não ser escrita de formas diferentes.
CREATE TABLE Categoria_Evento (
    id_evento  INTEGER      NOT NULL,
    categoria  VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_categoria_evento PRIMARY KEY (id_evento, categoria),
    CONSTRAINT fk_categoria_evento_evento FOREIGN KEY (id_evento) REFERENCES Evento (id_evento) ON DELETE CASCADE,
    CONSTRAINT ck_categoria_evento_dominio CHECK (categoria IN ('MUSICA','FESTIVAL','TEATRO','STAND-UP','ESPORTE',
                                                                'TECNOLOGIA','CONGRESSO','GASTRONOMIA','CULTURA','INFANTIL'))
);

-- R9 Setor
CREATE TABLE Setor (
    id_setor   INTEGER       NOT NULL,
    nome       VARCHAR2(60)  NOT NULL,
    descricao  VARCHAR2(200),
    CONSTRAINT pk_setor PRIMARY KEY (id_setor),
    CONSTRAINT uk_setor_nome UNIQUE (nome)
);

-- R10 Lote (ordem = sequência em que os lotes abrem)
CREATE TABLE Lote (
    id_lote    INTEGER       NOT NULL,
    nome       VARCHAR2(60)  NOT NULL,
    ordem      INTEGER       NOT NULL,
    descricao  VARCHAR2(200),
    CONSTRAINT pk_lote PRIMARY KEY (id_lote),
    CONSTRAINT uk_lote_nome_ordem UNIQUE (nome, ordem),
    CONSTRAINT ck_lote_ordem CHECK (ordem >= 0)
);

-- R15 Funcao (usada como cargo em Vinculo e como papel em Atuacao)
CREATE TABLE Funcao (
    id_funcao  INTEGER       NOT NULL,
    nome       VARCHAR2(60)  NOT NULL,
    descricao  VARCHAR2(200),
    CONSTRAINT pk_funcao PRIMARY KEY (id_funcao),
    CONSTRAINT uk_funcao_nome UNIQUE (nome)
);

-- R11 Oferta (entidade associativa do ternário precifica)
CREATE TABLE Oferta (
    id_evento          INTEGER       NOT NULL,
    id_setor           INTEGER       NOT NULL,
    id_lote            INTEGER       NOT NULL,
    preco              NUMBER(10,2)  NOT NULL,
    dt_abertura_venda  DATE          NOT NULL,
    CONSTRAINT pk_oferta PRIMARY KEY (id_evento, id_setor, id_lote),
    CONSTRAINT fk_oferta_evento FOREIGN KEY (id_evento) REFERENCES Evento (id_evento),
    CONSTRAINT fk_oferta_setor  FOREIGN KEY (id_setor)  REFERENCES Setor (id_setor),
    CONSTRAINT fk_oferta_lote   FOREIGN KEY (id_lote)   REFERENCES Lote (id_lote),
    CONSTRAINT ck_oferta_preco CHECK (preco > 0)
);

-- R13 Pedido
CREATE TABLE Pedido (
    id_pedido      INTEGER NOT NULL,
    dt_realizacao  DATE    NOT NULL,
    cpf_usuario    VARCHAR2(11) NOT NULL,
    CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (cpf_usuario) REFERENCES Usuario (cpf)
);

-- R14 Forma_Pagamento (multivalorado de Pedido)
CREATE TABLE Forma_Pagamento (
    id_pedido        INTEGER      NOT NULL,
    forma_pagamento  VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_forma_pagamento PRIMARY KEY (id_pedido, forma_pagamento),
    CONSTRAINT fk_forma_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES Pedido (id_pedido) ON DELETE CASCADE,
    CONSTRAINT ck_forma_pagamento_dominio CHECK (forma_pagamento IN ('PIX','CARTAO_CREDITO','CARTAO_DEBITO','BOLETO','CARTEIRA_DIGITAL'))
);

-- R12 Ingresso (entidade fraca de Evento)
-- id_evento está na PK e na FK composta para Oferta, então um ingresso
-- não consegue apontar para a oferta de outro evento.
-- Ingresso ainda não vendido fica com id_pedido e preco_pago nulos.
CREATE TABLE Ingresso (
    id_evento     INTEGER      NOT NULL,
    num_ingresso  INTEGER      NOT NULL,
    preco_pago    NUMBER(10,2),
    id_setor      INTEGER      NOT NULL,
    id_lote       INTEGER      NOT NULL,
    id_pedido     INTEGER,
    CONSTRAINT pk_ingresso PRIMARY KEY (id_evento, num_ingresso),
    CONSTRAINT fk_ingresso_evento FOREIGN KEY (id_evento) REFERENCES Evento (id_evento),
    CONSTRAINT fk_ingresso_oferta FOREIGN KEY (id_evento, id_setor, id_lote)
        REFERENCES Oferta (id_evento, id_setor, id_lote),
    CONSTRAINT fk_ingresso_pedido FOREIGN KEY (id_pedido) REFERENCES Pedido (id_pedido),
    CONSTRAINT ck_ingresso_numero CHECK (num_ingresso > 0),
    CONSTRAINT ck_ingresso_preco CHECK (preco_pago IS NULL OR preco_pago > 0),
    -- ou tem pedido e preço pago, ou não tem nenhum dos dois
    CONSTRAINT ck_ingresso_venda CHECK ((id_pedido IS NULL AND preco_pago IS NULL)
                                     OR (id_pedido IS NOT NULL AND preco_pago IS NOT NULL))
);

-- R16 Vinculo (Produtor x Empresa, com histórico)
-- dt_fim nulo = vínculo em vigor.
CREATE TABLE Vinculo (
    id_produtor  INTEGER NOT NULL,
    id_empresa   INTEGER NOT NULL,
    dt_inicio    DATE    NOT NULL,
    dt_fim       DATE,
    id_funcao    INTEGER NOT NULL,
    CONSTRAINT pk_vinculo PRIMARY KEY (id_produtor, id_empresa, dt_inicio),
    CONSTRAINT fk_vinculo_produtor FOREIGN KEY (id_produtor) REFERENCES Produtor (id_criador),
    CONSTRAINT fk_vinculo_empresa  FOREIGN KEY (id_empresa)  REFERENCES Empresa (id_criador),
    CONSTRAINT fk_vinculo_funcao   FOREIGN KEY (id_funcao)   REFERENCES Funcao (id_funcao),
    CONSTRAINT ck_vinculo_periodo CHECK (dt_fim IS NULL OR dt_fim >= dt_inicio)
);

-- R17 Atuacao (Produtor x Evento, com histórico)
CREATE TABLE Atuacao (
    id_produtor  INTEGER NOT NULL,
    id_evento    INTEGER NOT NULL,
    dt_inicio    DATE    NOT NULL,
    dt_fim       DATE,
    CONSTRAINT pk_atuacao PRIMARY KEY (id_produtor, id_evento, dt_inicio),
    CONSTRAINT fk_atuacao_produtor FOREIGN KEY (id_produtor) REFERENCES Produtor (id_criador),
    CONSTRAINT fk_atuacao_evento   FOREIGN KEY (id_evento)   REFERENCES Evento (id_evento),
    CONSTRAINT ck_atuacao_periodo CHECK (dt_fim IS NULL OR dt_fim >= dt_inicio)
);

-- R18 Desempenha (Atuacao x Funcao)
CREATE TABLE Desempenha (
    id_produtor  INTEGER NOT NULL,
    id_evento    INTEGER NOT NULL,
    dt_inicio    DATE    NOT NULL,
    id_funcao    INTEGER NOT NULL,
    CONSTRAINT pk_desempenha PRIMARY KEY (id_produtor, id_evento, dt_inicio, id_funcao),
    CONSTRAINT fk_desempenha_atuacao FOREIGN KEY (id_produtor, id_evento, dt_inicio)
        REFERENCES Atuacao (id_produtor, id_evento, dt_inicio),
    CONSTRAINT fk_desempenha_funcao FOREIGN KEY (id_funcao) REFERENCES Funcao (id_funcao)
);

-- Índices nas FKs mais usadas em junção (o Oracle só indexa PK e UNIQUE sozinho).
CREATE INDEX idx_evento_criador  ON Evento (id_criador);
CREATE INDEX idx_evento_cep      ON Evento (cep);
CREATE INDEX idx_pedido_usuario  ON Pedido (cpf_usuario);
CREATE INDEX idx_ingresso_pedido ON Ingresso (id_pedido);