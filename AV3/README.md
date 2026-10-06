# AV3 - Scripts de criação e povoamento

Grupo 9 - Plataforma de eventos

## Arquivos

| Arquivo | O que faz |
|---|---|
| `01_ddl_criacao.sql` | Cria as 6 sequences, as 18 tabelas e 4 índices |
| `02_dml_povoamento.sql` | Povoa as 18 tabelas |
| `03_verificacao.sql` | 15 consultas para conferir o povoamento |
| `04_teste_restricoes.sql` | 11 comandos que o banco tem que recusar |
| `resultados/01_Resultado.txt` | Saída do script 01 no Oracle Live SQL |
| `resultados/02_Resultado.txt` | Saída dos scripts 01 e 02 rodados em sequência no Oracle Live SQL |
| `resultados/03_verificacao_Resultado.txt` | Saída do script 03 |
| `resultados/04_teste_restricoes_Resultado.txt` | Saída do script 04 |
| `Minimundo_AV3.md` | Minimundo atualizado (ALT-19 e ALT-20) |

## Como rodar

No Oracle Live SQL, rodar o 01 e depois o 02, cada um como script inteiro. O 03 e o 04 são opcionais.

O 01 apaga as tabelas e sequences antes de criar, então pode ser rodado de novo. Para povoar outra vez é preciso rodar o 01 antes.

## Checklist

| Item | Onde está |
|---|---|
| CREATE TABLE | 18 tabelas no script 01, uma para cada relação da AV2 |
| INSERT INTO | 194 comandos no script 02, mais os que ficam dentro dos dois blocos PL/SQL |
| CONSTRAINT | 18 PRIMARY KEY, 24 FOREIGN KEY e 8 UNIQUE, todas com nome |
| CREATE SEQUENCE | `seq_criador`, `seq_evento`, `seq_pedido`, `seq_funcao`, `seq_setor` e `seq_lote`, usadas com `NEXTVAL` em colunas INTEGER |
| CHECK | 21 no script 01: formato de CPF, CNPJ, CEP, telefone, e-mail e conta; valores permitidos de tipo_criador, UF, categoria e forma de pagamento; preço maior que zero; data final depois da inicial |

## Povoamento

| Tabela | Linhas | Tabela | Linhas |
|---|---|---|---|
| Usuario | 30 | Oferta | 40 |
| Telefone | 40 | Ingresso | 831 |
| Criador | 12 | Pedido | 57 |
| Produtor | 8 | Forma_Pagamento | 64 |
| Empresa | 4 | Funcao | 8 |
| Endereco | 12 | Vinculo | 10 |
| Evento | 10 | Atuacao | 12 |
| Categoria_Evento | 19 | Desempenha | 18 |
| Setor | 6 | Lote | 5 |

Dos 831 ingressos, 381 foram vendidos.

As ofertas, os ingressos e os pedidos são inseridos por dois blocos PL/SQL no script 02. O minimundo pede que os ingressos sejam emitidos junto com o evento e numerados em sequência dentro dele, e que o `preco_pago` seja o preço da oferta no dia da compra. Os blocos fazem isso e dão erro se um pedido for anterior ao cadastro do usuário, se cair fora do período de venda ou se faltar ingresso.

Os dados cobrem as situações que as perguntas do minimundo precisam:

- 5 ofertas esgotadas e as outras com venda parcial
- 7 eventos já realizados e 3 ainda à venda
- 7 pedidos com duas formas de pagamento e 14 com ingressos de setores diferentes
- 3 ofertas reajustadas depois da venda, com `preco_pago` diferente do preço atual
- 7 usuários que nunca compraram e 8 que não foram indicados por ninguém
- produtor com duas atuações no mesmo evento, produtor que mudou de cargo na mesma empresa, produtor em duas empresas e produtor que publica evento sem vínculo com empresa
- 4 eventos sem produtor atuando

## Mudanças em relação à AV2

Nenhuma relação, atributo ou chave primária mudou.

- `Usuario(email)` virou chave alternativa (UNIQUE e NOT NULL). Na AV2 estava como decisão a confirmar. É a ALT-19 do `Minimundo_AV3.md`.
- `Criador(agencia, num_conta)` é chave alternativa (UNIQUE). É a ALT-20 do `Minimundo_AV3.md`.
- Não foi criado atributo de quantidade em Oferta. A quantidade ofertada é a contagem dos ingressos emitidos para a oferta (`qtd_emitida`, atributo derivado da AV1), e a taxa de esgotamento é vendidos sobre emitidos. A consulta 11 do script 03 calcula isso.

## O que não dá para garantir com constraint

Estas regras ficam por conta do povoamento e são conferidas no script 03:

- todo Criador é Produtor ou Empresa, nunca os dois, e `tipo_criador` bate com a subclasse
- todo evento tem oferta, todo pedido tem ingresso e toda atuação tem função
- vínculos do mesmo produtor na mesma empresa não se sobrepõem

CPF e CNPJ não têm validação de dígito verificador.
