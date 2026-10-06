-- Povoamento. Rodar depois do 01_ddl_criacao.sql.
--
-- Os ids vêm sempre de <sequence>.NEXTVAL. As FKs são buscadas por cpf, cnpj
-- ou nome, então o script não depende do número que a sequence gerou.
-- CPFs, CNPJs, contas e telefones são inventados.


-- 1. Usuario (30). Quem indica é inserido antes de quem foi indicado.
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('04812367091', 'Ana Beatriz', 'Albuquerque', 'ana.albuquerque@gmail.com', DATE '1991-03-12', DATE '2024-01-15', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('37250914861', 'Carlos Eduardo', 'Pereira', 'carlos.pereira@outlook.com', DATE '1985-07-22', DATE '2024-01-20', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('82619475030', 'Mariana', 'Cavalcanti', 'mariana.cavalcanti@hotmail.com', DATE '1993-11-05', DATE '2024-02-03', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('15934782605', 'Rafael', 'Tavares', 'rafael.tavares@yahoo.com.br', DATE '1988-05-30', DATE '2024-02-10', '04812367091', DATE '2024-02-10');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('60473829150', 'Juliana', 'Monteiro', 'juliana.monteiro@email.com.br', DATE '1995-09-18', DATE '2024-02-18', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('29581367408', 'Thiago', 'Barros', 'thiago.barros@gmail.com', DATE '1990-01-27', DATE '2024-03-02', '82619475030', DATE '2024-03-02');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('73096158240', 'Fernanda', 'Siqueira', 'fernanda.siqueira@outlook.com', DATE '1987-12-09', DATE '2024-03-11', '37250914861', DATE '2024-03-11');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('41857293610', 'Lucas', 'Nogueira', 'lucas.nogueira@hotmail.com', DATE '1998-04-14', DATE '2024-04-05', '82619475030', DATE '2024-04-05');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('96320481750', 'Camila', 'Rocha', 'camila.rocha@yahoo.com.br', DATE '1996-02-08', DATE '2024-04-20', '60473829150', DATE '2024-04-20');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('58714029366', 'Bruno', 'Carvalho', 'bruno.carvalho@email.com.br', DATE '1992-08-25', DATE '2024-05-12', '73096158240', DATE '2024-05-12');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('20468351970', 'Patrícia', 'Lopes', 'patricia.lopes@gmail.com', DATE '1989-06-14', DATE '2024-06-01', '04812367091', DATE '2024-06-01');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('83159702463', 'Diego', 'Fernandes', 'diego.fernandes@outlook.com', DATE '2000-10-03', DATE '2024-06-18', '15934782605', DATE '2024-06-18');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('34720896512', 'Larissa', 'Gomes', 'larissa.gomes@hotmail.com', DATE '1999-12-21', DATE '2024-07-07', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('67105438920', 'Gustavo', 'Ribeiro', 'gustavo.ribeiro@yahoo.com.br', DATE '1983-04-02', DATE '2024-08-15', '20468351970', DATE '2024-08-15');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('12983647053', 'Beatriz', 'Moura', 'beatriz.moura@email.com.br', DATE '2001-01-30', DATE '2024-09-09', '83159702463', DATE '2024-09-09');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('75430918246', 'Henrique', 'Duarte', 'henrique.duarte@gmail.com', DATE '1994-03-17', DATE '2024-10-22', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('48267019385', 'Isabela', 'Freitas', 'isabela.freitas@outlook.com', DATE '1997-07-11', DATE '2024-11-05', '34720896512', DATE '2024-11-05');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('90614783521', 'Felipe', 'Araújo', 'felipe.araujo@hotmail.com', DATE '1986-09-29', DATE '2025-01-13', '67105438920', DATE '2025-01-13');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('26839540170', 'Natália', 'Pinheiro', 'natalia.pinheiro@yahoo.com.br', DATE '2002-05-06', DATE '2025-02-02', '12983647053', DATE '2025-02-02');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('51792368049', 'Vinícius', 'Maciel', 'vinicius.maciel@email.com.br', DATE '1991-11-19', DATE '2025-03-18', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('38405917628', 'Aline', 'Cordeiro', 'aline.cordeiro@gmail.com', DATE '1993-08-08', DATE '2025-05-27', '20468351970', DATE '2025-05-27');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('64912037851', 'Rodrigo', 'Santana', 'rodrigo.santana@outlook.com', DATE '1984-02-14', DATE '2025-07-04', '90614783521', DATE '2025-07-04');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('17356984206', 'Letícia', 'Brandão', 'leticia.brandao@hotmail.com', DATE '2003-06-23', DATE '2025-09-12', '48267019385', DATE '2025-09-12');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('85073261940', 'Marcelo', 'Teixeira', 'marcelo.teixeira@yahoo.com.br', DATE '1979-10-16', DATE '2025-10-30', NULL, NULL);
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('42690817355', 'Sofia', 'Medeiros', 'sofia.medeiros@email.com.br', DATE '2004-03-09', DATE '2025-12-08', '26839540170', DATE '2025-12-08');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('70518342967', 'Paulo Henrique', 'Vasconcelos', 'paulo.vasconcelos@gmail.com', DATE '1982-01-05', DATE '2026-01-21', '64912037851', DATE '2026-01-21');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('23947106588', 'Renata', 'Queiroz', 'renata.queiroz@outlook.com', DATE '1990-12-02', DATE '2026-02-26', '38405917628', DATE '2026-02-26');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('59081724630', 'Eduardo', 'Guedes', 'eduardo.guedes@hotmail.com', DATE '1996-09-04', DATE '2026-04-14', '51792368049', DATE '2026-04-14');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('81236459072', 'Tatiana', 'Lacerda', 'tatiana.lacerda@yahoo.com.br', DATE '1988-07-27', DATE '2026-06-09', '42690817355', DATE '2026-06-09');
INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro, cpf_indicador, dt_indicacao)
VALUES ('36705298414', 'Matheus', 'Oliveira', 'matheus.oliveira@email.com.br', DATE '2005-11-13', DATE '2026-08-03', '59081724630', DATE '2026-08-03');

-- 2. Telefone (40)
INSERT INTO Telefone (cpf, telefone) VALUES ('04812367091', '81987654321');
INSERT INTO Telefone (cpf, telefone) VALUES ('04812367091', '81991122334');
INSERT INTO Telefone (cpf, telefone) VALUES ('37250914861', '81988112233');
INSERT INTO Telefone (cpf, telefone) VALUES ('37250914861', '8133219876');
INSERT INTO Telefone (cpf, telefone) VALUES ('82619475030', '81999887766');
INSERT INTO Telefone (cpf, telefone) VALUES ('82619475030', '81992334455');
INSERT INTO Telefone (cpf, telefone) VALUES ('15934782605', '81997766551');
INSERT INTO Telefone (cpf, telefone) VALUES ('60473829150', '81998877665');
INSERT INTO Telefone (cpf, telefone) VALUES ('29581367408', '81996655443');
INSERT INTO Telefone (cpf, telefone) VALUES ('73096158240', '81995544332');
INSERT INTO Telefone (cpf, telefone) VALUES ('41857293610', '81994433221');
INSERT INTO Telefone (cpf, telefone) VALUES ('96320481750', '81993322110');
INSERT INTO Telefone (cpf, telefone) VALUES ('58714029366', '81992211009');
INSERT INTO Telefone (cpf, telefone) VALUES ('20468351970', '81981234567');
INSERT INTO Telefone (cpf, telefone) VALUES ('20468351970', '8132214455');
INSERT INTO Telefone (cpf, telefone) VALUES ('83159702463', '81982345678');
INSERT INTO Telefone (cpf, telefone) VALUES ('34720896512', '81983456789');
INSERT INTO Telefone (cpf, telefone) VALUES ('67105438920', '81984567890');
INSERT INTO Telefone (cpf, telefone) VALUES ('67105438920', '81985678901');
INSERT INTO Telefone (cpf, telefone) VALUES ('12983647053', '81986789012');
INSERT INTO Telefone (cpf, telefone) VALUES ('75430918246', '11987654321');
INSERT INTO Telefone (cpf, telefone) VALUES ('75430918246', '11998761234');
INSERT INTO Telefone (cpf, telefone) VALUES ('48267019385', '11976543210');
INSERT INTO Telefone (cpf, telefone) VALUES ('90614783521', '81987001122');
INSERT INTO Telefone (cpf, telefone) VALUES ('26839540170', '71988776655');
INSERT INTO Telefone (cpf, telefone) VALUES ('51792368049', '21987654321');
INSERT INTO Telefone (cpf, telefone) VALUES ('51792368049', '21991234567');
INSERT INTO Telefone (cpf, telefone) VALUES ('38405917628', '85988776655');
INSERT INTO Telefone (cpf, telefone) VALUES ('64912037851', '31987654321');
INSERT INTO Telefone (cpf, telefone) VALUES ('17356984206', '81981002003');
INSERT INTO Telefone (cpf, telefone) VALUES ('85073261940', '11965432109');
INSERT INTO Telefone (cpf, telefone) VALUES ('85073261940', '1133224455');
INSERT INTO Telefone (cpf, telefone) VALUES ('42690817355', '81980011223');
INSERT INTO Telefone (cpf, telefone) VALUES ('70518342967', '81991010202');
INSERT INTO Telefone (cpf, telefone) VALUES ('70518342967', '81991010303');
INSERT INTO Telefone (cpf, telefone) VALUES ('23947106588', '71991234000');
INSERT INTO Telefone (cpf, telefone) VALUES ('23947106588', '7133445566');
INSERT INTO Telefone (cpf, telefone) VALUES ('59081724630', '81992020404');
INSERT INTO Telefone (cpf, telefone) VALUES ('81236459072', '85999887766');
INSERT INTO Telefone (cpf, telefone) VALUES ('36705298414', '81993030505');

-- 3. Setor, Lote e Funcao
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Pista', 'Area em pe em frente ao palco');
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Pista Premium', 'Area em pe com acesso privilegiado e bar exclusivo');
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Arquibancada', 'Assentos em degraus com visao panoramica');
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Camarote', 'Area elevada com mesas e servico de bar');
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'VIP', 'Area reservada com open bar e entrada exclusiva');
INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Plateia', 'Cadeiras numeradas voltadas ao palco');
INSERT INTO Lote (id_lote, nome, ordem, descricao) VALUES (seq_lote.NEXTVAL, 'Lote Promocional', 0, 'Lote de lancamento com desconto maximo e quantidade reduzida');
INSERT INTO Lote (id_lote, nome, ordem, descricao) VALUES (seq_lote.NEXTVAL, 'Primeiro Lote', 1, 'Primeira janela regular de venda');
INSERT INTO Lote (id_lote, nome, ordem, descricao) VALUES (seq_lote.NEXTVAL, 'Segundo Lote', 2, 'Segunda janela de venda, com reajuste');
INSERT INTO Lote (id_lote, nome, ordem, descricao) VALUES (seq_lote.NEXTVAL, 'Terceiro Lote', 3, 'Terceira janela de venda, proxima ao evento');
INSERT INTO Lote (id_lote, nome, ordem, descricao) VALUES (seq_lote.NEXTVAL, 'Lote Final', 4, 'Ultimas unidades, vendidas na semana do evento');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Produção Executiva', 'Responsavel geral pela execucao e orcamento do evento');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Curadoria', 'Selecao e programacao das atracoes ou do conteudo');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Marketing', 'Divulgacao, midia e relacionamento com o publico');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Logística', 'Montagem de estrutura, fornecedores, transporte e cronograma');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Direção Artística', 'Concepcao artistica e conducao do palco');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Captação de Patrocínio', 'Prospeccao e relacionamento com patrocinadores');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Coordenação de Palco', 'Operacao do palco, som, luz e passagem de som');
INSERT INTO Funcao (id_funcao, nome, descricao) VALUES (seq_funcao.NEXTVAL, 'Credenciamento', 'Controle de acesso, credenciais e fluxo de entrada');

-- 4. Endereco (12 CEPs, usados por Empresa e Evento)
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('50030230', 'Rua da Moeda', 'Recife Antigo', 'Recife', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('51021040', 'Avenida Boa Viagem', 'Boa Viagem', 'Recife', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('50010010', 'Praça do Marco Zero', 'Recife Antigo', 'Recife', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('52061000', 'Avenida Cruz Cabugá', 'Santo Amaro', 'Recife', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('53120040', 'Rua do Amparo', 'Carmo', 'Olinda', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('55014000', 'Rua Vigário Freitas', 'Maurício de Nassau', 'Caruaru', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('50740400', 'Avenida Professor Moraes Rego', 'Cidade Universitária', 'Recife', 'PE');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('01310100', 'Avenida Paulista', 'Bela Vista', 'São Paulo', 'SP');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('04094050', 'Avenida Pedro Álvares Cabral', 'Vila Mariana', 'São Paulo', 'SP');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('01050070', 'Rua Álvaro de Carvalho', 'Centro', 'São Paulo', 'SP');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('40170010', 'Avenida Oceânica', 'Barra', 'Salvador', 'BA');
INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('60165121', 'Avenida Beira Mar', 'Meireles', 'Fortaleza', 'CE');

-- 5. Criador (8 produtores e 4 empresas)
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '0341', '10234-5', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '0341', '11876-0', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '1105', '20455-3', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '0341', '12099-7', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '2204', '30871-9', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '1105', '20991-4', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '0341', '13342-1', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '2204', '31555-6', 'PRODUTOR');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '3001', '70210-8', 'EMPRESA');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '3001', '70455-2', 'EMPRESA');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '3002', '80123-4', 'EMPRESA');
INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '3001', '70981-5', 'EMPRESA');

-- Produtor: o id_criador é achado pela conta bancária
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '0341' AND num_conta = '10234-5'), '82619475030');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '0341' AND num_conta = '11876-0'), '15934782605');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '1105' AND num_conta = '20455-3'), '60473829150');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '0341' AND num_conta = '12099-7'), '29581367408');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '2204' AND num_conta = '30871-9'), '73096158240');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '1105' AND num_conta = '20991-4'), '41857293610');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '0341' AND num_conta = '13342-1'), '96320481750');
INSERT INTO Produtor (id_criador, cpf)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '2204' AND num_conta = '31555-6'), '58714029366');

-- Empresa
INSERT INTO Empresa (id_criador, cnpj, nome, cep, numero, complemento)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '3001' AND num_conta = '70210-8'), '10234567000108', 'Pulso Produções LTDA', '50030230', '120', 'Sala 304');
INSERT INTO Empresa (id_criador, cnpj, nome, cep, numero, complemento)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '3001' AND num_conta = '70455-2'), '20345678000119', 'Maré Alta Entretenimento S.A.', '51021040', '2500', 'Andar 7');
INSERT INTO Empresa (id_criador, cnpj, nome, cep, numero, complemento)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '3002' AND num_conta = '80123-4'), '30456789000120', 'Cena Aberta Cultural ME', '01310100', '1500', 'Conjunto 82');
INSERT INTO Empresa (id_criador, cnpj, nome, cep, numero, complemento)
VALUES ((SELECT id_criador FROM Criador WHERE agencia = '3001' AND num_conta = '70981-5'), '40567890000131', 'Sertão Digital Eventos LTDA', '55014000', '45', NULL);

-- 6. Evento (10)
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Festival Maré Viva 2025', 'Festival de musica autoral pernambucana com tres palcos e feira de artesanato.', DATE '2025-11-22', '50010010', 'S/N', 'Palco Principal', (SELECT id_criador FROM Empresa WHERE cnpj = '20345678000119'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Noite do Forró Pé de Serra', 'Noite de forro tradicional com trios de pe de serra e quadrilha ao vivo.', DATE '2026-06-13', '55014000', '300', 'Patio de Eventos', (SELECT id_criador FROM Empresa WHERE cnpj = '40567890000131'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Recife Tech Summit 2026', 'Congresso de tecnologia com trilhas de dados, nuvem e inteligencia artificial.', DATE '2026-04-18', '50740400', '1235', 'Auditorio Central', (SELECT id_criador FROM Empresa WHERE cnpj = '10234567000108'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Stand-up Pernambuco: Risadas ao Vivo', 'Noite com cinco comediantes da cena local em formato de showcase.', DATE '2026-05-09', '52061000', '300', 'Teatro Alameda', (SELECT id_criador FROM Produtor WHERE cpf = '60473829150'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Sabores do Nordeste', 'Feira gastronomica com chefs regionais, degustacoes guiadas e musica ao vivo.', DATE '2026-08-22', '53120040', '88', 'Casarao Colonial', (SELECT id_criador FROM Empresa WHERE cnpj = '20345678000119'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Rock na Praça', 'Festival de rock com bandas nacionais em um dia de programacao.', DATE '2026-03-28', '04094050', 'S/N', 'Gramado Central', (SELECT id_criador FROM Empresa WHERE cnpj = '30456789000120'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Teatro: A Última Sessão', 'Drama em dois atos sobre o fechamento de um cinema de rua.', DATE '2026-09-12', '01050070', '455', 'Sala Principal', (SELECT id_criador FROM Produtor WHERE cpf = '73096158240'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Réveillon Orla de Boa Viagem 2027', 'Virada de ano com shows em palco na orla e queima de fogos.', DATE '2026-12-31', '51021040', 'S/N', 'Altura do Posto 6', (SELECT id_criador FROM Empresa WHERE cnpj = '20345678000119'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Festival de Jazz de Salvador', 'Tres noites de jazz e musica instrumental brasileira em arena a beira-mar.', DATE '2026-11-14', '40170010', 'S/N', 'Arena Barra', (SELECT id_criador FROM Produtor WHERE cpf = '29581367408'));
INSERT INTO Evento (id_evento, nome, descricao, dt_realizacao, cep, numero, complemento, id_criador)
VALUES (seq_evento.NEXTVAL, 'Copa Nordeste de Futevôlei', 'Torneio regional de futevolei com duplas de oito estados.', DATE '2027-01-23', '60165121', '3000', 'Arena de Areia', (SELECT id_criador FROM Produtor WHERE cpf = '82619475030'));

-- 7. Categoria_Evento (19)
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'), 'MUSICA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'), 'FESTIVAL');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'), 'MUSICA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'), 'FESTIVAL');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'), 'CULTURA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'), 'TECNOLOGIA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'), 'CONGRESSO');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Stand-up Pernambuco: Risadas ao Vivo'), 'STAND-UP');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste'), 'GASTRONOMIA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste'), 'CULTURA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'), 'MUSICA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Teatro: A Última Sessão'), 'TEATRO');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Teatro: A Última Sessão'), 'CULTURA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'), 'MUSICA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'), 'FESTIVAL');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Festival de Jazz de Salvador'), 'MUSICA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Festival de Jazz de Salvador'), 'FESTIVAL');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Festival de Jazz de Salvador'), 'CULTURA');
INSERT INTO Categoria_Evento (id_evento, categoria) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Copa Nordeste de Futevôlei'), 'ESPORTE');

-- 8. Oferta (40) e Ingresso (831)
-- O minimundo diz que os ingressos são emitidos junto com o evento e numerados
-- em sequência dentro dele. abrir_oferta insere a oferta e emite p_qtd ingressos
-- continuando a numeração do evento. Todos nascem sem pedido.

DECLARE
    PROCEDURE abrir_oferta (
        p_evento   IN VARCHAR2,
        p_setor    IN VARCHAR2,
        p_lote     IN VARCHAR2,
        p_preco    IN NUMBER,
        p_abertura IN DATE,
        p_qtd      IN INTEGER
    ) IS
        v_id_evento Evento.id_evento%TYPE;
        v_id_setor  Setor.id_setor%TYPE;
        v_id_lote   Lote.id_lote%TYPE;
        v_ultimo    INTEGER;
    BEGIN
        SELECT id_evento INTO v_id_evento FROM Evento WHERE nome = p_evento;
        SELECT id_setor  INTO v_id_setor  FROM Setor  WHERE nome = p_setor;
        SELECT id_lote   INTO v_id_lote   FROM Lote   WHERE nome = p_lote;

        INSERT INTO Oferta (id_evento, id_setor, id_lote, preco, dt_abertura_venda)
        VALUES (v_id_evento, v_id_setor, v_id_lote, p_preco, p_abertura);

        SELECT NVL(MAX(num_ingresso), 0) INTO v_ultimo
          FROM Ingresso WHERE id_evento = v_id_evento;

        INSERT INTO Ingresso (id_evento, num_ingresso, preco_pago, id_setor, id_lote, id_pedido)
        SELECT v_id_evento, v_ultimo + LEVEL, NULL, v_id_setor, v_id_lote, NULL
          FROM dual
        CONNECT BY LEVEL <= p_qtd;
    END abrir_oferta;
BEGIN
    -- Festival Maré Viva 2025
    abrir_oferta('Festival Maré Viva 2025', 'Pista', 'Lote Promocional', 90, DATE '2025-06-02', 20);
    abrir_oferta('Festival Maré Viva 2025', 'Pista', 'Primeiro Lote', 140, DATE '2025-07-01', 30);
    abrir_oferta('Festival Maré Viva 2025', 'Pista Premium', 'Primeiro Lote', 260, DATE '2025-07-01', 15);
    abrir_oferta('Festival Maré Viva 2025', 'VIP', 'Primeiro Lote', 480, DATE '2025-07-01', 10);
    abrir_oferta('Festival Maré Viva 2025', 'Pista', 'Segundo Lote', 180, DATE '2025-09-01', 30);
    abrir_oferta('Festival Maré Viva 2025', 'Pista Premium', 'Segundo Lote', 320, DATE '2025-09-01', 15);
    abrir_oferta('Festival Maré Viva 2025', 'VIP', 'Segundo Lote', 560, DATE '2025-09-01', 10);
    -- Noite do Forró Pé de Serra
    abrir_oferta('Noite do Forró Pé de Serra', 'Pista', 'Primeiro Lote', 60, DATE '2026-03-01', 30);
    abrir_oferta('Noite do Forró Pé de Serra', 'Camarote', 'Primeiro Lote', 150, DATE '2026-03-01', 12);
    abrir_oferta('Noite do Forró Pé de Serra', 'Pista', 'Segundo Lote', 80, DATE '2026-04-15', 30);
    abrir_oferta('Noite do Forró Pé de Serra', 'Camarote', 'Segundo Lote', 190, DATE '2026-04-15', 12);
    -- Recife Tech Summit 2026
    abrir_oferta('Recife Tech Summit 2026', 'Plateia', 'Lote Promocional', 150, DATE '2026-01-10', 20);
    abrir_oferta('Recife Tech Summit 2026', 'Plateia', 'Primeiro Lote', 250, DATE '2026-02-01', 30);
    abrir_oferta('Recife Tech Summit 2026', 'VIP', 'Primeiro Lote', 600, DATE '2026-02-01', 10);
    abrir_oferta('Recife Tech Summit 2026', 'Plateia', 'Segundo Lote', 350, DATE '2026-03-10', 20);
    -- Stand-up Pernambuco: Risadas ao Vivo
    abrir_oferta('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Primeiro Lote', 70, DATE '2026-03-20', 25);
    abrir_oferta('Stand-up Pernambuco: Risadas ao Vivo', 'Camarote', 'Primeiro Lote', 140, DATE '2026-03-20', 8);
    abrir_oferta('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Segundo Lote', 90, DATE '2026-04-10', 25);
    -- Sabores do Nordeste
    abrir_oferta('Sabores do Nordeste', 'Pista', 'Primeiro Lote', 45, DATE '2026-05-20', 30);
    abrir_oferta('Sabores do Nordeste', 'VIP', 'Primeiro Lote', 120, DATE '2026-05-20', 10);
    abrir_oferta('Sabores do Nordeste', 'Pista', 'Segundo Lote', 60, DATE '2026-07-01', 30);
    -- Rock na Praça
    abrir_oferta('Rock na Praça', 'Pista', 'Lote Promocional', 80, DATE '2025-12-01', 20);
    abrir_oferta('Rock na Praça', 'Pista', 'Primeiro Lote', 120, DATE '2026-01-15', 30);
    abrir_oferta('Rock na Praça', 'Arquibancada', 'Primeiro Lote', 90, DATE '2026-01-15', 25);
    abrir_oferta('Rock na Praça', 'Pista', 'Segundo Lote', 160, DATE '2026-02-20', 30);
    abrir_oferta('Rock na Praça', 'Arquibancada', 'Segundo Lote', 110, DATE '2026-02-20', 25);
    -- Teatro: A Última Sessão
    abrir_oferta('Teatro: A Última Sessão', 'Plateia', 'Primeiro Lote', 100, DATE '2026-06-15', 25);
    abrir_oferta('Teatro: A Última Sessão', 'Camarote', 'Primeiro Lote', 200, DATE '2026-06-15', 6);
    abrir_oferta('Teatro: A Última Sessão', 'Plateia', 'Segundo Lote', 130, DATE '2026-08-01', 20);
    -- Réveillon Orla de Boa Viagem 2027
    abrir_oferta('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Lote Promocional', 200, DATE '2026-08-15', 20);
    abrir_oferta('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Primeiro Lote', 300, DATE '2026-09-15', 30);
    abrir_oferta('Réveillon Orla de Boa Viagem 2027', 'Pista Premium', 'Primeiro Lote', 450, DATE '2026-09-15', 12);
    abrir_oferta('Réveillon Orla de Boa Viagem 2027', 'VIP', 'Primeiro Lote', 900, DATE '2026-09-15', 8);
    -- Festival de Jazz de Salvador
    abrir_oferta('Festival de Jazz de Salvador', 'Pista', 'Primeiro Lote', 110, DATE '2026-08-01', 30);
    abrir_oferta('Festival de Jazz de Salvador', 'Arquibancada', 'Primeiro Lote', 80, DATE '2026-08-01', 20);
    abrir_oferta('Festival de Jazz de Salvador', 'VIP', 'Primeiro Lote', 350, DATE '2026-08-01', 8);
    abrir_oferta('Festival de Jazz de Salvador', 'Pista', 'Segundo Lote', 150, DATE '2026-09-20', 30);
    -- Copa Nordeste de Futevôlei
    abrir_oferta('Copa Nordeste de Futevôlei', 'Arquibancada', 'Primeiro Lote', 50, DATE '2026-09-01', 30);
    abrir_oferta('Copa Nordeste de Futevôlei', 'Camarote', 'Primeiro Lote', 180, DATE '2026-09-01', 10);
    abrir_oferta('Copa Nordeste de Futevôlei', 'Arquibancada', 'Segundo Lote', 70, DATE '2026-10-01', 30);
END;
/

-- 9. Pedido (57), Forma_Pagamento (64) e venda dos ingressos
-- novo_pedido insere o pedido e 1 ou 2 formas de pagamento.
-- item vende os p_qtd ingressos livres de menor número da oferta e grava em
-- preco_pago o preço da oferta naquele momento.
-- O bloco dá erro se o pedido for anterior ao cadastro do usuário, se a compra
-- cair fora do período de venda ou se faltar ingresso.
DECLARE
    v_pedido    Pedido.id_pedido%TYPE;
    v_dt_pedido DATE;

    PROCEDURE novo_pedido (
        p_cpf    IN VARCHAR2,
        p_data   IN DATE,
        p_forma1 IN VARCHAR2,
        p_forma2 IN VARCHAR2 DEFAULT NULL
    ) IS
        v_cadastro DATE;
    BEGIN
        SELECT dt_cadastro INTO v_cadastro FROM Usuario WHERE cpf = p_cpf;
        IF p_data < v_cadastro THEN
            RAISE_APPLICATION_ERROR(-20001, 'Pedido anterior ao cadastro do usuario ' || p_cpf);
        END IF;
        v_dt_pedido := p_data;

        INSERT INTO Pedido (id_pedido, dt_realizacao, cpf_usuario)
        VALUES (seq_pedido.NEXTVAL, p_data, p_cpf)
        RETURNING id_pedido INTO v_pedido;

        INSERT INTO Forma_Pagamento (id_pedido, forma_pagamento) VALUES (v_pedido, p_forma1);
        IF p_forma2 IS NOT NULL THEN
            INSERT INTO Forma_Pagamento (id_pedido, forma_pagamento) VALUES (v_pedido, p_forma2);
        END IF;
    END novo_pedido;

    PROCEDURE item (
        p_evento IN VARCHAR2,
        p_setor  IN VARCHAR2,
        p_lote   IN VARCHAR2,
        p_qtd    IN INTEGER
    ) IS
        v_id_evento Evento.id_evento%TYPE;
        v_id_setor  Setor.id_setor%TYPE;
        v_id_lote   Lote.id_lote%TYPE;
        v_preco     Oferta.preco%TYPE;
        v_abertura  DATE;
        v_dt_evento DATE;
    BEGIN
        SELECT e.id_evento, s.id_setor, l.id_lote, o.preco, o.dt_abertura_venda, e.dt_realizacao
          INTO v_id_evento, v_id_setor, v_id_lote, v_preco, v_abertura, v_dt_evento
          FROM Evento e
          JOIN Oferta o ON o.id_evento = e.id_evento
          JOIN Setor  s ON s.id_setor  = o.id_setor
          JOIN Lote   l ON l.id_lote   = o.id_lote
         WHERE e.nome = p_evento AND s.nome = p_setor AND l.nome = p_lote;

        IF v_dt_pedido < v_abertura OR v_dt_pedido > v_dt_evento THEN
            RAISE_APPLICATION_ERROR(-20002, 'Compra fora da janela de venda: ' || p_evento || ' / ' || p_setor || ' / ' || p_lote);
        END IF;

        UPDATE Ingresso
           SET id_pedido = v_pedido, preco_pago = v_preco
         WHERE id_evento = v_id_evento
           AND num_ingresso IN (SELECT num_ingresso
                                  FROM (SELECT num_ingresso
                                          FROM Ingresso
                                         WHERE id_evento = v_id_evento
                                           AND id_setor  = v_id_setor
                                           AND id_lote   = v_id_lote
                                           AND id_pedido IS NULL
                                         ORDER BY num_ingresso)
                                 WHERE ROWNUM <= p_qtd);

        IF SQL%ROWCOUNT < p_qtd THEN
            RAISE_APPLICATION_ERROR(-20003, 'Estoque insuficiente: ' || p_evento || ' / ' || p_setor || ' / ' || p_lote);
        END IF;
    END item;
BEGIN
    novo_pedido('04812367091', DATE '2025-06-10', 'PIX');
        item('Festival Maré Viva 2025', 'Pista', 'Lote Promocional', 4);
    novo_pedido('20468351970', DATE '2025-06-15', 'CARTAO_CREDITO', 'PIX');
        item('Festival Maré Viva 2025', 'Pista', 'Lote Promocional', 6);
    novo_pedido('34720896512', DATE '2025-06-20', 'BOLETO');
        item('Festival Maré Viva 2025', 'Pista', 'Lote Promocional', 10);
    novo_pedido('83159702463', DATE '2025-07-05', 'PIX');
        item('Festival Maré Viva 2025', 'Pista', 'Primeiro Lote', 4);
    novo_pedido('67105438920', DATE '2025-07-08', 'CARTAO_CREDITO');
        item('Festival Maré Viva 2025', 'Pista', 'Primeiro Lote', 3);
        item('Festival Maré Viva 2025', 'Pista Premium', 'Primeiro Lote', 1);
    novo_pedido('75430918246', DATE '2025-08-02', 'PIX');
        item('Festival Maré Viva 2025', 'Pista', 'Primeiro Lote', 5);
        item('Festival Maré Viva 2025', 'Pista Premium', 'Primeiro Lote', 2);
    novo_pedido('48267019385', DATE '2025-08-15', 'CARTAO_CREDITO');
        item('Festival Maré Viva 2025', 'VIP', 'Primeiro Lote', 2);
    novo_pedido('38405917628', DATE '2025-09-05', 'CARTAO_CREDITO');
        item('Festival Maré Viva 2025', 'Pista', 'Segundo Lote', 4);
    novo_pedido('26839540170', DATE '2025-09-18', 'PIX', 'CARTAO_CREDITO');
        item('Festival Maré Viva 2025', 'Pista', 'Segundo Lote', 2);
        item('Festival Maré Viva 2025', 'Pista Premium', 'Segundo Lote', 2);
    novo_pedido('64912037851', DATE '2025-10-02', 'CARTAO_CREDITO');
        item('Festival Maré Viva 2025', 'Pista', 'Segundo Lote', 6);
    novo_pedido('85073261940', DATE '2025-11-05', 'PIX');
        item('Festival Maré Viva 2025', 'Pista Premium', 'Segundo Lote', 3);
        item('Festival Maré Viva 2025', 'VIP', 'Segundo Lote', 2);
    novo_pedido('51792368049', DATE '2025-11-12', 'PIX');
        item('Festival Maré Viva 2025', 'Pista', 'Segundo Lote', 5);
    novo_pedido('42690817355', DATE '2025-12-10', 'PIX');
        item('Rock na Praça', 'Pista', 'Lote Promocional', 8);
    novo_pedido('85073261940', DATE '2025-12-15', 'CARTAO_DEBITO');
        item('Rock na Praça', 'Pista', 'Lote Promocional', 12);
    novo_pedido('75430918246', DATE '2026-01-15', 'CARTAO_CREDITO');
        item('Recife Tech Summit 2026', 'Plateia', 'Lote Promocional', 5);
    novo_pedido('51792368049', DATE '2026-01-20', 'CARTAO_CREDITO', 'PIX');
        item('Recife Tech Summit 2026', 'Plateia', 'Lote Promocional', 15);
    novo_pedido('75430918246', DATE '2026-01-20', 'CARTAO_CREDITO');
        item('Rock na Praça', 'Pista', 'Primeiro Lote', 12);
    novo_pedido('26839540170', DATE '2026-01-28', 'PIX');
        item('Rock na Praça', 'Arquibancada', 'Primeiro Lote', 6);
    novo_pedido('70518342967', DATE '2026-02-01', 'CARTAO_CREDITO', 'PIX');
        item('Rock na Praça', 'Pista', 'Primeiro Lote', 8);
        item('Rock na Praça', 'Arquibancada', 'Primeiro Lote', 4);
    novo_pedido('90614783521', DATE '2026-02-10', 'CARTAO_CREDITO');
        item('Recife Tech Summit 2026', 'Plateia', 'Primeiro Lote', 10);
    novo_pedido('34720896512', DATE '2026-02-25', 'PIX');
        item('Recife Tech Summit 2026', 'Plateia', 'Primeiro Lote', 4);
        item('Recife Tech Summit 2026', 'VIP', 'Primeiro Lote', 1);
    novo_pedido('34720896512', DATE '2026-03-01', 'PIX');
        item('Rock na Praça', 'Pista', 'Segundo Lote', 7);
    novo_pedido('58714029366', DATE '2026-03-02', 'CARTEIRA_DIGITAL');
        item('Recife Tech Summit 2026', 'Plateia', 'Primeiro Lote', 8);
    novo_pedido('12983647053', DATE '2026-03-05', 'PIX');
        item('Noite do Forró Pé de Serra', 'Pista', 'Primeiro Lote', 6);
    novo_pedido('51792368049', DATE '2026-03-10', 'CARTAO_CREDITO');
        item('Rock na Praça', 'Pista', 'Segundo Lote', 5);
        item('Rock na Praça', 'Arquibancada', 'Segundo Lote', 3);
    novo_pedido('90614783521', DATE '2026-03-12', 'PIX');
        item('Noite do Forró Pé de Serra', 'Pista', 'Primeiro Lote', 10);
    novo_pedido('70518342967', DATE '2026-03-15', 'CARTAO_CREDITO');
        item('Recife Tech Summit 2026', 'Plateia', 'Segundo Lote', 6);
    novo_pedido('42690817355', DATE '2026-03-20', 'CARTAO_DEBITO');
        item('Noite do Forró Pé de Serra', 'Pista', 'Primeiro Lote', 14);
    novo_pedido('67105438920', DATE '2026-03-25', 'CARTAO_CREDITO');
        item('Noite do Forró Pé de Serra', 'Camarote', 'Primeiro Lote', 4);
    novo_pedido('83159702463', DATE '2026-03-25', 'PIX');
        item('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Primeiro Lote', 4);
    novo_pedido('48267019385', DATE '2026-04-01', 'CARTAO_CREDITO');
        item('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Primeiro Lote', 6);
        item('Stand-up Pernambuco: Risadas ao Vivo', 'Camarote', 'Primeiro Lote', 2);
    novo_pedido('85073261940', DATE '2026-04-02', 'PIX');
        item('Recife Tech Summit 2026', 'Plateia', 'Segundo Lote', 5);
        item('Recife Tech Summit 2026', 'VIP', 'Primeiro Lote', 2);
    novo_pedido('17356984206', DATE '2026-04-12', 'CARTAO_DEBITO');
        item('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Segundo Lote', 3);
    novo_pedido('70518342967', DATE '2026-04-20', 'PIX');
        item('Noite do Forró Pé de Serra', 'Pista', 'Segundo Lote', 8);
    novo_pedido('59081724630', DATE '2026-04-25', 'PIX');
        item('Stand-up Pernambuco: Risadas ao Vivo', 'Plateia', 'Segundo Lote', 8);
    novo_pedido('23947106588', DATE '2026-05-10', 'CARTAO_CREDITO');
        item('Noite do Forró Pé de Serra', 'Pista', 'Segundo Lote', 12);
    novo_pedido('04812367091', DATE '2026-05-25', 'PIX');
        item('Sabores do Nordeste', 'Pista', 'Primeiro Lote', 4);
        item('Sabores do Nordeste', 'VIP', 'Primeiro Lote', 2);
    novo_pedido('64912037851', DATE '2026-05-30', 'CARTAO_CREDITO', 'PIX');
        item('Noite do Forró Pé de Serra', 'Camarote', 'Segundo Lote', 6);
    novo_pedido('38405917628', DATE '2026-06-10', 'CARTAO_CREDITO');
        item('Sabores do Nordeste', 'Pista', 'Primeiro Lote', 10);
    novo_pedido('67105438920', DATE '2026-06-20', 'PIX');
        item('Teatro: A Última Sessão', 'Plateia', 'Primeiro Lote', 4);
    novo_pedido('81236459072', DATE '2026-06-25', 'CARTAO_CREDITO');
        item('Teatro: A Última Sessão', 'Plateia', 'Primeiro Lote', 6);
        item('Teatro: A Última Sessão', 'Camarote', 'Primeiro Lote', 2);
    novo_pedido('23947106588', DATE '2026-07-05', 'PIX');
        item('Sabores do Nordeste', 'Pista', 'Segundo Lote', 6);
    novo_pedido('81236459072', DATE '2026-07-20', 'CARTAO_CREDITO', 'PIX');
        item('Sabores do Nordeste', 'Pista', 'Segundo Lote', 10);
    novo_pedido('12983647053', DATE '2026-08-05', 'CARTAO_DEBITO');
        item('Teatro: A Última Sessão', 'Plateia', 'Segundo Lote', 3);
    novo_pedido('20468351970', DATE '2026-08-05', 'PIX');
        item('Festival de Jazz de Salvador', 'Pista', 'Primeiro Lote', 6);
    novo_pedido('37250914861', DATE '2026-08-10', 'CARTAO_CREDITO');
        item('Sabores do Nordeste', 'VIP', 'Primeiro Lote', 3);
    novo_pedido('38405917628', DATE '2026-08-12', 'CARTAO_CREDITO');
        item('Festival de Jazz de Salvador', 'Pista', 'Primeiro Lote', 4);
        item('Festival de Jazz de Salvador', 'VIP', 'Primeiro Lote', 1);
    novo_pedido('64912037851', DATE '2026-08-20', 'CARTAO_CREDITO');
        item('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Lote Promocional', 10);
    novo_pedido('90614783521', DATE '2026-08-25', 'PIX');
        item('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Lote Promocional', 10);
    novo_pedido('48267019385', DATE '2026-08-30', 'PIX');
        item('Festival de Jazz de Salvador', 'Arquibancada', 'Primeiro Lote', 4);
    novo_pedido('67105438920', DATE '2026-09-05', 'PIX');
        item('Copa Nordeste de Futevôlei', 'Arquibancada', 'Primeiro Lote', 6);
    novo_pedido('17356984206', DATE '2026-09-12', 'CARTAO_CREDITO');
        item('Copa Nordeste de Futevôlei', 'Arquibancada', 'Primeiro Lote', 4);
        item('Copa Nordeste de Futevôlei', 'Camarote', 'Primeiro Lote', 2);
    novo_pedido('83159702463', DATE '2026-09-20', 'CARTAO_CREDITO');
        item('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Primeiro Lote', 6);
    novo_pedido('36705298414', DATE '2026-09-22', 'PIX');
        item('Réveillon Orla de Boa Viagem 2027', 'Pista', 'Primeiro Lote', 4);
        item('Réveillon Orla de Boa Viagem 2027', 'Pista Premium', 'Primeiro Lote', 2);
    novo_pedido('59081724630', DATE '2026-09-25', 'CARTAO_DEBITO');
        item('Festival de Jazz de Salvador', 'Pista', 'Segundo Lote', 3);
    novo_pedido('23947106588', DATE '2026-09-28', 'CARTAO_CREDITO', 'PIX');
        item('Réveillon Orla de Boa Viagem 2027', 'VIP', 'Primeiro Lote', 2);
    novo_pedido('36705298414', DATE '2026-10-02', 'PIX');
        item('Copa Nordeste de Futevôlei', 'Arquibancada', 'Segundo Lote', 2);
END;
/

-- 10. Reajuste de preço de 3 ofertas depois das vendas.
-- O preco_pago dos ingressos já vendidos não muda (pergunta 25 do minimundo).
UPDATE Oferta SET preco = 65
 WHERE id_evento = (SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste')
   AND id_setor  = (SELECT id_setor  FROM Setor  WHERE nome = 'Pista')
   AND id_lote   = (SELECT id_lote   FROM Lote   WHERE nome = 'Segundo Lote');
UPDATE Oferta SET preco = 320
 WHERE id_evento = (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027')
   AND id_setor  = (SELECT id_setor  FROM Setor  WHERE nome = 'Pista')
   AND id_lote   = (SELECT id_lote   FROM Lote   WHERE nome = 'Primeiro Lote');
UPDATE Oferta SET preco = 380
 WHERE id_evento = (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026')
   AND id_setor  = (SELECT id_setor  FROM Setor  WHERE nome = 'Plateia')
   AND id_lote   = (SELECT id_lote   FROM Lote   WHERE nome = 'Segundo Lote');

-- 11. Vinculo (10)
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '20345678000119'),
        DATE '2024-03-01', DATE '2025-06-30',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '20345678000119'),
        DATE '2025-07-01', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Direção Artística'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '10234567000108'),
        DATE '2024-04-01', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '40567890000131'),
        DATE '2025-01-01', DATE '2025-12-31',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Marketing'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '60473829150'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '30456789000120'),
        DATE '2024-05-10', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Curadoria'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '10234567000108'),
        DATE '2024-03-15', DATE '2025-09-30',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '20345678000119'),
        DATE '2025-10-01', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '41857293610'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '30456789000120'),
        DATE '2025-02-01', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '96320481750'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '10234567000108'),
        DATE '2025-03-01', DATE '2026-02-28',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Marketing'));
INSERT INTO Vinculo (id_produtor, id_empresa, dt_inicio, dt_fim, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '58714029366'),
        (SELECT id_criador FROM Empresa  WHERE cnpj = '20345678000119'),
        DATE '2025-08-01', NULL,
        (SELECT id_funcao FROM Funcao WHERE nome = 'Captação de Patrocínio'));

-- 12. Atuacao (12) e Desempenha (18)
-- Thiago Barros tem duas atuações no Maré Viva, em períodos diferentes.
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-08-01', DATE '2025-12-05');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-07-01', DATE '2025-08-31');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-10-15', DATE '2025-12-01');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'),
        DATE '2026-01-10', DATE '2026-04-25');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'),
        DATE '2026-03-01', DATE '2026-06-20');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '73096158240'),
        (SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'),
        DATE '2026-02-15', DATE '2026-06-25');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '60473829150'),
        (SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'),
        DATE '2025-11-10', DATE '2026-04-05');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '41857293610'),
        (SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'),
        DATE '2026-01-05', DATE '2026-04-10');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '96320481750'),
        (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'),
        DATE '2026-01-15', DATE '2026-04-30');
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'),
        DATE '2026-07-01', NULL);
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '58714029366'),
        (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'),
        DATE '2026-07-15', NULL);
INSERT INTO Atuacao (id_produtor, id_evento, dt_inicio, dt_fim)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste'),
        DATE '2026-04-20', DATE '2026-09-05');

INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-08-01',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Direção Artística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-08-01',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Curadoria'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-07-01',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Festival Maré Viva 2025'),
        DATE '2025-10-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'),
        DATE '2026-01-10',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'),
        DATE '2026-01-10',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Credenciamento'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '15934782605'),
        (SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'),
        DATE '2026-03-01',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Coordenação de Palco'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '73096158240'),
        (SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'),
        DATE '2026-02-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '73096158240'),
        (SELECT id_evento FROM Evento WHERE nome = 'Noite do Forró Pé de Serra'),
        DATE '2026-02-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Marketing'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '60473829150'),
        (SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'),
        DATE '2025-11-10',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Curadoria'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '60473829150'),
        (SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'),
        DATE '2025-11-10',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Direção Artística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '41857293610'),
        (SELECT id_evento FROM Evento WHERE nome = 'Rock na Praça'),
        DATE '2026-01-05',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '96320481750'),
        (SELECT id_evento FROM Evento WHERE nome = 'Recife Tech Summit 2026'),
        DATE '2026-01-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Marketing'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '82619475030'),
        (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'),
        DATE '2026-07-01',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Direção Artística'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '58714029366'),
        (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'),
        DATE '2026-07-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Captação de Patrocínio'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '58714029366'),
        (SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'),
        DATE '2026-07-15',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Marketing'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste'),
        DATE '2026-04-20',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Produção Executiva'));
INSERT INTO Desempenha (id_produtor, id_evento, dt_inicio, id_funcao)
VALUES ((SELECT id_criador FROM Produtor WHERE cpf = '29581367408'),
        (SELECT id_evento FROM Evento WHERE nome = 'Sabores do Nordeste'),
        DATE '2026-04-20',
        (SELECT id_funcao FROM Funcao WHERE nome = 'Logística'));

COMMIT;
