# Banco de Dados - MedStudy Buddy V2

## 1. Principios

O banco deve ser desenhado para varios anos de evolucao. A V2 nao deve copiar o schema antigo: deve preservar aprendizados de negocio e corrigir limitacoes.

Regras obrigatorias:

- PostgreSQL via Supabase.
- UUID como chave primaria.
- `created_at` e `updated_at` em tabelas de dominio.
- Foreign keys explicitas.
- Constraints para enums e invariantes.
- Indices para consultas frequentes.
- RLS em todas as tabelas publicas.
- Policies documentadas junto das migrations.
- Tipos TypeScript gerados a partir do Supabase.
- Nenhuma tabela de videochamada.
- Nenhuma tabela `study_rooms`.
- Nenhuma tabela `study_room_participants`.
- Nenhuma variavel `DAILY_API_KEY`.

## 2. Extensoes recomendadas

- `pgcrypto` para UUIDs.
- `citext` para username case-insensitive, ou indice unico em `lower(username)`.

## 3. Identidade e preferencias

### Fundacao da Fase 3

A Fase 3 cria apenas a fundacao inicial:

- `profiles`;
- `user_preferences`;
- `subscription_plans`;
- `plan_entitlements`;
- `subscriptions`;
- funcoes de bootstrap, trial e verificacao de acesso;
- RLS, policies, grants e testes SQL.

As migrations foram criadas localmente e nao devem ser aplicadas ao remoto sem autorizacao explicita. A revisao detalhada esta em `docs/FASE_3_REVISAO_BANCO.md`.

### profiles

Perfil principal do usuario.

Campos sugeridos:

- `id` uuid PK, FK para `auth.users(id)`;
- `full_name` text;
- `username` citext ou text com indice unico case-insensitive;
- `avatar_url` text;
- `course` text;
- `institution` text;
- `academic_period` text;
- `country` text;
- `onboarding_completed_at` timestamptz;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Regras:

- criado por trigger apos cadastro;
- trigger deve copiar nome, username e idioma inicial quando fornecidos;
- usuario edita apenas seu proprio perfil;
- recursos sociais leem somente campos publicos necessarios.

### user_preferences

Preferencias sincronizadas entre dispositivos.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `language` text;
- `timezone` text;
- `week_starts_on` smallint;
- `date_format` text;
- `theme_mode` text;
- `theme_palette` text;
- `primary_color` text;
- `accent_color` text;
- `default_session_minutes` integer;
- `planning_style` text;
- `notifications_enabled` boolean;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Constraints:

- `language` em `pt-BR`, `es`, `en`;
- `theme_mode` em `light`, `dark`, `system`;
- `planning_style` em `intense`, `balanced`, `buffered`;
- `week_starts_on` entre 0 e 6.

### subscriptions

Estado de trial e assinatura. Nao havera plano gratuito permanente. O produto tera trial gratuito de 3 dias com acesso equivalente ao Pro.

Depois que o trial expirar, a conta e os dados permanecem armazenados. O usuario ainda pode fazer login e acessar configuracoes/assinatura, mas funcionalidades protegidas ficam bloqueadas ate uma assinatura valida.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `plan_code` text;
- `status` text;
- `trial_started_at` timestamptz;
- `trial_ends_at` timestamptz;
- `current_period_started_at` timestamptz;
- `current_period_ends_at` timestamptz;
- `cancel_at_period_end` boolean;
- `canceled_at` timestamptz;
- `provider` text;
- `provider_customer_id` text;
- `provider_subscription_id` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Constraints:

- `plan_code` em `essential`, `pro`, `pro_ai`;
- `status` em `trialing`, `active`, `past_due`, `canceled`, `expired`, `paused`, `incomplete`;
- inicialmente usar apenas `trialing`, `active`, `expired`;
- `pro_ai` previsto, mas inativo.

Observacoes:

- `pro_ai` nao deve ser exibido nem implementado agora;
- nomes comerciais nao devem ser hardcoded;
- nao implementar precos, checkout, cobranca nem webhooks nesta fase;
- relacao usuario-assinatura deve ser segura, auditavel e preparada para webhooks futuros;
- inicio do trial deve ser idempotente;
- trial deve iniciar no primeiro login valido apos confirmacao de email;
- `trial_ends_at` deve ser calculado no backend ou banco, sem confiar apenas no relogio do navegador.

### plan_entitlements

Capacidades disponiveis por plano ou regra.

Campos conceituais:

- `id` uuid PK;
- `plan_code` text;
- `feature_code` text;
- `enabled` boolean;
- `limit_value` jsonb;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Exemplos de `feature_code`:

- `schedule.daily`;
- `schedule.weekly`;
- `schedule.monthly`;
- `schedule.timeline`;
- `schedule.basic_rescheduling`;
- `schedule.advanced_rescheduling`;
- `flashcards.basic`;
- `flashcards.attachments`;
- `analytics.basic`;
- `analytics.advanced`;
- `themes.presets`;
- `themes.custom`;
- `exports.enabled`;
- `ai.schedule_generation`.

Regras:

- paginas e componentes nao devem consultar `plan_code` diretamente;
- autorizacao de funcionalidades deve passar por servico central;
- nao usar condicoes espalhadas como `plan === "pro"`.

## 4. Planejamento

### exams

Provas do usuario.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `title` text;
- `description` text;
- `exam_date` date;
- `exam_time` time;
- `course_name` text;
- `priority` text;
- `perceived_difficulty` text;
- `color` text;
- `status` text;
- `weight` numeric;
- `preparation_starts_on` date;
- `final_review_days` integer;
- `planning_strategy` text;
- `notes` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Status:

- `draft`;
- `active`;
- `completed`;
- `cancelled`;
- `archived`.

### subjects

Catalogo de materias do usuario.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `name` text;
- `description` text;
- `color` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### exam_subjects

Relacao entre provas e materias.

Campos sugeridos:

- `id` uuid PK;
- `exam_id` uuid FK;
- `subject_id` uuid FK;
- `position` integer;
- `created_at` timestamptz.

Constraint:

- unico por `exam_id`, `subject_id`.

### study_topics

Conteudos estudaveis.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `exam_id` uuid FK;
- `subject_id` uuid FK;
- `title` text;
- `description` text;
- `difficulty` text;
- `priority` text;
- `estimated_minutes` integer;
- `position` integer;
- `suggested_activity_type` text;
- `desired_review_count` integer;
- `mastery_status` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Pre-requisitos:

- usar tabela relacional `study_topic_prerequisites` desde a primeira migration relacionada a conteudos;
- nao usar arrays para armazenar pre-requisitos;
- ciclos nao devem ser permitidos;
- validacao de ciclos deve existir na camada de dominio e possuir testes automatizados.

### study_topic_prerequisites

Pre-requisitos entre conteudos.

Campos obrigatorios:

- `id` uuid PK;
- `topic_id` uuid FK para `study_topics(id)`;
- `prerequisite_topic_id` uuid FK para `study_topics(id)`;
- `created_at` timestamptz.

Regras:

- `topic_id` nao pode ser igual a `prerequisite_topic_id`;
- relacionamento deve ser unico por `topic_id`, `prerequisite_topic_id`;
- ambos os conteudos devem pertencer ao mesmo usuario;
- ciclos de dependencia nao devem ser permitidos;
- exclusoes devem respeitar integridade referencial;
- validacao de ciclos fica na camada de dominio e deve ter testes;
- regras simples devem ser reforcadas por constraints sempre que possivel;
- RLS deve garantir acesso apenas aos relacionamentos dos conteudos do usuario.

### availability_rules

Disponibilidade semanal padrao.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `weekday` smallint;
- `start_time` time;
- `end_time` time;
- `min_session_minutes` integer;
- `max_session_minutes` integer;
- `max_daily_minutes` integer;
- `preferred_period` text;
- `is_available` boolean;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### availability_exceptions

Bloqueios e excecoes por data.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `date` date;
- `start_time` time;
- `end_time` time;
- `type` text;
- `reason` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Tipos:

- `blocked`;
- `extra_available`;
- `reduced_available`.

### study_plans

Plano calculado para uma prova.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `exam_id` uuid FK;
- `starts_on` date;
- `ends_on` date;
- `strategy` text;
- `total_estimated_minutes` integer;
- `available_minutes` integer;
- `capacity_usage_percent` numeric;
- `safety_margin_minutes` integer;
- `progress_percent` numeric;
- `schedule_state` text;
- `algorithm_version` text;
- `last_rescheduled_at` timestamptz;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Estados:

- `draft`;
- `active`;
- `overloaded`;
- `completed`;
- `archived`.

### study_tasks

Tarefas e sessoes planejadas.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `plan_id` uuid FK;
- `exam_id` uuid FK;
- `subject_id` uuid FK;
- `topic_id` uuid FK;
- `title` text;
- `description` text;
- `scheduled_date` date;
- `scheduled_start_time` time;
- `estimated_minutes` integer;
- `actual_minutes` integer;
- `priority` text;
- `difficulty` text;
- `activity_type` text;
- `status` text;
- `position` integer;
- `notes` text;
- `source` text;
- `is_locked` boolean;
- `original_scheduled_date` date;
- `reschedule_count` integer;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Status:

- `planned`;
- `in_progress`;
- `partially_completed`;
- `completed`;
- `postponed`;
- `late`;
- `cancelled`.

Tipos de atividade:

- `theory`;
- `reading`;
- `class`;
- `summary`;
- `review`;
- `flashcards`;
- `exercises`;
- `mock_exam`;
- `custom`.

### task_reschedules

Historico de replanejamentos.

Campos sugeridos:

- `id` uuid PK;
- `task_id` uuid FK;
- `user_id` uuid FK;
- `previous_date` date;
- `new_date` date;
- `previous_estimated_minutes` integer;
- `new_estimated_minutes` integer;
- `reason` text;
- `strategy` text;
- `performed_by` text;
- `created_at` timestamptz.

### study_sessions

Registro real de estudo e Pomodoro.

Campos sugeridos:

- `id` uuid PK;
- `user_id` uuid FK;
- `task_id` uuid FK nullable;
- `exam_id` uuid FK nullable;
- `started_at` timestamptz;
- `ended_at` timestamptz;
- `duration_seconds` integer;
- `session_type` text;
- `source` text;
- `completed` boolean;
- `notes` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

Regras:

- sessoes devem ser persistidas no banco;
- sessoes devem sincronizar entre dispositivos;
- `task_id` e opcional para permitir sessoes livres;
- `exam_id` e opcional para permitir foco geral;
- `localStorage` pode ser usado apenas como contingencia temporaria para sessao ativa e preferencias nao criticas.
- duracao final nao deve depender apenas de valor enviado pelo cliente;
- validar duracao negativa;
- validar `ended_at` anterior a `started_at`;
- impedir sessoes absurdamente longas;
- mitigar manipulacao simples de estatisticas;
- planejar regra para sessoes simultaneas conflitantes do mesmo usuario, caso essa restricao seja adotada.

## 5. Flashcards

### flashcard_decks

- `id` uuid PK;
- `user_id` uuid FK;
- `exam_id` uuid FK nullable;
- `subject_id` uuid FK nullable;
- `title` text;
- `description` text;
- `color` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### flashcards

- `id` uuid PK;
- `user_id` uuid FK;
- `deck_id` uuid FK;
- `exam_id` uuid FK nullable;
- `topic_id` uuid FK nullable;
- `front` text;
- `back` text;
- `difficulty` text;
- `next_review_on` date;
- `review_count` integer;
- `ease_factor` numeric;
- `interval_days` integer;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### flashcard_reviews

- `id` uuid PK;
- `user_id` uuid FK;
- `flashcard_id` uuid FK;
- `reviewed_at` timestamptz;
- `rating` text;
- `previous_interval_days` integer;
- `next_interval_days` integer;
- `next_review_on` date.

### flashcard_attachments

- `id` uuid PK;
- `user_id` uuid FK;
- `flashcard_id` uuid FK;
- `file_path` text;
- `file_name` text;
- `file_type` text;
- `file_size` integer;
- `created_at` timestamptz.

## 6. Social

### friend_requests

- `id` uuid PK;
- `sender_id` uuid FK;
- `receiver_id` uuid FK;
- `status` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### chat_messages

- `id` uuid PK;
- `sender_id` uuid FK;
- `receiver_id` uuid FK;
- `message` text;
- `read_at` timestamptz;
- `created_at` timestamptz.

### user_presence_preferences

- `id` uuid PK;
- `user_id` uuid FK;
- `show_online_status` boolean;
- `share_study_streak` boolean;
- `share_weekly_hours` boolean;
- `created_at` timestamptz;
- `updated_at` timestamptz.

## 7. Sistema

### notifications

- `id` uuid PK;
- `user_id` uuid FK;
- `type` text;
- `title` text;
- `body` text;
- `read_at` timestamptz;
- `metadata` jsonb;
- `created_at` timestamptz.

### feature_flags

- `id` uuid PK;
- `key` text unique;
- `description` text;
- `enabled` boolean;
- `audience` text;
- `created_at` timestamptz;
- `updated_at` timestamptz.

### audit_events

- `id` uuid PK;
- `user_id` uuid FK nullable;
- `event_type` text;
- `entity_type` text;
- `entity_id` uuid nullable;
- `metadata` jsonb;
- `created_at` timestamptz.

Nao armazenar segredos em auditoria.

## 8. Storage

Buckets previstos:

- `avatars`;
- `flashcard-attachments`.

Regras:

- paths devem iniciar com `user_id`;
- MIME e tamanho maximo devem ser limitados;
- anexos devem respeitar limites de plano no futuro;
- nunca armazenar tokens ou segredos.

## 9. Indices prioritarios

- `profiles lower(username)` ou `username citext unique`;
- `exams(user_id, status, exam_date)`;
- `subjects(user_id, name)`;
- `study_topics(user_id, exam_id, subject_id)`;
- `study_topic_prerequisites(topic_id, prerequisite_topic_id)` unico;
- `study_topic_prerequisites(topic_id)`;
- `study_topic_prerequisites(prerequisite_topic_id)`;
- `availability_rules(user_id, weekday)`;
- `availability_exceptions(user_id, date)`;
- `study_plans(user_id, exam_id, schedule_state)`;
- `study_tasks(user_id, scheduled_date, status)`;
- `study_tasks(plan_id, scheduled_date, position)`;
- `task_reschedules(task_id, created_at)`;
- `study_sessions(user_id, started_at)`;
- `flashcards(user_id, next_review_on)`;
- `chat_messages(sender_id, receiver_id, created_at)`;
- `notifications(user_id, read_at, created_at)`.

## 10. RLS

Politica geral:

- dados pessoais: usuario acessa apenas seus registros;
- dados de estudo: `user_id = auth.uid()`;
- dados sociais: acesso limitado a remetente, destinatario ou campos publicos;
- storage: paths iniciados por `auth.uid()`;
- sistema: leitura/escrita restrita por necessidade.

Toda migration deve incluir ou acompanhar as policies necessarias antes de ser considerada pronta.

## 11. Feature entitlements, trial e acesso

O banco deve permitir evoluir funcionalidades por plano sem refatoracao estrutural.

Planos internos previstos:

- `essential`;
- `pro`;
- `pro_ai` futuro e inativo.

Nao havera plano gratuito permanente. Havera trial de 3 dias, iniciado no primeiro login valido apos confirmacao de email, com acesso equivalente ao Pro.

Estados de assinatura previstos:

- `trialing`;
- `active`;
- `past_due`;
- `canceled`;
- `expired`;
- `paused`;
- `incomplete`.

Inicialmente:

- `trialing`;
- `active`;
- `expired`.

Essential:

- criacao e gestao de provas;
- cronograma adaptativo;
- visualizacao diaria;
- visualizacao semanal;
- replanejamento basico;
- Pomodoro;
- flashcards basicos;
- estatisticas basicas;
- temas predefinidos;
- PT, ES e EN.

Pro:

- tudo do Essential;
- visualizacao mensal;
- trilha completa ate a prova;
- replanejamento avancado;
- estatisticas detalhadas;
- temas e paletas personalizadas;
- anexos em flashcards;
- historico completo;
- exportacoes;
- funcionalidades avancadas futuras.

Pro AI:

- tudo do Pro;
- funcionalidades de IA futuras;
- nao implementar nem exibir agora.

Essas capacidades nao devem ser codificadas diretamente no frontend ou em regras espalhadas. Quando implementadas, devem ficar em configuracao central, feature entitlements ou estrutura equivalente.

## 12. Seguranca de assinatura

- trial nao pode ser reiniciado por novo login;
- trial nao deve depender do relogio do navegador;
- usuario expirado ainda pode acessar login, configuracoes e assinatura;
- dados nao devem ser apagados automaticamente ao expirar trial;
- funcionalidades protegidas devem consultar camada central de entitlements;
- webhooks futuros devem ser auditaveis e idempotentes;
- provider ids nao devem ser tratados como autoridade unica sem validar assinatura associada ao usuario.
