# 01_fractal_cadastro_responsaveis

## Nome
Cadastro de responsaveis

## Funcao
Registra responsaveis administrativos, tecnicos, operacionais e financeiros.

## Escopo
fractal_submodulo

## Padrao plug and play
Este fractal possui contrato, manifesto, schema de dados e eventos proprios para poder ser ativado, reutilizado, versionado e integrado aos demais modulos do ecossistema Genius.

## Entradas esperadas
- Dados cadastrais ou operacionais relacionados ao escopo do fractal.
- Identificadores do modulo, submodulo, unidade agricola e usuario responsavel.
- Eventos consumidos de outros fractais, quando aplicavel.

## Saidas geradas
- Registros validados para uso interno e integracao.
- Eventos publicados para Hub, DataLake, dashboards e APIs.
- Indicadores e status para acompanhamento operacional.
