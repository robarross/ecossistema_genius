# FLUXO_OPERACIONAL_PLUG_AND_PLAY_Mod_Gestao_Unidade_Agricola

Este fluxo mostra como o modulo deve operar quando instalado como componente plug and play do ecossistema Genius.

## Fluxo principal

1. Cadastro ou atualizacao da unidade agricola.
2. Ativacao dos fractais centrais do modulo.
3. Ativacao dos fractais dos submodulos conforme necessidade da unidade.
4. Validacao de campos obrigatorios, documentos, vinculos, areas e permissoes.
5. Gravacao em Supabase ou base operacional equivalente.
6. Publicacao de eventos no Genius Hub.
7. Indexacao no DataLake.
8. Atualizacao dos dashboards do modulo e dashboards executivos.
9. Exposicao controlada por APIs.
10. Consumo por agentes, automacoes, modulos produtivos, territoriais, financeiros, fiscais e marketplace.

## Sequencia tecnica

```text
Planilha/Formulario/API
  -> Supabase unidade_agricola.unidades_agricolas
  -> Tabelas dos fractais
  -> fractal_eventos_log
  -> Genius Hub
  -> DataLake
  -> Dashboards BI
  -> APIs/Agentes/Outros Modulos
```

## Regra de instalacao

O modulo pode ser instalado com todos os fractais ou em modo gradual:

- nucleo minimo: unidade, identidade, permissoes, status e integracao;
- pacote territorial: areas, limites, acessos e mapas;
- pacote documental: titulares, documentos, vencimentos e evidencias;
- pacote operacional: ativos, status, prestacao de contas e dashboards.

## Dependencias fortes

- Mod_Gestao_Genius_Hub
- Mod_Gestao_Dados_DataLake
- Mod_Gestao_Integracoes_APIs
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Seguranca_Informacao

## Modulos que devem consumir esta base

- Gestão Produção Vegetal
- Gestão Produção Animal/Pecuária
- Georreferenciamento
- Regularização Fundiária
- Construções Rurais
- Manutenção
- Financeiro
- Fiscal/Tributário
- Marketplace Agrícola
