# Frontend Local - Mod_Gestao_Unidade_Agricola

## Objetivo

Testar e evoluir localmente o modulo Gestao da Unidade Agricola consumindo as views do Supabase e preparando o frontend para ser plugado na futura Plataforma Ecossistema Genius.

Este frontend e do modulo inteiro. Ele consome dados dos submodulos e dos fractais por meio de views, eventos e contratos padronizados.

## Arquivos principais

```text
index.html
styles.css
app.js
config.js
config.example.js
server.mjs
manifesto_frontend_modulo.json
CONTRATO_FRONTEND_PLATAFORMA_GENIUS.md
```

## Modos de uso

### Standalone

Roda sozinho para teste, homologacao e operacao local do modulo.

```powershell
node server.mjs
```

Depois abra:

```text
http://localhost:4173
```

### Plugado na Plataforma Genius

Quando a Plataforma Ecossistema Genius for criada, este frontend devera ser carregado pelo manifesto:

```text
manifesto_frontend_modulo.json
```

Caminho sugerido na plataforma:

```text
/modulos/unidade-agricola
```

## Configuracao Supabase

1. No Supabase, copie a `anon public key`.
2. Edite `config.js`.
3. Substitua:

```js
anonKey: "COLE_AQUI_A_SUPABASE_ANON_KEY"
```

pela chave `anon`.

Nunca use `service_role_key` no frontend.

## Data API

O schema abaixo precisa estar exposto na Data API do Supabase:

```text
unidade_agricola
```

Para homologacao, execute no SQL Editor:

```text
../supabase/migrations/202604260013_frontend_dev_grants_unidade_agricola.sql
```

## Telas atuais

```text
Dashboard
Cadastros
Gerenciamento do Modulo
Ferramentas
Relatorios
Banco de Dados
Configuracoes
```

Abas internas de Gerenciamento:

```text
Unidades
Detalhe
Auditoria
Importacoes
```

## Chat lateral direito com Agentes de IA

O frontend possui uma aba lateral direita recolhivel chamada `Chat IA`.

Ela expande para o lado esquerdo, contrai para o lado direito e serve como ambiente de conversa contextual com os Agentes de IA do modulo. Nesta fase funciona localmente; depois sera conectada aos agentes reais e ao Genius Hub.

## Cadastro inicial

A tela `Cadastros` possui o primeiro formulario operacional:

```text
Cadastro da Unidade Agricola
Cadastro de Proprietarios e Possuidores
Cadastro de Responsaveis e Gestores
```

Eles registram rascunhos localmente no navegador para validar campos e fluxo. A proxima etapa e criar as functions/RPCs no Supabase para gravar os cadastros, validar regras e publicar eventos dos fractais.

Cada cadastro tambem possui o botao `Modo Planilha`, que abre um ambiente em grade tipo Excel para preencher ou editar varios rascunhos de uma vez.

## Contratos plug and play

Este frontend possui dois contratos:

```text
manifesto_frontend_modulo.json
CONTRATO_FRONTEND_PLATAFORMA_GENIUS.md
```

Eles definem:

```text
id do modulo
nome
versao
modo standalone
modo plataforma
rotas
menus
views consumidas
eventos publicados
eventos consumidos
permissoes
dependencias
dashboards
pontos de encaixe na Plataforma Genius
```
