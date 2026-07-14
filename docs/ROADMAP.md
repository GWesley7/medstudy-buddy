# Roadmap - MedStudy Buddy V2

## Estrategia

O desenvolvimento deve ocorrer em fases pequenas. Cada fase precisa gerar um estado funcional, verificavel e documentado do projeto.

Regras:

- nao avancar para a proxima fase sem concluir os criterios da fase atual;
- nao implementar funcionalidades fora da fase aprovada;
- nao executar migrations, deploy ou alteracoes remotas sem autorizacao;
- atualizar documentacao ao final de cada fase;
- executar lint, typecheck, testes e build quando houver codigo.

## Fase 1 - Arquitetura e planejamento

Objetivo: consolidar entendimento do produto, arquitetura, banco, padroes e processo.

Entregas:

- `docs/ARQUITETURA.md`;
- `docs/ROADMAP.md`;
- `docs/BANCO_DE_DADOS.md`;
- `docs/PADROES_DE_CODIGO.md`;
- `docs/CHECKLIST_DESENVOLVIMENTO.md`;
- `docs/AGENTS.md`.

Criterios de aceite:

- documentacao V2 reconhecida como fonte oficial;
- documentacao antiga registrada como historica;
- decisoes de remocao de Daily.co, WebRTC e IA ativa documentadas;
- roadmap aprovado antes de novas implementacoes.

## Fase 2 - Estrutura React

Objetivo: criar a fundacao frontend sem funcionalidades de negocio.

Status: concluida em 2026-07-13.

Entregas:

- React + Vite + TypeScript strict;
- ESLint e Prettier;
- Tailwind CSS;
- shadcn/ui;
- React Router com lazy loading;
- TanStack Query;
- React Hook Form;
- Zod;
- estrutura de pastas oficial;
- paginas placeholder para validar navegacao;
- testes basicos;
- build funcional.

Criterios de aceite:

- `npm run format:check` passa;
- `npm run lint` passa;
- `npm run typecheck` passa;
- `npm run test:run` passa;
- `npm run build` passa;
- nenhuma dependencia Lovable;
- nenhuma dependencia Daily.co;
- nenhuma funcionalidade de IA.

## Fase 3 - Fundacao inicial do banco Supabase

Objetivo: preparar a fundacao local e revisavel do banco Supabase sem aplicar alteracoes ao projeto remoto.

Entregas:

- migrations SQL para `profiles`;
- migrations SQL para `user_preferences`;
- catalogo `subscription_plans`;
- catalogo `plan_entitlements`;
- tabela `subscriptions`;
- funcoes de bootstrap de usuario;
- funcoes de trial e verificacao de acesso;
- RLS, policies e grants;
- seed idempotente de planos e entitlements;
- testes SQL de banco;
- documentacao tecnica da revisao.

Criterios de aceite:

- migrations criadas, mas nao executadas no remoto;
- RLS habilitada em todas as tabelas publicas criadas;
- grants revisados;
- trial inicia apenas via funcao segura e idempotente;
- cliente autenticado nao escreve diretamente em assinatura;
- testes SQL criados para execucao local;
- nenhum `db push`;
- banco remoto intocado.

## Fase 4 - Autenticacao

Objetivo: implementar entrada segura no produto.

Entregas:

- cadastro;
- confirmacao de email;
- login;
- logout;
- recuperacao de senha;
- redefinicao de senha;
- sessao persistente;
- rotas publicas de auth;
- guards de rotas autenticadas;
- criacao automatica do perfil;
- inicio automatico e idempotente do trial no primeiro login valido;
- uso de `getUser()` em acoes criticas;
- testes completos de email/senha;
- Google OAuth somente depois de email/senha estar funcionando e testado.

Criterios de aceite:

- usuario consegue criar conta;
- usuario confirma email;
- usuario consegue entrar e sair;
- usuario consegue recuperar senha;
- usuario consegue redefinir senha;
- sessao persiste corretamente;
- rotas protegidas funcionam;
- perfil e criado automaticamente;
- trial inicia uma unica vez apos confirmacao de email;
- `trial_ends_at` nao depende apenas do relogio do navegador;
- estados de loading, erro e sucesso existem;
- nao ha segredos no client;
- Google OAuth funciona apos email/senha;
- Facebook OAuth e Apple OAuth permanecem fora do MVP.

## Fase 5 - Perfil

Objetivo: criar identidade persistente do usuario.

Entregas:

- migration de `profiles`;
- trigger de criacao de perfil;
- username unico e case-insensitive;
- perfil editavel;
- avatar preparado;
- RLS;
- testes de RLS.

Criterios de aceite:

- perfil criado automaticamente;
- usuario edita apenas o proprio perfil;
- busca social ve apenas campos permitidos;
- migrations revisadas antes de aplicar.

## Fase 6 - Preferencias, temas e i18n

Objetivo: sincronizar preferencias pessoais e preparar interface multilíngue.

Entregas:

- `user_preferences`;
- idioma `pt-BR`, `es`, `en`;
- tema claro, escuro e system;
- paletas predefinidas;
- cores personalizadas com validacao de contraste;
- tokens semanticos para tema;
- preview antes de salvar tema personalizado;
- sugestao de alternativa valida para combinacoes invalidas;
- restauracao do tema padrao;
- suporte correto a light, dark e system;
- servico central para contraste, foreground adequado, preview e defaults;
- primeiro dia da semana, formato de data e timezone.

Criterios de aceite:

- preferencias persistem no banco;
- textos usam chaves de traducao;
- tema sincroniza entre dispositivos;
- contraste minimo e respeitado;
- cores do usuario nao sao aplicadas diretamente em componentes;
- texto normal respeita contraste de 4,5:1;
- texto grande, elementos interativos, bordas relevantes e indicadores importantes respeitam contraste de 3:1.

## Fase 7 - Onboarding

Objetivo: conduzir o usuario ao primeiro cronograma util.

Entregas:

- selecao de idioma;
- dados iniciais de perfil;
- tema e paleta;
- primeira prova;
- materias/conteudos iniciais;
- disponibilidade semanal;
- restricoes;
- estrategia de planejamento;
- revisao antes de confirmar.

Criterios de aceite:

- usuario pode concluir rapidamente;
- campos nao essenciais podem ser pulados;
- dados salvos sao reutilizados nas fases de planejamento.

## Fase 8 - Provas

Objetivo: gerenciar provas como unidade principal de planejamento.

Entregas:

- CRUD de provas;
- status;
- prioridade;
- dificuldade percebida;
- cor;
- data e horario;
- periodo de preparacao;
- dias finais reservados;
- estrategia de planejamento.

Criterios de aceite:

- usuario gerencia apenas suas provas;
- validacoes impedem datas e status invalidos;
- lista e detalhe possuem estados remotos completos.

## Fase 9 - Materias e conteudos

Objetivo: modelar o que precisa ser estudado.

Entregas:

- CRUD de materias;
- associacao prova-materia;
- CRUD de conteudos;
- duracao estimada;
- prioridade;
- dificuldade;
- pre-requisitos;
- tabela relacional `study_topic_prerequisites`;
- validacao de ciclos na camada de dominio;
- tipo de atividade sugerido;
- status de dominio.

Criterios de aceite:

- prova pode ter varias materias e conteudos;
- conteudos geram insumos suficientes para o algoritmo;
- pre-requisitos sao preservados em tabela relacional;
- `topic_id` nao pode ser igual a `prerequisite_topic_id`;
- relacionamento de pre-requisito e unico;
- ciclos nao sao permitidos;
- validacao de ciclos possui testes automatizados.

## Fase 10 - Disponibilidade

Objetivo: representar a rotina real do usuario.

Entregas:

- disponibilidade semanal;
- multiplos blocos por dia;
- duracao minima e maxima de sessao;
- limite maximo diario;
- excecoes por data;
- dias bloqueados;
- preferencias por periodo;
- calculo de capacidade.

Criterios de aceite:

- capacidade por dia e periodo e calculada corretamente;
- excecoes alteram capacidade;
- testes cobrem regras principais.

## Fase 11 - Cronograma deterministico

Objetivo: gerar plano de estudo sem IA.

Entregas:

- configuracao central de fatores;
- calculo de peso por conteudo;
- divisao de conteudos longos;
- respeito a pre-requisitos;
- reserva de dias finais;
- revisoes planejadas;
- alertas de sobrecarga;
- criacao de `study_plans` e `study_tasks`;
- visualizacao de hoje e semana.

Criterios de aceite:

- plano gerado a partir de prova, conteudos e disponibilidade;
- capacidade insuficiente e explicada;
- algoritmo coberto por testes;
- nenhuma chamada de IA.

## Fase 12 - Replanejamento

Objetivo: adaptar o plano quando a realidade muda.

Entregas:

- conclusao parcial;
- tarefa nao concluida;
- bloqueio de dia;
- mudanca de disponibilidade;
- prova antecipada ou adiada;
- preview de mudancas;
- historico em `task_reschedules`;
- preservacao de tarefas concluidas e bloqueadas.

Criterios de aceite:

- replanejamento e transacional;
- usuario ve o que sera alterado;
- tarefas bloqueadas nao sao movidas automaticamente;
- tarefas concluidas nunca sao alteradas.

## Fase 13 - Foco e Pomodoro

Objetivo: conectar execucao real ao cronograma.

Entregas:

- Pomodoro global;
- inicio a partir de tarefa;
- pausa, retomada e encerramento;
- `study_sessions`;
- `duration_seconds`;
- `session_type`;
- `source`;
- `completed`;
- validacoes contra duracao negativa, horarios invalidos e sessoes absurdamente longas;
- status de sessao;
- conclusao total ou parcial da tarefa;
- sincronizacao entre dispositivos.

Criterios de aceite:

- historico nao fica apenas em `localStorage`;
- sessoes sincronizam entre dispositivos;
- duracao final nao depende apenas de valor enviado pelo client;
- sessao atualiza progresso;
- fluxos principais testados.

## Fase 14 - Dashboard e progresso

Objetivo: mostrar a situacao atual sem excesso de graficos.

Entregas:

- dashboard simples;
- plano de hoje;
- proxima prova;
- tarefas atrasadas;
- tempo estudado hoje e semana;
- progresso da trilha;
- ritmo esperado versus real;
- metricas por prova e materia.

Criterios de aceite:

- dados reais aparecem no dashboard;
- metricas sao consistentes com sessoes e tarefas;
- nao ha previsao de aprovacao sem base estatistica.

## Fase 15 - Flashcards

Objetivo: adicionar revisao espacada integrada ao planejamento.

Entregas:

- decks;
- flashcards;
- associacao opcional a prova/conteudo;
- anexos;
- revisao espacada deterministica;
- estatisticas;
- revisoes pendentes distinguiveis no cronograma.

Criterios de aceite:

- algoritmo de revisao testado;
- anexos respeitam Storage/RLS;
- revisoes nao se confundem com tarefas manuais.

## Fase 16 - Social

Objetivo: implementar recursos sociais secundarios.

Entregas:

- username;
- solicitacoes de amizade;
- lista de amigos;
- chat 1:1;
- Supabase Presence;
- preferencias de compartilhamento.

Criterios de aceite:

- usuario controla o que compartilha;
- chat tem RLS;
- sem videochamadas;
- sem Daily.co.

## Fase 17 - Sons ambientes

Objetivo: incluir foco sonoro opcional.

Entregas:

- chuva;
- floresta;
- cafe;
- ruido branco;
- lo-fi apenas com midia licenciada ou propria;
- volume persistido;
- som selecionado persistido.

Criterios de aceite:

- audio nao inicia sem interacao;
- preferencias persistem;
- recurso nao bloqueia fluxo central.

## Fase 18 - Trial, assinatura e entitlements

Objetivo: preparar trial, assinatura e capacidades protegidas sem pagamento ativo, checkout, cobranca ou webhooks reais.

Entregas:

- planos internos `essential`, `pro`, `pro_ai`;
- `pro_ai` inativo;
- trial de 3 dias;
- estados `trialing`, `active`, `expired` inicialmente;
- preparo para estados `past_due`, `canceled`, `paused`, `incomplete`;
- feature entitlements centralizados;
- servicos `hasFeature`, `canAccessFeature` ou equivalentes;
- expiracao de acesso a funcionalidades protegidas;
- acesso mantido a login, configuracoes e assinatura apos trial expirado;
- preparo para provedores futuros como Stripe, Mercado Pago ou Paddle;
- UI de assinatura;
- mensagens claras de trial expirado.

Criterios de aceite:

- nomes comerciais nao estao hardcoded;
- componentes nao verificam `plan_code` diretamente;
- autorizacao passa por entitlements centralizados;
- dados do usuario nao sao apagados ao fim do trial;
- nenhuma cobranca real criada;
- nenhum checkout criado;
- nenhum webhook criado;
- `pro_ai` nao e exibido;
- pagamento fica para fase autorizada separadamente.

## Fase 19 - Hardening MVP

Objetivo: preparar o MVP para uso real.

Entregas:

- auditoria de seguranca;
- testes E2E criticos;
- testes de RLS;
- acessibilidade;
- performance;
- revisao de bundle;
- revisao de erros e logs;
- documentacao atualizada.

Criterios de aceite:

- lint, typecheck, testes e build passam;
- RLS impede acesso cruzado;
- fluxos MVP completos funcionam;
- nenhuma dependencia proibida existe.

## Backlog pos-MVP

- exportacao de cronograma;
- notificacoes push;
- sala de foco sem video;
- modo de foco individual com tarefa, Pomodoro e sons ambientes;
- aplicativo mobile;
- analytics avancado;
- integracao de pagamento;
- IA no plano `pro_ai`, apenas apos decisao explicita.
