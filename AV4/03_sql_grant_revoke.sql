-- GRANT e REVOKE.
--
-- O Oracle Live SQL não deixa criar usuários nem conceder privilégios, então
-- os comandos ficam comentados. Rodar este arquivo não faz nada.
--
-- GRANT dá a outro usuário (ou papel) um privilégio sobre um objeto do nosso
-- esquema: SELECT, INSERT, UPDATE, DELETE em tabela ou view, EXECUTE em
-- procedure, função ou package. REVOKE retira um privilégio dado antes.
-- WITH GRANT OPTION deixa quem recebeu repassar o privilégio a terceiros.
--
-- Cenário: dois perfis acessam o banco da plataforma.
--   analista_bi  monta os relatórios e só lê.
--   app_vendas   é a aplicação web que registra as compras.


-- analista_bi lê as views de relatório, sem ver CPF nem e-mail das tabelas base.
-- GRANT SELECT ON vw_resumo_evento  TO analista_bi;
-- GRANT SELECT ON vw_venda_ingresso TO analista_bi;

-- Primeira versão da aplicação: gravava a compra direto nas tabelas.
-- GRANT SELECT ON Evento  TO app_vendas;
-- GRANT SELECT ON Oferta  TO app_vendas;
-- GRANT SELECT, INSERT ON Pedido          TO app_vendas;
-- GRANT SELECT, INSERT ON Forma_Pagamento TO app_vendas;
-- GRANT SELECT, UPDATE (id_pedido, preco_pago) ON Ingresso TO app_vendas;

-- Com a pkg_vendas (script 05), a compra passa a ser feita só pela procedure
-- realizar_compra, que valida estoque e pedido. A aplicação recebe EXECUTE na
-- package e perde a escrita direta nas tabelas. A package roda com os
-- privilégios do dono, então continua conseguindo gravar.
-- GRANT EXECUTE ON pkg_vendas TO app_vendas;
-- REVOKE INSERT ON Pedido          FROM app_vendas;
-- REVOKE INSERT ON Forma_Pagamento FROM app_vendas;
-- REVOKE UPDATE ON Ingresso        FROM app_vendas;
