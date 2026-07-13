# MedStudy Buddy V2 — Especificação Técnica e Prompt Mestre para o Codex

> Documento-base para reconstrução independente do MedStudy Buddy, utilizando o projeto anterior apenas como referência funcional e visual. Esta versão NÃO deve ser uma cópia literal do projeto do Lovable. Ela deve corrigir limitações da versão anterior e reorganizar o produto em torno do planejamento acadêmico adaptativo.

---

# 1. Missão do produto

O MedStudy Buddy é um SaaS de organização acadêmica criado para funcionar como um parceiro de estudos. Seu objetivo principal é ajudar estudantes a transformar provas, conteúdos e disponibilidade pessoal em um cronograma claro, flexível e adaptável à rotina real.

A aplicação deve responder rapidamente às seguintes perguntas:

- O que devo estudar hoje?
- Quanto tempo isso levará?
- Qual é a minha prioridade?
- Estou no ritmo certo para a prova?
- O que ficou pendente?
- Como posso reorganizar o meu plano após um imprevisto?

O sistema não deve ser apenas um calendário ou uma lista de tarefas. Ele deve representar toda a trilha de preparação do usuário até cada prova.

---

# 2. Decisões definitivas desta versão

## 2.1. Funcionalidades removidas

Remover completamente:

- Daily.co.
- Videochamadas.
- Chamadas de áudio.
- WebRTC.
- Salas baseadas em vídeo ou áudio.
- Edge Functions `create-daily-room` e `delete-daily-room`.
- Tabelas antigas `study_rooms` e `study_room_participants`.
- Campos `daily_room_name`, `daily_room_url`, `room_type`, `password` e outros relacionados às chamadas.
- Variável `DAILY_API_KEY`.
- Componentes `StudyRooms` e `RoomSettingsDialog` da implementação anterior.

Não manter código morto ou dependências relacionadas a essa integração.

## 2.2. Inteligência artificial

Não implementar recursos de IA nesta versão.

A arquitetura poderá prever futuramente um plano `pro_ai`, mas não deve:

- chamar OpenAI ou outro LLM;
- exibir funcionalidades de IA ativas;
- gerar cronogramas por IA;
- gerar resumos, questões ou flashcards por IA;
- exigir chave de API de IA.

O planejamento inicial e o replanejamento devem funcionar por algoritmos determinísticos e regras transparentes.

## 2.3. Prioridade máxima

O núcleo do produto será:

1. provas;
2. conteúdos;
3. disponibilidade do usuário;
4. cronogramas adaptativos;
5. replanejamento após imprevistos;
6. acompanhamento da trilha até a prova.

---

# 3. Público-alvo

Prioritariamente:

- estudantes de medicina;
- estudantes universitários com alto volume de conteúdo;
- candidatos a residência, concursos e provas de título;
- usuários que estudam para várias provas simultaneamente;
- pessoas que precisam adaptar os estudos a uma rotina variável.

A modelagem não deve limitar o produto exclusivamente à medicina. O texto, onboarding e categorias podem priorizar estudantes de medicina, mas a estrutura deve aceitar qualquer curso.

---

# 4. Proposta de valor

> Planeje a preparação para suas provas, adapte o cronograma quando a rotina mudar e saiba todos os dias exatamente o que precisa estudar.

Diferenciais:

- cronograma criado a partir da disponibilidade real;
- replanejamento simples após imprevistos;
- visualizações diária, semanal, mensal e trilha até a prova;
- registro de tempo planejado e realizado;
- sessões parcialmente concluídas;
- personalização de tema e identidade visual;
- interface em português, espanhol e inglês;
- integração entre cronograma, Pomodoro, flashcards e progresso;
- experiência simples apesar da profundidade funcional.

---

# 5. Stack tecnológica

Manter uma stack próxima à versão anterior, removendo dependências do Lovable.

## Frontend

- React 18 ou versão estável compatível com o projeto.
- TypeScript com modo estrito.
- Vite.
- React Router.
- Tailwind CSS.
- shadcn/ui e Radix UI.
- TanStack Query para todo estado remoto.
- React Hook Form.
- Zod.
- date-fns.
- Recharts.
- Lucide React.
- next-themes ou solução equivalente para tema.
- Biblioteca de drag-and-drop acessível, preferencialmente `@dnd-kit`.

## Backend e dados

- Supabase.
- PostgreSQL.
- Supabase Auth.
- Supabase Storage.
- Supabase Realtime apenas onde houver valor real, como chat e presença.
- SQL versionado em migrations.
- Row-Level Security em todas as tabelas públicas.

## Testes

- Vitest.
- React Testing Library.
- Playwright.
- pgTAP ou testes SQL para RLS.

## Deploy

- Frontend: Vercel, Netlify ou Cloudflare Pages.
- Backend: Supabase.
- Repositório: GitHub.

---

# 6. Princípios técnicos

- TypeScript estrito.
- Sem `any` não justificado.
- Componentes pequenos e reutilizáveis.
- Regras de negócio fora dos componentes visuais.
- Queries centralizadas em hooks ou services.
- TanStack Query como padrão para cache, invalidação e loading.
- Validação com Zod no frontend e também em funções server-side.
- RLS como camada obrigatória de autorização.
- Migrations pequenas, versionadas e reversíveis quando possível.
- Nenhuma chave secreta no frontend.
- Nenhuma dependência do Lovable.
- Nenhum código relacionado ao Daily.co.
- Acessibilidade por padrão.
- Layout responsivo e mobile-first.

---

# 7. Perfis e personalização

Cada usuário deve possuir um perfil persistido no banco.

## Dados pessoais

- nome completo;
- username único;
- avatar;
- curso;
- instituição;
- semestre/período;
- país;
- fuso horário;
- idioma preferido;
- formato de data;
- primeiro dia da semana;
- duração padrão de sessão;
- preferência de notificações.

## Aparência

Oferecer:

- modo claro;
- modo escuro;
- modo automático, seguindo o sistema;
- paletas predefinidas;
- cor primária personalizada;
- cor de destaque personalizada;
- opção para restaurar o tema padrão.

Paletas iniciais sugeridas:

- MedStudy padrão;
- Azul clínico;
- Verde foco;
- Roxo noturno;
- Laranja energia;
- Neutro minimalista.

A personalização deve ser validada para manter contraste mínimo e legibilidade. O sistema não deve permitir combinações que tornem textos ou botões ilegíveis.

As preferências devem ser persistidas no banco para sincronização entre dispositivos. Pode existir cache local para evitar flash de tema durante a inicialização.

---

# 8. Internacionalização

Idiomas obrigatórios:

- Português do Brasil (`pt-BR`).
- Espanhol (`es`).
- Inglês (`en`).

Todos os textos da interface devem utilizar chaves de tradução. Não escrever rótulos fixos diretamente nos componentes.

Estrutura sugerida:

```text
src/i18n/
  index.ts
  locales/
    pt-BR.json
    es.json
    en.json
```

Traduzir:

- navegação;
- onboarding;
- formulários;
- mensagens de erro;
- validações;
- toasts;
- estados vazios;
- status de tarefas;
- tipos de atividade;
- notificações;
- datas, meses e dias da semana;
- assinatura;
- configurações;
- termos essenciais.

O idioma deve ser selecionado no onboarding e alterável nas configurações. Persistir no perfil.

---

# 9. Onboarding

O onboarding deve conduzir o usuário até um primeiro cronograma útil.

Etapas:

1. Selecionar idioma.
2. Informar nome, curso e instituição, todos editáveis depois.
3. Escolher tema e paleta.
4. Informar a próxima prova.
5. Adicionar matérias ou conteúdos.
6. Informar disponibilidade semanal.
7. Informar dias indisponíveis ou restrições.
8. Escolher o estilo de planejamento: intenso, equilibrado ou com folga.
9. Definir quantidade de dias finais reservados para revisão, questões ou simulados.
10. Revisar e confirmar o cronograma gerado.

O usuário deve poder pular campos não essenciais e concluir o onboarding rapidamente.

---

# 10. Domínio principal

## 10.1. Provas

Uma prova deve possuir:

- título;
- descrição;
- data e horário opcionais;
- curso ou disciplina;
- prioridade;
- dificuldade percebida;
- cor;
- status;
- peso opcional;
- data inicial de preparação;
- quantidade de dias finais reservados para revisão;
- estratégia de planejamento;
- observações.

Status sugeridos:

- rascunho;
- ativa;
- concluída;
- cancelada;
- arquivada.

## 10.2. Matérias e conteúdos

A prova pode possuir várias matérias e conteúdos.

Exemplo:

```text
Prova: Farmacologia
  Matéria: Farmacodinâmica
    Conteúdo: Agonismo e antagonismo
    Conteúdo: Curva dose-resposta
  Matéria: Farmacocinética
    Conteúdo: Eliminação de ordem zero e um
```

Cada conteúdo deve aceitar:

- título;
- descrição;
- matéria;
- dificuldade;
- prioridade;
- duração estimada;
- ordem;
- pré-requisitos;
- tipo de atividade sugerido;
- número de revisões desejadas;
- status de domínio.

## 10.3. Disponibilidade

O usuário deve poder configurar:

- disponibilidade padrão por dia da semana;
- vários blocos por dia;
- duração mínima e máxima de sessão;
- dias bloqueados;
- exceções de datas específicas;
- períodos de viagem, trabalho ou aula;
- preferência por manhã, tarde ou noite;
- limite máximo de carga diária;
- intervalo mínimo entre sessões.

Exemplo:

```text
Segunda: 09:00–11:00 e 19:00–21:00
Terça: indisponível
Quarta: 14:00–18:00
Sábado: até 3 horas, horário flexível
```

## 10.4. Plano de estudo

O plano deve estar vinculado a uma prova e armazenar:

- período;
- estratégia;
- carga total estimada;
- carga disponível;
- percentual de capacidade utilizado;
- margem de segurança;
- progresso;
- estado do cronograma;
- versão do algoritmo usado;
- data do último replanejamento.

Estratégias:

- intenso: até 95% da capacidade disponível;
- equilibrado: até 80%;
- com folga: até 65%.

Esses percentuais devem ser configuráveis no código, não espalhados pela interface.

## 10.5. Sessões e tarefas

Cada tarefa de estudo deve possuir:

- plano;
- prova;
- matéria;
- conteúdo;
- título;
- descrição;
- data;
- horário opcional;
- duração estimada;
- duração realizada;
- prioridade;
- dificuldade;
- tipo de atividade;
- status;
- ordem do dia;
- dependências;
- observações;
- origem: automática ou manual;
- flag de bloqueio manual;
- data original antes de replanejamentos;
- número de replanejamentos.

Tipos de atividade:

- teoria;
- leitura;
- aula;
- resumo;
- revisão;
- flashcards;
- exercícios;
- simulado;
- atividade personalizada.

Status:

- planejada;
- em andamento;
- parcialmente concluída;
- concluída;
- adiada;
- atrasada;
- cancelada.

---

# 11. Geração determinística do cronograma

Não usar IA.

O algoritmo deve:

1. calcular todos os dias disponíveis entre o início do plano e a prova;
2. reservar os dias finais definidos para revisão, questões e simulados;
3. calcular a capacidade por dia a partir da disponibilidade;
4. aplicar o percentual da estratégia escolhida;
5. calcular o peso de cada conteúdo usando dificuldade, prioridade e duração;
6. respeitar pré-requisitos;
7. dividir conteúdos longos em sessões menores;
8. evitar exceder a carga diária máxima;
9. inserir revisões em intervalos configuráveis;
10. preservar margem para imprevistos;
11. avisar quando a carga necessária ultrapassar a capacidade disponível.

Uma fórmula inicial possível:

```text
peso = duração_estimada
     × fator_dificuldade
     × fator_prioridade
     × fator_proximidade_da_prova
```

Os fatores devem estar centralizados em um módulo configurável e cobertos por testes.

Quando não houver capacidade suficiente, o sistema deve explicar o problema e oferecer opções:

- aumentar disponibilidade;
- reduzir conteúdos;
- reduzir número de revisões;
- usar estratégia mais intensa;
- começar antes;
- manter o plano com alerta de sobrecarga.

---

# 12. Replanejamento adaptativo

Esta é uma funcionalidade central.

Ao ocorrer uma mudança, o sistema deve recalcular apenas o necessário e preservar escolhas manuais.

Gatilhos:

- sessão não concluída;
- sessão parcialmente concluída;
- usuário bloqueou um dia;
- disponibilidade semanal mudou;
- prova foi antecipada ou adiada;
- novo conteúdo foi adicionado;
- conteúdo foi removido;
- usuário adiantou uma tarefa;
- usuário solicitou reorganização manual.

Opções oferecidas:

- mover para o próximo dia disponível;
- distribuir pelos próximos dias;
- dividir em sessões menores;
- usar um bloco de margem;
- ajustar apenas o dia;
- ajustar apenas a semana;
- recalcular até a prova;
- manter pendente sem alterar o plano;
- decidir manualmente.

Regras importantes:

- tarefas com `is_locked = true` não podem ser movidas automaticamente;
- tarefas já concluídas nunca devem ser alteradas;
- alterações devem gerar histórico;
- o usuário deve visualizar uma prévia antes de confirmar grandes mudanças;
- o sistema deve mostrar quais tarefas serão movidas;
- o replanejamento deve ser transacional;
- o algoritmo deve evitar criar dias sobrecarregados;
- a margem de segurança deve ser consumida antes de sobrecarregar dias futuros, quando aplicável.

---

# 13. Visualizações do cronograma

## Hoje

Mostrar:

- sessões do dia;
- duração total;
- prioridade;
- tarefa atual;
- atrasos;
- progresso diário;
- botão começar sessão;
- botão reorganizar o dia.

## Semana

Mostrar:

- carga planejada e realizada;
- distribuição por dia;
- tarefas atrasadas;
- dias sobrecarregados;
- capacidade livre;
- drag-and-drop entre dias.

## Mês

Mostrar:

- provas;
- sessões;
- revisões;
- simulados;
- carga diária;
- eventos indisponíveis;
- indicadores de sobrecarga.

## Trilha até a prova

Mostrar fases:

```text
Conteúdo inicial → consolidação → revisões → exercícios → simulados → revisão final → prova
```

Exibir:

- posição atual;
- percentual concluído;
- ritmo esperado versus real;
- dias restantes;
- carga restante;
- risco de atraso;
- próximas etapas.

---

# 14. Dashboard

A página inicial deve ser extremamente simples.

Blocos principais:

- saudação;
- plano de hoje;
- próxima prova;
- progresso da trilha;
- tarefas atrasadas;
- tempo estudado hoje e na semana;
- atalho para começar sessão;
- atalho para reorganizar o dia;
- alertas relevantes.

Exemplo de conteúdo:

```text
Bom dia, Gabriel

Hoje
3 sessões · 2h30 planejadas

Próxima prova
Farmacologia · faltam 7 dias

Progresso do plano
68%

[Começar sessão] [Reorganizar dia] [Ver cronograma]
```

Evitar excesso de gráficos na tela inicial.

---

# 15. Pomodoro e registro de estudo

Manter Pomodoro global, porém integrá-lo às tarefas.

Requisitos:

- iniciar Pomodoro a partir de uma tarefa;
- registrar sessão no banco;
- manter o timer ao navegar entre páginas;
- permitir foco, pausa curta e pausa longa;
- permitir duração personalizada;
- registrar duração planejada e realizada;
- permitir pausa, retomada e encerramento;
- ao finalizar, perguntar se a tarefa foi concluída, parcialmente concluída ou continua pendente;
- sincronizar estatísticas entre dispositivos.

Não manter o histórico somente em `localStorage`.

---

# 16. Flashcards

Manter:

- criação manual;
- agrupamento por matéria;
- associação opcional a prova e conteúdo;
- anexos;
- revisão espaçada;
- filtros;
- estatísticas.

Melhorar o algoritmo de repetição espaçada. Pode usar SM-2 simplificado ou FSRS em versão futura, desde que o algoritmo seja determinístico e testado.

As revisões pendentes podem aparecer no cronograma, mas devem ser distinguíveis das tarefas criadas manualmente.

---

# 17. Recursos sociais

Manter como funcionalidades secundárias:

- username;
- solicitações de amizade;
- lista de amigos;
- chat 1:1;
- presença online real usando Supabase Presence;
- comparação opcional de sequência de estudos ou horas, somente mediante consentimento.

Não criar videochamadas.

Uma futura “sala de foco” sem vídeo pode ser considerada depois, contendo apenas:

- participantes online;
- timer sincronizado;
- chat;
- objetivo da sessão;
- ranking opcional.

Essa sala não deve fazer parte do primeiro MVP, salvo se as funcionalidades centrais estiverem concluídas.

---

# 18. Sons ambientes

Manter como recurso opcional:

- chuva;
- floresta;
- café;
- ruído branco;
- lo-fi, apenas com mídia licenciada ou própria.

Persistir volume e som selecionado. Não iniciar áudio automaticamente sem interação do usuário.

---

# 19. Assinaturas e planos

Preparar a arquitetura para:

- `free`;
- `pro`;
- `pro_ai`, futuro e inativo.

Não integrar pagamento no primeiro passo, a menos que seja solicitado em uma etapa específica.

Sugestão de limites:

## Free

- quantidade limitada de provas ativas;
- cronograma diário e semanal;
- Pomodoro;
- flashcards básicos;
- paletas predefinidas;
- três idiomas.

## Pro

- provas e planos ilimitados;
- visualização mensal e trilha completa;
- replanejamento avançado;
- temas personalizados;
- estatísticas detalhadas;
- anexos ampliados;
- histórico completo;
- exportação.

## Pro AI — futuro

Não mostrar como disponível. Apenas prever enum e feature flag.

---

# 20. Modelo de dados proposto

Criar migrations para as seguintes tabelas.

## Identidade e preferências

- `profiles`
- `user_preferences`
- `user_subscriptions`

## Planejamento

- `exams`
- `subjects`
- `exam_subjects`
- `study_topics`
- `availability_rules`
- `availability_exceptions`
- `study_plans`
- `study_tasks`
- `task_reschedules`
- `study_sessions`

## Flashcards

- `flashcard_decks`
- `flashcards`
- `flashcard_reviews`
- `flashcard_attachments`

## Social

- `friend_requests`
- `chat_messages`
- `user_presence_preferences`

## Sistema

- `notifications`
- `feature_flags`
- `audit_events`, somente para ações relevantes e sem armazenar segredos.

Cada tabela deve ter:

- UUID como PK;
- timestamps;
- foreign keys explícitas;
- índices de consultas frequentes;
- constraints;
- RLS;
- policies documentadas;
- tipos TypeScript gerados pelo Supabase.

Não criar `study_rooms` nem `study_room_participants` nesta versão.

---

# 21. Requisitos importantes do banco

## `profiles`

O trigger de criação deve copiar corretamente:

- nome completo;
- username;
- idioma inicial, quando fornecido.

O username deve ser normalizado, único e case-insensitive. Considerar `citext` ou índice por `lower(username)`.

## `user_preferences`

Campos sugeridos:

- `language`;
- `timezone`;
- `week_starts_on`;
- `date_format`;
- `theme_mode`;
- `theme_palette`;
- `primary_color`;
- `accent_color`;
- `default_session_minutes`;
- `planning_style`;
- `notifications_enabled`.

## `study_tasks`

Além de campos básicos, incluir:

- `estimated_minutes`;
- `actual_minutes`;
- `status`;
- `activity_type`;
- `scheduled_date`;
- `scheduled_start_time`;
- `original_scheduled_date`;
- `is_locked`;
- `reschedule_count`;
- `source`;
- `position`.

## `task_reschedules`

Registrar:

- tarefa;
- data anterior;
- data nova;
- duração anterior;
- duração nova;
- motivo;
- estratégia;
- quem executou;
- timestamp.

## `study_sessions`

Registrar:

- usuário;
- tarefa opcional;
- prova opcional;
- início;
- fim;
- duração;
- tipo de timer;
- status;
- notas.

---

# 22. Segurança

- RLS em todas as tabelas públicas.
- Usuário acessa apenas seus próprios dados, salvo recursos sociais explicitamente compartilhados.
- Uploads em paths iniciados pelo `user_id`.
- Limites de tamanho e MIME em buckets.
- Validação server-side quando houver Edge Functions.
- Nunca confiar apenas em validação do cliente.
- Proteção contra abuso em busca de usuários e chat.
- Rate limit em ações sensíveis.
- Recuperação de senha implementada.
- Revalidação com `getUser()` em ações críticas.
- Não armazenar senhas ou tokens de terceiros.
- Não usar HTML inseguro.
- Sanitizar campos de texto exibidos em contexto compartilhado.

---

# 23. Rotas propostas

## Públicas

- `/auth`
- `/auth/verify`
- `/forgot-password`
- `/reset-password`
- `/terms`
- `/privacy`

## Autenticadas

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

Usar route-level lazy loading.

---

# 24. Organização de pastas sugerida

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
  types/
  test/
supabase/
  migrations/
  functions/
  seed.sql
```

Cada feature deve conter, quando necessário:

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

---

# 25. Estados de UX obrigatórios

Toda tela com dados remotos deve possuir:

- loading;
- skeleton;
- vazio;
- erro;
- sucesso;
- retry;
- feedback de operação;
- confirmação em ações destrutivas.

O aplicativo deve ser utilizável em celular, tablet e desktop.

---

# 26. Acessibilidade

- Navegação por teclado.
- Focus visível.
- Labels reais em formulários.
- ARIA quando necessário.
- Contraste adequado.
- Não depender apenas de cor para status.
- Respeitar `prefers-reduced-motion`.
- Drag-and-drop com alternativa por teclado e botões de mover.

---

# 27. Métricas do usuário

Calcular:

- tempo estudado hoje, semana e mês;
- tempo planejado versus realizado;
- taxa de conclusão;
- sessões concluídas;
- sequência de dias;
- distribuição por matéria;
- progresso por prova;
- conteúdos mais atrasados;
- estimativa de carga restante;
- ritmo esperado versus real.

Não apresentar “previsão de aprovação” sem base estatística confiável.

---

# 28. Fases de desenvolvimento

## Fase 0 — Fundação

- scaffold;
- lint;
- TypeScript strict;
- design system;
- i18n;
- Supabase local;
- CI;
- testes iniciais.

## Fase 1 — Autenticação e perfil

- login;
- cadastro;
- confirmação de email;
- recuperação de senha;
- onboarding;
- perfil;
- preferências;
- temas;
- idiomas.

## Fase 2 — Provas e conteúdos

- CRUD de provas;
- matérias;
- conteúdos;
- prioridades;
- dificuldade;
- estimativas.

## Fase 3 — Disponibilidade

- regras semanais;
- exceções;
- dias bloqueados;
- capacidade.

## Fase 4 — Cronograma

- algoritmo determinístico;
- criação de plano;
- tarefas;
- visualização diária e semanal;
- alertas de sobrecarga.

## Fase 5 — Replanejamento

- atrasos;
- conclusão parcial;
- redistribuição;
- preview;
- histórico;
- tarefas bloqueadas.

## Fase 6 — Foco e progresso

- Pomodoro integrado;
- sessões persistidas;
- dashboard;
- estatísticas.

## Fase 7 — Flashcards

- decks;
- cartões;
- revisão;
- anexos;
- integração opcional com cronograma.

## Fase 8 — Social

- amizades;
- presença;
- chat.

## Fase 9 — Assinatura

- feature flags;
- limites Free e Pro;
- pagamento apenas em etapa separada.

---

# 29. Critérios de aceite do MVP

O MVP só deve ser considerado funcional quando:

- usuário consegue criar conta e recuperar senha;
- onboarding salva idioma, tema e disponibilidade;
- usuário cria uma prova com vários conteúdos;
- sistema gera cronograma sem IA;
- usuário visualiza hoje e semana;
- usuário conclui parcialmente ou totalmente uma tarefa;
- usuário perde uma sessão e consegue replanejar;
- tarefas bloqueadas não são movidas;
- histórico de replanejamento é salvo;
- Pomodoro registra tempo no banco;
- progresso da prova é recalculado;
- tema e idioma sincronizam entre dispositivos;
- RLS impede acesso a dados de outro usuário;
- build, lint e testes passam;
- nenhuma dependência do Daily.co existe;
- nenhuma funcionalidade de IA está ativa.

---

# 30. Prompt mestre para iniciar no Codex

Copie a seção abaixo e envie ao Codex junto com este documento e, quando possível, com o código exportado do projeto antigo.

---

## PROMPT PARA O CODEX

Você atuará como arquiteto e desenvolvedor full-stack responsável pela reconstrução do SaaS **MedStudy Buddy V2**.

Leia integralmente o arquivo `MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md` antes de modificar ou criar código. Ele é a fonte da verdade do novo produto.

Também existe uma documentação do projeto anterior, criada no Lovable. Utilize-a apenas para compreender funcionalidades, estilo e fluxos que podem ser reaproveitados. Não recrie cegamente a arquitetura antiga.

### Objetivo

Construir um SaaS independente, funcional, seguro, testado e pronto para deploy, centrado em cronogramas adaptativos para preparação de provas.

### Regras obrigatórias

1. Não utilizar Lovable como dependência.
2. Não implementar Daily.co, WebRTC, videochamadas ou chamadas de áudio.
3. Remover qualquer código, banco, componente ou variável relacionado a salas de chamada.
4. Não implementar IA nesta versão.
5. Preparar apenas a arquitetura futura para o plano `pro_ai`, mantendo-o inativo.
6. Manter português, espanhol e inglês em toda a aplicação.
7. Implementar perfil e aparência altamente personalizáveis.
8. Fazer do cronograma adaptativo a principal funcionalidade.
9. Usar TypeScript strict.
10. Usar TanStack Query para dados remotos.
11. Aplicar RLS em todas as tabelas públicas.
12. Criar migrations SQL versionadas.
13. Criar testes unitários, integração, E2E e testes de RLS nos fluxos críticos.
14. Não armazenar sessões de estudo apenas em localStorage.
15. Não ocultar erros com mocks ou dados fictícios em produção.
16. Não alterar o escopo sem registrar a decisão em documentação.

### Stack

- React + TypeScript + Vite.
- Tailwind CSS + shadcn/ui.
- React Router.
- TanStack Query.
- React Hook Form + Zod.
- Supabase Auth, PostgreSQL, Storage e Realtime.
- Vitest, React Testing Library e Playwright.

### Forma de trabalho

Não tente construir tudo em uma única alteração.

Primeiro:

1. analise a documentação;
2. inspecione o repositório existente, se fornecido;
3. crie `docs/ARCHITECTURE.md`;
4. crie `docs/DATABASE.md`;
5. crie `docs/ROADMAP.md`;
6. crie `docs/DECISIONS.md`;
7. identifique o que será reaproveitado, removido e reescrito;
8. proponha a árvore final do projeto;
9. apresente o plano da Fase 0 e aguarde validação antes de implementar funcionalidades de domínio.

Depois da validação, execute fase por fase.

Para cada fase:

- explique o objetivo;
- liste arquivos que serão criados ou modificados;
- implemente;
- execute lint, typecheck e testes;
- corrija todos os erros;
- atualize a documentação;
- apresente um resumo do que foi concluído;
- indique riscos e próximos passos.

### Primeira tarefa

Execute apenas a Fase 0:

- inicializar ou reorganizar o projeto;
- remover dependências do Lovable;
- configurar TypeScript strict;
- configurar lint e formatação;
- configurar Tailwind e shadcn;
- configurar React Router com lazy loading;
- configurar TanStack Query;
- configurar i18n com `pt-BR`, `es` e `en`;
- configurar next-themes com light, dark e system;
- preparar o cliente Supabase;
- preparar Supabase local e estrutura de migrations;
- configurar Vitest, Testing Library e Playwright;
- criar CI no GitHub Actions;
- criar páginas placeholder acessíveis para auth, onboarding e dashboard;
- criar documentação inicial.

Não implemente ainda o algoritmo de cronograma na Fase 0.

Ao final, informe:

- estrutura criada;
- comandos usados;
- decisões técnicas;
- testes executados;
- pendências;
- plano exato da Fase 1.

---

# 31. Comando de continuação para cada fase

Após finalizar uma fase, utilizar:

```text
Leia novamente MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md e os documentos em docs/. Execute somente a próxima fase do roadmap. Não avance para fases posteriores. Preserve todas as regras arquiteturais, execute lint, typecheck e testes e atualize a documentação antes de concluir.
```

---

# 32. Observação sobre migração do projeto antigo

O projeto antigo já possui uma base útil com React, TypeScript, Vite, Supabase, autenticação, RLS, flashcards, Pomodoro, chat, idiomas e tema. Porém, ele também contém decisões que devem ser revistas, como TypeScript permissivo, uso limitado de TanStack Query, progresso calculado no cliente, sessões salvas em localStorage, ausência de testes e integração com Daily.co.

A migração deve reaproveitar apenas código que:

- esteja compatível com a nova arquitetura;
- possua tipagem adequada;
- não dependa do Lovable;
- não dependa do Daily.co;
- possa ser testado;
- respeite o novo modelo de dados;
- mantenha acessibilidade e responsividade.

Não realizar copy-paste indiscriminado.

---

# 33. Fonte da verdade

Em caso de conflito:

1. este documento V2 prevalece;
2. decisões registradas em `docs/DECISIONS.md` prevalecem sobre a documentação antiga;
3. a documentação antiga serve apenas como referência histórica;
4. comportamento do código antigo não deve ser preservado quando contradizer os objetivos da V2.

