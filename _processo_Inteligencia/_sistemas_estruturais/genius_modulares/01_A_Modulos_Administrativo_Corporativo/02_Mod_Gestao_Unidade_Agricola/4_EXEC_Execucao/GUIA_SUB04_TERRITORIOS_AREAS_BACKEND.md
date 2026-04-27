# Guia Backend - Submodulo 04 Territorios e Areas de Producao

Este guia acompanha a migration `202604260017_sub04_backend.sql`.

## Objetivo

Transformar o `04_sub_territorios_areas_producao` em uma camada executavel do backend, estruturando areas produtivas, glebas, talhoes, usos atuais e potencial produtivo da unidade agricola.

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

A unidade precisa estar pronta em:

`vw_sub01_cadastro_unidades_agricolas_operacional.pronto_para_submodulos_dependentes = true`

## Fractais executados

1. `01_fractal_areas_produtivas`
2. `02_fractal_glebas_talhoes`
3. `03_fractal_uso_atual_area`
4. `04_fractal_potencial_produtivo`
5. `05_fractal_historico_ocupacao_uso`
6. `06_fractal_integracao_producao_geo_precisao`

## Funcao principal

`unidade_agricola.salvar_sub04_area_producao(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade para submodulos dependentes;
- cria ou atualiza a area produtiva em `sub04_territorios_areas_producao`;
- registra gleba/talhao e area pai quando informado;
- cria os 6 fractais do submodulo 04;
- publica eventos validados para cada fractal;
- prepara a area para Producao Vegetal, Producao Animal, Georreferenciamento, Agricultura de Precisao, Dashboards e Genius Hub.

## Views criadas

`vw_sub04_territorios_areas_operacional`

Mostra areas, unidade vinculada, uso atual, cultura/atividade, status de validacao, total de fractais validados e readiness para modulos dependentes.

`vw_sub04_fractais_status_area`

Mostra uma linha por fractal do submodulo 04 para cada area.

`vw_sub04_validacao_areas_producao`

Mostra se codigo, nome, unidade, area em hectares e uso atual estao consistentes.

`vw_sub04_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB04_TERRITORIOS_AREAS_BACKEND.sql`

Resultado esperado:

- 1 area teste criada ou atualizada;
- 6 fractais publicados para a area;
- 6 eventos publicados no log para o submodulo 04;
- contrato backend visivel em `vw_sub04_contrato_backend`.
