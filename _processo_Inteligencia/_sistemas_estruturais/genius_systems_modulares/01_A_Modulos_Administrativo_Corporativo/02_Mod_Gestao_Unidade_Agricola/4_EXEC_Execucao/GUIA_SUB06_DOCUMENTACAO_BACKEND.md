# Guia Backend - Submodulo 06 Documentacao da Unidade

Este guia acompanha a migration `202604260019_sub06_backend.sql`.

## Objetivo

Transformar o `06_sub_documentacao_unidade` em uma camada executavel do backend, organizando documentos fundiarios, ambientais, fiscais/cadastrais, validades, vencimentos, uploads/evidencias e integracoes.

## Dependencia obrigatoria

`01_sub_cadastro_unidades_agricolas`

## Complementa

- `Mod_Gestao_Regularizacao_Fundiaria`
- `Mod_Gestao_Fiscal_Tributaria`
- `Mod_Gestao_Juridica`
- `Mod_Gestao_Documentos_Storage`

## Fractais executados

1. `01_fractal_documentos_fundiarios`
2. `02_fractal_documentos_ambientais`
3. `03_fractal_documentos_fiscais_cadastrais`
4. `04_fractal_validades_vencimentos`
5. `05_fractal_uploads_evidencias`
6. `06_fractal_integracao_regularizacao_fiscal_storage`

## Funcao principal

`unidade_agricola.salvar_sub06_documento_unidade(...)`

Ela faz:

- localiza a unidade pelo `codigo_unidade`;
- verifica se o submodulo 01 liberou a unidade;
- cria ou atualiza o documento em `sub06_documentos_unidade`;
- calcula status de validade/vencimento;
- registra referencia de arquivo, bucket e path de storage;
- cria os 6 fractais do submodulo 06;
- publica eventos validados para cada fractal;
- prepara dados para regularizacao fundiaria, fiscal/tributario, juridico e storage.

## Views criadas

`vw_sub06_documentacao_operacional`

Mostra documentos, unidade vinculada, validade, evidencia, status de validacao, total de fractais validados e readiness para modulos dependentes.

`vw_sub06_fractais_status_documento`

Mostra uma linha por fractal do submodulo 06 para cada documento.

`vw_sub06_validacao_documentos`

Mostra se codigo, nome, tipo, unidade, arquivo/evidencia e validade estao consistentes.

`vw_sub06_contrato_backend`

Expoe o contrato backend do submodulo para a Plataforma Genius e demais modulos consumidores.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_SUB06_DOCUMENTACAO_BACKEND.sql`

Resultado esperado:

- 1 documento teste criado ou atualizado;
- 6 fractais publicados para o documento;
- 6 eventos publicados no log para o submodulo 06;
- contrato backend visivel em `vw_sub06_contrato_backend`.
