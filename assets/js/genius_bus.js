/**
 * Genius Bus - Universal Data Bus & Gamification Client
 * Version: 1.0.0
 * Author: Genius Systems #04
 * Description: Connects HTML Portals to Supabase for Telemetry and XP Sync.
 */

class GeniusBus {
    constructor(supabaseClient) {
        this.supabase = supabaseClient;
        this.profileId = null;
        this.stats = {
            xp: 0,
            level: 1,
            medals: [],
            trust_score: 100,
            badges: [],
            theme: 'default'
        };
        this.isInitialized = false;
    }

    /**
     * Initialize the Bus with the current user session
     */
    async init() {
        try {
            const { data: { user } } = await this.supabase.auth.getUser();
            if (!user) throw new Error("Usuário não autenticado no Supabase.");
            
            this.profileId = user.id;
            await this.refreshStats();
            this.setupRealtimeSync();
            this.isInitialized = true;
            console.log("🌐 Genius Bus: Sistema de Telemetria Conectado.");
        } catch (err) {
            console.error("❌ Genius Bus: Falha na inicialização.", err.message);
        }
    }

    /**
     * Pull current stats from Supabase
     */
    async refreshStats() {
        const { data, error } = await this.supabase
            .from('genius_user_stats')
            .select('*')
            .eq('profile_id', this.profileId)
            .single();

        if (error) {
            console.warn("⚠️ Genius Bus: Perfil novo detectado. Aguardando trigger de criação...");
            return;
        }

        this.stats = {
            xp: data.xp_total,
            level: data.level,
            medals: data.medals,
            trust_score: data.trust_score,
            badges: data.badges,
            theme: data.current_theme
        };
        
        this.dispatchLocalUpdate();
    }

    /**
     * Listen for realtime changes in XP or Medals from other portals
     */
    setupRealtimeSync() {
        this.supabase
            .channel('public:genius_user_stats')
            .on('postgres_changes', { 
                event: 'UPDATE', 
                schema: 'public', 
                table: 'genius_user_stats',
                filter: `profile_id=eq.${this.profileId}`
            }, payload => {
                console.log("🔄 Genius Bus: Sincronia Realtime Detectada.", payload.new);
                this.stats.xp = payload.new.xp_total;
                this.stats.level = payload.new.level;
                this.stats.medals = payload.new.medals;
                this.stats.trust_score = payload.new.trust_score;
                this.stats.badges = payload.new.badges;
                this.stats.theme = payload.new.current_theme;
                this.dispatchLocalUpdate();
            })
            .subscribe();
    }

    /**
     * Emit a telemetry event to the Enterprise Bus
     */
    async emitEvent(type, payload = {}, criticality = 'INFO') {
        const { error } = await this.supabase
            .from('genius_system_events')
            .insert([{
                event_type: type,
                payload: payload,
                criticality: criticality
            }]);

        if (error) console.error("❌ Genius Bus: Erro ao emitir evento.", error);
    }

    /**
     * Grant XP to the user
     */
    async grantXP(amount, actionDesc = "Ação de Sistema") {
        const newXP = this.stats.xp + amount;
        
        const { error } = await this.supabase
            .from('genius_user_stats')
            .update({ xp_total: newXP })
            .eq('profile_id', this.profileId);

        if (error) console.error("❌ Genius Bus: Erro ao conceder XP.", error);
    }

    /**
     * Log an agent decision (Observability)
     */
    async logDecision(agentId, type, reasoning, payload = {}) {
        const { error } = await this.supabase
            .from('genius_agent_decisions')
            .insert([{
                agent_id: agentId,
                decision_type: type,
                reasoning: reasoning,
                payload: payload
            }]);

        if (error) console.error("❌ Genius Bus: Erro ao registrar decisão.", error);
    }

    /**
     * Update the local UI (Dispatch custom event for the HTML portals)
     */
    dispatchLocalUpdate() {
        const event = new CustomEvent('genius_bus_update', { detail: this.stats });
        window.dispatchEvent(event);
    }
}

// Export for global use
window.GeniusBus = GeniusBus;
