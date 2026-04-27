# SPEC: Genius Bus (Especificação Técnica)

## 1. Arquitetura de Software
O **Genius Bus** será implementado como um módulo Javascript (Singleton) importado por todas as páginas do ecossistema.

- **Tecnologia Central:** Supabase JS SDK (via CDN).
- **Padrão de Comunicação:** REST/PostgREST.
- **Cache Local:** Re-implementar `localStorage` apenas como buffer em caso de queda de rede (Offline First).

## 2. API do Barramento (`genius_bus.js`)
Funções core que serão expostas para as páginas:

```javascript
/* Estrutura proposta */
const GeniusBus = {
    // Inicializa a conexão
    init: (url, key) => { ... },

    // Persiste Ganhos de XP
    updateXP: async (newXp) => { ... },

    // Conquista de Medalha
    addMedal: async (medalName) => { ... },

    // Telemetria Agêntica (LOG)
    dispatchLog: async (agent, eventType, payload) => { ... },

    // Sincronização Global
    sync: async () => { ... }
};
```

## 3. Estrutura de Dados (Supabase)
### Tabela: `genius_user_stats`
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| id | uuid | Primary Key (Serial) |
| username | text | Roberto |
| xp_total | int | Acumulado total |
| current_level | int | Nível calculado |
| medals | jsonb | Array de medalhas conquistadas |
| active_theme | text | 'dark' ou 'gold' |

### Tabela: `genius_telemetry`
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| id | uuid | Primary Key |
| created_at | date | Timestamp automático |
| agent_id | text | ID do agente emissor (#04, #100, etc) |
| type | text | 'INFO', 'WARNING', 'CRITICAL' |
| content | jsonb | Payload do evento |

## 4. Segurança e Guardrails (Etapa 3.5 Antecipada)
- **RLS (Row Level Security):** Ativar no Supabase para permitir apenas que o ID autenticado escreva dados.
- **API Keys:** Utilizar variáveis de ambiente ou carregar via arquivo de configuração externo `config_bus.json` (fora do controle de versão se necessário).

## 5. Próximos Passos (Etapa 4 - Design)
- Design da interface de "Status de Conexão" no Cockpit (Ícone de nuvem sincronizada).
