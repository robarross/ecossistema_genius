# Guia Backend - Submodulo 02 Proprietarios e Possuidores

Este guia acompanha a migration `202604260015_sub02_backend.sql`.

## Objetivo

Transformar o `02_sub_proprietarios_possuidores` em uma camada executavel do backend, conectada ao submodulo 01 por `id_unidade_agricola` e `codigo_unidade`.

## Dependencia obrigatoria

Antes de cadastrar titulares, a unidade precisa estar pronta no submodulo 01:

`vw_sub01_cadastro_unidades_agricolas_operacional.pronto_para_submodulos_dependentes = true`

## Fractais executados

1. `01_fractal_cadastro_proprietarios`
2. `02_fractal_cadastro_possuidores`
3. `03_fractal_documentos_titulares`
4. `04_fractal_vinculos_unidade_agricola`
5. `05_fractal_historico_titularidade`
6. `06_fractal_integracao_contratos_juridico_permissoes`

## Funcao principal

`unidade_agricola.salvar_sub02_proprietario_possuidor(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade para submodulos dependentes;
- cria ou atualiza o titular em `sub02_titulares_unidade`;
- cria os 6 fractais do submodulo 02;
- publica eventos validados para cada fractal;
- deixa o titular pronto para contratos, juridico, fiscal, permissoes e Genius Hub.

## Views criadas

`vw_sub02_proprietarios_possuidores_operacional`

Mostra titulares, unidade vinculada, status de validacao, total de fractais validados e readiness para modulos dependentes.

`vw_sub02_fractais_status_titular`

Mostra uma linha por fractal do submodulo 02 para cada titular.

`vw_sub02_validacao_titulares`

Mostra se nome, vinculo, documento e unidade vinculada estao consistentes.

`vw_sub02_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e para os demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB02_PROPRIETARIOS_POSSUIDORES_BACKEND.sql`

Resultado esperado:

- 1 titular teste criado ou atualizado;
- 6 fractais publicados para o titular;
- 6 eventos publicados no log para o submodulo 02;
- contrato backend visivel em `vw_sub02_contrato_backend`.
