# Checklist de Replicação do Padrão Plug and Play

Use este checklist para aplicar o padrão do módulo Gestão da Unidade Agrícola em outros módulos do Ecossistema Genius.

## 1. Estrutura base

- [ ] Criar pasta do módulo.
- [ ] Criar `0_IN_Entrada`.
- [ ] Criar `1_DNA_Processo`.
- [ ] Criar `2_OUT_Saida`.
- [ ] Criar `3_LIB_Biblioteca`.
- [ ] Criar `4_EXEC_Execucao`.
- [ ] Criar `README.md`.
- [ ] Criar `manifesto_modulo.json`.
- [ ] Criar `contrato_integracao.md`.

## 2. Fractais

- [ ] Criar fractais centrais do módulo.
- [ ] Criar fractais por submódulo.
- [ ] Criar `README.md` por fractal.
- [ ] Criar `manifesto_fractal.json` por fractal.
- [ ] Criar `contrato_integracao.md` por fractal.
- [ ] Criar `schema_dados.json` por fractal.
- [ ] Criar `eventos_fractal.md` por fractal.

## 3. Consolidação

- [ ] Criar catálogo de fractais.
- [ ] Criar catálogo de eventos.
- [ ] Criar catálogo de schemas.
- [ ] Criar matriz de integração.
- [ ] Criar índice operacional.

## 4. Supabase

- [ ] Criar schema do módulo.
- [ ] Criar tabela raiz.
- [ ] Criar tabelas dos fractais.
- [ ] Criar catálogo de eventos.
- [ ] Criar log de eventos.
- [ ] Criar seed.
- [ ] Criar testes de implantação.

## 5. API e integrações

- [ ] Criar OpenAPI.
- [ ] Criar contrato de API.
- [ ] Criar webhooks/eventos.
- [ ] Criar SDK client conceitual.

## 6. Dashboards e auditoria

- [ ] Criar views operacionais.
- [ ] Criar views de KPIs.
- [ ] Criar views relacionais.
- [ ] Criar views de auditoria/qualidade.
- [ ] Criar views de liberação para ecossistema.

## 7. Importação

- [ ] Criar staging de planilha/CSV.
- [ ] Criar modelos CSV/XLSX.
- [ ] Criar função de processamento.
- [ ] Criar pré-validação.
- [ ] Criar view de erros.
- [ ] Criar testes de importação.

## 8. Liberação

- [ ] Validar dados mínimos.
- [ ] Validar eventos.
- [ ] Validar dashboards.
- [ ] Validar auditoria saudável.
- [ ] Liberar módulos consumidores.

## 9. Critério de pronto

O módulo pode ser considerado plug and play quando:

- importa dados;
- processa para tabelas oficiais;
- cria fractais;
- publica eventos;
- alimenta dashboards;
- passa na auditoria;
- libera dados para outros módulos.
