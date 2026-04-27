# Guia Backend - Submodulo 10 Prestacao de Contas da Unidade

Este guia acompanha a migration `202604260023_sub10_backend.sql`.

## Objetivo

Transformar o `10_sub_prestacao_contas_unidade` em uma camada executavel do backend, fechando o processo do modulo com resumo operacional, evidencias, indicadores de conformidade, pendencias, historico de atualizacoes e integracao com financeiro, administrativo e auditoria.

Este submodulo nao substitui os relatorios especificos dos demais submodulos. Ele faz o fechamento auditavel da unidade e entrega dados consolidados para consumidores internos.

## Dependencias

- `01_sub_cadastro_unidades_agricolas`
- `09_sub_status_operacional_unidade`

## Fractais executados

1. `01_fractal_resumo_operacional_unidade`
2. `02_fractal_evidencias_suporte`
3. `03_fractal_indicadores_conformidade`
4. `04_fractal_pendencias_abertas`
5. `05_fractal_historico_atualizacoes`
6. `06_fractal_integracao_financeiro_admin_auditoria`

## Funcao principal

`unidade_agricola.salvar_sub10_prestacao_contas_unidade(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza a prestacao de contas em `sub10_prestacao_contas_unidade`;
- registra periodo, resumo, evidencias, conformidade, pendencias e valores referenciados;
- vincula opcionalmente ao status operacional do submodulo 09;
- cria os 6 fractais do submodulo 10;
- publica eventos validados para cada fractal;
- prepara integracao com financeiro, administrativo, auditoria, DataLake, dashboards e Genius Hub.

## Views criadas

`vw_sub10_prestacao_contas_operacional`

Mostra prestacoes de contas, unidade vinculada, periodo, evidencias, conformidade, pendencias, valores, status, validacao e readiness para modulos dependentes.

`vw_sub10_fractais_status_prestacao`

Mostra uma linha por fractal do submodulo 10 para cada prestacao de contas.

`vw_sub10_validacao_prestacao_contas`

Mostra se codigo, nome, periodo, unidade e evidencias estao consistentes.

`vw_sub10_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB10_PRESTACAO_CONTAS_BACKEND.sql`

Resultado esperado:

- 1 prestacao de contas teste criada ou atualizada;
- 6 fractais publicados para a prestacao;
- 6 eventos publicados no log para o submodulo 10;
- `status_validacao = saudavel`;
- `pronto_para_modulos_dependentes = true`;
- contrato backend visivel em `vw_sub10_contrato_backend`.
