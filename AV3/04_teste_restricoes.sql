-- Teste das constraints. Rodar depois do 01 e do 02.
-- São 11 comandos que o banco tem que recusar. Cada um deve imprimir uma linha
-- começando com OK e o erro do Oracle; se aparecer FALHA, a constraint não pegou.
-- O ROLLBACK no fim desfaz qualquer comando aceito por engano.
DECLARE
    PROCEDURE teste (p_descricao IN VARCHAR2, p_comando IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_comando;
        DBMS_OUTPUT.PUT_LINE('FALHA | ' || p_descricao || ' | o comando foi aceito');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OK    | ' || p_descricao || ' | ' || SUBSTR(SQLERRM, 1, 110));
    END teste;
BEGIN
    teste('01 CPF com 10 digitos (CHECK ck_usuario_cpf)',
          q'[INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro) VALUES ('1234567890', 'Teste', 'Cpf', 'teste.cpf@email.com', DATE '1990-01-01', DATE '2026-01-01')]');

    teste('02 e-mail duplicado (UNIQUE uk_usuario_email)',
          q'[INSERT INTO Usuario (cpf, primeiro_nome, sobrenome, email, dt_nascimento, dt_cadastro) VALUES ('99999999999', 'Teste', 'Email', 'ana.albuquerque@gmail.com', DATE '1990-01-01', DATE '2026-01-01')]');

    teste('03 usuario indicando a si mesmo (CHECK ck_usuario_autoindicacao)',
          q'[UPDATE Usuario SET cpf_indicador = cpf, dt_indicacao = DATE '2026-01-01' WHERE cpf = '04812367091']');

    teste('04 tipo_criador fora do dominio (CHECK ck_criador_tipo)',
          q'[INSERT INTO Criador (id_criador, agencia, num_conta, tipo_criador) VALUES (seq_criador.NEXTVAL, '9999', '99999-9', 'ONG')]');

    teste('05 UF inexistente (CHECK ck_endereco_uf)',
          q'[INSERT INTO Endereco (cep, logradouro, bairro, cidade, uf) VALUES ('12345678', 'Rua Teste', 'Bairro', 'Cidade', 'XX')]');

    teste('06 setor com nome repetido (UNIQUE uk_setor_nome)',
          q'[INSERT INTO Setor (id_setor, nome, descricao) VALUES (seq_setor.NEXTVAL, 'Pista', 'duplicado')]');

    teste('07 oferta com preco zero (CHECK ck_oferta_preco)',
          q'[UPDATE Oferta SET preco = 0 WHERE ROWNUM = 1]');

    teste('08 preco_pago em ingresso sem pedido (CHECK ck_ingresso_venda)',
          q'[UPDATE Ingresso SET preco_pago = 50 WHERE id_pedido IS NULL AND ROWNUM = 1]');

    teste('09 ingresso em oferta inexistente, setor Camarote no Reveillon (FK fk_ingresso_oferta)',
          q'[INSERT INTO Ingresso (id_evento, num_ingresso, preco_pago, id_setor, id_lote, id_pedido) VALUES ((SELECT id_evento FROM Evento WHERE nome = 'Réveillon Orla de Boa Viagem 2027'), 9999, NULL, (SELECT id_setor FROM Setor WHERE nome = 'Camarote'), (SELECT id_lote FROM Lote WHERE nome = 'Primeiro Lote'), NULL)]');

    teste('10 vinculo terminando antes de comecar (CHECK ck_vinculo_periodo)',
          q'[UPDATE Vinculo SET dt_fim = dt_inicio - 1 WHERE ROWNUM = 1]');

    teste('11 excluir evento que tem ofertas, ingressos e atuacoes (FK das tabelas filhas)',
          q'[DELETE FROM Evento WHERE nome = 'Rock na Praça']');

    ROLLBACK;
END;
/
