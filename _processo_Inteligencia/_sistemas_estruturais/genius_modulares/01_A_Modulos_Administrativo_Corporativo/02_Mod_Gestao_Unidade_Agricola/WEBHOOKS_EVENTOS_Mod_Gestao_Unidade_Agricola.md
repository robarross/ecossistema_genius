# WEBHOOKS_EVENTOS_Mod_Gestao_Unidade_Agricola

Este documento define como os eventos dos fractais devem ser publicados para Genius Hub, DataLake, dashboards e outros modulos.

## Endpoint receptor sugerido

```text
POST /webhooks/genius-hub/unidade-agricola
```

## Headers sugeridos

- `Authorization: Bearer <token>`
- `X-Genius-Module: Mod_Gestao_Unidade_Agricola`
- `X-Genius-Event: <nome_evento>`
- `X-Genius-Trace-Id: <uuid>`

## Payload padrao

```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.fractal_identidade_unidade.criado",
  "id_unidade_agricola": "uuid",
  "id_fractal_registro": "uuid",
  "modulo_origem": "Mod_Gestao_Unidade_Agricola",
  "submodulo_origem": "N/A",
  "fractal_origem": "01_fractal_identidade_unidade",
  "status": "pendente",
  "payload": {},
  "published_at": "timestamp"
}
```

## Eventos catalogados

Total de eventos: 272

| evento | metodo | endpoint | consumidores |
| --- | --- | --- | --- |
| unidade_agricola.fractal_dados_basicos_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_dados_basicos_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_dados_basicos_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_dados_basicos_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_localizacao_referencia_territorial.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_localizacao_referencia_territorial.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_localizacao_referencia_territorial.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_localizacao_referencia_territorial.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_classificacao_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_classificacao_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_classificacao_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_classificacao_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_situacao_cadastral.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_situacao_cadastral.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_situacao_cadastral.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_situacao_cadastral.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validacao_campos_obrigatorios.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validacao_campos_obrigatorios.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validacao_campos_obrigatorios.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validacao_campos_obrigatorios.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_datalake_mapas_modulos.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_datalake_mapas_modulos.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_datalake_mapas_modulos.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_datalake_mapas_modulos.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_proprietarios.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_proprietarios.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_proprietarios.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_proprietarios.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_possuidores.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_possuidores.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_possuidores.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_possuidores.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_titulares.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_titulares.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_titulares.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_titulares.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_vinculos_unidade_agricola.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_vinculos_unidade_agricola.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_vinculos_unidade_agricola.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_vinculos_unidade_agricola.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_titularidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_titularidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_titularidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_titularidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_contratos_juridico_permissoes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_contratos_juridico_permissoes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_contratos_juridico_permissoes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_contratos_juridico_permissoes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_responsaveis.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_responsaveis.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_responsaveis.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_cadastro_responsaveis.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_funcoes_papeis_operacionais.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_funcoes_papeis_operacionais.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_funcoes_papeis_operacionais.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_funcoes_papeis_operacionais.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_tecnica.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_tecnica.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_tecnica.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_tecnica.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_administrativa.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_administrativa.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_administrativa.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_responsabilidade_administrativa.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_niveis_autorizacao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_niveis_autorizacao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_niveis_autorizacao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_niveis_autorizacao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_tarefas_projetos_cowork.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_tarefas_projetos_cowork.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_tarefas_projetos_cowork.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_tarefas_projetos_cowork.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_areas_produtivas.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_areas_produtivas.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_areas_produtivas.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_areas_produtivas.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_glebas_talhoes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_glebas_talhoes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_glebas_talhoes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_glebas_talhoes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uso_atual_area.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uso_atual_area.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uso_atual_area.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uso_atual_area.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_potencial_produtivo.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_potencial_produtivo.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_potencial_produtivo.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_potencial_produtivo.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_ocupacao_uso.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_ocupacao_uso.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_ocupacao_uso.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_ocupacao_uso.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_producao_geo_precisao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_producao_geo_precisao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_producao_geo_precisao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_producao_geo_precisao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_limites_fisicos_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_limites_fisicos_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_limites_fisicos_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_limites_fisicos_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_internos_externos.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_internos_externos.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_internos_externos.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_internos_externos.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estradas_ramais_porteiras.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estradas_ramais_porteiras.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estradas_ramais_porteiras.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estradas_ramais_porteiras.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pontos_criticos_acesso.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pontos_criticos_acesso.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pontos_criticos_acesso.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pontos_criticos_acesso.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_controle_circulacao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_controle_circulacao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_controle_circulacao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_controle_circulacao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fundiarios.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fundiarios.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fundiarios.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fundiarios.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_ambientais.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_ambientais.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_ambientais.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_ambientais.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fiscais_cadastrais.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fiscais_cadastrais.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fiscais_cadastrais.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documentos_fiscais_cadastrais.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validades_vencimentos.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validades_vencimentos.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validades_vencimentos.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_validades_vencimentos.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uploads_evidencias.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uploads_evidencias.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uploads_evidencias.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_uploads_evidencias.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estruturas_existentes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estruturas_existentes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estruturas_existentes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estruturas_existentes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_benfeitorias_instalacoes_fixas.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_benfeitorias_instalacoes_fixas.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_benfeitorias_instalacoes_fixas.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_benfeitorias_instalacoes_fixas.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_equipamentos_fixos_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_equipamentos_fixos_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_equipamentos_fixos_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_equipamentos_fixos_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estado_conservacao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estado_conservacao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estado_conservacao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_estado_conservacao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacao_areas_uso_operacional.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacao_areas_uso_operacional.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacao_areas_uso_operacional.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacao_areas_uso_operacional.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_construcoes_manutencao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_construcoes_manutencao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_construcoes_manutencao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_construcoes_manutencao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_chaves_fisicas.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_chaves_fisicas.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_chaves_fisicas.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_chaves_fisicas.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_digitais.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_digitais.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_digitais.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_acessos_digitais.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_perfis_operacionais.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_perfis_operacionais.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_perfis_operacionais.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_perfis_operacionais.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_autorizacoes_area_funcao.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_autorizacoes_area_funcao.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_autorizacoes_area_funcao.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_autorizacoes_area_funcao.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_acesso.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_acesso.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_acesso.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_acesso.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_cowork_workspace.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_cowork_workspace.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_cowork_workspace.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_seguranca_cowork_workspace.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_geral_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_geral_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_geral_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_geral_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_produtivo.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_produtivo.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_produtivo.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_produtivo.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_documental.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_documental.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_documental.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_documental.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_estrutural.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_estrutural.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_estrutural.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_estrutural.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_risco_pendencia.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_risco_pendencia.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_risco_pendencia.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_status_risco_pendencia.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_resumo_operacional_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_resumo_operacional_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_resumo_operacional_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_resumo_operacional_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_evidencias_suporte.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_evidencias_suporte.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_evidencias_suporte.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_evidencias_suporte.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_conformidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_conformidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_conformidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_conformidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pendencias_abertas.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pendencias_abertas.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pendencias_abertas.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_pendencias_abertas.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_atualizacoes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_atualizacoes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_atualizacoes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_historico_atualizacoes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_financeiro_admin_auditoria.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_financeiro_admin_auditoria.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_financeiro_admin_auditoria.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_financeiro_admin_auditoria.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_identidade_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_identidade_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_identidade_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_identidade_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacionamentos_unidade.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacionamentos_unidade.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacionamentos_unidade.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_relacionamentos_unidade.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_governanca_permissoes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_governanca_permissoes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_governanca_permissoes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_governanca_permissoes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documental_juridico.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documental_juridico.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documental_juridico.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_documental_juridico.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_operacional_status.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_operacional_status.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_operacional_status.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_operacional_status.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_ecossistema.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_ecossistema.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_ecossistema.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_integracao_ecossistema.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_dashboards.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_dashboards.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_dashboards.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_indicadores_dashboards.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_inteligencia_automacoes.criado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_inteligencia_automacoes.atualizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_inteligencia_automacoes.validado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
| unidade_agricola.fractal_inteligencia_automacoes.sincronizado | POST | /webhooks/genius-hub/unidade-agricola | Genius Hub, DataLake, Dashboards BI, Integracoes APIs |
