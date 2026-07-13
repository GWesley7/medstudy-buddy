# Arquitetura - MedStudy Buddy V2

## Visao geral

O MedStudy Buddy V2 sera uma aplicacao SaaS full-stack baseada em React, TypeScript, Vite e Supabase. A arquitetura sera modular por dominio, com regras de negocio isoladas em services e algoritmos testaveis, enquanto componentes React ficarao focados em apresentacao e interacao.

O nucleo do produto sera o cronograma adaptativo:

```text
provas -> materias -> conteudos -> disponibilidade -> plano -> tarefas -> sessoes -> progresso
```

## Decisoes arquiteturais principais

1. A especificacao V2 e a fonte oficial da verdade.
2. O projeto antigo e apenas referencia historica.
3. O app sera reconstruido do zero.
4. Daily.co, WebRTC, videochamadas e salas de audio/video nao entram na V2.
5. IA nao sera implementada nesta versao.
6. A arquitetura deixara espaco para `pro_ai`, mas sem funcionalidades ativas.
7. Cronograma, disponibilidade e replanejamento sao o centro do produto.
8. Sessoes de estudo serao persistidas no banco, nao apenas em `localStorage`.
9. Todo estado remoto passara por TanStack Query.
10. Toda tabela publica tera RLS.

## Camadas

### Interface

Responsavel por layouts, paginas, formularios, feedbacks, estados vazios, skeletons, acessibilidade e responsividade.

Tecnologias:

- React.
- Tailwind CSS.
- shadcn/ui.
- Radix UI.
- Lucide React.

### Aplicacao

Responsavel por coordenar fluxos entre UI, dominio e dados:

- hooks de queries;
- mutations;
- route loaders quando fizer sentido;
- providers globais;
- guards de autenticacao;
- notificacoes de sucesso e erro.

### Dominio

Responsavel pelas regras de negocio puras:

- calculo de capacidade;
- geracao deterministica de cronograma;
- divisao de conteudos longos;
- calculo de peso;
- regras de replanejamento;
- progresso;
- repeticao espacada de flashcards.

Esta camada deve ter testes unitarios fortes e evitar dependencia direta de React.

### Dados

Responsavel por persistencia e integracoes:

- cliente Supabase;
- repositories ou services de acesso a dados;
- migrations SQL;
- tipos gerados do Supabase;
- storage;
- realtime.

### Infraestrutura

Responsavel por qualidade e entrega:

- CI;
- lint;
- typecheck;
- testes;
- build;
- configuracao de ambiente.

## Organizacao de pastas

```text
src/
  app/
    providers/
    router/
  components/
    ui/
    layout/
    shared/
  features/
    auth/
    onboarding/
    profile/
    preferences/
    exams/
    subjects/
    topics/
    availability/
    planning/
    scheduling/
    tasks/
    focus/
    flashcards/
    progress/
    social/
    subscription/
  hooks/
  i18n/
  integrations/
    supabase/
  lib/
  pages/
  styles/
  test/
  types/
supabase/
  migrations/
  functions/
  seed.sql
```

## Padrao interno de feature

```text
features/exams/
  components/
  hooks/
  queries/
  mutations/
  schemas/
  services/
  types/
  utils/
```

Nem toda feature precisara de todas as pastas. A estrutura deve surgir conforme necessidade real.

## Roteamento

Rotas publicas:

- `/auth`
- `/auth/verify`
- `/forgot-password`
- `/reset-password`
- `/terms`
- `/privacy`

Rotas autenticadas:

- `/`
- `/onboarding`
- `/today`
- `/schedule`
- `/schedule/week`
- `/schedule/month`
- `/exams`
- `/exams/new`
- `/exams/:examId`
- `/exams/:examId/edit`
- `/exams/:examId/timeline`
- `/tasks/:taskId`
- `/flashcards`
- `/flashcards/decks/:deckId`
- `/progress`
- `/focus`
- `/friends`
- `/messages`
- `/settings/profile`
- `/settings/preferences`
- `/settings/appearance`
- `/settings/notifications`
- `/subscription`

Todas as rotas de pagina devem usar lazy loading.

## Estado

### Estado remoto

TanStack Query sera usado para:

- cache;
- loading;
- erro;
- retry;
- invalidacao;
- atualizacao apos mutations.

### Estado local

Usado apenas para estado efemero:

- dialogs;
- filtros locais;
- abas;
- inputs ainda nao submetidos;
- estado visual temporario.

### Persistencia local

Permitida apenas para melhorar experiencia:

- cache de tema para evitar flash visual;
- preferencias nao criticas enquanto o perfil carrega.

Dados de estudo, sessoes, progresso e cronograma devem ser persistidos no banco.

## Internacionalizacao

Todos os textos de UI devem usar chaves de traducao.

Estrutura:

```text
src/i18n/
  index.ts
  locales/
    pt-BR.json
    es.json
    en.json
```

O idioma sera escolhido no onboarding e salvo em `user_preferences`.

## Temas

Suporte obrigatorio:

- claro;
- escuro;
- automatico pelo sistema;
- paletas predefinidas;
- cores primaria e de destaque personalizadas.

As cores personalizadas devem ser validadas para contraste minimo antes de serem aceitas.

## Algoritmo de cronograma

O algoritmo sera deterministico e configuravel.

Entradas principais:

- prova;
- conteudos;
- dificuldade;
- prioridade;
- duracao estimada;
- pre-requisitos;
- disponibilidade;
- dias bloqueados;
- estrategia de planejamento;
- dias finais reservados;
- regras de revisao.

Saidas:

- plano;
- tarefas;
- alertas;
- capacidade utilizada;
- margem de seguranca;
- explicacao de sobrecarga quando houver.

Configuracoes centrais:

- fatores de dificuldade;
- fatores de prioridade;
- percentuais por estrategia;
- intervalos de revisao;
- limites de carga diaria;
- duracao minima e maxima de sessao.

## Replanejamento

O replanejamento deve:

- preservar tarefas concluidas;
- preservar tarefas bloqueadas;
- gerar historico;
- ser transacional;
- apresentar preview antes de mudancas amplas;
- recalcular apenas o necessario sempre que possivel.

## Supabase

Uso previsto:

- Auth para identidade.
- PostgreSQL para dados.
- Storage para avatares e anexos.
- Realtime para chat e presenca.
- Edge Functions apenas quando houver necessidade real de validacao server-side, rate limit ou fluxo sensivel.

Nao usar Edge Functions relacionadas a Daily.co.

## Seguranca

- RLS em todas as tabelas publicas.
- Policies documentadas junto das migrations.
- Usuario acessa apenas os proprios dados.
- Dados sociais acessiveis apenas quando explicitamente compartilhados.
- Uploads em paths iniciados por `user_id`.
- Limites de MIME e tamanho nos buckets.
- `getUser()` em acoes criticas.
- Rate limit em buscas de usuarios, chat e acoes sensiveis.
- Nenhum token secreto no frontend.

## Testes

Prioridades:

- algoritmos de planejamento;
- regras de replanejamento;
- validacoes Zod;
- hooks de dados criticos;
- fluxos de auth;
- RLS;
- fluxos E2E do MVP.

## O que nao deve existir na V2

- Dependencias do Lovable.
- `DAILY_API_KEY`.
- `study_rooms`.
- `study_room_participants`.
- componentes de salas de video/audio.
- chamadas a APIs de IA.
- features ativas de `pro_ai`.
- mocks ocultando erro em producao.
- TODOs permanentes.
