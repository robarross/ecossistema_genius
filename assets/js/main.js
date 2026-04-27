import { supabase } from './supabase.js';

document.addEventListener('DOMContentLoaded', async () => {
    console.log("🚀 Genius Bus: Iniciando conexão inteligente...");

    // Instanciar o Bus Real
    const bus = new window.GeniusBus(supabase);
    await bus.init();

    const xpDisplay = document.getElementById('display-xp');
    const levelDisplay = document.getElementById('display-level');
    const trustDisplay = document.getElementById('display-trust');
    const badgesDisplay = document.getElementById('display-badges');
    const eventsList = document.getElementById('events-list');
    const busStream = document.getElementById('bus-stream');

    // Atualizar UI com os dados do Bus
    const updateUI = (stats) => {
        if (xpDisplay) xpDisplay.textContent = stats.xp;
        if (levelDisplay) levelDisplay.textContent = stats.level;
        if (trustDisplay) trustDisplay.textContent = stats.trust_score;
        
        if (badgesDisplay && stats.badges) {
            badgesDisplay.innerHTML = '';
            stats.badges.forEach(badge => {
                const b = document.createElement('span');
                b.title = badge.name;
                b.textContent = badge.icon || '🏅';
                b.style.fontSize = '2rem';
                badgesDisplay.appendChild(b);
            });
            if (stats.badges.length === 0) badgesDisplay.textContent = 'Nenhuma';
        }
        
        // Efeito de brilho se houver mudança de XP
        const xpCard = document.getElementById('card-xp');
        if (xpCard) {
            xpCard.style.boxShadow = '0 0 20px var(--moss)';
            setTimeout(() => xpCard.style.boxShadow = '', 1000);
        }
    };

    // Escutar atualizações do Bus
    window.addEventListener('genius_bus_update', (e) => {
        updateUI(e.detail);
    });

    // Função para renderizar pulsos no console lateral
    const addPulseToConsole = (event) => {
        if (!busStream) return;
        
        const time = new Date(event.created_at || Date.now()).toLocaleTimeString();
        const item = document.createElement('div');
        item.className = `pulse-item ${event.criticality?.toLowerCase() || 'info'}`;
        
        const sender = event.agent_id ? `Agente ${event.agent_id.substring(0,8)}` : 'SISTEMA';
        
        item.innerHTML = `
            <div class="pulse-meta">[${time}] ${sender}</div>
            <div class="pulse-body">> ${event.event_type}: ${JSON.stringify(event.payload)}</div>
        `;
        busStream.prepend(item);
        if (busStream.childNodes.length > 50) busStream.removeChild(busStream.lastChild);
    };

    // Inscrição Realtime para Telemetria e Decisões
    supabase
        .channel('realtime_elite')
        .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'genius_system_events' }, payload => {
            addPulseToConsole(payload.new);
        })
        .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'genius_agent_decisions' }, payload => {
            console.log("🧠 Nova Decisão de Agente!", payload.new);
            const decisionEvent = {
                created_at: payload.new.created_at,
                agent_id: payload.new.agent_id,
                event_type: `DECISION:${payload.new.decision_type}`,
                payload: { reason: payload.new.reasoning },
                criticality: 'WARN' // Decisões ganham destaque
            };
            addPulseToConsole(decisionEvent);
        })
        .subscribe();

    // Buscar eventos iniciais
    const { data: initialEvents } = await supabase
        .from('genius_system_events')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(10);

    if (initialEvents && eventsList) {
        eventsList.innerHTML = '';
        initialEvents.forEach(ev => {
            const el = document.createElement('div');
            el.style.padding = '8px';
            el.style.borderBottom = '1px solid #eee';
            el.innerHTML = `[${new Date(ev.created_at).toLocaleTimeString()}] <strong>[${ev.event_type}]</strong>`;
            eventsList.appendChild(el);
            addPulseToConsole(ev);
        });
    }

    // Inicializar UI
    updateUI(bus.stats);

    // TESTE: Registrar uma decisão inicial de ativação do sistema
    setTimeout(() => {
        bus.logDecision(null, 'SYSTEM_BOOT', 'Inicialização do ecossistema com suporte à Elite Integration e Marketplace concluída.');
    }, 2000);

    // Lógica Global de Compra (Exposta para os botões do HTML)
    window.buyItem = async (itemName, cost) => {
        if (bus.stats.xp < cost) {
            alert(`XP Insuficiente! Você precisa de ${cost} XP, mas tem apenas ${bus.stats.xp}.`);
            return;
        }

        if (confirm(`Deseja adquirir "${itemName}" por ${cost} XP?`)) {
            // Deduzir XP via Bus
            await bus.grantXP(-cost, `Compra de Ativo LEGO: ${itemName}`);
            
            // Logar Decisão de Aquisição
            await bus.logDecision(null, 'MARKET_ACQUISITION', `Usuário adquiriu a peça "${itemName}" via Genius Store.`, { item: itemName, cost });
            
            alert(`✅ Sucesso! "${itemName}" foi adicionado ao seu Inventário.`);
        }
    };
});
