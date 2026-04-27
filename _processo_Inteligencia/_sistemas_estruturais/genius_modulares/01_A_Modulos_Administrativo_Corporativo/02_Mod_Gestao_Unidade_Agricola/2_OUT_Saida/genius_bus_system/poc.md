# POC ⚡: Genius Bus (Prova de Conceito)

Este documento define os objetivos técnicos para validar a viabilidade do barramento antes da implantação total.

## 1. Meta da POC
Validar que uma página HTML simples consegue enviar um objeto JSON para uma tabela remota no Supabase e ler o resultado de volta.

## 2. Ambiente de Teste
- **Script**: `scratch/test_bus.js`
- **Tabela**: `genius_test_logs` (ou similar temporária).
- **Sucesso**: Ver o registro no painel do Supabase 1 segundo após o gatilho no navegador.

## 3. Script de Validação (Pseudo-código)
```javascript
const testPing = async () => {
    const { data, error } = await supabase
        .from('genius_telemetry')
        .insert([{ agent_id: 'POC_TEST', type: 'INFO', content: { msg: 'Conexão Estabelecida' } }]);
    
    if (error) console.error('Falha na POC:', error);
    else console.log('Sucesso na POC:', data);
};
```

## 4. Dependência Crítica (BLOQUEIO 🛑)
Para prosseguir da **Etapa 5 (POC)** para a **Etapa 6 (Implantação)**, o Arquiteto (Roberto) deve fornecer ou autorizar a criação de:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

## 5. Critério de Saída
- Confirmação de escrita na nuvem.
- Persistência de um valor numérico (XP) simulado.
