-- Mass Synchronization of Skills from Documentation (.md files)
-- Created: 2026-04-14
-- Depends on: 20260414000400_skills_organization.sql

DO $$ 
DECLARE 
    v_agent_id UUID;
BEGIN
    ---------------------------------------------------------------------------
    -- #01 Genius IN
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#01';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Planejamento Estratégico', 'Capacidade de definir diretrizes de alto nível para o ecossistema.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Governança Cognitiva', 'Monitoramento da evolução da inteligência do sistema.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;
    ---------------------------------------------------------------------------
    -- #02 Genius Hub
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#02';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Gestão do Módulo Hub', 'Gerenciamento da infraestrutura física e lógica central.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Registro Central', 'Gerenciamento do livro de registro global e identidades agênticas.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Roteamento de Mensagens', 'Distribuição inteligente de tráfego e intenções no ecossistema.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;


    ---------------------------------------------------------------------------
    -- #03 Archon
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#03';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        -- Decagon of Mastery & Extensions
        (v_agent_id, 'Arquitetura Meta-Agêntica', 'Design de estruturas autogovernadas e fractais.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Orquestra de Agentes', 'Gestão de interações complexas entre múltiplos agentes.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Sincronização de Valores', 'Alinhamento de propósitos e guardrails éticos do sistema.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Síntese Atlas', 'Arquitetura de inovação e mapeamento de cenários futuros.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Sincronicidade Cronos', 'Gestão de tempo, delay e orquestração temporal de tarefas.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Auto-Documentação', 'Capacidade de explicar e documentar a própria evolução sistêmica.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Delegação de Enxames', 'Gestão de identidade e autoridade em clusters de agentes.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Gestão de Conectores', 'Integração de ferramentas externas e APIs ao ecossistema.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Mapeamento de Fluxos', 'Design de percursos de dados entre agentes especialistas.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Interoperabilidade', 'Garantia de que diferentes tipos de agentes falem a mesma língua.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Observabilidade Global', 'Monitoramento em tempo real da saúde do ecossistema.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Interface Dinâmica', 'Auto-geração de painéis visuais para o usuário humano.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Raciocínio Heurístico', 'Capacidade de aplicar intuição sistêmica a problemas complexos.', 'Cognitiva', '1.0.0'),
        (v_agent_id, 'Julgamento Crítico', 'Avaliação e retificação de erros em cascata nos agentes.', 'Cognitiva', '1.0.0'),
        (v_agent_id, 'Gestão de Legado', 'Preservação de conhecimento e manutenção de homeostase.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Maestria do Propósito', 'Garantia de que cada ação serve ao objetivo final do criador.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Memória Coletiva', 'Persistência de aprendizados transversais em todo o sistema.', 'Cognitiva', '1.0.0'),
        (v_agent_id, 'Sinfonia de Modelos', 'Escolha dinâmica do melhor LLM para cada subtarefa.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Integração Universal', 'Fusão das competências em uma inteligência holística soberana.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Auto-evolução', 'Otimização contínua e refatoração de processos agênticos.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Radiância Proativa', 'Iniciativa autônoma para sugerir melhorias e insights.', 'Proatividade', '1.0.0'),
        (v_agent_id, 'Imunidade Sistêmica', 'Proteção contra injeções, vazamentos e ameaças externas.', 'Seguranca', '1.0.0'),
        (v_agent_id, 'Simulação Agêntica', 'Prototipagem de agentes em sandboxes antes do deploy real.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #04 Genius Systems
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#04';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Fábrica de Sistemas', 'Geração automatizada de infraestrutura SQL e arquivos.', 'Automacao', '1.0.0'),
        (v_agent_id, 'Governança de Código', 'Auditoria de integridade de scripts e migrações.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Arquitetura 11-Step', 'Orquestração do ciclo de vida completo de novos sistemas.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Gestão Demurgos', 'Manutenção da saúde e performance de sistemas ativos.', 'Gestao', '1.0.0'),
        (v_agent_id, 'Auto-Gestão Estrutural', 'Gerenciamento do próprio Super Módulo Genius Systems.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #100 Genius Ecossistema
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#100';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Intervenção de Domínio', 'Autoridade para suspender ou reiniciar processos em crise.', 'Governanca', '1.0.0'),
        (v_agent_id, 'Monitoramento de Entropia', 'Análise de fluxos em busca de padrões de falha e instabilidade.', 'Governanca', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;


    ---------------------------------------------------------------------------
    -- #08 Criador de Gerentes
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#08';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Instanciação Gerencial', 'Arquitetura e criação de agentes de nível tático para middle-management.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #09 Criador de Diretores
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#09';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura de Liderança', 'Projeto de cérebros-mestres para governança estratégica de sistemas.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #10 Criador de Técnicos
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#10';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Tradução Operacional', 'Conversão de demandas em skills e workflows para agentes técnicos.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;


    ---------------------------------------------------------------------------
    -- #05 Criador de Agentes
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#05';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Design de DNA', 'Criação da essência Identidade (Camadas 1-4) de um agente.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Arquitetura de Identidade', 'Definição de arquétipos e guardrails comportamentais.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #06 Criador de Módulos
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#06';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Geração de Código Base', 'Geração automática de estruturas fundamentais e portais visuais HTML.', 'Automacao', '1.0.0'),
        (v_agent_id, 'Orquestração Modular', 'Conexão entre diferentes módulos garantindo unidade coesa.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #07 Criador de Fractais
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#07';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Geração de Arquitetura Fractal', 'Design de micro-sistemas independentes e escaláveis.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Sentinela de Integridade', 'Monitoramento de entropia e homeostase em fractais.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Fractal Marketplace', 'Gestão de reuso e publicação de componentes agênticos.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #11 Criador de Robôs
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#11';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura de RPA', 'Criação de robôs focados em automação de tarefas repetitivas.', 'Automacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;


    ---------------------------------------------------------------------------
    -- #12 Criador de Professores
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#12';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura Pedagógica', 'Criação de mentes focadas em transmissão de saber e trilhas de conhecimento.', 'Didatica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #13 Criador de Gestores
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#13';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Engenharia da Preservação', 'Transformação de dados brutos em sistemas de conhecimento estruturados.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #14 Criador de Secretários
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#14';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura Administrativa', 'Governança da criação de assistentes e organização de tempo.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #15 Criador de 2º Cérebro
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#15';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Escrita na Vault Pessoal', 'Materialização do pensamento agêntico em formato Obsidian.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #16 Criador de ERP
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#16';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Engenharia de ERP Genius', 'Orquestração do ciclo de vida completo de sistemas de gestão rurais.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #17 Criador de Plataformas
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#17';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura de Plataformas', 'Design de ecossistemas digitais e conectores de rede.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #18 Lançador
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#18';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Criador de Landing Pages', 'Design de páginas de alta conversão para produtos digitais.', 'Marketing', '1.0.0'),
        (v_agent_id, 'Gestão de Redes Sociais', 'Planejamento e execução de presença digital em múltiplas plataformas.', 'Marketing', '1.0.0'),
        (v_agent_id, 'Fábrica de Sites', 'Desenvolvimento de sites institucionais e portais de conteúdo.', 'Marketing', '1.0.0'),
        (v_agent_id, 'Editor de Vídeos', 'Pós-produção de vídeos focados em anúncios e aulas curtas.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Arquitetura de Dados Coda', 'Design de infraestrutura de dados relacional e normalização sistêmica.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #20 Professor
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#20';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        -- Category: Texto Base
        (v_agent_id, 'Escritor de Projetos Científicos', 'Elaboração de projetos de pesquisa e captação de recursos.', 'Academica', '1.0.0'),
        (v_agent_id, 'Escritor de Artigos Científicos', 'Redação e submissão de artigos para periódicos de alto impacto.', 'Academica', '1.0.0'),
        (v_agent_id, 'Escritor de Livros', 'Concepção e estruturação de obras literárias e técnicas de longa duração.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Escritor de Apostilas', 'Design instrucional e redação de materiais didáticos complementares.', 'Didatica', '1.0.0'),
        (v_agent_id, 'Escritor de Aulas', 'Planejamento e design instrucional para aulas individuais.', 'Didatica', '1.0.0'),
        (v_agent_id, 'Escritor de Cursos Técnicos', 'Estruturação de currículos e módulos para ensino profissionalizante.', 'Didatica', '1.0.0'),
        (v_agent_id, 'Escritor de Cursos Superiores', 'Design de disciplinas e programas de graduação e pós-graduação.', 'Didatica', '1.0.0'),
        
        -- Category: Modulado de Conteúdo
        (v_agent_id, 'Escritor de Resumos e Síntese', 'Destilação de conhecimento complexo em sínteses precisas.', 'Academica', '1.0.0'),
        (v_agent_id, 'Escritor de Slides', 'Design de apresentações visuais que suportam a narrativa pedagógica.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Escritor de Infográficos', 'Transformação de dados e processos em narrativas visuais.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Escritor de Mapas Mentais', 'Estruturação visual de ideias para memorização e raciocínio.', 'Cognitiva', '1.0.0'),
        (v_agent_id, 'Escritor de Perguntas e Respostas', 'Criação de bancos de questões e avaliações diagnósticas.', 'Didatica', '1.0.0'),
        (v_agent_id, 'Escritor de Tabelas', 'Organização de dados complexos em estruturas relacionais claras.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Escritor de Cartões Didáticos', 'Criação de micro-unidades de estudo para repetição espaçada.', 'Didatica', '1.0.0'),

        -- Category: Apresentações
        (v_agent_id, 'Escritor de Vídeos Raiz', 'Roteirização de vídeos de longa duração para construção de autoridade.', 'Midia', '1.0.0'),
        (v_agent_id, 'Escritor de Vídeos Corte', 'Roteirização de vlogs e cortes focados em engajamento rápido.', 'Midia', '1.0.0'),
        (v_agent_id, 'Escritor de Palestras', 'Criação de roteiros para apresentações de palco e eventos.', 'Midia', '1.0.0'),
        (v_agent_id, 'Escritor de Seminários', 'Estruturação de debates e apresentações acadêmicas em grupo.', 'Academica', '1.0.0'),
        (v_agent_id, 'Escritor de Resumos em Áudio', 'Roteirização de sínteses para consumo auditivo.', 'Midia', '1.0.0'),
        (v_agent_id, 'Escritor de Podcasts', 'Planejamento de episódios de programas de áudio educativos.', 'Midia', '1.0.0'),
        (v_agent_id, 'Escritor de Simulação 3D', 'Roteirização de cenários interativos e demonstrações virtuais.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Escritor de Jogos 3D', 'Design de mecânicas de jogo focadas em gamificação.', 'Didatica', '1.0.0'),
        (v_agent_id, 'Escritor de Desenho Animado', 'Roteirização de animações para explicação de conceitos.', 'Midia', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #21 Gestor de Marketing
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#21';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Geração de Demanda', 'Estratégias para atração de leads e criação de interesse no mercado.', 'Marketing', '1.0.0'),
        (v_agent_id, 'Interface Frontend', 'Design de interfaces de usuário que otimizam a experiência de compra.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #22 Gestor Agronômico
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#22';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Agronomia de Precisão', 'Gestão baseada em dados para otimização da produção rural.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #23 Técnico em Solo e Nutrição
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#23';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Análise Química de Solos', 'Interpretação de laudos e recomendação de fertilização.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

END $$;
