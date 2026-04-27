# DESIGN 🌟: Genius Bus (User Interface & Experience)

Este documento descreve como a infraestrutura invisível do Genius Bus se manifesta visualmente para o Roberto no Cockpit Administrativo.

## 1. Indicador de Conectividade (Cloud Sync)
Um ícone minimalista de "Nuvem" será adicionado à **Header da Sidebar de Chat** ou ao **Portal Mestre**.

- **Estados Visuais:**
    - 🟢 **Verde Pulsante:** Sincronizado com o Supabase. Tudo em ordem.
    - 🟡 **Âmbar Estático:** Modo Offline (Usando LocalStorage). Sincronização pendente.
    - 🔴 **Vermelho Glitch:** Erro Crítico de Comunicação. Solicitar intervenção do Guardian.

## 2. Activity Pulse (O Pulso de Dados)
Uma pequena animação de "glow" (brilho) de 2px no contorno da nuvem toda vez que um pacote de telemetria for enviado com sucesso. Isso dá a sensação de um sistema "vivo".

## 3. Painel de Eventos (Console do Guardian)
Dentro da Sidebar de Chat, o Guardian terá uma aba secreta ou um comando (/logs) que renderiza os últimos 5 eventos do barramento em uma lista estilizada (Glassmorphism).

- **Estilo dos Logs:**
    - `[INFO]` - Texto Azul Ártico.
    - `[WARN]` - Texto Laranja Neon.
    - `[ALERT]` - Texto Vermelho Sangue (Com tremor sutil).

## 4. Animações de Transição
Ao subir de nível, o ícone da nuvem deve se transformar em um ícone de **Troféu Dourado** temporariamente, celebrando a persistência do progresso na nuvem.

## 5. Assets Necessários
- Ícone de Nuvem SVG (Customizado Genius).
- Gradientes de Estado (CSS Tokens).
