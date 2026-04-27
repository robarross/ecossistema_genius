# Guia Backend - Submodulo 09 Status Operacional da Unidade

Este guia acompanha a migration `202604260022_sub09_backend.sql`.

## Objetivo

Transformar o `09_sub_status_operacional_unidade` em uma camada executavel do backend, consolidando status geral, produtivo, documental, estrutural, riscos, pendencias, alertas e planejamento da unidade agricola.

Este submodulo nao substitui dashboards. Ele registra o status operacional oficial que dashboards, BI, agentes, planejamento e tarefas podem consumir.

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

## Consolida

- `03_sub_responsaveis_gestores`
- `04_sub_territorios_areas_producao`
- `06_sub_documentacao_unidade`
- `07_sub_base_ativos_estruturais_unidade`
- `08_sub_chaves_permissoes_operacionais`

## Fractais executados

1. `01_fractal_status_geral_unidade`
2. `02_fractal_status_produtivo`
3. `03_fractal_status_documental`
4. `04_fractal_status_estrutural`
5. `05_fractal_status_risco_pendencia`
6. `06_fractal_integracao_dashboards_alertas_planejamento`

## Funcao principal

`unidade_agricola.salvar_sub09_status_operacional_unidade(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza o status em `sub09_status_operacional_unidade`;
- registra status geral, produtivo, documental, estrutural, risco, pendencias e alertas;
- cria os 6 fractais do submodulo 09;
- publica eventos validados para cada fractal;
- prepara o consumo por dashboards, planejamento, tarefas, alertas, agentes e Genius Hub.

## Views criadas

`vw_sub09_status_operacional_unidade`

Mostra o status consolidado da unidade, indicadores de risco/pendencia, status de validacao, total de fractais validados e readiness para modulos dependentes.

`vw_sub09_fractais_status_operacional`

Mostra uma linha por fractal do submodulo 09 para cada registro de status operacional.

`vw_sub09_validacao_status_operacional`

Mostra se codigo, ciclo, status geral e unidade estao consistentes.

`vw_sub09_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB09_STATUS_OPERACIONAL_BACKEND.sql`

Resultado esperado:

- 1 status operacional teste criado ou atualizado;
- 6 fractais publicados para o status;
- 6 eventos publicados no log para o submodulo 09;
- `status_validacao = saudavel`;
- `pronto_para_modulos_dependentes = true`;
- contrato backend visivel em `vw_sub09_contrato_backend`.
