# Guia Backend - Submodulo 08 Chaves e Permissoes Operacionais

Este guia acompanha a migration `202604260021_sub08_backend.sql`.

## Objetivo

Transformar o `08_sub_chaves_permissoes_operacionais` em uma camada executavel do backend, controlando chaves fisicas, acessos digitais, perfis operacionais, autorizacoes por area ou funcao, historico de acesso e integracao com seguranca, Cowork e Workspace.

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

## Complementa

- `03_sub_responsaveis_gestores`
- `04_sub_territorios_areas_producao`
- `07_sub_base_ativos_estruturais_unidade`
- `Mod_Gestao_Seguranca_Patrimonial`
- `Mod_Gestao_Cowork_Workspace`
- `Mod_Gestao_Chaves_Permissoes`
- `Mod_Gestao_Genius_Hub`

## Fractais executados

1. `01_fractal_chaves_fisicas`
2. `02_fractal_acessos_digitais`
3. `03_fractal_perfis_operacionais`
4. `04_fractal_autorizacoes_area_funcao`
5. `05_fractal_historico_acesso`
6. `06_fractal_integracao_seguranca_cowork_workspace`

## Funcao principal

`unidade_agricola.salvar_sub08_chave_permissao_operacional(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza a permissao em `sub08_chaves_permissoes_operacionais`;
- vincula opcionalmente a responsavel, titular, area e ativo estrutural;
- registra tipo de acesso, perfil, nivel de permissao, recurso controlado, credencial, validade e historico;
- cria os 6 fractais do submodulo 08;
- publica eventos validados para cada fractal;
- prepara a unidade para integracao com seguranca, Cowork, Workspace, tarefas e Genius Hub.

## Views criadas

`vw_sub08_chaves_permissoes_operacional`

Mostra chaves/permissoes, unidade vinculada, responsavel, area, ativo estrutural, perfil, nivel, validade, status de validacao e readiness para modulos dependentes.

`vw_sub08_fractais_status_chave_permissao`

Mostra uma linha por fractal do submodulo 08 para cada chave/permissao.

`vw_sub08_validacao_chaves_permissoes`

Mostra se codigo, nome, tipo de acesso, unidade e perfil estao consistentes.

`vw_sub08_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB08_CHAVES_PERMISSOES_BACKEND.sql`

Resultado esperado:

- 1 chave/permissao teste criada ou atualizada;
- 6 fractais publicados para a permissao;
- 6 eventos publicados no log para o submodulo 08;
- `status_validacao = saudavel`;
- `pronto_para_modulos_dependentes = true`;
- contrato backend visivel em `vw_sub08_contrato_backend`.
