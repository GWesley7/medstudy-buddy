# Plano de Implementacao - MedStudy Buddy V2

## Fonte da verdade

Este plano segue `docs/MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md` como documento oficial da V2.

`docs/DOCUMENTACAO_TECNICA_MEDSTUDY_BUDDY.md` deve ser usado apenas como referencia historica para entender fluxos, regras de negocio e funcionalidades do produto anterior. Em caso de conflito, a especificacao V2 prevalece.

## Objetivo da reconstrucao

Reconstruir o MedStudy Buddy do zero como um SaaS moderno para organizacao academica, centrado em provas, conteudos, disponibilidade real do usuario, cronogramas adaptativos e replanejamento deterministico.

A primeira versao nao deve conter:

- Daily.co.
- WebRTC.
- videochamadas ou chamadas de audio.
- Edge Functions de salas.
- funcionalidades ativas de IA.
- dependencias do Lovable.
- codigo reaproveitado automaticamente do projeto antigo.

## Principios de implementacao

- TypeScript em modo estrito.
- Separacao clara entre UI, dominio, dados e integracoes.
- Regras de negocio fora de componentes visuais.
- TanStack Query como padrao para estado remoto.
- React Hook Form e Zod para formularios e validacao.
- RLS em todas as tabelas publicas.
- Migrations SQL versionadas.
- Testes desde a fundacao.
- Acessibilidade e responsividade como requisitos de produto.
- Internacionalizacao obrigatoria em `pt-BR`, `es` e `en`.
- Nenhum segredo no frontend.
- Nenhum dado critico confiado apenas ao client.

## Stack proposta

### Frontend

- React 18.
- TypeScript strict.
- Vite.
- React Router com lazy loading por rota.
- Tailwind CSS.
- shadcn/ui e Radix UI.
- Lucide React.
- TanStack Query.
- React Hook Form.
- Zod.
- date-fns.
- Recharts.
- next-themes.
- `@dnd-kit` para drag-and-drop acessivel.

### Backend e dados

- Supabase Auth.
- PostgreSQL.
- Supabase Storage.
- Supabase Realtime apenas onde houver valor real, como presenca e chat.
- SQL versionado em `supabase/migrations`.
- RLS em todas as tabelas publicas.

### Testes e qualidade

- Vitest.
- React Testing Library.
- Playwright.
- Testes SQL ou pgTAP para RLS.
- ESLint.
- Prettier.
- GitHub Actions para CI.

## Estrutura inicial do projeto

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
    locales/
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
docs/
```

Cada feature podera conter:

```text
components/
hooks/
queries/
mutations/
schemas/
services/
types/
utils/
```

## Modulos e responsabilidades

### Auth

Responsavel por login, cadastro, verificacao de email, recuperacao de senha, reset de senha e protecao de rotas.

### Onboarding

Responsavel por idioma, perfil inicial, tema, primeira prova, conteudos, disponibilidade, restricoes e geracao do primeiro cronograma util.

### Profile e Preferences

Responsaveis por dados pessoais, preferencias regionais, idioma, tema, paletas, notificacoes e configuracoes padrao de estudo.

### Exams, Subjects e Topics

Responsaveis por provas, materias e conteudos. Devem modelar dificuldade, prioridade, pre-requisitos, estimativas e status de dominio.

### Availability

Responsavel por regras semanais, blocos de disponibilidade, excecoes, dias bloqueados, limites diarios e preferencias de periodo.

### Planning e Scheduling

Responsaveis pelo algoritmo deterministico de geracao de cronograma, distribuicao de tarefas, capacidade, margem de seguranca, alertas de sobrecarga e versao do algoritmo.

### Tasks

Responsavel por sessoes/tarefas planejadas, status, conclusao parcial, bloqueio manual, dependencias e replanejamentos.

### Focus

Responsavel por Pomodoro global integrado as tarefas e persistencia de sessoes reais no banco.

### Flashcards

Responsavel por decks, cartoes, anexos, revisoes e associacao opcional a prova, materia ou conteudo.

### Progress

Responsavel por metricas de tempo, ritmo esperado versus real, progresso por prova, atrasos e distribuicao por materia.

### Social

Funcionalidade secundaria para username, amizades, chat 1:1 e presenca real. Sem videochamadas.

### Subscription

Responsavel por planos `free`, `pro` e preparacao inativa para `pro_ai`. Pagamento nao entra na primeira etapa.

## Fases de desenvolvimento

### Fase 0 - Fundacao

- Scaffold do app.
- TypeScript strict.
- ESLint e Prettier.
- Tailwind e shadcn/ui.
- Router com lazy loading.
- Providers globais.
- TanStack Query.
- i18n com `pt-BR`, `es` e `en`.
- next-themes com light, dark e system.
- Cliente Supabase.
- Estrutura de migrations.
- Vitest, Testing Library e Playwright.
- CI.
- Paginas placeholder acessiveis para auth, onboarding e dashboard.

### Fase 1 - Autenticacao, perfil e preferencias

- Cadastro.
- Login.
- Verificacao de email.
- Recuperacao e reset de senha.
- Trigger de perfil.
- Preferencias persistidas.
- Temas e paletas.
- Onboarding inicial.

### Fase 2 - Provas e conteudos

- CRUD de provas.
- Materias.
- Conteudos.
- Prioridade, dificuldade, estimativas, pre-requisitos e status de dominio.

### Fase 3 - Disponibilidade

- Regras semanais.
- Varios blocos por dia.
- Excecoes.
- Dias bloqueados.
- Calculo de capacidade.

### Fase 4 - Cronograma

- Algoritmo deterministico.
- Criacao de plano.
- Tarefas.
- Visualizacao diaria e semanal.
- Alertas de sobrecarga.

### Fase 5 - Replanejamento

- Conclusao parcial.
- Atrasos.
- Preview de mudancas.
- Historico de replanejamento.
- Preservacao de tarefas bloqueadas e concluidas.

### Fase 6 - Foco e progresso

- Pomodoro integrado a tarefas.
- Study sessions persistidas.
- Dashboard.
- Estatisticas principais.

### Fase 7 - Flashcards

- Decks.
- Cartoes.
- Revisao espacada deterministica.
- Anexos.
- Integracao opcional ao cronograma.

### Fase 8 - Social

- Amizades.
- Presenca.
- Chat 1:1.
- Comparacao opcional mediante consentimento.

### Fase 9 - Assinaturas

- Feature flags.
- Limites Free e Pro.
- Preparacao para pagamento em etapa separada.
- Plano `pro_ai` previsto, mas inativo.

## Criterios para avancar entre fases

Antes de iniciar cada fase seguinte:

- revisar arquitetura;
- remover duplicacoes;
- executar lint;
- executar typecheck;
- executar testes relevantes;
- revisar acessibilidade basica;
- atualizar documentacao;
- registrar decisoes arquiteturais relevantes.

## Proximo passo recomendado

Validar estes documentos e, apos aprovacao, executar somente a Fase 0, sem implementar o algoritmo de cronograma ainda.
