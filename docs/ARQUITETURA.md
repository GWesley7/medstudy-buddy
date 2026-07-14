# Arquitetura - MedStudy Buddy V2

## 1. Resumo do projeto

MedStudy Buddy V2 e um SaaS de organizacao academica para transformar provas, conteudos e disponibilidade real do estudante em cronogramas adaptativos. O produto deve orientar o usuario diariamente sobre o que estudar, quanto tempo dedicar, quais prioridades atacar e como reorganizar o plano quando a rotina muda.

A versao antiga, documentada em `DOCUMENTACAO_TECNICA_MEDSTUDY_BUDDY.md`, serve apenas como referencia historica. A fonte oficial do produto e `MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md`.

## 2. Objetivo principal

Construir uma plataforma duradoura, segura e escalavel para planejamento academico adaptativo, com foco em:

- provas;
- materias;
- conteudos;
- disponibilidade;
- cronogramas deterministico-adaptativos;
- replanejamento apos imprevistos;
- registro de estudo;
- progresso ate a prova.

O produto nao deve ser apenas uma agenda ou lista de tarefas. Ele deve representar a trilha de preparacao do estudante.

## 3. Publico alvo

Publico prioritario:

- estudantes de medicina;
- estudantes universitarios com alto volume de conteudo;
- candidatos a residencia, concursos e provas de titulo;
- usuarios que estudam para varias provas simultaneamente;
- pessoas com rotina variavel que precisam reorganizar estudos com frequencia.

A comunicacao pode priorizar medicina, mas a modelagem nao deve limitar o produto a esse curso.

## 4. Funcionalidades principais

- Onboarding guiado ate o primeiro cronograma util.
- Cadastro de provas.
- Cadastro de materias e conteudos por prova.
- Configuracao de disponibilidade semanal e excecoes.
- Geracao deterministica de cronograma.
- Visualizacao diaria, semanal, mensal e trilha ate a prova.
- Replanejamento adaptativo com preview e historico.
- Tarefas com status, duracao prevista, duracao realizada e bloqueio manual.
- Pomodoro integrado a tarefas e persistido no banco.
- Flashcards manuais com revisao espacada deterministica.
- Perfil, preferencias, temas, paletas e internacionalizacao.
- Estatisticas de tempo, ritmo e progresso.
- Recursos sociais secundarios: amizades, chat e presenca.
- Trial gratuito de 3 dias com acesso equivalente ao Pro.
- Assinaturas preparadas para `essential`, `pro` e `pro_ai` futuro e inativo.
- Feature entitlements centralizados para controlar funcionalidades protegidas.

## 5. Funcionalidades removidas da V2

Remover completamente:

- Daily.co;
- WebRTC;
- videochamadas;
- chamadas de audio;
- salas de video ou audio;
- Edge Functions `create-daily-room` e `delete-daily-room`;
- tabelas `study_rooms` e `study_room_participants`;
- campos relacionados a salas, senhas de sala e URLs Daily;
- variavel `DAILY_API_KEY`;
- componentes `StudyRooms` e `RoomSettingsDialog`;
- qualquer funcionalidade ativa de IA;
- qualquer chamada a OpenAI, LLM ou gerador automatico por IA.

## 6. Melhorias encontradas na V2

A especificacao V2 corrige pontos importantes da arquitetura antiga:

- cronograma passa a ser o centro do produto;
- disponibilidade do usuario deixa de ser simplificada;
- replanejamento vira funcionalidade central;
- sessoes de estudo passam a ser persistidas no banco;
- TypeScript deve ser estrito;
- TanStack Query passa a ser padrao para dados remotos;
- internacionalizacao deve ser sistematica;
- preferencias e tema devem sincronizar entre dispositivos;
- RLS e testes passam a ser requisitos de aceite;
- IA fica fora do MVP, evitando complexidade prematura;
- videochamadas sao removidas, reduzindo custo e superficie de risco.

## 7. Problemas da arquitetura antiga

Principais riscos identificados no projeto historico:

- TypeScript permissivo.
- Uso limitado de TanStack Query.
- Regras de negocio espalhadas em componentes.
- Progresso calculado ou atualizado no client.
- Sessoes de estudo em `localStorage`.
- Ausencia de testes automatizados.
- Integracao Daily.co adicionava complexidade, custos e riscos.
- Senha de sala era validada no client e armazenada em texto plano.
- Rotas sem lazy loading.
- Preferencias de tema/idioma locais, sem sincronizacao robusta.
- Ausencia de recuperacao de senha completa.
- Falta de rate limit proprio em acoes sensiveis.
- Presenca online parcialmente visual, sem Presence real.

## 8. Melhorias recomendadas

- Criar arquitetura por features, nao por tipo tecnico apenas.
- Manter dominio de planejamento em modulos puros e testaveis.
- Centralizar configuracoes do algoritmo.
- Persistir todo dado relevante no banco.
- Usar TanStack Query em todo acesso remoto.
- Criar schemas Zod para formularios, mutations e funcoes server-side.
- Testar algoritmo, RLS e fluxos E2E criticos desde cedo.
- Criar migrations pequenas e revisaveis.
- Evitar mocks em producao.
- Criar feature flags para funcionalidades pagas/futuras.
- Planejar indices do banco antes do volume crescer.
- Separar paginas de composicao, componentes de UI e servicos de dominio.
- Modelar pre-requisitos de conteudos com tabela relacional desde a primeira migration de conteudos.
- Validar ciclos de pre-requisitos na camada de dominio com testes automatizados.
- Centralizar limites de planos e permissoes em configuracao ou feature flags, sem hardcode em UI.
- Usar tokens semanticos para temas personalizados, nunca aplicar cores escolhidas diretamente nos componentes.

## 8.1. Decisoes oficiais aprovadas

### Trial, assinatura e planos

Nao havera plano gratuito permanente. O produto tera um periodo de teste gratuito de 3 dias.

O trial deve comecar no primeiro login valido apos a confirmacao do email, nao no momento em que a conta e criada. O inicio do trial deve ser idempotente: multiplos logins nao podem reiniciar nem prolongar o periodo. A data de termino deve ser calculada no backend ou no banco, nunca confiando apenas no relogio do navegador.

Durante o trial, o usuario tera acesso equivalente ao plano Pro.

Depois que o trial expirar:

- o usuario ainda podera fazer login;
- podera acessar configuracoes e assinatura;
- vera claramente que o periodo de teste terminou;
- os dados existentes permanecerao armazenados;
- funcionalidades protegidas ficarao bloqueadas;
- o acesso sera restaurado apos ativacao de assinatura valida.

A arquitetura deve prever os codigos internos de planos:

- `essential`;
- `pro`;
- `pro_ai`.

Os nomes comerciais podem mudar e nao devem ser hardcoded na logica de dominio. `pro_ai` e reservado para o futuro e nao deve ser exibido, vendido ou implementado no MVP.

Nao havera checkout, cobranca, precos, webhooks ou integracao real com provedor de pagamento nesta primeira etapa. Mesmo assim, o modelo de dados deve ficar preparado para Stripe, Mercado Pago, Paddle ou outro provedor futuro.

Estados de assinatura previstos:

- `trialing`;
- `active`;
- `past_due`;
- `canceled`;
- `expired`;
- `paused`;
- `incomplete`.

Inicialmente poderao ser usados apenas:

- `trialing`;
- `active`;
- `expired`.

### Feature entitlements

Planos devem ser diferenciados por funcionalidades disponiveis, nao apenas por limites numericos.

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

Nao hardcode permissoes diretamente em paginas ou componentes. Evitar condicoes como `plan === "pro"`. A arquitetura deve usar uma camada centralizada de capacidades ou feature entitlements.

Exemplos conceituais de capacidades:

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

Interfaces/servicos planejados:

- `hasFeature(featureCode)`;
- `canAccessFeature(featureCode)`;
- `getCurrentEntitlements()`.

Paginas e componentes devem consultar essa camada centralizada.

### Autenticacao social

O primeiro ciclo de autenticacao deve seguir esta ordem:

1. cadastro por email e senha;
2. confirmacao de email;
3. login;
4. logout;
5. recuperacao de senha;
6. redefinicao de senha;
7. sessao persistente;
8. rotas protegidas;
9. criacao automatica do perfil;
10. inicio automatico do trial no primeiro login valido;
11. testes completos.

Depois que email e senha estiverem funcionando e testados, Google OAuth pode ser implementado ainda dentro da fase geral de autenticacao.

Facebook OAuth e Apple OAuth ficam fora do MVP inicial.

### Temas personalizados

Temas devem usar tokens semanticos:

- `background`;
- `foreground`;
- `card`;
- `card-foreground`;
- `primary`;
- `primary-foreground`;
- `accent`;
- `accent-foreground`;
- `muted`;
- `muted-foreground`;
- `border`;
- `input`;
- `ring`;
- `destructive`;
- `destructive-foreground`.

A cor escolhida pelo usuario nao deve ser aplicada diretamente em componentes. Ela deve alimentar tokens semanticos validados.

Requisitos minimos de contraste:

- 4,5:1 para texto normal;
- 3:1 para texto grande;
- 3:1 para elementos interativos, bordas relevantes e indicadores visuais importantes.

Combinacoes invalidas devem ser rejeitadas, o sistema deve sugerir alternativa valida, deve haver preview antes de salvar e o usuario deve poder restaurar o tema padrao.

Temas devem funcionar corretamente em light mode, dark mode e modo system.

Planejar um servico central para calcular contraste, validar combinacoes, escolher foreground adequado, gerar preview e restaurar defaults.

### Foco individual

O modo de foco individual pode existir futuramente como tarefa + Pomodoro + sons ambientes, sem chamada, sem video, sem audio em grupo e sem sala compartilhada.

## 9. Tecnologias recomendadas

Frontend:

- React.
- TypeScript strict.
- Vite.
- React Router.
- Tailwind CSS.
- shadcn/ui.
- Radix UI.
- Lucide React.
- TanStack Query.
- React Hook Form.
- Zod.
- date-fns.
- Recharts.
- next-themes.
- `@dnd-kit` para drag-and-drop acessivel.

Backend e dados:

- Supabase Auth.
- PostgreSQL.
- Supabase Storage.
- Supabase Realtime apenas para chat e presenca.
- Supabase Edge Functions apenas quando houver necessidade real de validacao server-side, rate limit ou operacao sensivel.
- SQL versionado em migrations.
- RLS em todas as tabelas publicas.

Qualidade:

- Vitest.
- React Testing Library.
- Playwright.
- pgTAP ou testes SQL para RLS.
- ESLint.
- Prettier.
- GitHub Actions.

## 10. Organizacao do projeto

Estrutura recomendada:

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
docs/
```

Na fundacao da Fase 2, as rotas existem apenas como placeholders para validar navegacao, layout, tema e idioma. A integracao Supabase permanece centralizada em `src/integrations/supabase`, com uma fachada em `src/lib/supabase`. O i18n inicial da interface fica em `src/lib/i18n` ate que a fase de preferencias defina a persistencia remota e a organizacao final de catalogos.

## 11. Organizacao do banco

O banco deve ser organizado por dominios:

- identidade e preferencias;
- planejamento;
- assinatura e permissoes;
- flashcards;
- social;
- sistema.

Todas as tabelas publicas devem ter:

- UUID como chave primaria;
- timestamps;
- foreign keys explicitas;
- constraints;
- indices para consultas frequentes;
- RLS;
- policies documentadas;
- tipos TypeScript gerados.

Detalhes ficam em `docs/BANCO_DE_DADOS.md`.

A fundacao da Fase 3 concentra identidade, preferencias, catalogo de planos, entitlements, subscriptions, trial e acesso em migrations locais revisaveis. Nenhuma migration deve ser aplicada ao remoto sem aprovacao explicita.

## 12. Organizacao dos servicos

Servicos devem ficar dentro das features quando pertencerem a um dominio especifico.

Padrao:

```text
features/planning/
  services/
    schedule-generator.ts
    capacity-calculator.ts
    reschedule-preview.ts
```

Regras:

- servicos de dominio nao devem depender de React;
- algoritmos devem receber entradas explicitas e retornar resultados tipados;
- integracoes externas devem ficar em `src/integrations`;
- mutations e queries devem ficar separadas dos componentes visuais.
- validacao de ciclos de pre-requisitos deve ficar no dominio de conteudos/planejamento e possuir testes automatizados.

## 13. Organizacao dos componentes

Categorias:

- `components/ui`: primitives e componentes shadcn reutilizaveis.
- `components/layout`: shell, sidebar, header, navegacao.
- `components/shared`: estados vazios, loading, erros, confirmacoes, formatadores visuais.
- `features/*/components`: componentes especificos de cada dominio.

Regras:

- componentes nao devem conter regra de negocio pesada;
- formularios usam React Hook Form + Zod;
- todo componente interativo deve ser acessivel por teclado;
- estados loading, vazio, erro e sucesso devem ser planejados.

## 14. Organizacao dos hooks

Tipos de hooks:

- hooks globais e genericos em `src/hooks`;
- hooks de feature em `features/*/hooks`;
- queries em `features/*/queries`;
- mutations em `features/*/mutations`.

Regras:

- hooks de dados devem usar TanStack Query;
- nomes devem deixar claro se leem, alteram ou coordenam estado;
- hooks nao devem esconder efeitos colaterais criticos sem testes.

## 15. Organizacao das paginas

Paginas devem ser finas e atuar como composicao de layout, hooks e componentes.

Rotas publicas:

- `/auth`;
- `/auth/verify`;
- `/forgot-password`;
- `/reset-password`;
- `/terms`;
- `/privacy`.

Rotas autenticadas:

- `/`;
- `/onboarding`;
- `/today`;
- `/schedule`;
- `/schedule/week`;
- `/schedule/month`;
- `/exams`;
- `/exams/new`;
- `/exams/:examId`;
- `/exams/:examId/edit`;
- `/exams/:examId/timeline`;
- `/tasks/:taskId`;
- `/flashcards`;
- `/flashcards/decks/:deckId`;
- `/progress`;
- `/focus`;
- `/friends`;
- `/messages`;
- `/settings/profile`;
- `/settings/preferences`;
- `/settings/appearance`;
- `/settings/notifications`;
- `/subscription`.

Todas as paginas devem usar lazy loading.

## 16. Organizacao das APIs

Inicialmente, a API principal sera o Supabase:

- Auth para identidade;
- PostgREST para CRUD com RLS;
- Storage para avatares e anexos;
- Realtime para chat e presenca.

Edge Functions devem ser criadas apenas quando necessario:

- validacao server-side sensivel;
- rate limit;
- operacoes transacionais que nao devem ficar no client;
- webhooks futuros de pagamento;
- tarefas administrativas controladas.

Nao criar APIs para IA nesta etapa.

## 17. Organizacao da documentacao

Documentos permanentes:

- `docs/ARQUITETURA.md`: visao tecnica e organizacao geral.
- `docs/ROADMAP.md`: fases de desenvolvimento.
- `docs/BANCO_DE_DADOS.md`: modelo e regras de dados.
- `docs/PADROES_DE_CODIGO.md`: convencoes de implementacao.
- `docs/CHECKLIST_DESENVOLVIMENTO.md`: checklist obrigatorio por tarefa/fase.
- `docs/AGENTS.md`: regras permanentes para agentes.
- `docs/MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md`: fonte oficial do produto.
- `docs/DOCUMENTACAO_TECNICA_MEDSTUDY_BUDDY.md`: referencia historica.

Toda decisao que altere escopo, arquitetura, banco ou fluxo principal deve ser registrada na documentacao antes ou junto da implementacao.
