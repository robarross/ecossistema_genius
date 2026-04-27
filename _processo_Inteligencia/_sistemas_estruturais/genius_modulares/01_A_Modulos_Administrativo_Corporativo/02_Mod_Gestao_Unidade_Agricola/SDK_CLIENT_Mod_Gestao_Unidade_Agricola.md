# SDK_CLIENT_Mod_Gestao_Unidade_Agricola

Este guia mostra como agentes, automacoes, apps e integracoes podem consumir a API do modulo.

## Cliente logico

```ts
type GeniusClientConfig = {
  baseUrl: string;
  token: string;
};

class UnidadeAgricolaClient {
  constructor(private config: GeniusClientConfig) {}

  async listarUnidades(filtros = {}) {
    return request("GET", "/unidades-agricolas", filtros);
  }

  async criarUnidade(payload) {
    return request("POST", "/unidades-agricolas", payload);
  }

  async listarFractais(idUnidadeAgricola: string) {
    return request("GET", `/unidades-agricolas/${idUnidadeAgricola}/fractais`);
  }

  async criarRegistroFractal(idUnidadeAgricola: string, nomeFractal: string, payload) {
    return request("POST", `/unidades-agricolas/${idUnidadeAgricola}/fractais/${nomeFractal}`, payload);
  }

  async publicarEvento(nomeFractal: string, payload) {
    return request("POST", `/fractais/${nomeFractal}/eventos`, payload);
  }
}
```

## Casos de uso para agentes

- Validar se uma unidade agricola esta pronta para producao.
- Verificar documentos pendentes.
- Criar tarefas a partir de pendencias dos fractais.
- Sincronizar dados com DataLake.
- Atualizar dashboards apos mudanca de status.
- Alimentar outros modulos com dados da unidade.

## Fractais disponiveis para consumo inicial

| nivel | submodulo | fractal | descricao |
| --- | --- | --- | --- |
| submodulo | 01_sub_cadastro_unidades_agricolas | 01_fractal_dados_basicos_unidade | Registra identificadores, nome, codigo, tipo, categoria e dados essenciais da unidade agricola. |
| submodulo | 01_sub_cadastro_unidades_agricolas | 02_fractal_localizacao_referencia_territorial | Registra endereco, coordenadas, municipio, UF, comunidade, acesso e referencias territoriais. |
| submodulo | 01_sub_cadastro_unidades_agricolas | 03_fractal_classificacao_unidade | Classifica a unidade por tipo, porte, finalidade, uso predominante e perfil produtivo. |
| submodulo | 01_sub_cadastro_unidades_agricolas | 04_fractal_situacao_cadastral | Controla status cadastral, pendencias, revisoes, validacoes e historico de atualizacao. |
| submodulo | 01_sub_cadastro_unidades_agricolas | 05_fractal_validacao_campos_obrigatorios | Define regras minimas de preenchimento, consistencia e liberacao para integracoes. |
| submodulo | 01_sub_cadastro_unidades_agricolas | 06_fractal_integracao_datalake_mapas_modulos | Conecta o cadastro da unidade ao DataLake, mapas, Hub, dashboards e modulos dependentes. |
| submodulo | 02_sub_proprietarios_possuidores | 01_fractal_cadastro_proprietarios | Registra proprietarios pessoas fisicas ou juridicas vinculados a unidade agricola. |
| submodulo | 02_sub_proprietarios_possuidores | 02_fractal_cadastro_possuidores | Registra possuidores, ocupantes, arrendatarios e demais titulares operacionais da unidade. |
| submodulo | 02_sub_proprietarios_possuidores | 03_fractal_documentos_titulares | Organiza documentos pessoais, empresariais, fundiarios e cadastrais dos titulares. |
| submodulo | 02_sub_proprietarios_possuidores | 04_fractal_vinculos_unidade_agricola | Define tipo de vinculo, percentual, periodo, responsabilidade e status da relacao. |

## Observacao

O SDK real pode ser implementado depois em TypeScript, Python ou Edge Functions. Este arquivo define o contrato de uso para manter agentes e integracoes alinhados.
