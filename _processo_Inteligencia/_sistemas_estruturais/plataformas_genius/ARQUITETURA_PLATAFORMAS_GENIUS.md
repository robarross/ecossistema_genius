# Arquitetura de Plataformas Genius

Esta camada organiza o ecossistema Genius em plataformas. Cada modulo pode funcionar como um sistema proprio, e conjuntos de modulos formam plataformas especializadas. A 01_Plataforma_Genius_System integra todas as demais plataformas.

## Logica Geral

- Modulos: sistemas funcionais especializados.
- Plataformas: conjuntos de modulos integrados por dominio.
- 01_Plataforma_Genius_System: plataforma-mae que integra plataformas, dados, usuarios, fluxos, APIs, dashboards, automacoes e governanca.

## Plataformas

### 01_Plataforma_Genius_System

Plataforma-mae e sistema operacional central do ecossistema Genius. Integra todas as demais plataformas, controla navegacao, usuarios, dados, integracoes, automacoes, dashboards e visao geral.

**Modulos principais**
- Mod_Gestao_Genius_In
- Mod_Gestao_Genius_Hub
- Mod_Gestao_Dados_DataLake
- Mod_Gestao_Integracoes_APIs
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Automacoes
- Mod_Gestao_Seguranca_Informacao
- Mod_Gestao_Genius_Cloud

**Modulos transversais/integrados**
- Mod_Gestao_Projetos
- Mod_Gestao_Genius_Workspace
- Mod_Gestao_Genius_Cowork
- Mod_Gestao_Comunidade_Agricola
- Mod_Gestao_Biblioteca_Agro
- Mod_Gestao_Genius_News_Rural
- Mod_Gestao_Instituto_Escola

### 03_Plataforma_Genius_AgroGestao

Plataforma de gestao administrativa, financeira, corporativa e cadastral rural.

**Modulos principais**
- Mod_Gestao_Administrativa
- Mod_Gestao_Comercial
- Mod_Gestao_Compras_Suprimentos
- Mod_Gestao_Contabil
- Mod_Gestao_Contratos
- Mod_Gestao_Financeira
- Mod_Gestao_Fiscal_Tributaria
- Mod_Gestao_Governanca
- Mod_Gestao_Juridica
- Mod_Gestao_RH
- Mod_Gestao_Unidade_Agricola

**Modulos transversais/integrados**
- Mod_Gestao_Projetos
- Mod_Gestao_Genius_Workspace
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Integracoes_APIs

### 04_Plataforma_Genius_GeoAmbiental

Plataforma territorial, ambiental, geoespacial, fundiaria, ESG e carbono.

**Modulos principais**
- Mod_Gestao_Carbono_Servicos_Ambientais
- Mod_Gestao_ESG_Rural
- Mod_Gestao_Geointeligencia_SIG
- Mod_Gestao_Georreferenciamento
- Mod_Gestao_Meio_Ambiente
- Mod_Gestao_Regularizacao_Fundiaria
- Mod_Gestao_Sensoriamento_Remoto
- Mod_Gestao_Recursos_Hidricos

**Modulos transversais/integrados**
- Mod_Gestao_Unidade_Agricola
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Dados_DataLake
- Mod_Gestao_Projetos

### 05_Plataforma_Genius_InfraRural

Plataforma de infraestrutura rural, operacao fisica, manutencao, logistica, patrimonio, energia, seguranca e conectividade.

**Modulos principais**
- Mod_Gestao_Construcoes_Rurais
- Mod_Gestao_Energia_Utilidades
- Mod_Gestao_Irrigacao_Drenagem
- Mod_Gestao_Logistica
- Mod_Gestao_Manutencao
- Mod_Gestao_Patrimonio
- Mod_Gestao_Seguranca_Rural
- Mod_Gestao_Conectividade_Rural

**Modulos transversais/integrados**
- Mod_Gestao_Unidade_Agricola
- Mod_Gestao_Compras_Suprimentos
- Mod_Gestao_Projetos
- Mod_Gestao_Genius_Workspace

### 06_Plataforma_Genius_AgroProducao

Plataforma produtiva rural para producao vegetal, animal, pos-colheita, agroindustria, alimentos, agroecologia e florestal.

**Modulos principais**
- Mod_Gestao_Producao_Vegetal_Agricola
- Mod_Gestao_Producao_Animal_Pecuaria
- Mod_Gestao_PosColheita
- Mod_Gestao_Agroindustria_Rural
- Mod_Gestao_Alimentos
- Mod_Gestao_Agroecologia
- Mod_Gestao_Florestal
- Mod_Gestao_Agricultura_Precisao

**Modulos transversais/integrados**
- Mod_Gestao_Unidade_Agricola
- Mod_Gestao_Irrigacao_Drenagem
- Mod_Gestao_Marketplace_Agricola
- Mod_Gestao_Dashboards_BI

### 07_Plataforma_Genius_Mercado_Rural

Plataforma de mercado, comercializacao, marketplace, credito rural, imoveis, servicos e expansao de negocios.

**Modulos principais**
- Mod_Gestao_Marketplace_Agricola
- Mod_Gestao_Banco_Rural_Genius
- Mod_Gestao_Imobiliaria_Rural
- Mod_Gestao_Consultoria_Servicos
- Mod_Gestao_Expansao_NovosNegocios
- Mod_Gestao_Comercial

**Modulos transversais/integrados**
- Mod_Gestao_Contratos
- Mod_Gestao_Financeira
- Mod_Gestao_Logistica
- Mod_Gestao_Alimentos
- Mod_Gestao_Agroindustria_Rural

### 08_Plataforma_Genius_Conhecimento

Plataforma de conhecimento, educacao, comunidade, comunicacao, cowork, workspace e projetos colaborativos.

**Modulos principais**
- Mod_Gestao_Instituto_Escola
- Mod_Gestao_Biblioteca_Agro
- Mod_Gestao_Comunidade_Agricola
- Mod_Gestao_Genius_News_Rural
- Mod_Gestao_Genius_Cowork
- Mod_Gestao_Genius_Workspace
- Mod_Gestao_Projetos

**Modulos transversais/integrados**
- Mod_Gestao_Consultoria_Servicos
- Mod_Gestao_Tecnica_Especialista
- Mod_Jogos_3D
- Mod_Gestao_Simulador_Rural_3D

### 09_Plataforma_Genius_3D_Experience

Plataforma de simulacao, visualizacao 3D, jogos, treinamento interativo e experiencias gamificadas.

**Modulos principais**
- Mod_Gestao_Simulador_Rural_3D
- Mod_Jogos_3D

**Modulos transversais/integrados**
- Mod_Gestao_Instituto_Escola
- Mod_Gestao_Genius_Workspace
- Mod_Gestao_Projetos
- Mod_Gestao_Unidade_Agricola
- Mod_Gestao_Geointeligencia_SIG

### 02_Plataforma_Genius_TechOps

Plataforma tecnica digital para cloud, IoT, automacoes, APIs, seguranca, conectividade e suporte especialista.

**Modulos principais**
- Mod_Gestao_TI_IoT_Rural
- Mod_Gestao_Genius_Cloud
- Mod_Gestao_Integracoes_APIs
- Mod_Gestao_Automacoes
- Mod_Gestao_Seguranca_Informacao
- Mod_Gestao_Conectividade_Rural
- Mod_Gestao_Tecnica_Especialista

**Modulos transversais/integrados**
- Mod_Gestao_Dados_DataLake
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Genius_Hub
- Mod_Gestao_Genius_In

