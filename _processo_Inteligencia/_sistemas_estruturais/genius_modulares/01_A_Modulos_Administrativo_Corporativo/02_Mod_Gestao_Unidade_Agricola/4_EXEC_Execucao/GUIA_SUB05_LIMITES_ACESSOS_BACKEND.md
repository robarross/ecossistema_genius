# Guia Backend - Submodulo 05 Limites e Acessos

Este guia acompanha a migration `202604260018_sub05_backend.sql`.

## Objetivo

Transformar o `05_sub_limites_acessos` em uma camada executavel do backend, registrando limites fisicos, acessos internos/externos, estradas, ramais, porteiras, pontos criticos e controle de circulacao da unidade.

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

## Complementa

`04_sub_territorios_areas_producao`

O campo `codigo_area_relacionada` permite vincular um acesso, limite ou ponto critico a uma area, gleba ou talhao.

## Fractais executados

1. `01_fractal_limites_fisicos_unidade`
2. `02_fractal_acessos_internos_externos`
3. `03_fractal_estradas_ramais_porteiras`
4. `04_fractal_pontos_criticos_acesso`
5. `05_fractal_controle_circulacao`
6. `06_fractal_integracao_seguranca_logistica_manutencao`

## Funcao principal

`unidade_agricola.salvar_sub05_limite_acesso(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza o limite/acesso em `sub05_limites_acessos`;
- registra relacao opcional com area do submodulo 04;
- cria os 6 fractais do submodulo 05;
- publica eventos validados para cada fractal;
- prepara dados para seguranca, logistica, manutencao, georreferenciamento e Genius Hub.

## Views criadas

`vw_sub05_limites_acessos_operacional`

Mostra limites/acessos, unidade vinculada, area relacionada, condicao de acesso, controle de circulacao, status de validacao e readiness para modulos dependentes.

`vw_sub05_fractais_status_limite_acesso`

Mostra uma linha por fractal do submodulo 05 para cada limite/acesso.

`vw_sub05_validacao_limites_acessos`

Mostra se codigo, nome, unidade, tipo e condicao de acesso estao consistentes.

`vw_sub05_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB05_LIMITES_ACESSOS_BACKEND.sql`

Resultado esperado:

- 1 limite/acesso teste criado ou atualizado;
- 6 fractais publicados para o limite/acesso;
- 6 eventos publicados no log para o submodulo 05;
- contrato backend visivel em `vw_sub05_contrato_backend`.
