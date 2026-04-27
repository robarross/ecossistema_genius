# Guia - Funcao de Auditoria Geral do Modulo

Este guia acompanha a migration `202604260025_funcao_auditoria_geral_modulo.sql`.

## Objetivo

Criar uma funcao que audita automaticamente o `Mod_Gestao_Unidade_Agricola` para uma unidade especifica.

## Funcao criada

`unidade_agricola.auditar_modulo_unidade_agricola(p_codigo_unidade text)`

## O que ela retorna

- status geral do modulo;
- se a unidade esta pronta para o Ecossistema Genius;
- total de submodulos previstos;
- total de submodulos prontos;
- total de submodulos pendentes;
- percentual de prontidao dos submodulos;
- total de fractais validados;
- total de fractais registrados;
- percentual de fractais validados;
- diagnostico textual;
- pendencias em JSON;
- proximas acoes em JSON;
- resumo completo dos submodulos.

## Fonte de dados

A funcao usa a view:

`unidade_agricola.vw_modulo_unidade_agricola_consolidado`

Assim, ela nao duplica regras dos submodulos. Ela apenas transforma a visao consolidada em diagnostico automatico.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_FUNCAO_AUDITORIA_GERAL_MODULO.sql`

Resultado esperado para a unidade de teste completa:

- `status_modulo = saudavel`;
- `pronto_para_ecossistema_genius = true`;
- `total_submodulos_prontos = 10`;
- `total_submodulos_pendentes = 0`;
- `total_fractais_validados = 60`;
- `total_fractais_registrados = 60`;
- `pendencias = []`.
