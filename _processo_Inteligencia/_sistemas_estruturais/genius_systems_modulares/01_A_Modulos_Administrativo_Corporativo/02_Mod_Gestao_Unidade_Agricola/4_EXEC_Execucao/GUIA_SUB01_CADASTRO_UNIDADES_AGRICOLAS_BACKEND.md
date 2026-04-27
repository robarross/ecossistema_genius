# Guia Backend - Submodulo 01 Cadastro de Unidades Agricolas

Este guia acompanha a migration `202604260014_sub01_backend.sql`.

## Objetivo

Transformar o `01_sub_cadastro_unidades_agricolas` em uma camada executavel do backend, com funcao de cadastro, validacao, eventos, views operacionais e contrato plug and play.

## Fractais executados

1. `01_fractal_dados_basicos_unidade`
2. `02_fractal_localizacao_referencia_territorial`
3. `03_fractal_classificacao_unidade`
4. `04_fractal_situacao_cadastral`
5. `05_fractal_validacao_campos_obrigatorios`
6. `06_fractal_integracao_datalake_mapas_modulos`

## Funcao principal

`unidade_agricola.salvar_sub01_cadastro_unidade_agricola(...)`

Ela faz:

- cria ou atualiza a unidade em `unidades_agricolas`;
- cria ou atualiza os 6 fractais do submodulo 01;
- publica eventos validados para cada fractal;
- deixa a unidade pronta para alimentar submodulos dependentes quando os fractais base estiverem completos.

## Views criadas

`vw_sub01_cadastro_unidades_agricolas_operacional`

Mostra a unidade, status de validacao, total de fractais validados e se ela esta pronta para submodulos dependentes.

`vw_sub01_fractais_status_unidade`

Mostra uma linha por fractal do submodulo 01 para cada unidade agricola.

`vw_sub01_validacao_campos_obrigatorios`

Mostra se os campos essenciais da unidade estao preenchidos.

`vw_sub01_contrato_backend`

Expõe o contrato backend do submodulo para a Plataforma Genius e para os demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB01_CADASTRO_UNIDADES_AGRICOLAS_BACKEND.sql`

Resultado esperado:

- 1 unidade teste criada ou atualizada;
- 6 fractais validados para a unidade;
- 6 eventos publicados no log para o submodulo 01;
- contrato backend visivel em `vw_sub01_contrato_backend`.
