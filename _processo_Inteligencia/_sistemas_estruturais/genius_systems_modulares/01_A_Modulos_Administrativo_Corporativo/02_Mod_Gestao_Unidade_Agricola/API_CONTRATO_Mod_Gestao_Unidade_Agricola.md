# API_CONTRATO_Mod_Gestao_Unidade_Agricola

Este documento explica como outros modulos, plataformas, agentes e automacoes devem consumir o modulo Gestão da Unidade Agrícola.

## Papel da API

A API transforma o modulo em um componente plug and play. Outros modulos nao precisam conhecer a estrutura interna dos 68 fractais; eles podem consumir endpoints padronizados de unidade agricola, fractais e eventos.

## Endpoints principais

| metodo | endpoint | funcao |
| --- | --- | --- |
| GET | /unidades-agricolas | Lista unidades agrícolas para consumo operacional e dashboards. |
| POST | /unidades-agricolas | Cria unidade agrícola e inicia fluxo dos fractais centrais. |
| GET | /unidades-agricolas/{id} | Busca unidade agrícola consolidada. |
| PATCH | /unidades-agricolas/{id} | Atualiza unidade agrícola e publica evento de atualização. |
| GET | /unidades-agricolas/{id}/fractais | Lista registros dos fractais vinculados à unidade. |
| POST | /unidades-agricolas/{id}/fractais/{nome_fractal} | Cria registro em fractal específico. |
| GET | /eventos | Consulta eventos publicados pelo módulo. |
| POST | /fractais/{nome_fractal}/eventos | Publica evento de fractal para Hub/DataLake/APIs. |
| POST | /integracoes/sync | Dispara sincronização com Hub, DataLake, dashboards e APIs. |

## Modulos consumidores prioritarios

- Produção Vegetal: consome unidades, areas, talhoes, status e localizacao.
- Produção Animal/Pecuária: consome unidade, areas, ativos e responsaveis.
- Georreferenciamento: consome limites, areas, coordenadas e referencias territoriais.
- Regularização Fundiária: consome proprietarios, documentos e vinculos.
- Construções Rurais: consome ativos estruturais como base.
- Manutenção: consome ativos, acessos, estruturas e status operacional.
- Financeiro/Fiscal: consome unidade, titulares, documentos e prestacao de contas.
- Marketplace Agrícola: consome unidade validada, status e rastreabilidade.

## Regras de consumo

- Todo consumo deve informar `id_unidade_agricola` quando o dado for operacional.
- Todo registro de fractal deve publicar evento quando criado, atualizado, validado ou sincronizado.
- Toda integracao deve respeitar permissoes, RLS e perfil do usuario.
- Payloads flexiveis devem ser estabilizados em schema quando virarem regra de negocio.

## Exemplo de payload para criar unidade

```json
{
  "codigo_unidade": "PA-0001",
  "nome_unidade": "Fazenda Santa Clara",
  "tipo_unidade": "Fazenda",
  "status_cadastro": "Ativo",
  "uf": "AM",
  "municipio": "Manaus",
  "area_total_ha": 1250.5
}
```
