# Guia Backend - Submodulo 03 Responsaveis e Gestores

Este guia acompanha a migration `202604260016_sub03_backend.sql`.

## Objetivo

Transformar o `03_sub_responsaveis_gestores` em uma camada executavel do backend, conectada ao submodulo 01 por `id_unidade_agricola` e `codigo_unidade`.

Este submodulo tambem complementa o submodulo 02, porque um responsavel pode ser proprietario, possuidor, gestor, tecnico ou operador. Quando houver relacao com titular, use `codigo_titular`.

## Dependencias

Obrigatoria:

`01_sub_cadastro_unidades_agricolas`

Complementar:

`02_sub_proprietarios_possuidores`

## Fractais executados

1. `01_fractal_cadastro_responsaveis`
2. `02_fractal_funcoes_papeis_operacionais`
3. `03_fractal_responsabilidade_tecnica`
4. `04_fractal_responsabilidade_administrativa`
5. `05_fractal_niveis_autorizacao`
6. `06_fractal_integracao_tarefas_projetos_cowork`

## Funcao principal

`unidade_agricola.salvar_sub03_responsavel_gestor(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade para submodulos dependentes;
- vincula opcionalmente o responsavel a um titular do submodulo 02 por `codigo_titular`;
- cria ou atualiza o responsavel em `sub03_responsaveis_gestores`;
- cria os 6 fractais do submodulo 03;
- publica eventos validados para cada fractal;
- deixa o responsavel pronto para Projetos, Tarefas, Cowork/Workspace, Permissoes e Genius Hub.

## Views criadas

`vw_sub03_responsaveis_gestores_operacional`

Mostra responsaveis, unidade vinculada, titular complementar, status de validacao, total de fractais validados e readiness para modulos dependentes.

`vw_sub03_fractais_status_responsavel`

Mostra uma linha por fractal do submodulo 03 para cada responsavel.

`vw_sub03_validacao_responsaveis`

Mostra se nome, tipo de responsabilidade, nivel de autorizacao e unidade vinculada estao consistentes.

`vw_sub03_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB03_RESPONSAVEIS_GESTORES_BACKEND.sql`

Resultado esperado:

- 1 responsavel teste criado ou atualizado;
- 6 fractais publicados para o responsavel;
- 6 eventos publicados no log para o submodulo 03;
- contrato backend visivel em `vw_sub03_contrato_backend`.
