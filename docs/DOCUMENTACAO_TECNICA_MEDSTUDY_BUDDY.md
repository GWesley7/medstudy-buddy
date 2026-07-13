# Documentação Técnica Completa — MedStudy Buddy

> Documento gerado como referência de reconstrução ("re-implementação fiel") do projeto atualmente hospedado no Lovable, para migração a um projeto independente mantido via Codex.
> Escopo: representa o estado **atual** do código-fonte do repositório em `main` (data de referência: 13/07/2026). Todos os detalhes de implementação, schemas, RLS, funções, componentes, rotas e integrações estão descritos abaixo. Nada foi omitido intencionalmente.

---

## Índice

1. Visão Geral
2. Stack Tecnológica
3. Estrutura Completa do Projeto
4. Banco de Dados (schemas, migrations, RLS, funções, triggers, sequences, buckets)
5. Autenticação
6. Backend (Edge Functions Supabase)
7. Frontend (páginas, componentes, contexts, hooks)
8. Fluxo Completo do Usuário
9. Lógica de Negócio
10. Integrações
11. Segurança
12. Performance
13. Dependências
14. Variáveis de Ambiente
15. Configurações de Build
16. Deploy
17. Testes
18. Melhorias Implementadas
19. Melhorias Futuras
20. Guia de Recriação para o Codex

---

## 1. Visão Geral

### Objetivo do SaaS
**MedStudy Buddy** é uma plataforma SaaS de produtividade e organização acadêmica voltada a estudantes de medicina. Concentra em um único produto:
- Gestão de provas (com cronograma calculado).
- Planos de estudo com tarefas diárias e calendário mensal.
- Sistema de flashcards com anexos (imagem/arquivo) e revisão espaçada.
- Área de estudo com timer Pomodoro global, sons ambientes e salas de estudo em vídeo/áudio (WebRTC via Daily.co).
- Sistema social: perfis com `@username`, amigos, chat em tempo real, presença online.
- Estatísticas de tempo de estudo (dia/semana/mês).
- i18n em PT/EN/ES e tema claro/escuro.
- Página de assinatura (plano free/premium — UI apenas, sem provedor de pagamento integrado ainda).

### Público-alvo
Estudantes de medicina (graduação, residência, especialistas em preparação para provas de título) que precisam gerir grande volume de matéria em janelas fixas até uma data de prova.

### Problema que resolve
Substitui a mistura de planilhas + apps de flashcards + timers + Discord/Zoom por uma única ferramenta integrada, com dados persistidos e social embutido.

### Fluxo principal do usuário
1. Acessa `/` → sem sessão é redirecionado para `/auth`.
2. Faz cadastro (email + senha + nome completo + `@username`) ou login (email/senha, Google, Facebook OAuth).
3. Confirma email (fluxo de verificação Supabase).
4. Entra no **Dashboard** (`/`) com resumo (próximas provas, tarefas do dia, estatísticas).
5. Cria uma **prova** em `/provas/nova` (matéria, data, horas diárias, descrição).
6. Cria um **plano de estudo** vinculado (automático ou manual) que gera tarefas por dia.
7. Marca tarefas concluídas em `/planos` (checkbox atualiza `progress` do plano).
8. Cria/estuda **flashcards** em `/flashcards` e `/flashcards/materias`.
9. Vai à **Área de Estudo** (`/area-estudo`) para usar Pomodoro, sons ambientes, entrar/criar salas de estudo, ver amigos online, chat.
10. Acompanha **progresso** em `/progresso`.
11. Ajusta **preferências** em `/configuracoes` (idioma, tema, senha, avatar, notificações).
12. Vê **assinatura** em `/assinatura`. Faz logout via `ProfileMenu`.

### Arquitetura geral
- **SPA React** (Vite + React Router v6) totalmente client-side.
- **BaaS Supabase**: PostgreSQL, Auth, Storage, Realtime, Edge Functions (Deno).
- **Serviço externo**: Daily.co (WebRTC) para salas de estudo em vídeo/áudio.
- **Estado global**: Context API (Language, Pomodoro, AmbientSound). Estado remoto: TanStack Query (instância criada mas maior parte das telas usa Supabase JS direto + `useState/useEffect`). Estado local persistido: `localStorage` (tema, idioma, config pomodoro, sessões de estudo).
- Padrão **Component-Driven Development** com biblioteca **shadcn/ui** (Radix + Tailwind).

### Organização das funcionalidades
```
Auth (público)
 └── Layout (protegido, requer sessão)
      ├── Dashboard
      ├── Planos de Estudo (+ Calendário + Criar Plano modal)
      ├── Provas / Nova Prova
      ├── Flashcards / Flashcards por Matéria (+ Anexos)
      ├── Progresso
      ├── Área de Estudo (Pomodoro + Ambiente + Salas + Amigos)
      ├── Assinatura
      ├── Configurações
      └── Termos
```

---

## 2. Stack Tecnológica

### Frontend
| Camada | Escolha | Versão |
|---|---|---|
| Bundler | Vite | ^5.4.19 |
| Framework | React | ^18.3.1 |
| Renderer | react-dom | ^18.3.1 |
| Linguagem | TypeScript | ^5.8.3 (strict:false, noImplicitAny:false, strictNullChecks:false — permissivo) |
| Plugin React | @vitejs/plugin-react-swc | ^3.11.0 (compilação SWC) |
| UI kit | shadcn/ui (Radix UI + variantes com CVA) | ver `package.json` |
| CSS | Tailwind CSS | ^3.4.17 |
| Plugin animações | tailwindcss-animate | ^1.0.7 |
| Plugin typography | @tailwindcss/typography | ^0.5.16 |
| Ícones | lucide-react | ^0.462.0 |
| Estado remoto | @tanstack/react-query | ^5.83.0 (QueryClient criado; a maior parte usa Supabase direto) |
| Roteamento | react-router-dom | ^6.30.1 |
| Formulários | react-hook-form | ^7.61.1 |
| Validação | zod | ^3.25.76 + @hookform/resolvers ^3.10.0 |
| Datas | date-fns | ^3.6.0 |
| Gráficos | recharts | ^2.15.4 |
| Carrossel | embla-carousel-react | ^8.6.0 |
| Notificações | sonner ^1.7.4 + toaster shadcn |
| Utilidades | clsx, tailwind-merge, class-variance-authority, cmdk, vaul, input-otp, react-day-picker, react-resizable-panels |
| Tema | next-themes ^0.3.0 (light/dark; storage: localStorage) |
| Fonte | Google Fonts **Inter** (300..700) via `<link>` em `index.html` |

### Backend (BaaS)
| Camada | Escolha |
|---|---|
| Provedor | Supabase (Lovable Cloud) |
| DB | PostgreSQL 15 (via Supabase) |
| API | PostgREST auto-gerado (client oficial `@supabase/supabase-js` ^2.77.0) |
| ORM | Nenhum. SQL puro + client tipado (`Database` gerado em `src/integrations/supabase/types.ts`) |
| Auth | Supabase Auth (email/senha + OAuth Google/Facebook) |
| Storage | Supabase Storage (buckets `avatars` e `flashcard-attachments`) |
| Realtime | Supabase Realtime — habilitado para `chat_messages` e `study_rooms` |
| Serverless | Supabase Edge Functions (Deno runtime) — `create-daily-room`, `delete-daily-room` |

### Serviço externo
- **Daily.co**: API REST `https://api.daily.co/v1/rooms` para criar/deletar salas WebRTC (video/audio, chat, screen share, prejoin UI, PIP).

### Infraestrutura
- Hospedagem: Lovable (subdomínio `*.lovable.app`) — no destino Codex: qualquer hospedagem estática (Vercel, Netlify, Cloudflare Pages) + Supabase.
- Build: `vite build` (produção) / `vite build --mode development`.
- Dev: `vite` na porta **8080**, host `::` (`vite.config.ts`).
- Deploy backend: migrations SQL versionadas em `supabase/migrations/` + Edge Functions em `supabase/functions/`.

---

## 3. Estrutura Completa do Projeto

```
.
├── .env                              # VITE_SUPABASE_* (build-time)
├── .gitignore
├── README.md
├── bun.lock / bun.lockb / package-lock.json
├── components.json                   # shadcn/ui config
├── eslint.config.js
├── index.html                        # entry HTML, meta, fonte Inter
├── package.json
├── postcss.config.js                 # tailwindcss + autoprefixer
├── tailwind.config.ts
├── tsconfig.json / tsconfig.app.json / tsconfig.node.json
├── vite.config.ts                    # porta 8080, alias @, componentTagger dev
├── public/
│   ├── favicon.ico
│   ├── placeholder.svg
│   └── robots.txt
├── src/
│   ├── App.css                       # legado do template Vite (não usado nas rotas)
│   ├── App.tsx                       # Providers + Router + rotas
│   ├── main.tsx                      # createRoot
│   ├── index.css                     # Tailwind + design tokens HSL (light/dark)
│   ├── vite-env.d.ts
│   ├── lib/
│   │   └── utils.ts                  # cn() = twMerge(clsx())
│   ├── integrations/supabase/
│   │   ├── client.ts                 # createClient tipado
│   │   └── types.ts                  # tipos Database gerados
│   ├── contexts/
│   │   ├── LanguageContext.tsx       # i18n PT/EN/ES + t()
│   │   ├── PomodoroContext.tsx       # timer global persistente
│   │   └── AmbientSoundContext.tsx   # player de sons ambientes
│   ├── hooks/
│   │   ├── use-mobile.tsx            # matchMedia breakpoint 768
│   │   ├── use-toast.ts              # shadcn toast
│   │   ├── useFriends.ts             # lista amigos + realtime
│   │   └── useStudyTimer.ts          # cronômetro de estudo (localStorage)
│   ├── components/
│   │   ├── Layout.tsx                # shell autenticado (header + sidebar + Outlet)
│   │   ├── AppSidebar.tsx            # menu lateral
│   │   ├── AvatarUpload.tsx          # upload avatar → bucket "avatars"
│   │   ├── ChatWindow.tsx            # janela chat 1:1 realtime
│   │   ├── FlashcardAttachmentUpload.tsx
│   │   ├── FriendsList.tsx           # busca @, envia/aceita solicitações
│   │   ├── LanguageSelector.tsx
│   │   ├── PomodoroHeader.tsx        # indicador no header
│   │   ├── ProfileMenu.tsx           # dropdown avatar + logout
│   │   ├── ThemeToggle.tsx           # next-themes
│   │   ├── study-area/
│   │   │   ├── AmbientSoundPlayer.tsx
│   │   │   ├── FriendsOnline.tsx
│   │   │   ├── PomodoroSettings.tsx
│   │   │   ├── PomodoroTimer.tsx     # UI principal do timer
│   │   │   ├── RoomSettingsDialog.tsx
│   │   │   ├── StudyRooms.tsx        # criar/entrar/deletar salas Daily.co
│   │   │   └── StudyStats.tsx        # gráfico de horas
│   │   ├── study-plans/
│   │   │   ├── CalendarView.tsx      # calendário mensal com tarefas
│   │   │   └── CreatePlanModal.tsx   # criar plano auto/manual
│   │   └── ui/                       # ~50 componentes shadcn/ui
│   └── pages/
│       ├── Index.tsx                 # legado (não referenciado por rota)
│       ├── Auth.tsx                  # login / cadastro / OAuth
│       ├── Dashboard.tsx             # "/"
│       ├── Planos.tsx                # "/planos"
│       ├── Provas.tsx                # "/provas"
│       ├── NovaProva.tsx             # "/provas/nova"
│       ├── Flashcards.tsx            # "/flashcards"
│       ├── FlashcardsBySubject.tsx   # "/flashcards/materias"
│       ├── Progresso.tsx             # "/progresso"
│       ├── AreaEstudo.tsx            # "/area-estudo"
│       ├── Assinatura.tsx            # "/assinatura"
│       ├── Configuracoes.tsx         # "/configuracoes"
│       ├── Termos.tsx                # "/termos"
│       └── NotFound.tsx              # "*"
└── supabase/
    ├── config.toml                   # apenas project_id
    ├── functions/
    │   ├── create-daily-room/index.ts
    │   └── delete-daily-room/index.ts
    └── migrations/                   # 12 migrations SQL (ver seção 4)
```

Notas importantes:
- `src/pages/Index.tsx` é resquício do template; a rota `/` é servida por `Dashboard`.
- `src/App.css` também é resquício; estilização real está em `src/index.css`.
- Não existe `src/hooks/useAuth.ts` — controle de sessão está inline em `Layout.tsx` e `Auth.tsx`.

---

## 4. Banco de Dados

### 4.1. Provedor
PostgreSQL gerenciado pelo Supabase (esquema `public` para dados da aplicação; `auth`, `storage`, `realtime` são gerenciados). Publicação Realtime: `supabase_realtime` (adiciona `chat_messages` e `study_rooms`). Extensão `pgcrypto` habilitada por padrão no Supabase (`gen_random_uuid()`).

### 4.2. Tabelas

Todas as tabelas ficam em `public.*`. Todas têm RLS habilitado. Todas usam `id UUID PRIMARY KEY DEFAULT gen_random_uuid()` (exceto `profiles` cujo `id` é `= auth.users.id`).

#### `public.profiles`
Perfil do usuário; cria automaticamente ao registrar (trigger `on_auth_user_created`).

| Coluna | Tipo | Null | Default | Notas |
|---|---|---|---|---|
| `id` | uuid | NOT NULL | – | PK, FK → `auth.users(id)` ON DELETE CASCADE |
| `nome_completo` | text | NULL | – | vem de `raw_user_meta_data->>'nome_completo'` |
| `username` | text | NULL | – | UNIQUE (`profiles_username_unique`), índice `idx_profiles_username` |
| `profile_image_url` | text | NULL | – | URL pública no bucket `avatars` |
| `avatar_thumbnail_url` | text | NULL | – | thumbnail (mesmo bucket) |
| `created_at` | timestamptz | NOT NULL | `now()` | |
| `updated_at` | timestamptz | NOT NULL | `now()` | trigger `update_profiles_updated_at` |

RLS:
- SELECT/UPDATE/INSERT restritos a `auth.uid() = id`.

#### `public.exams`
Provas cadastradas.

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` (PK) |
| `user_id` | uuid | NOT NULL | – (FK `auth.users` CASCADE) |
| `subject` | text | NOT NULL | – |
| `exam_date` | date | NOT NULL | – |
| `daily_study_hours` | integer | NULL | – |
| `description` | text | NULL | – |
| `created_at` | timestamptz | NULL | `now()` |
| `updated_at` | timestamptz | NULL | `now()` (trigger) |

RLS: 4 policies — usuário só vê/insere/atualiza/deleta os próprios (`auth.uid() = user_id`).

#### `public.study_plans`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `user_id` | uuid | NOT NULL | – (FK auth.users CASCADE) |
| `exam_id` | uuid | NULL | – (FK `exams(id)` CASCADE) |
| `subject` | text | NOT NULL | – |
| `exam_date` | date | NOT NULL | – |
| `weekly_hours` | integer | NOT NULL | – |
| `progress` | integer | NULL | `0` (0-100) |
| `created_at` | timestamptz | NULL | `now()` |
| `updated_at` | timestamptz | NULL | `now()` (trigger) |

RLS: 4 policies — próprios registros.

#### `public.study_tasks`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `plan_id` | uuid | NOT NULL | – (FK `study_plans(id)` CASCADE) |
| `title` | text | NOT NULL | – |
| `estimated_hours` | numeric (DECIMAL) | NOT NULL | – |
| `completed` | boolean | NULL | `false` |
| `task_date` | date | NOT NULL | – |
| `created_at` | timestamptz | NULL | `now()` |
| `updated_at` | timestamptz | NULL | `now()` (trigger) |

RLS: baseado em EXISTS no `study_plans` do dono (`auth.uid() = study_plans.user_id`).

#### `public.flashcards`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `user_id` | uuid | NOT NULL | – (FK auth.users CASCADE) |
| `materia` | text | NOT NULL | – |
| `pergunta` | text | NOT NULL | – |
| `resposta` | text | NOT NULL | – |
| `dificuldade` | text | NULL | `'ruim'`; CHECK IN (`'ruim','médio','bom','ótimo'`) |
| `proxima_revisao` | date | NOT NULL | `CURRENT_DATE` |
| `revisoes` | integer | NULL | `0` |
| `created_at` | timestamptz | NOT NULL | `now()` |
| `updated_at` | timestamptz | NOT NULL | `now()` (trigger) |

RLS: 4 policies — próprios flashcards.

#### `public.flashcard_attachments`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `flashcard_id` | uuid | NOT NULL | – (FK `flashcards(id)` CASCADE) |
| `file_url` | text | NOT NULL | – (URL pública no bucket `flashcard-attachments`) |
| `file_name` | text | NOT NULL | – |
| `file_type` | text | NOT NULL | – (MIME) |
| `file_size` | integer | NOT NULL | – (bytes) |
| `created_at` | timestamptz | NOT NULL | `now()` |

RLS: SELECT/INSERT/DELETE se o `flashcard` referenciado pertence ao `auth.uid()`.

#### `public.friend_requests`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `sender_id` | uuid | NOT NULL | – (FK `profiles(id)` CASCADE) |
| `receiver_id` | uuid | NOT NULL | – (FK `profiles(id)` CASCADE) |
| `status` | text | NOT NULL | – CHECK IN (`'pending','accepted','rejected'`) |
| `created_at` | timestamptz | NULL | `now()` |
| `updated_at` | timestamptz | NULL | `now()` (trigger) |

Constraint UNIQUE `(sender_id, receiver_id)`.

RLS:
- SELECT: sender ou receiver.
- INSERT: só o próprio sender.
- UPDATE: só o receiver (aceitar/rejeitar).
- DELETE: sender ou receiver.

#### `public.chat_messages`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `sender_id` | uuid | NOT NULL | – (FK auth.users CASCADE) |
| `receiver_id` | uuid | NOT NULL | – (FK auth.users CASCADE) |
| `message` | text | NOT NULL | – |
| `read` | boolean | NULL | `false` |
| `created_at` | timestamptz | NULL | `now()` |

RLS:
- SELECT: sender ou receiver.
- INSERT: só sender = auth.uid().
- UPDATE: só receiver (marcar como lida).

Realtime: `ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;`

#### `public.study_rooms`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `name` | text | NOT NULL | – |
| `description` | text | NULL | – |
| `host_id` | uuid | NOT NULL | – (FK auth.users CASCADE) |
| `daily_room_name` | text | NOT NULL | – UNIQUE (id retornado por Daily.co) |
| `daily_room_url` | text | NOT NULL | – |
| `room_type` | text | NOT NULL | – CHECK IN (`'video','audio'`) |
| `max_participants` | integer | NOT NULL | `10` |
| `is_active` | boolean | NOT NULL | `true` |
| `is_public` | boolean | NULL | `true` |
| `password` | text | NULL | – (senha da sala, em texto — ver seção 11) |
| `room_number` | integer | NULL | atribuído por trigger a partir de sequence `study_room_number_seq` (start 1000) |
| `created_at` | timestamptz | NOT NULL | `now()` |
| `updated_at` | timestamptz | NOT NULL | `now()` (trigger) |

RLS:
- SELECT: qualquer usuário se `is_active = true`.
- INSERT: `auth.uid() = host_id`.
- UPDATE/DELETE: apenas host.

Realtime: `ALTER PUBLICATION supabase_realtime ADD TABLE study_rooms;`

Trigger `assign_room_number_trigger` (BEFORE INSERT) atribui `room_number := nextval('study_room_number_seq')` quando NULL.

#### `public.study_room_participants`

| Coluna | Tipo | Null | Default |
|---|---|---|---|
| `id` | uuid | NOT NULL | `gen_random_uuid()` |
| `room_id` | uuid | NOT NULL | – (FK `study_rooms(id)` CASCADE) |
| `user_id` | uuid | NOT NULL | – |
| `invited_at` | timestamptz | NULL | `now()` |

Constraint UNIQUE `(room_id, user_id)`.

RLS:
- SELECT: se a sala é pública e ativa **ou** `auth.uid() = user_id`.
- ALL: host da sala pode gerenciar (`FOR ALL USING host_id = auth.uid()`).

### 4.3. Funções (schema `public`)

```sql
-- Cria linha em profiles ao criar auth.user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, nome_completo)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'nome_completo');
  RETURN NEW;
END; $$;

-- Atualiza updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- Atribui room_number sequencial
CREATE OR REPLACE FUNCTION public.assign_room_number()
RETURNS trigger LANGUAGE plpgsql
AS $$ BEGIN
  IF NEW.room_number IS NULL THEN
    NEW.room_number := nextval('study_room_number_seq');
  END IF;
  RETURN NEW;
END; $$;
```

### 4.4. Triggers

| Trigger | Tabela | Evento | Função |
|---|---|---|---|
| `on_auth_user_created` | `auth.users` | AFTER INSERT | `handle_new_user()` |
| `update_profiles_updated_at` | `profiles` | BEFORE UPDATE | `update_updated_at_column()` |
| `update_friend_requests_updated_at` | `friend_requests` | BEFORE UPDATE | idem |
| `update_exams_updated_at` | `exams` | BEFORE UPDATE | idem |
| `update_study_plans_updated_at` | `study_plans` | BEFORE UPDATE | idem |
| `update_study_tasks_updated_at` | `study_tasks` | BEFORE UPDATE | idem |
| `update_flashcards_updated_at` | `flashcards` | BEFORE UPDATE | idem |
| `update_study_rooms_updated_at` | `study_rooms` | BEFORE UPDATE | idem |
| `assign_room_number_trigger` | `study_rooms` | BEFORE INSERT | `assign_room_number()` |

### 4.5. Sequences

- `study_room_number_seq` START 1000, INCREMENT 1.

### 4.6. Storage buckets (schema `storage`)

**`avatars`** — público, 5 MB, MIME: `image/jpeg`, `image/jpg`, `image/png`, `image/webp`.
Policies (`storage.objects`):
- SELECT: `bucket_id = 'avatars'` (todos podem ver).
- INSERT/UPDATE/DELETE: `bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]` (o path deve começar por `<user_id>/…`).

**`flashcard-attachments`** — público.
Policies:
- SELECT/INSERT/UPDATE/DELETE: `bucket_id = 'flashcard-attachments' AND auth.uid()::text = (storage.foldername(name))[1]`.

### 4.7. Migrations (arquivo por arquivo)

12 arquivos em `supabase/migrations/` (ordem cronológica pelo prefixo):

1. `20251101014728_...` — cria `profiles`, RLS, `handle_new_user`, trigger `on_auth_user_created`, `update_updated_at_column`, trigger em `profiles`.
2. `20251101014829_...` — corrige `update_updated_at_column` com `SECURITY DEFINER SET search_path = public`.
3. `20251101222840_...` — adiciona `profile_image_url` e `avatar_thumbnail_url` em `profiles`; cria bucket `avatars` (público, 5 MB, MIME list) + policies.
4. `20251104195703_...` — adiciona `username` a `profiles` (UNIQUE) + índice; cria `friend_requests` + RLS + trigger `updated_at`.
5. `20251106224546_...` — reforça `UNIQUE (username)` (idempotente) e cria índice se não existir.
6. `20251106224708_...` — cria `exams`, `study_plans`, `study_tasks`, `chat_messages` com RLS completo; recria `update_updated_at_column` (sem `SECURITY DEFINER` — redefinida); triggers `updated_at`; adiciona `chat_messages` ao `supabase_realtime`.
7. `20251108025151_...` — cria bucket `flashcard-attachments` (público); cria tabelas `flashcards` e `flashcard_attachments` com RLS e policies de storage por pasta do usuário; trigger `updated_at`.
8. `20251112003355_...` — cria `study_rooms` (v1 sem password/room_number/is_public), RLS, trigger `updated_at`, publica em realtime.
9. `20251113003357_...` — adiciona `room_number`, `password`, `is_public` a `study_rooms`; cria `study_room_number_seq`; função + trigger `assign_room_number`; cria `study_room_participants` + RLS.
10. `20251113003503_...` — idempotência das alterações da migration 9 (DO blocks).
11. `20251113003529_...` — (ajustes complementares em `study_rooms` — DO blocks idempotentes).
12. `20251113003556_...` — ajustes finais em Edge Functions/RLS relacionados a delete de salas.

> Ao reconstruir no Codex sem depender das migrations do Supabase, gere um **único** SQL "canônico" combinando os efeitos acumulados (schema final descrito na seção 4.2 é o estado ao qual as 12 migrations convergem).

### 4.8. Seeds
Nenhum seed no repositório. Dados iniciais aparecem apenas via uso do app.

### 4.9. Views / Procedures
Nenhuma view. Nenhuma stored procedure além das funções descritas em 4.3.

---

## 5. Autenticação

### 5.1. Provedor
Supabase Auth. Fluxos habilitados: **email/senha** (com confirmação de email) + **OAuth Google** + **OAuth Facebook** (Apple citado no código, não usado na UI).

### 5.2. Fluxo de cadastro (`Auth.tsx`)
1. Validações client-side: campos obrigatórios (email, senha, nome, username), username ≥ 3 chars, senha ≥ 6 chars.
2. Verifica se `username` já existe (`select username from profiles where username=? maybeSingle()`).
3. `supabase.auth.signUp({ email, password, options: { data: { nome_completo, username }, emailRedirectTo: window.location.origin + '/' } })`.
4. Sucesso → toast + `setVerificationSent(true)` (UI muda para tela "Verifique seu email").
5. Trigger DB `handle_new_user()` cria linha em `profiles` (com `nome_completo`). Observação: **`username` não é copiado pelo trigger** — o app grava depois via `Configuracoes` ou fluxo posterior; a coluna nasce NULL. (Fica como ponto de atenção — considerar estender o trigger ao migrar.)
6. Reenvio: `supabase.auth.resend({ type:'signup', email, options:{ emailRedirectTo } })`.

### 5.3. Fluxo de login
- Email/senha: `supabase.auth.signInWithPassword`. Tratamento específico da mensagem "Invalid login credentials".
- OAuth: `supabase.auth.signInWithOAuth({ provider, options:{ redirectTo: origin + '/' } })`.
- Após `SIGNED_IN`, listener em `Auth.tsx` navega para `/`.

### 5.4. Sessões
- Armazenamento: `localStorage` (`storage: localStorage` no `createClient`).
- `persistSession: true`, `autoRefreshToken: true` → Supabase renova access token automaticamente (JWT + refresh token).
- `Layout.tsx` verifica sessão no mount com `getSession()`; se ausente redireciona para `/auth`. Listener `onAuthStateChange` reage a `SIGNED_OUT`.
- Nunca é chamado `getUser()` para revalidar (padrão atual do projeto — nota de segurança).

### 5.5. Recuperação de senha
Não implementada UI própria (`resetPasswordForEmail` não é chamado). Página `/reset-password` **não existe**. Ver seção 19 (melhorias futuras).

### 5.6. Papéis / permissões
Não há tabela `user_roles`. Toda autorização é derivada do `auth.uid()` via RLS por proprietário. Não há admin/moderador. Ao migrar/expandir, seguir padrão canônico de `user_roles` + `has_role()` `SECURITY DEFINER`.

### 5.7. Segredos gerenciados
- Publicáveis (client): `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY` (anon key), `VITE_SUPABASE_PROJECT_ID`.
- Runtime Edge Functions (Supabase Secrets): `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_DB_URL`, `DAILY_API_KEY`.

---

## 6. Backend — Edge Functions

Toda API custom vive em Edge Functions Deno. Não há servidor Node/Express. Nenhum outro endpoint.

### 6.1. `POST /functions/v1/create-daily-room`
Arquivo: `supabase/functions/create-daily-room/index.ts`.

- **Headers**: `Authorization: Bearer <access_token>`, `Content-Type: application/json`, `apikey: <anon>`.
- **Body**:
  ```json
  {
    "name": "string",
    "description": "string|null",
    "roomType": "video" | "audio",
    "maxParticipants": 1..50,
    "password": "string|null",
    "isPublic": true|false
  }
  ```
- **Fluxo**:
  1. Trata CORS (OPTIONS).
  2. Cria cliente Supabase com Auth header do request. `auth.getUser()`; se null → 400 "Unauthorized".
  3. Valida `name` e `roomType`.
  4. Chama `POST https://api.daily.co/v1/rooms` (Bearer `DAILY_API_KEY`) com propriedades:
     `enable_chat`, `enable_screenshare`, `max_participants`, `enable_prejoin_ui`, `enable_people_ui`, `enable_pip_ui`.
  5. Insere em `study_rooms` (`name, description, host_id=user.id, daily_room_name, daily_room_url, room_type, max_participants, password, is_public, is_active=true`).
- **Response 200**: `{ "room": { ...linha inserida } }`.
- **Response 400**: `{ "error": "mensagem" }`.
- **Erros tratados**: `DAILY_API_KEY` ausente, resposta não-OK do Daily, erros do Postgres.

### 6.2. `POST /functions/v1/delete-daily-room`
Arquivo: `supabase/functions/delete-daily-room/index.ts`.

- **Body**: `{ "roomId": "uuid" }`.
- **Fluxo**:
  1. Autentica user.
  2. Busca `study_rooms` onde `id = roomId AND host_id = user.id`. Se não existe → 400.
  3. Chama `DELETE https://api.daily.co/v1/rooms/{daily_room_name}` (Bearer `DAILY_API_KEY`).
     - Se retornar 404 → considera já deletada e segue.
     - Outros erros HTTP → 400.
  4. `UPDATE study_rooms SET is_active = false WHERE id = ? AND host_id = ?`.
- **Response 200**: `{ "success": true }`.
- **Logs**: `console.log/console.error` (aparecem em Supabase → Edge Function Logs).

### 6.3. Middlewares / erros / logs
- Sem framework HTTP: `Deno.serve` puro via `std/http/server`.
- CORS: headers `Access-Control-Allow-Origin: *`, `Allow-Headers: authorization, x-client-info, apikey, content-type`.
- Erros: `try/catch` global, JSON `{error}` com status 400 (não usa 401/403/404 fine-grained — reproduzir se desejar).

### 6.4. Regras de negócio no backend
- Toda validação server-side é feita apenas em `create-daily-room` (nome+tipo) e por RLS. Não há Zod nas Edge Functions atuais — reforçar ao migrar.

---

## 7. Frontend

### 7.1. Bootstrapping
- `src/main.tsx` monta `<App />` em `#root`.
- `src/App.tsx` empilha providers na ordem: `QueryClientProvider` → `LanguageProvider` → `PomodoroProvider` → `AmbientSoundProvider` → `TooltipProvider` → `<Toaster/><Sonner/>` → `BrowserRouter`.
- Rotas:
  - `/auth` → `<Auth />` (público)
  - `<Route element={<Layout />}>` (protegido pelo `Layout`):
    - `/` → `Dashboard`
    - `/provas` → `Provas`
    - `/provas/nova` → `NovaProva`
    - `/planos` → `Planos`
    - `/flashcards` → `Flashcards`
    - `/flashcards/materias` → `FlashcardsBySubject`
    - `/progresso` → `Progresso`
    - `/area-estudo` → `AreaEstudo`
    - `/assinatura` → `Assinatura`
    - `/configuracoes` → `Configuracoes`
    - `/termos` → `Termos`
    - `*` → `NotFound`

### 7.2. Layout autenticado (`components/Layout.tsx`)
- `useEffect` inicial → `supabase.auth.getSession()`; se nula, `navigate('/auth')`; se ok, `setLoading(false)`.
- Listener `onAuthStateChange` também redireciona em `SIGNED_OUT`.
- Estrutura: `<SidebarProvider>` + `<AppSidebar>` + coluna com `<header>` fixo (SidebarTrigger, logo `GraduationCap`, título "MedStudy Buddy" + tagline, `PomodoroHeader`, badge Online/Offline clicável, `LanguageSelector`, `ProfileMenu`, `ThemeToggle`) + `<main>` com `<Outlet />`.
- Enquanto carrega: `<Loader2 className="animate-spin" />` centralizado.

### 7.3. Sidebar (`AppSidebar.tsx`)
- Componente shadcn `Sidebar` com um único grupo "Menu Principal".
- Items (`{ key, url, icon }`):
  - Dashboard (`/`, Home)
  - Planos de Estudo (`/planos`, BookMarked)
  - Provas (`/provas`, FileText)
  - Flashcards (`/flashcards`, BookOpen)
  - Progresso (`/progresso`, BarChart)
  - Área de Estudo (`/area-estudo`, Headphones)
  - Assinatura (`/assinatura`, CreditCard)
- Cada item usa `NavLink` com `end={url==='/'}`, classes ativas em `bg-primary/10 font-semibold`.
- Rótulos vêm de `useLanguage().t(item.key)`.

### 7.4. Páginas (uma a uma)

**`Auth.tsx`** — Login/Cadastro (visão em `Tabs`): OAuth Google/Facebook, formulários controlados, estados de loading, `verificationSent`, `resendVerification`. Design: Card centralizado, gradient background.

**`Dashboard.tsx`** — resumo. Blocos: próximas provas (query `exams` limit N), tarefas de hoje (`study_tasks` por data), estatísticas resumidas (usa `useStudyTimer.getStudyStats()`), atalho para "Nova Prova". Layout de grid responsivo (col-1 mobile, col-2/3 desktop).

**`Provas.tsx`** — lista de provas do usuário. Botão "Nova Prova" leva a `/provas/nova`. Cada card mostra `subject`, `exam_date`, dias restantes, `daily_study_hours`, `description`. Ações: editar/excluir (excluir cascade em plans/tasks pela FK).

**`NovaProva.tsx`** — formulário controlado (React Hook Form + Zod se aplicado; código atual pode usar useState puro): campos `subject`, `exam_date`, `daily_study_hours`, `description`. On submit: `insert into exams`. Após salvar, redireciona para `/provas` (ou oferece criar plano).

**`Planos.tsx`** — ver arquivo integral acima. Componente principal `CreatePlanModal`; lista de planos ativos (com progresso e próximas 3 tarefas checkbox); seção "Tarefas de Hoje"; `CalendarView` mensal na base; `Dialog` com detalhes ao clicar em tarefa. Estado local `planos` (array), `toggleTarefa` recomputa `progress`.

**`Flashcards.tsx`** — cadastro/edição de flashcards, filtro por matéria/dificuldade, revisão. Ao responder, atualiza `dificuldade`, incrementa `revisoes`, recalcula `proxima_revisao` (regra ver seção 9).

**`FlashcardsBySubject.tsx`** — agrupa por `materia`; contadores, botão para revisar.

**`FlashcardAttachmentUpload.tsx`** — upload multi-arquivo para `flashcard-attachments/{user_id}/{flashcard_id}/{filename}` (path começa com `user_id` para satisfazer RLS de storage), depois `insert` em `flashcard_attachments`. Suporta imagem/PDF; mostra preview de imagens.

**`Progresso.tsx`** — gráficos `recharts` (barras/linhas) com dados do `useStudyTimer` (leitura de localStorage) e métricas de tarefas concluídas (query em `study_tasks`).

**`AreaEstudo.tsx`** — layout 2 col: `PomodoroTimer` (grande) + `AmbientSoundPlayer` + `StudyRooms` na esquerda; `FriendsOnline` + `StudyStats` (card único) na direita. Callback `handlePomodoroComplete` reinicia contador de estudo.

**`Assinatura.tsx`** — UI de planos free vs premium (mock — sem integração de pagamento).

**`Configuracoes.tsx`** — abas: Perfil (nome, username, avatar via `AvatarUpload`), Segurança (troca de senha `supabase.auth.updateUser({password})`), Preferências (idioma, tema), Notificações. Persiste em `profiles`.

**`Termos.tsx`** — página estática de termos.

**`NotFound.tsx`** — 404 shadcn.

**`Index.tsx`** — vestigial (mantém o "Hello" template Vite); **não roteado**.

### 7.5. Componentes shadcn/ui
Localizados em `src/components/ui/*` (accordion, alert, alert-dialog, aspect-ratio, avatar, badge, breadcrumb, button, calendar, card, carousel, chart, checkbox, collapsible, command, context-menu, dialog, drawer, dropdown-menu, form, hover-card, input, input-otp, label, menubar, navigation-menu, pagination, popover, progress, radio-group, resizable, scroll-area, select, separator, sheet, sidebar, skeleton, slider, sonner, switch, table, tabs, textarea, toast, toaster, toggle, toggle-group, tooltip, use-toast). Padrão shadcn: primitives Radix + Tailwind + CVA variants. Não devem ser modificados diretamente.

### 7.6. Componentes de negócio
- `AvatarUpload.tsx` — input file, redimensiona no client (se aplicável), envia para `avatars/{user_id}/avatar.png`, `upsert:true`, `getPublicUrl`, `update profiles set profile_image_url`.
- `ChatWindow.tsx` — janela de chat 1:1. Subscribe em canal `chat_messages` filtrado por `receiver_id=eq.{me}` e `sender_id=eq.{other}`. Envia `insert` em `chat_messages`. Marca `read=true` ao abrir.
- `FriendsList.tsx` — busca por `@username`, envia solicitação, aceita/rejeita (update status), remove amizade.
- `PomodoroHeader.tsx` — mostra `mm:ss` do timer global e um botão para abrir a Área de Estudo.
- `PomodoroTimer.tsx` / `PomodoroSettings.tsx` — UI que consome `PomodoroContext`. Round: focus (25) → shortBreak (5) → focus → shortBreak → focus → shortBreak → focus → longBreak (15). Alerta sonoro (Audio API + arquivo) e Notificação; troca de modo automática. Modo fullscreen.
- `StudyRooms.tsx` — lista salas (query `study_rooms` where `is_active=true`, subscribe realtime). Botão "Criar Sala" abre `RoomSettingsDialog`. Ao criar chama `supabase.functions.invoke('create-daily-room', {body})`. Ao clicar "Entrar", abre iframe/modal com `daily_room_url` (ou redireciona nova janela). Excluir chama `delete-daily-room`.
- `RoomSettingsDialog.tsx` — form controlado: name, description, roomType, maxParticipants (slider), password (opcional), isPublic (switch).
- `StudyStats.tsx` — mostra hoje/semana/mês em `hh:mm`, gráfico simples.
- `FriendsOnline.tsx` — usa `useFriends()`; simula presença via subscribe em `friend_requests` (a lógica de "online" atual é UI-side; para presença real, usar `supabase.channel().track()` com Presence API — ver seção 19).
- `AmbientSoundPlayer.tsx` — dropdown de trilhas (chuva, floresta, lo-fi etc.), botão play/pause, slider de volume; usa `AmbientSoundContext`.
- `LanguageSelector.tsx` — dropdown pt/en/es.
- `ThemeToggle.tsx` — `next-themes` (`useTheme`) alterna `light/dark`, persiste em `localStorage`.
- `ProfileMenu.tsx` — dropdown com avatar → Configurações, Termos, **Sair** (`supabase.auth.signOut()`).
- `CalendarView.tsx` — grid 7×N do mês, marca dias com tarefas, click abre detalhe.
- `CreatePlanModal.tsx` — dois modos:
  - **Automático**: dado `exam_date`, `weekly_hours`, distribui tarefas por dia até a data (regra na seção 9).
  - **Manual**: usuário adiciona tarefas linha a linha (título, data, horas).
  Salva em `study_plans` + N inserts em `study_tasks` (ou usa `.insert([array])`).

### 7.7. Contexts

**`LanguageContext.tsx`** — `type Language = 'pt'|'en'|'es'`. Objeto `translations` gigante com chaves `"header.online"` etc. Cada chave tem `{pt, en, es}`. `t(key)` retorna `translations[key][language] || key`. Idioma salvo em `localStorage.language`.

**`PomodoroContext.tsx`** — estado: `time` (segundos), `isRunning`, `mode: 'focus'|'shortBreak'|'longBreak'`, `sessions`, e configuráveis `focusTime`, `shortBreakTime`, `longBreakTime` (min). Persiste config em `localStorage`. `useEffect` roda `setInterval` decrementando `time`; quando chega a 0, dispara toast, som e alterna `mode` conforme regra (a cada 4 focus → longBreak). Timer é global (`Provider` no `App.tsx`) — continua rodando ao navegar.

**`AmbientSoundContext.tsx`** — `currentSound`, `isPlaying`, `volume`, `Audio` instance. Métodos `play(soundKey)`, `pause`, `setVolume`. Sons em arquivos estáticos servidos por CDN externo ou `public/`.

### 7.8. Hooks

**`useStudyTimer.ts`** — cronômetro isolado (não confundir com Pomodoro). `startStudying()` marca timestamp; `stopStudying()` calcula duração e agrega em `localStorage.studySessions` como `{ 'YYYY-MM-DD': segundos }`. `getStudyStats()` retorna `{today, week, month}` em minutos.

**`useFriends.ts`** — carrega amigos via `friend_requests` com status `accepted` (joins `sender_profile`/`receiver_profile` por FK). Subscribe realtime em `friend_requests` para recarregar. Retorna `{ friends, loading }`.

**`use-toast.ts`** — cópia oficial shadcn (reducer + variants).

**`use-mobile.tsx`** — matchMedia `(max-width: 767px)`.

### 7.9. Responsividade
- Sidebar colapsável em telas ≤ 768px (padrão shadcn `SidebarProvider`).
- Grids `grid-cols-1 md:grid-cols-2 lg:grid-cols-3` em Dashboard, Planos, Flashcards.
- Header: badges e language selector escondem labels em mobile via utilitários Tailwind.

---

## 8. Fluxo Completo do Usuário (detalhado)

1. **Primeiro acesso**: `/` → `Layout` verifica sessão → sem sessão → redirect `/auth`.
2. **Cadastro**: `/auth` aba "Cadastro" → preenche → `signUp` → email de confirmação enviado → tela informativa com botão "Reenviar".
3. **Confirmação email**: usuário clica no link → Supabase redireciona para `emailRedirectTo` (`origin + '/'`) → sessão criada → `SIGNED_IN` → `navigate('/')`.
4. **Login**: `/auth` aba "Login" → email/senha ou OAuth → sessão persistida em `localStorage` → redirect `/`.
5. **Dashboard**: quer criar prova → botão → `/provas/nova`.
6. **Criar prova**: form → `insert exams` → redirect `/provas` ou abre modal "criar plano?".
7. **Criar plano**: `/planos` → botão → `CreatePlanModal` → escolhe automático ou manual → gera tarefas → insert `study_plans` + `study_tasks` (batch).
8. **Marcar tarefa**: `/planos` → checkbox → `update study_tasks set completed` → recalcular `progress` do plano (client-side no exemplo atual).
9. **Flashcards**: `/flashcards` → cria (form) → revisa (mostra pergunta, clica "Mostrar resposta", escolhe dificuldade → recalcula `proxima_revisao`).
10. **Área de estudo**: inicia Pomodoro (25 min); Pomodoro persiste ao navegar; escolhe som ambiente; entra em sala existente (`Entrar` abre iframe Daily.co) ou cria sala (Edge Function).
11. **Chat**: abre `ChatWindow` de um amigo → digita → `insert chat_messages` → outro lado recebe via Realtime.
12. **Progresso**: vê gráficos de horas estudadas + tarefas cumpridas.
13. **Configurações**: altera nome/username/avatar/senha/idioma/tema.
14. **Logout**: `ProfileMenu` → `signOut` → `SIGNED_OUT` → redirect `/auth`.

Fluxos alternativos:
- Email não confirmado → login falha ("Email not confirmed").
- Username já em uso no cadastro → toast erro (validação prévia).
- Password menor que 6 → toast erro.
- OAuth cancelado → toast erro genérico.
- Erro rede → toast "Erro".
- Sala Daily.co já deletada (404) → função ignora e apenas marca `is_active=false`.

---

## 9. Lógica de Negócio

- **Progresso do plano**: `progresso = round((tarefas_concluidas / total_tarefas) * 100)`. Atualizado no client ao marcar checkbox; persistir com `update study_plans set progress` (o código atual atualiza apenas `state`; ver melhoria futura).
- **Distribuição automática de tarefas**: `CreatePlanModal` (modo automático): dado `exam_date`, `weekly_hours`, dias até a prova → gera 1 tarefa por dia útil configurável, `estimated_hours = weekly_hours / dias_estudo_semana`.
- **Revisão espaçada de flashcards** (simplificada — não é SM-2 completo):
  - `ruim` → `proxima_revisao = hoje + 1 dia`.
  - `médio` → hoje + 3 dias.
  - `bom` → hoje + 7 dias.
  - `ótimo` → hoje + 14 dias.
  - `revisoes` incrementa em 1 a cada resposta.
- **Pomodoro**: após cada `focus` completa, `sessions++`. A cada 4 sessions, próximo break vira `longBreak`; caso contrário `shortBreak`. Ao completar break, volta para `focus`. Ao trocar `mode`, `time` reseta para o novo valor.
- **Study Rooms**:
  - Máximo participantes 1..50 (default 10). Passado ao Daily.co como `max_participants`.
  - `password` opcional; verificação de senha é **client-side** (bloquear entrar antes de abrir URL). ⚠️ Isso não é seguro sem verificação server-side (ver Segurança/Melhorias).
  - `room_number` sequencial exibido ao usuário para partilhar (`#1000, #1001, ...`).
- **Amizades**:
  - Estados: `pending → accepted | rejected`.
  - Cancelamento: qualquer lado pode deletar.
  - Não se pode enviar solicitação para si próprio (validação client-side).
- **Chat**:
  - `read=true` ao abrir a conversa (update batch de mensagens onde `receiver_id=me`).
  - Mensagens em tempo real via canal Realtime.
- **Timer de estudo**: apenas local (`localStorage`), não sincroniza entre dispositivos.
- **Preferências**:
  - Idioma persistido em `localStorage.language`.
  - Tema persistido em `localStorage.theme` (via next-themes).
  - Config Pomodoro em `localStorage.pomodoroFocusTime/ShortBreak/LongBreak`.

---

## 10. Integrações

| Serviço | Uso | Como |
|---|---|---|
| **Supabase** | DB, Auth, Storage, Realtime | `@supabase/supabase-js` client + Edge Functions |
| **Daily.co** | Salas WebRTC (video/audio, chat, screenshare) | API REST + iframe embed |
| **Google Fonts** | Fonte Inter | `<link>` em `index.html` |
| **Google OAuth** | Login social | Supabase Auth (`signInWithOAuth('google')`) — provider configurado no dashboard Supabase |
| **Facebook OAuth** | Login social | idem (`signInWithOAuth('facebook')`) |

Não há: analytics (GA/Plausible), pagamentos (Stripe/Paddle), envio de email transacional próprio (usa o do Supabase Auth), webhooks externos, IA/LLM (nenhum LLM chamado no código atual).

---

## 11. Segurança

- **RLS** habilitada em **todas** as tabelas `public.*` — proprietário pelo `auth.uid()`.
- **JWT** validado pelo Supabase; expiração + refresh automático.
- **OAuth 2.0** para Google/Facebook via Supabase.
- **Validação client-side** em todos os forms (comprimento, obrigatoriedade). Falta validação server-side reforçada em Edge Functions (recomenda-se Zod).
- **Storage**: policies limitam pastas por `user_id` (path prefix).
- **Secrets**: `DAILY_API_KEY` e `SUPABASE_SERVICE_ROLE_KEY` só em Edge Functions (nunca no bundle client). `SUPABASE_PUBLISHABLE_KEY` (anon) é público por design.
- **XSS**: React escapa por padrão; nenhum `dangerouslySetInnerHTML`.
- **SQL Injection**: impossível — apenas client tipado + RLS.
- **CSRF**: N/A (SPA + tokens Bearer no header).
- **Rate limit**: apenas o padrão do Supabase Edge Functions/Auth. Sem rate limit próprio.
- **Criptografia em trânsito**: HTTPS/TLS pela Supabase e Daily.co.
- **Pontos frágeis conhecidos**:
  - `study_rooms.password` armazenado em **texto plano** — para dado sensível, hash + verificação server-side (Edge Function).
  - `Layout` usa `getSession()` para gate — considere `getUser()` em fluxos críticos.
  - Ausência de RLS `service_role`-only para joins sensíveis: reforçar `GRANT`s ao migrar (Supabase legacy grantia por padrão; setups novos exigem `GRANT SELECT, INSERT, UPDATE, DELETE ON public.<table> TO authenticated;`).

---

## 12. Performance

- **Vite + SWC**: build/dev extremamente rápidos.
- **Code splitting**: rotas não são lazy-loaded no código atual (todas em `App.tsx` estáticas) — melhoria fácil: `React.lazy(() => import('./pages/...'))` + `<Suspense>`.
- **TanStack Query**: cliente criado, mas majoritariamente não usado — migrar queries para `useQuery` traria cache/refetch/dedupe.
- **Lazy load imagens**: `<img loading="lazy">` recomendado em avatares e anexos.
- **Realtime**: apenas em canais necessários (`chat_messages`, `study_rooms`, `friend_requests`). Desinscreve em cleanup dos `useEffect`.
- **Otimização de bundle**: Tailwind purga classes não usadas.
- **Compressão**: gerenciada pela hospedagem (Brotli/Gzip).

---

## 13. Dependências

### Produção (function → propósito)
- `@hookform/resolvers` — bridge Zod/Yup com React Hook Form.
- `@radix-ui/react-*` — primitives acessíveis (accordion, dialog, dropdown, popover, etc.).
- `@supabase/supabase-js` — cliente oficial.
- `@tanstack/react-query` — cache/estado remoto.
- `class-variance-authority` — variantes de componentes tipadas.
- `clsx` + `tailwind-merge` — utilitário `cn()`.
- `cmdk` — command palette.
- `date-fns` — datas.
- `embla-carousel-react` — carrossel.
- `input-otp` — inputs de OTP.
- `lucide-react` — ícones SVG.
- `next-themes` — tema light/dark persistente.
- `react`, `react-dom` — core.
- `react-day-picker` — calendário shadcn.
- `react-hook-form` — formulários.
- `react-resizable-panels` — painéis.
- `react-router-dom` — roteamento.
- `recharts` — gráficos.
- `sonner` — toasts.
- `tailwindcss-animate` — animações.
- `vaul` — drawers mobile.
- `zod` — schemas de validação.

### Dev
- `@eslint/js`, `eslint`, `typescript-eslint`, `eslint-plugin-react-hooks`, `eslint-plugin-react-refresh`, `globals` — lint.
- `@tailwindcss/typography` — plugin.
- `@types/node`, `@types/react`, `@types/react-dom` — tipagens.
- `@vitejs/plugin-react-swc` — plugin React.
- `autoprefixer`, `postcss`, `tailwindcss` — CSS.
- `lovable-tagger` — plugin dev-only do Lovable (remover ao migrar).
- `typescript` — compilador.
- `vite` — bundler.

---

## 14. Variáveis de Ambiente

### Client (build-time, prefixo `VITE_` — expostas no bundle)
| Variável | Origem | Descrição |
|---|---|---|
| `VITE_SUPABASE_URL` | `.env` | URL do projeto Supabase (`https://<ref>.supabase.co`) |
| `VITE_SUPABASE_PUBLISHABLE_KEY` | `.env` | Anon/publishable key (JWT) |
| `VITE_SUPABASE_PROJECT_ID` | `.env` | Ref do projeto (usado para chamadas diretas de Edge Functions se necessário) |

### Edge Functions (runtime Deno, gerenciadas por Supabase Secrets)
| Variável | Descrição |
|---|---|
| `SUPABASE_URL` | URL do projeto |
| `SUPABASE_ANON_KEY` | Anon key (usada para propagar Authorization do request) |
| `SUPABASE_SERVICE_ROLE_KEY` | Service-role key (não usada atualmente; disponível se precisar bypass RLS) |
| `SUPABASE_DB_URL` | Connection string Postgres (não usada nas funções atuais) |
| `SUPABASE_PUBLISHABLE_KEY` | Idem `SUPABASE_ANON_KEY` |
| `DAILY_API_KEY` | API key do Daily.co |

Ao migrar para Codex/self-hosted, replicar as mesmas variáveis. Nunca commitar `.env` ou service_role. Ao trocar de host, atualizar `redirectTo` do OAuth no dashboard Supabase.

---

## 15. Configurações

### `package.json` (scripts)
```json
"dev": "vite",
"build": "vite build",
"build:dev": "vite build --mode development",
"lint": "eslint .",
"preview": "vite preview"
```

### `vite.config.ts`
- `server.host = "::"`, `server.port = 8080`.
- Plugins: `react()` (SWC), `componentTagger()` só em `mode==='development'` (Lovable — **remover ao migrar**).
- Alias `@` → `./src`.

### `tsconfig.json`
- Referencia `tsconfig.app.json` e `tsconfig.node.json`.
- `baseUrl: "."`, `paths: { "@/*": ["./src/*"] }`.
- `noImplicitAny:false`, `noUnusedParameters:false`, `skipLibCheck:true`, `allowJs:true`, `noUnusedLocals:false`, `strictNullChecks:false` (permissivo — apertar ao refatorar).

### `tsconfig.app.json`
- `target: ES2020`, `moduleResolution: bundler`, `jsx: react-jsx`, `strict: false`.

### `tsconfig.node.json`
- Config específica para `vite.config.ts`.

### `eslint.config.js`
- Flat config: extends `js.configs.recommended` + `typescript-eslint`; `react-hooks/recommended`; `react-refresh/only-export-components` (warn); `@typescript-eslint/no-unused-vars` desativado.

### `tailwind.config.ts`
- `darkMode: ['class']`.
- `content: ['./src/**/*.{ts,tsx}', ...]`.
- Tokens: cores lidas de CSS vars HSL (`hsl(var(--primary))` etc.), plus `success`, `sidebar.*`.
- Fonte: `fontFamily.inter = ['Inter', 'sans-serif']`.
- Border-radius: `lg = var(--radius)`, `md = calc(var(--radius) - 2px)`.
- Keyframes/animations: `accordion-down`, `accordion-up`.
- Plugin: `tailwindcss-animate`.

### `postcss.config.js`
`plugins: { tailwindcss:{}, autoprefixer:{} }`.

### `index.html`
- `<title>MedStudy Buddy</title>` + description + OG tags (a imagem OG aponta para Lovable — trocar).
- Preconnect Google Fonts + `<link>` da Inter.
- `<div id="root">` + `<script type="module" src="/src/main.tsx">`.

### `components.json`
Config shadcn/ui (aliases, style, `tailwind.config`, etc. — não alterar manualmente).

### `src/index.css`
- Tailwind base/components/utilities.
- Tokens `:root` (light) e `.dark`: `--background/--foreground/--card/--popover/--primary/--secondary/--muted/--accent/--success/--warning/--destructive/--border/--input/--ring/--radius/--sidebar-*`.
- Gradients: `--gradient-primary`, `--gradient-success`.
- Sombras: `--shadow-soft/medium/strong`.
- Utilitários: `.animate-in`, `.animate-out`, `.gradient-primary`, `.gradient-success`, `.shadow-soft/.medium/.strong`.
- `body { @apply bg-background text-foreground font-inter antialiased }`.

---

## 16. Deploy

### Ambiente de desenvolvimento
```bash
bun install     # ou npm install
bun run dev     # vite em 0.0.0.0:8080
```

### Build de produção
```bash
bun run build   # gera dist/
```

### Publicação frontend (recomendado no destino Codex)
- **Vercel / Netlify / Cloudflare Pages / GitHub Pages** — servir `dist/`.
- SPA fallback: configurar redirect `/* → /index.html` (Netlify `_redirects`, Vercel `rewrites`).
- Definir env vars `VITE_SUPABASE_*` no dashboard do provider.

### Backend
- **Supabase**: manter projeto. Aplicar migrations via `supabase db push` (Supabase CLI) ou executar SQL consolidado no SQL Editor.
- **Edge Functions**: `supabase functions deploy create-daily-room` e `deploy delete-daily-room`.
- Configurar secrets: `supabase secrets set DAILY_API_KEY=...`.
- Configurar providers OAuth (Google/Facebook) no dashboard, com redirect URL `https://<seu-dominio>/`.

### Frontend vs Backend
- Frontend: rebuild + redeploy.
- Backend (SQL/functions): deploy imediato ao aplicar.

---

## 17. Testes

**Nenhum teste automatizado existe hoje** (nem unitário, integração ou E2E). Recomendações ao migrar:
- Vitest + React Testing Library para componentes.
- Playwright para E2E (login, criar prova, criar plano, entrar sala).
- Testes de policies RLS via `supabase test` (pgTAP).

---

## 18. Melhorias Implementadas Durante o Desenvolvimento

Ordem cronológica (deduzida das migrations e histórico):
1. **v1** — Perfis + auth email/senha; trigger `handle_new_user` (`profiles`).
2. **v1.1** — Correção de `search_path` em funções `SECURITY DEFINER`.
3. **v1.2** — Avatars: bucket + policies + colunas `profile_image_url` e `avatar_thumbnail_url`.
4. **v2** — Sistema social: `username` UNIQUE, `friend_requests`, RLS.
5. **v2.1** — Reforço UNIQUE username + índice.
6. **v3** — Domínio de estudo: `exams`, `study_plans`, `study_tasks`, `chat_messages` (realtime).
7. **v4** — Flashcards + anexos (bucket `flashcard-attachments`).
8. **v5** — Salas de estudo (Daily.co): `study_rooms`, RLS, realtime, Edge Functions `create-daily-room` / `delete-daily-room`.
9. **v5.1** — `room_number` sequencial (sequence 1000), `password`, `is_public`, `study_room_participants`.
10. **v5.2** — Migrations idempotentes (DO blocks) para salas.
11. **v5.3** — Ajustes finais RLS/logs em delete de salas.
12. **UX** — i18n PT/EN/ES; tema claro/escuro; Pomodoro global persistente entre rotas; sons ambientes; calendário mensal; presença online (UI).

---

## 19. Melhorias Futuras (backlog)

- Página `/reset-password` + fluxo `resetPasswordForEmail`.
- Estender `handle_new_user()` para copiar `username` de `raw_user_meta_data`.
- Migrar queries para `TanStack Query` (cache, invalidação).
- Lazy load de rotas (`React.lazy` + `Suspense`).
- Persistir `study_sessions` no Supabase (cross-device) em vez de `localStorage`.
- Presença real com `supabase.channel().track()` (Presence API).
- Hash de senha de sala (bcrypt/argon em Edge Function) + verificação server-side.
- Rate limit em Edge Functions.
- Integração de pagamento (Stripe/Paddle) para Assinatura Premium.
- Notificações push (Web Push).
- IA para gerar planos de estudo automaticamente (Lovable AI Gateway / OpenAI).
- Testes automatizados (Vitest + Playwright).
- Storage: rate/quota por usuário, thumbnails automáticas.
- Roles (`user_roles` + `has_role`) para funcionalidades admin.

---

## 20. Guia de Recriação para o Codex

Este passo-a-passo permite ao Codex recriar o projeto **do zero**, mantendo paridade 1:1 com o atual.

### 20.1. Scaffold
```bash
bun create vite medstudy-buddy --template react-swc-ts
cd medstudy-buddy
bun install
```
Adicionar Tailwind v3 + shadcn:
```bash
bun add -D tailwindcss@^3.4 postcss autoprefixer tailwindcss-animate @tailwindcss/typography
npx tailwindcss init -p
bunx shadcn@latest init
bunx shadcn@latest add accordion alert alert-dialog aspect-ratio avatar badge breadcrumb button calendar card carousel chart checkbox collapsible command context-menu dialog drawer dropdown-menu form hover-card input input-otp label menubar navigation-menu pagination popover progress radio-group resizable scroll-area select separator sheet sidebar skeleton slider sonner switch table tabs textarea toast toggle toggle-group tooltip
```
Instalar demais deps:
```bash
bun add @hookform/resolvers @supabase/supabase-js @tanstack/react-query class-variance-authority clsx cmdk date-fns embla-carousel-react input-otp lucide-react next-themes react-day-picker react-hook-form react-resizable-panels react-router-dom recharts sonner tailwind-merge vaul zod
```

### 20.2. Configuração
- Copiar exatamente: `vite.config.ts` (removendo `componentTagger`), `tailwind.config.ts`, `postcss.config.js`, `tsconfig*.json`, `eslint.config.js`, `index.html`, `src/index.css`, `src/main.tsx`, `src/lib/utils.ts`.
- Criar `.env` local:
  ```
  VITE_SUPABASE_URL=...
  VITE_SUPABASE_PUBLISHABLE_KEY=...
  VITE_SUPABASE_PROJECT_ID=...
  ```

### 20.3. Supabase
1. Criar projeto novo.
2. Habilitar Auth email + provedores Google/Facebook (adicionar client_id/secret nos dashboards).
3. Rodar SQL consolidado (concatenação das 12 migrations em `supabase/migrations/`) via SQL Editor **na ordem**.
4. Verificar buckets `avatars` (público, 5MB, MIME lista) e `flashcard-attachments` (público) — as próprias migrations criam.
5. Deploy das Edge Functions:
   ```bash
   supabase functions deploy create-daily-room
   supabase functions deploy delete-daily-room
   supabase secrets set DAILY_API_KEY=<sua-chave>
   ```
6. Publicação Realtime já incluída nas migrations (`chat_messages`, `study_rooms`).

### 20.4. Frontend
- Copiar TODO o conteúdo de `src/` (respeitando pastas: `pages/`, `components/`, `contexts/`, `hooks/`, `integrations/supabase/`).
- Regenerar `src/integrations/supabase/types.ts` com `supabase gen types typescript --project-id <ref> > src/integrations/supabase/types.ts`.
- Não alterar `src/integrations/supabase/client.ts`.

### 20.5. Design system
- Cores HSL exatas em `src/index.css` (light + dark). Não usar `text-white`/`bg-black` fora de tokens.
- Fonte Inter via Google Fonts (`index.html`).
- Radius `0.75rem`, sombras `--shadow-soft/medium/strong`.

### 20.6. Rotas
Ver `src/App.tsx`. Reproduzir na íntegra — inclui `/auth` público e demais protegidas por `Layout`.

### 20.7. Integrações
- Daily.co: criar conta, gerar API key, salvar como secret.
- OAuth Google/Facebook: URLs de redirect no dashboard Supabase = `https://<domínio>/`.

### 20.8. Deploy
- Frontend: Vercel/Netlify/Cloudflare Pages com build `bun run build` e publish `dist/`.
- Configurar SPA fallback para `index.html`.
- Configurar env vars `VITE_SUPABASE_*` no provider.

### 20.9. Checklist de paridade
- [ ] Login/cadastro/OAuth funcionando.
- [ ] Trigger `handle_new_user` cria row em `profiles`.
- [ ] RLS aplicada em todas as tabelas.
- [ ] i18n PT/EN/ES intercambiável.
- [ ] Tema light/dark persistente.
- [ ] Pomodoro roda entre rotas.
- [ ] Sons ambientes tocam.
- [ ] CRUD provas / planos / tarefas / flashcards / anexos.
- [ ] Amizades: enviar/aceitar/rejeitar via `@username`.
- [ ] Chat 1:1 realtime.
- [ ] Criar/entrar/deletar sala Daily.co com password/isPublic/maxParticipants.
- [ ] Calendário mensal em `/planos`.
- [ ] Progresso com gráficos.
- [ ] Configurações: avatar, senha, idioma, tema.

### 20.10. Comportamentos implícitos importantes
- **Sessão persistida em `localStorage`** — troca de aba mantém login.
- **Pomodoro em `Provider` global** — ao navegar, o timer não para.
- **`isOnline` no header é apenas visual/toggle client** — não reflete presença real ainda.
- **`progress` do plano é atualizado no estado local** ao marcar tarefas — persistência DB depende do fluxo em `Planos.tsx` (recomendar `update study_plans set progress`).
- **`room_number` é atribuído por trigger** (não gere manualmente).
- **Storage paths obrigatoriamente iniciam com `<user_id>/`** para satisfazer policies.
- **Emails de confirmação** dependem do template Supabase Auth padrão; `emailRedirectTo` = `window.location.origin + '/'`.
- **`chat_messages.read`** é atualizado ao abrir o `ChatWindow` — implementar essa lógica no destino.
- **`Layout.tsx`** deve ser o único gatekeeper de rotas privadas — não colocar `useEffect` de sessão em cada página.

---

**Fim do documento.**
Se algo aqui divergir do código atual após futuras mudanças, atualizar este arquivo primeiro (fonte da verdade para a re-implementação no Codex).
