# Plano do Mapa: Módulo de Gestão da Unidade Agrícola

## 📌 Visão Geral
Este módulo é a **Base de Identidade** de todo o ecossistema. Ele fornece a estrutura territorial e administrativa sobre a qual todos os outros processos (Produção, Financeiro, RH) são construídos.

---

## 🧩 Submódulos e Fractals

### 1. Submódulo: Cadastro de Proprietários e Entidades Legais
**Objetivo**: Gerenciar a identidade jurídica e societária dos donos da operação.
**Descrição**: Centraliza dados de CPF/CNPJ, participações societárias e contratos de arrendamento.

*   **Fractal 1: Gestor de Participação (Holding)**: Mapeia a divisão de lucros e responsabilidades entre sócios.
*   **Fractal 2: Monitor de regularidade Fiscal**: Verifica automaticamente o status do CNPJ/CPF junto aos órgãos reguladores.
*   **Fractal 3: Curador de Certidões de Identidade**: Organiza os documentos pessoais e jurídicos anexados aos cadastros.

### 2. Submódulo: Registro de Fazendas e Unidades de Negócio
**Objetivo**: Organizar o nível macro territorial da operação.
**Descrição**: Identifica cada fazenda ou matriz administrativa com suas localizações e nomes oficiais.

*   **Fractal 1: Cartógrafo Digital de Propriedades**: Gerencia os limites macro geográficos da fazenda.
*   **Fractal 2: Supervisor de Centros de Lucro**: Vincula a fazenda física à sua conta contábil correspondente.
*   **Fractal 3: Gestor de Endereçamento Geovirtual**: Cria códigos de localização (plus codes) para cada sede ou estrutura fixa.

### 3. Submódulo: Mapeamento de Glebas e Setores
**Objetivo**: Divisão macro interna da terra.
**Descrição**: Divide as fazendas em grandes grupos produtivos ou áreas de preservação.

*   **Fractal 1: Arquiteto de Solo e Topografia**: Define o zoneamento com base em características geológicas fixas.
*   **Fractal 2: Vigilante de Áreas de Preservação**: Monitora as cercas e limites da Reserva Legal e APP.
*   **Fractal 3: Engenheiro de Vias e Acessos**: Mapeia as estradas internas e pontes que ligam as glebas.

### 4. Submódulo: Cadastro Técnico de Talhões (ID de Plantio)
**Objetivo**: Criar a célula básica da produção agrícola.
**Descrição**: Cadastro detalhado de cada área de plantio, com metragem exata e histórico de solo.

*   **Fractal 1: Escrivão de Identidade do Talhão**: Gera o QR Code e o ID único de cada talhão.
*   **Fractal 2: Calculador de Área Útil (Liquid Area)**: Define a metragem exata plantável descontando carreadores e manchas de solo.
*   **Fractal 3: Agrimensor de Coordenadas Centrais**: Define o ponto GPS de referência para automação de máquinas.

### 5. Submódulo: Dicionário de Ativos Imobiliários (Documentação)
**Objetivo**: Garantir a segurança fundiária da operação.
**Descrição**: Gestão de Matrículas, Escrituras, CCIR, ITR e impostos territoriais.

*   **Fractal 1: Bibliotecário de Matrículas e Ônus**: Monitora a validade de certidões atualizadas do cartório.
*   **Fractal 2: Gestor de Impostos Rurais (ITR)**: Consolida as informações para a declaração do imposto territorial.
*   **Fractal 3: Monitor de Sincronia CAR/Georreferenciamento**: Valida se o desenho do mapa bate com a documentação legal.

### 6. Submódulo: Central de Chaves de Relacionamento (IDs Genius)
**Objetivo**: Garantir que o sistema seja uma malha integrada.
**Descrição**: Central de "Chaves Estrangeiras" que ligam um talhão a todos os outros módulos (Solo, Clima, etc).

*   **Fractal 1: Orquestrador de Cross-Ref (X-Ref)**: Garante que um dado mudado no "Cadastro" atualize em todos os sistemas.
*   **Fractal 2: Integrador de ERP Externo**: Faz a "ponte" entre os IDs do Genius e os IDs de softwares de terceiro.
*   **Fractal 3: Gerador de Tags e Etiquetas de Campo**: Cria os meios físicos de identificação baseados no banco de dados.

---

## 📈 Próximos Passos
1. Validar a hierarquia com o Demurgos (#16).
2. Iniciar a criação dos DNA's dos fractais priorizados.
