# Roadmap - MedStudy Buddy V2

## Estrategia

O desenvolvimento sera incremental. Cada fase deve entregar uma base funcional, testada e documentada antes da proxima.

Nao implementar funcionalidades de fases futuras antes de validar a fase atual.

## Fase 0 - Fundacao

Objetivo: preparar a base tecnica do produto.

Entregas:

- Scaffold React + Vite + TypeScript strict.
- ESLint e Prettier.
- Tailwind CSS.
- shadcn/ui.
- React Router com lazy loading.
- TanStack Query.
- i18n com `pt-BR`, `es` e `en`.
- next-themes.
- Cliente Supabase.
- Estrutura `supabase/migrations`.
- Vitest.
- React Testing Library.
- Playwright.
- GitHub Actions.
- Paginas placeholder acessiveis:
  - auth;
  - onboarding;
  - dashboard.

Criterios de aceite:

- `lint` passa.
- `typecheck` passa.
- testes iniciais passam.
- build passa.
- nenhuma dependencia Lovable.
- nenhuma dependencia Daily.co.
- nenhuma funcionalidade de IA.

## Fase 1 - Autenticacao, perfil e preferencias

Objetivo: permitir entrada segura no produto e persistir identidade/preferencias.

Entregas:

- Cadastro.
- Login.
- Logout.
- Verificacao de email.
- Recuperacao de senha.
- Reset de senha.
- Trigger `profiles`.
- Tabela `user_preferences`.
- Onboarding inicial.
- Escolha de idioma.
- Tema claro, escuro e system.
- Paletas predefinidas.
- Validacao basica de contraste.

Criterios de aceite:

- usuario cria conta;
- perfil e preferencias sao criados automaticamente;
- idioma e tema persistem no banco;
- RLS impede acesso cruzado;
- testes de auth e RLS passam.

## Fase 2 - Provas, materias e conteudos

Objetivo: modelar o material que sera usado pelo cronograma.

Entregas:

- CRUD de provas.
- CRUD de materias.
- Associacao prova-materia.
- CRUD de conteudos.
- Prioridade.
- Dificuldade.
- Duracao estimada.
- Pre-requisitos.
- Status de dominio.

Criterios de aceite:

- usuario cria prova com varias materias e conteudos;
- conteudos possuem estimativas suficientes para o algoritmo;
- validacoes impedem dados invalidos;
- RLS cobre todas as tabelas.

## Fase 3 - Disponibilidade

Objetivo: representar a rotina real do usuario.

Entregas:

- Regras semanais.
- Varios blocos por dia.
- Excecoes por data.
- Dias bloqueados.
- Limite maximo de carga diaria.
- Duracao minima e maxima de sessao.
- Preferencia de periodo.
- Calculo de capacidade disponivel.

Criterios de aceite:

- usuario configura disponibilidade flexivel;
- sistema calcula capacidade por dia e por periodo;
- excecoes alteram a capacidade corretamente;
- testes cobrem os calculos principais.

## Fase 4 - Cronograma deterministico

Objetivo: gerar o primeiro cronograma adaptativo sem IA.

Entregas:

- Configuracao central de fatores.
- Calculo de peso por conteudo.
- Divisao de conteudos longos.
- Respeito a pre-requisitos.
- Reserva de dias finais.
- Estrategias:
  - intenso;
  - equilibrado;
  - com folga.
- Criacao de `study_plans`.
- Criacao de `study_tasks`.
- Visualizacao de hoje.
- Visualizacao semanal.
- Alertas de sobrecarga.

Criterios de aceite:

- cronograma e gerado a partir de prova, conteudos e disponibilidade;
- capacidade insuficiente e explicada ao usuario;
- algoritmo e coberto por testes;
- nenhuma IA e chamada.

## Fase 5 - Replanejamento adaptativo

Objetivo: adaptar o plano quando a rotina muda.

Entregas:

- Replanejamento por tarefa nao concluida.
- Replanejamento por conclusao parcial.
- Replanejamento por alteracao de disponibilidade.
- Replanejamento por prova antecipada ou adiada.
- Preview antes de grandes mudancas.
- Historico em `task_reschedules`.
- Preservacao de tarefas concluidas.
- Preservacao de tarefas bloqueadas.
- Opcoes manuais de decisao.

Criterios de aceite:

- tarefas bloqueadas nao sao movidas automaticamente;
- tarefas concluidas nunca sao alteradas;
- mudancas geram historico;
- operacoes criticas sao transacionais;
- testes cobrem os principais cenarios.

## Fase 6 - Foco, Pomodoro e progresso

Objetivo: conectar execucao real ao cronograma.

Entregas:

- Pomodoro global.
- Inicio de foco a partir de uma tarefa.
- Pausa, retomada e encerramento.
- Persistencia em `study_sessions`.
- Conclusao total ou parcial de tarefa.
- Dashboard simples.
- Metricas:
  - tempo hoje;
  - tempo na semana;
  - planejado versus realizado;
  - progresso por prova;
  - atrasos.

Criterios de aceite:

- tempo nao fica apenas em `localStorage`;
- dashboard reflete dados reais;
- finalizar sessao atualiza tarefa e progresso;
- testes cobrem registro de sessao e metricas.

## Fase 7 - Flashcards

Objetivo: adicionar revisao espacada integrada ao estudo.

Entregas:

- Decks.
- Flashcards.
- Associacao opcional a prova e conteudo.
- Anexos.
- Revisao espacada deterministica.
- Filtros.
- Estatisticas.
- Revisoes pendentes distinguiveis no cronograma.

Criterios de aceite:

- usuario cria e revisa flashcards;
- algoritmo de revisao e testado;
- anexos respeitam storage policies;
- revisoes podem aparecer no planejamento sem confundir tipos de tarefa.

## Fase 8 - Social

Objetivo: adicionar recursos sociais secundarios sem desviar do nucleo.

Entregas:

- Busca por username com protecao contra abuso.
- Solicitacoes de amizade.
- Lista de amigos.
- Chat 1:1.
- Presenca real via Supabase Presence.
- Preferencias de compartilhamento.

Criterios de aceite:

- usuario controla o que compartilha;
- chat respeita RLS;
- presenca e opcional conforme preferencias;
- nenhuma videochamada existe.

## Fase 9 - Assinaturas e limites

Objetivo: preparar monetizacao sem integrar pagamento ainda.

Entregas:

- Planos `free`, `pro`, `pro_ai`.
- `pro_ai` inativo.
- Feature flags.
- Limites por plano.
- UI de assinatura.
- Bloqueios e mensagens de upgrade.

Criterios de aceite:

- limites Free e Pro sao aplicados;
- arquitetura permite futura integracao de pagamento;
- nenhuma cobranca real e criada nesta fase.

## Backlog pos-MVP

- Exportacao de cronograma.
- Notificacoes push.
- Sala de foco sem video.
- App mobile.
- Analytics avancado.
- Integracao de pagamento.
- Recursos de IA sob plano `pro_ai`, somente apos decisao explicita.

## Marcos do MVP

O MVP sera considerado pronto quando:

- usuario cria conta e recupera senha;
- onboarding salva idioma, tema e disponibilidade;
- usuario cria prova com varios conteudos;
- sistema gera cronograma sem IA;
- usuario visualiza hoje e semana;
- usuario conclui tarefa total ou parcialmente;
- usuario replaneja apos atraso;
- tarefas bloqueadas sao preservadas;
- historico de replanejamento e salvo;
- Pomodoro registra tempo no banco;
- progresso da prova e recalculado;
- tema e idioma sincronizam entre dispositivos;
- RLS impede acesso a dados de outro usuario;
- lint, typecheck, testes e build passam;
- nao existe Daily.co;
- nao existe IA ativa.
