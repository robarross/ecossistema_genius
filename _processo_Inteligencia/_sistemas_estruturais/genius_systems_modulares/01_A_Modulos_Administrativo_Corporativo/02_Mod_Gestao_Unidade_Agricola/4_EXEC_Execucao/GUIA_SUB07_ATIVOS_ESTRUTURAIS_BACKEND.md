# Guia Backend - Submodulo 07 Base de Ativos Estruturais da Unidade

Este guia acompanha a migration `202604260020_sub07_backend.sql`.

## Objetivo

Transformar o `07_sub_base_ativos_estruturais_unidade` em uma camada executavel do backend, registrando estruturas existentes, benfeitorias, instalacoes fixas, equipamentos fixos, edificacoes e ativos estruturais associados a unidade agricola.

Este submodulo serve como base cadastral e operacional para o futuro `Mod_Construcoes_Rurais`, sem competir com ele.

## O que este submodulo faz

- cadastra ativos estruturais existentes na unidade;
- vincula o ativo a unidade agricola pelo `codigo_unidade` / `id_unidade_agricola`;
- pode vincular o ativo a uma area produtiva do submodulo 04 pelo `codigo_area_relacionada`;
- registra finalidade de uso, material predominante, area construida, capacidade, conservacao e prioridade de manutencao;
- marca se o ativo deve gerar demanda futura para Construcoes Rurais;
- publica eventos validados dos fractais para integracao com manutencao, patrimonio, georreferenciamento e Genius Hub.

## O que fica para o futuro Mod_Construcoes_Rurais

- projetos tecnicos;
- obras novas;
- reformas;
- orcamentos;
- cronogramas de execucao;
- equipes de obra;
- engenharia, ART/RRT, memoriais, plantas e acompanhamento tecnico;
- medicao de obra e entrega final.

Assim, o submodulo 07 diz: "este ativo existe, esta aqui, tem este uso e este estado". O modulo de Construcoes Rurais dira: "o que sera projetado, construido, reformado, orcado, executado e entregue".

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

## Complementa

- `04_sub_territorios_areas_producao`
- `Mod_Construcoes_Rurais`
- `Mod_Gestao_Manutencao`
- `Mod_Gestao_Patrimonial`
- `Mod_Gestao_Georreferenciamento`

## Fractais executados

1. `01_fractal_estruturas_existentes`
2. `02_fractal_benfeitorias_instalacoes_fixas`
3. `03_fractal_equipamentos_fixos_unidade`
4. `04_fractal_estado_conservacao`
5. `05_fractal_relacao_areas_uso_operacional`
6. `06_fractal_integracao_construcoes_manutencao`

## Funcao principal

`unidade_agricola.salvar_sub07_ativo_estrutural(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza o ativo em `sub07_ativos_estruturais`;
- vincula opcionalmente o ativo a area produtiva do submodulo 04;
- registra dados de localizacao, conservacao, uso, capacidade e manutencao;
- cria os 6 fractais do submodulo 07;
- publica eventos validados para cada fractal;
- deixa o ativo pronto para ser consumido pelo futuro modulo de Construcoes Rurais sem assumir as regras de obra.

## Views criadas

`vw_sub07_ativos_estruturais_operacional`

Mostra ativos estruturais, unidade vinculada, area relacionada, estado de conservacao, prioridade de manutencao, demanda para construcao rural, status de validacao e total de fractais validados.

`vw_sub07_fractais_status_ativo`

Mostra uma linha por fractal do submodulo 07 para cada ativo estrutural.

`vw_sub07_validacao_ativos_estruturais`

Mostra se codigo, nome, tipo, unidade e estado de conservacao estao consistentes.

`vw_sub07_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB07_ATIVOS_ESTRUTURAIS_BACKEND.sql`

Resultado esperado:

- 1 ativo estrutural teste criado ou atualizado;
- 6 fractais publicados para o ativo;
- 6 eventos publicados no log para o submodulo 07;
- `status_validacao = saudavel`;
- `pronto_para_modulos_dependentes = true`;
- contrato backend visivel em `vw_sub07_contrato_backend`.
