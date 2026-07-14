# MedStudy Buddy V2

Fundacao frontend do MedStudy Buddy V2, um SaaS de planejamento de estudos para transformar provas, conteudos e disponibilidade real em cronogramas adaptativos.

## Estado atual

- Fase atual implementada: Fase 3 - Fundacao inicial do banco Supabase.
- Esta base contem apenas fundacao tecnica e paginas placeholder.
- Nao ha autenticacao implementada.
- Ha migrations locais de banco para revisao, mas elas nao foram aplicadas ao projeto remoto.
- Nao ha IA, pagamentos, Daily.co ou WebRTC.

## Requisitos

- Node.js compativel com Vite.
- npm.
- Variaveis locais em `.env.local` quando tarefas futuras precisarem do Supabase.

## Ambiente

Crie `.env.local` com os mesmos nomes de `.env.example` e valores reais locais. Nunca versionar ou expor esses valores.

```env
VITE_SUPABASE_URL=
VITE_SUPABASE_PUBLISHABLE_KEY=
```

## Scripts

```bash
npm install
npm run dev
npm run format:check
npm run lint
npm run typecheck
npm run test:run
npm run build
```

## Estrutura principal

```text
src/
  app/
    providers/
    router/
  components/
    layout/
    shared/
    ui/
  features/
  hooks/
  i18n/
  integrations/
    supabase/
  lib/
    i18n/
    supabase/
  pages/
  styles/
  test/
  types/
supabase/
  migrations/
  tests/
docs/
```

## Banco

As migrations da Fase 3 estao em `supabase/migrations/` e os testes SQL em `supabase/tests/`.

Nao execute `supabase db push`, `supabase db reset` ou migrations contra o remoto sem autorizacao explicita.

A revisao tecnica esta em `docs/FASE_3_REVISAO_BANCO.md`.

## Rotas placeholder

- `/`
- `/exams`
- `/schedule`
- `/flashcards`
- `/focus`
- `/progress`
- `/subscription`
- `/settings`

Essas rotas existem apenas para validar navegacao, layout, tema, idioma e configuracao tecnica.

## Validacao esperada

Antes de concluir tarefas com codigo:

```bash
npm run format:check
npm run lint
npm run typecheck
npm run test:run
npm run build
```

## Regras importantes

- Seguir sempre a documentacao V2.
- Nao executar migrations, `db push`, deploy ou commit sem autorizacao explicita.
- Nao expor valores de `.env.local`.
- Nao implementar fases futuras sem aprovacao.
