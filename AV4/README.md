# AV4 - Consultas SQL e PL/SQL

Grupo 9 - Plataforma de eventos

## Arquivos

| Arquivo | O que faz |
|---|---|
| `01_sql_ddl_dml.sql` | ALTER TABLE, 2 índices, INSERT, UPDATE, DELETE e 2 views |
| `02_sql_consultas.sql` | 17 consultas que respondem perguntas e relatórios do minimundo |
| `03_sql_grant_revoke.sql` | GRANT e REVOKE comentados (o Live SQL não executa) |
| `04_pl_funcao_procedure.sql` | Função `fn_ingressos_disponiveis` e procedure `pr_relatorio_evento` |
| `05_pl_package.sql` | Package `pkg_vendas` (especificação e corpo) |
| `06_pl_triggers.sql` | Tabelas `Historico_Preco` e `Log_Operacao` e 4 triggers |
| `07_pl_testes.sql` | 6 blocos anônimos que usam a função, a procedure, a package e os triggers |
| `resultados/<script>_Resultado.txt` | Saída de cada script (exceto o `03`, que não executa nada) |

As saídas da pasta `resultados` foram geradas no Oracle AI Database 26ai Free (23.26), rodando localmente em contêiner, com o `sqlplus` executando os scripts da AV3 e da AV4 em sequência, do zero. É a mesma família de versão do Oracle Live SQL. Os ids e as datas de execução podem mudar de uma execução para outra.

## Como rodar

No Oracle Live SQL, cada arquivo como script inteiro, nesta ordem:

1. `AV3/01_ddl_criacao.sql` e `AV3/02_dml_povoamento.sql`
2. `AV4/01` a `AV4/07`

O `01` da AV4 altera a tabela Evento, então só roda uma vez sobre o povoamento. Para começar de novo é preciso rodar o `01` e o `02` da AV3 antes. O `06` apaga e recria as próprias tabelas, e o resto usa `CREATE OR REPLACE`.

O `UPDATE` de status e as compras usam `SYSDATE`. Os comentários com resultado esperado consideram o script rodado em outubro de 2026, com 7 eventos já realizados.

## Checklist SQL (26 itens)

| # | Item | Onde está |
|---|---|---|
| 1 | ALTER TABLE | `01`, seção 1: coluna `status` em Evento e a constraint `ck_evento_status` |
| 2 | CREATE INDEX | `01`, seção 2: `idx_ingresso_oferta` e `idx_pedido_data` |
| 3 | INSERT INTO | `01`, seção 4: usuária e telefone com `VALUES`; Segundo Lote do Réveillon com `INSERT ... SELECT`. Também na package e nos triggers |
| 4 | UPDATE | `01`, seção 3: eventos passados viram ENCERRADO. `07`, teste 6: reajuste de preço |
| 5 | DELETE | `01`, seção 5: telefone fixo de quem já tem celular |
| 6 | SELECT-FROM-WHERE | `02`, consulta 1 (junção escrita no `WHERE`) |
| 7 | BETWEEN | `02`, consulta 3 |
| 8 | IN | `02`, consulta 4 |
| 9 | LIKE | `02`, consulta 5 |
| 10 | IS NULL ou IS NOT NULL | `02`, consultas 6 e 17 |
| 11 | INNER JOIN | `02`, consultas 2, 3, 5 a 9, 11, 16 e 17 |
| 12 | MAX | `02`, consulta 7 |
| 13 | MIN | `02`, consulta 7 |
| 14 | AVG | `02`, consultas 7 e 9 |
| 15 | COUNT | `02`, consultas 2, 3, 4, 7, 8, 9 e 15 |
| 16 | LEFT, RIGHT ou FULL OUTER JOIN | `02`, consulta 2 (LEFT) e consulta 15 (FULL) |
| 17 | Subconsulta com operador relacional | `02`, consulta 9 |
| 18 | Subconsulta com IN | `02`, consulta 10 |
| 19 | Subconsulta com ANY | `02`, consulta 11 |
| 20 | Subconsulta com ALL | `02`, consulta 12 |
| 21 | ORDER BY | todas as consultas do `02` |
| 22 | GROUP BY | `02`, consultas 2, 3, 4, 5, 7, 8, 9 e 15 |
| 23 | HAVING | `02`, consultas 8 e 9 |
| 24 | UNION, INTERSECT ou MINUS | `02`, consulta 13 (INTERSECT) e consulta 14 (MINUS) |
| 25 | CREATE VIEW | `01`, seção 6: `vw_venda_ingresso` e `vw_resumo_evento`, usadas nas consultas 4, 7 e 12 |
| 26 | GRANT / REVOKE | `03` (comentado; ver abaixo) |

## Checklist PL (20 itens)

| # | Item | Onde está |
|---|---|---|
| 1 | RECORD | `05`: tipo `t_compra`. `07`, teste 3 |
| 2 | Estrutura do tipo TABLE | `05`: tipo `t_tab_compras` (`TABLE OF t_compra INDEX BY PLS_INTEGER`). `07`, teste 3 |
| 3 | Bloco anônimo | `07`, testes 1 a 6. Também o bloco de limpeza do `06` |
| 4 | CREATE PROCEDURE | `04`: `pr_relatorio_evento` |
| 5 | CREATE FUNCTION | `04`: `fn_ingressos_disponiveis` |
| 6 | %TYPE | Parâmetros e variáveis do `04`, `05` e `06` |
| 7 | %ROWTYPE | `04`: `Evento%ROWTYPE` e `Endereco%ROWTYPE` em `pr_relatorio_evento` |
| 8 | IF ELSIF | `05`: `emitir_ingressos` e `realizar_compra`. `06`: `trg_oferta_log` e `trg_ingresso_venda` |
| 9 | CASE WHEN | `04`: situação de cada oferta em `pr_relatorio_evento`. `07`, teste 1 |
| 10 | LOOP EXIT WHEN | `05`: laço do cursor em `realizar_compra` |
| 11 | WHILE LOOP | `05`: emissão em `emitir_ingressos` |
| 12 | FOR IN LOOP | `04`: cursor de ofertas. `05`: `historico_cliente`. `07`, testes 1 e 3 |
| 13 | SELECT ... INTO | `04`, `05` e `06` |
| 14 | CURSOR (OPEN, FETCH e CLOSE) | `05`: cursor `c_livres` em `realizar_compra` |
| 15 | EXCEPTION WHEN | `04`: `NO_DATA_FOUND` nas duas rotinas. `05`: `realizar_compra` e `valor_pedido`. `07`, teste 5 |
| 16 | Parâmetros IN, OUT e IN OUT | `05`: `realizar_compra` (`p_id_pedido` IN OUT, `p_valor` OUT) e `historico_cliente` (OUT) |
| 17 | CREATE OR REPLACE PACKAGE | `05`: `pkg_vendas` |
| 18 | CREATE OR REPLACE PACKAGE BODY | `05`: `pkg_vendas` |
| 19 | CREATE OR REPLACE TRIGGER (comando) | `06`: `trg_oferta_log` e `trg_pedido_sem_exclusao` |
| 20 | CREATE OR REPLACE TRIGGER (linha) | `06`: `trg_oferta_historico_preco` e `trg_ingresso_venda` |

## O que cada parte faz

**Consultas.** Cada consulta do `02` responde a uma pergunta (seção 5) ou a um relatório (seção 6) do minimundo, e o cabeçalho diz qual. Exemplos: receita mensal do semestre, ofertas encalhadas de eventos encerrados, clientes que gastaram acima da média, evento de maior receita por tipo de criador e uso de cada função como cargo e como papel em evento.

**Venda pela package.** Na AV3 a venda era feita por procedures locais dentro do script de povoamento. Na AV4 ela vira a `pkg_vendas`:

- `emitir_ingressos` emite os ingressos de uma oferta e continua a numeração do evento.
- `realizar_compra` cria o pedido (ou acrescenta ingressos a um pedido existente) e vende os ingressos livres de menor número. Se der erro no meio, volta ao savepoint e não fica pedido sem ingresso.
- `valor_pedido` devolve o valor total de um pedido.
- `historico_cliente` devolve os pedidos de um usuário.

**Triggers.** `trg_ingresso_venda` vale para qualquer venda, com ou sem a package. Ele bloqueia evento cancelado ou já realizado e oferta que ainda não abriu, e grava o `preco_pago` com o preço da oferta no momento da compra. `trg_oferta_historico_preco` guarda cada mudança de preço, o que explica a pergunta 25 (ingresso com `preco_pago` diferente do preço atual). `trg_oferta_log` e `trg_pedido_sem_exclusao` são de comando: o teste 6 faz um UPDATE de 4 ofertas e mostra 4 linhas no histórico e 1 no log.

**Testes.** O `07` usa tudo isso. O teste 5 segue o padrão do `04_teste_restricoes.sql` da AV3: 9 operações que o banco tem que recusar, cada uma impressa com OK ou FALHA. No fim confere que nenhuma compra recusada deixou pedido gravado.

## GRANT e REVOKE

O Oracle Live SQL não deixa criar usuário nem conceder privilégio, então os comandos do `03` estão comentados. `GRANT` dá a outro usuário ou papel um privilégio sobre um objeto (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `EXECUTE`). `REVOKE` tira um privilégio dado antes.

O cenário do arquivo tem dois perfis. Um analista só lê as views de relatório. A aplicação de vendas começa com escrita direta nas tabelas e, quando a `pkg_vendas` existe, recebe `EXECUTE` na package e perde o `INSERT` e o `UPDATE` diretos. A package roda com os privilégios do dono, então a compra continua funcionando, mas só pelo caminho que valida estoque e pedido.

## Mudanças em relação à AV3

- `Evento` ganhou a coluna `status` (ATIVO, ENCERRADO ou CANCELADO), com `CHECK`. O minimundo já separava eventos realizados de eventos à venda, mas isso só dava para calcular pela data. Agora o cancelamento também pode ser registrado.
- Novas tabelas `Historico_Preco` e `Log_Operacao`, preenchidas só pelos triggers. Ficam fora do modelo do minimundo porque são auditoria, não dado do negócio.
- Novos índices `idx_ingresso_oferta` e `idx_pedido_data`.
- Dados novos: uma usuária (Yasmin Correia, indicada pela Ana Beatriz), o Segundo Lote do Réveillon (3 ofertas e 50 ingressos) e uma compra dela pela package. Saem 4 telefones fixos. As 4 ofertas do Festival de Jazz ficam 10% mais caras.
