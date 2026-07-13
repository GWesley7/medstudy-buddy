# Modelo de Dados - MedStudy Buddy V2

## Diretrizes

- PostgreSQL via Supabase.
- UUID como chave primaria.
- `created_at` e `updated_at` em tabelas de dominio.
- Foreign keys explicitas.
- Indices para consultas frequentes.
- Constraints para enums e invariantes importantes.
- RLS em todas as tabelas publicas.
- Policies documentadas em migrations.
- Tipos TypeScript gerados a partir do Supabase.
- Nenhuma tabela de videochamada.
- Nenhuma tabela `study_rooms` ou `study_room_participants`.

## Extensoes recomendadas

- `pgcrypto` para UUIDs.
- `citext` para username case-insensitive, ou indice unico em `lower(username)`.

## Identidade e preferencias

### profiles

Perfil principal do usuario.

Campos principais:

- `id` uuid PK, FK para `auth.users(id)`.
- `full_name` text.
- `username` citext ou text com indice unico case-insensitive.
- `avatar_url` text.
- `course` text.
- `institution` text.
- `academic_period` text.
- `country` text.
- `onboarding_completed_at` timestamptz.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Regras:

- Criado por trigger apos cadastro.
- Username normalizado.
- Usuario pode ler e atualizar o proprio perfil.
- Outros usuarios podem ler somente campos publicos necessarios para recursos sociais.

### user_preferences

Preferencias sincronizadas entre dispositivos.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `language` text.
- `timezone` text.
- `week_starts_on` smallint.
- `date_format` text.
- `theme_mode` text.
- `theme_palette` text.
- `primary_color` text.
- `accent_color` text.
- `default_session_minutes` integer.
- `planning_style` text.
- `notifications_enabled` boolean.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `language` em `pt-BR`, `es`, `en`.
- `theme_mode` em `light`, `dark`, `system`.
- `planning_style` em `intense`, `balanced`, `buffered`.
- `week_starts_on` entre 0 e 6.

### user_subscriptions

Estado de plano e limites.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `plan` text.
- `status` text.
- `current_period_start` timestamptz.
- `current_period_end` timestamptz.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `plan` em `free`, `pro`, `pro_ai`.
- `pro_ai` previsto, mas inativo.

## Planejamento

### exams

Provas do usuario.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `title` text.
- `description` text.
- `exam_date` date.
- `exam_time` time.
- `course_name` text.
- `priority` text.
- `perceived_difficulty` text.
- `color` text.
- `status` text.
- `weight` numeric.
- `preparation_starts_on` date.
- `final_review_days` integer.
- `planning_strategy` text.
- `notes` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `status` em `draft`, `active`, `completed`, `cancelled`, `archived`.
- `planning_strategy` em `intense`, `balanced`, `buffered`.

### subjects

Catalogo de materias do usuario.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `name` text.
- `description` text.
- `color` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

### exam_subjects

Relacao entre provas e materias.

Campos principais:

- `id` uuid PK.
- `exam_id` uuid FK.
- `subject_id` uuid FK.
- `position` integer.
- `created_at` timestamptz.

Constraint:

- unico por `exam_id`, `subject_id`.

### study_topics

Conteudos estudaveis.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `exam_id` uuid FK.
- `subject_id` uuid FK.
- `title` text.
- `description` text.
- `difficulty` text.
- `priority` text.
- `estimated_minutes` integer.
- `position` integer.
- `prerequisite_topic_ids` uuid[] ou tabela relacional futura.
- `suggested_activity_type` text.
- `desired_review_count` integer.
- `mastery_status` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Observacao:

Para consultas complexas de pre-requisitos, uma tabela `study_topic_prerequisites` pode substituir o array antes da implementacao final.

### availability_rules

Disponibilidade semanal padrao.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `weekday` smallint.
- `start_time` time.
- `end_time` time.
- `min_session_minutes` integer.
- `max_session_minutes` integer.
- `max_daily_minutes` integer.
- `preferred_period` text.
- `is_available` boolean.
- `created_at` timestamptz.
- `updated_at` timestamptz.

### availability_exceptions

Bloqueios e excecoes por data.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `date` date.
- `start_time` time.
- `end_time` time.
- `type` text.
- `reason` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `type` em `blocked`, `extra_available`, `reduced_available`.

### study_plans

Plano calculado para uma prova.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `exam_id` uuid FK.
- `starts_on` date.
- `ends_on` date.
- `strategy` text.
- `total_estimated_minutes` integer.
- `available_minutes` integer.
- `capacity_usage_percent` numeric.
- `safety_margin_minutes` integer.
- `progress_percent` numeric.
- `schedule_state` text.
- `algorithm_version` text.
- `last_rescheduled_at` timestamptz.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `schedule_state` em `draft`, `active`, `overloaded`, `completed`, `archived`.

### study_tasks

Tarefas e sessoes planejadas.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `plan_id` uuid FK.
- `exam_id` uuid FK.
- `subject_id` uuid FK.
- `topic_id` uuid FK.
- `title` text.
- `description` text.
- `scheduled_date` date.
- `scheduled_start_time` time.
- `estimated_minutes` integer.
- `actual_minutes` integer.
- `priority` text.
- `difficulty` text.
- `activity_type` text.
- `status` text.
- `position` integer.
- `dependency_task_ids` uuid[] ou tabela relacional futura.
- `notes` text.
- `source` text.
- `is_locked` boolean.
- `original_scheduled_date` date.
- `reschedule_count` integer.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `status` em `planned`, `in_progress`, `partially_completed`, `completed`, `postponed`, `late`, `cancelled`.
- `source` em `automatic`, `manual`.
- `activity_type` em `theory`, `reading`, `class`, `summary`, `review`, `flashcards`, `exercises`, `mock_exam`, `custom`.

### task_reschedules

Historico de replanejamentos.

Campos principais:

- `id` uuid PK.
- `task_id` uuid FK.
- `user_id` uuid FK.
- `previous_date` date.
- `new_date` date.
- `previous_estimated_minutes` integer.
- `new_estimated_minutes` integer.
- `reason` text.
- `strategy` text.
- `performed_by` text.
- `created_at` timestamptz.

Constraints:

- `performed_by` em `user`, `system`.

### study_sessions

Registro real de estudo e Pomodoro.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `task_id` uuid FK nullable.
- `exam_id` uuid FK nullable.
- `started_at` timestamptz.
- `ended_at` timestamptz.
- `duration_minutes` integer.
- `timer_type` text.
- `status` text.
- `notes` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `timer_type` em `focus`, `short_break`, `long_break`, `manual`.
- `status` em `completed`, `interrupted`, `discarded`.

## Flashcards

### flashcard_decks

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `exam_id` uuid FK nullable.
- `subject_id` uuid FK nullable.
- `title` text.
- `description` text.
- `color` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

### flashcards

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `deck_id` uuid FK.
- `exam_id` uuid FK nullable.
- `topic_id` uuid FK nullable.
- `front` text.
- `back` text.
- `difficulty` text.
- `next_review_on` date.
- `review_count` integer.
- `ease_factor` numeric.
- `interval_days` integer.
- `created_at` timestamptz.
- `updated_at` timestamptz.

### flashcard_reviews

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `flashcard_id` uuid FK.
- `reviewed_at` timestamptz.
- `rating` text.
- `previous_interval_days` integer.
- `next_interval_days` integer.
- `next_review_on` date.

### flashcard_attachments

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `flashcard_id` uuid FK.
- `file_path` text.
- `file_name` text.
- `file_type` text.
- `file_size` integer.
- `created_at` timestamptz.

## Social

### friend_requests

Campos principais:

- `id` uuid PK.
- `sender_id` uuid FK.
- `receiver_id` uuid FK.
- `status` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Constraints:

- `status` em `pending`, `accepted`, `rejected`.
- unico por `sender_id`, `receiver_id`.

### chat_messages

Campos principais:

- `id` uuid PK.
- `sender_id` uuid FK.
- `receiver_id` uuid FK.
- `message` text.
- `read_at` timestamptz.
- `created_at` timestamptz.

### user_presence_preferences

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `show_online_status` boolean.
- `share_study_streak` boolean.
- `share_weekly_hours` boolean.
- `created_at` timestamptz.
- `updated_at` timestamptz.

## Sistema

### notifications

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK.
- `type` text.
- `title` text.
- `body` text.
- `read_at` timestamptz.
- `metadata` jsonb.
- `created_at` timestamptz.

### feature_flags

Campos principais:

- `id` uuid PK.
- `key` text unique.
- `description` text.
- `enabled` boolean.
- `audience` text.
- `created_at` timestamptz.
- `updated_at` timestamptz.

Uso inicial:

- preparar flags para recursos pagos e futuros;
- manter IA inativa.

### audit_events

Auditoria para acoes relevantes, sem armazenar segredos.

Campos principais:

- `id` uuid PK.
- `user_id` uuid FK nullable.
- `event_type` text.
- `entity_type` text.
- `entity_id` uuid nullable.
- `metadata` jsonb.
- `created_at` timestamptz.

## Buckets de Storage

### avatars

- Path deve iniciar com `user_id`.
- Limites de MIME para imagens.
- Limite de tamanho definido em migration/configuracao.

### flashcard-attachments

- Path deve iniciar com `user_id`.
- MIME permitido deve ser restrito.
- Tamanho maximo deve respeitar o plano do usuario no futuro.

## Indices prioritarios

- `profiles lower(username)` ou `username citext unique`.
- `exams(user_id, status, exam_date)`.
- `subjects(user_id, name)`.
- `study_topics(user_id, exam_id, subject_id)`.
- `availability_rules(user_id, weekday)`.
- `availability_exceptions(user_id, date)`.
- `study_plans(user_id, exam_id, schedule_state)`.
- `study_tasks(user_id, scheduled_date, status)`.
- `study_tasks(plan_id, scheduled_date, position)`.
- `task_reschedules(task_id, created_at)`.
- `study_sessions(user_id, started_at)`.
- `flashcards(user_id, next_review_on)`.
- `chat_messages(sender_id, receiver_id, created_at)`.
- `notifications(user_id, read_at, created_at)`.

## RLS - politica geral

- Dados pessoais: usuario acessa apenas seus proprios registros.
- Dados de estudo: usuario acessa apenas registros com `user_id = auth.uid()`.
- Dados sociais: acesso limitado a remetente, destinatario ou perfil publico necessario.
- Storage: paths obrigatoriamente iniciados por `auth.uid()`.
- Tabelas de sistema: leitura/escrita restrita conforme necessidade da feature.

As policies finais devem ser criadas e testadas nas migrations da fase correspondente.
