# AGENTS.md - Regras Permanentes do Projeto

## Fonte da verdade

1. `docs/MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md` e a fonte oficial da V2.
2. `docs/DOCUMENTACAO_TECNICA_MEDSTUDY_BUDDY.md` e apenas referencia historica.
3. Em caso de conflito, seguir a especificacao V2.
4. Decisoes arquiteturais aprovadas e registradas em `docs/` prevalecem sobre o projeto antigo.

## Escopo do produto

O MedStudy Buddy V2 e um SaaS de organizacao academica centrado em:

- provas;
- materias;
- conteudos;
- disponibilidade;
- cronogramas adaptativos;
- replanejamento deterministico;
- acompanhamento de progresso;
- Pomodoro integrado;
- flashcards;
- personalizacao;
- internacionalizacao.

## Proibicoes

Nao implementar:

- Daily.co;
- WebRTC;
- videochamadas;
- chamadas de audio;
- salas de video ou audio;
- Edge Functions `create-daily-room` ou `delete-daily-room`;
- tabelas `study_rooms` ou `study_room_participants`;
- variavel `DAILY_API_KEY`;
- funcionalidades ativas de IA;
- chamadas a OpenAI ou qualquer LLM;
- dependencias do Lovable;
- codigo morto;
- TODOs permanentes;
- mocks que escondam erros em producao;
- solucoes temporarias apenas para funcionar.

## Regras tecnicas

- Usar TypeScript strict.
- Manter `noImplicitAny` habilitado.
- Manter `strictNullChecks` habilitado.
- Manter `noUncheckedIndexedAccess` habilitado quando viavel.
- Evitar `any`; quando inevitavel, justificar localmente.
- Manter regras de negocio fora de componentes visuais.
- Usar TanStack Query para estado remoto.
- Usar React Hook Form e Zod para formularios.
- Usar migrations SQL versionadas.
- Aplicar RLS em todas as tabelas publicas.
- Validar dados no frontend e, quando houver fluxo sensivel, no server.
- Nunca expor segredos no frontend.
- Persistir sessoes de estudo no banco.
- Usar `localStorage` apenas como contingencia temporaria para sessao ativa e preferencias nao criticas.
- Criar testes para regras de dominio importantes.

## Regras de arquitetura

- Organizar codigo por features.
- Preferir componentes pequenos e reutilizaveis.
- Centralizar configuracoes de algoritmo.
- Centralizar validacoes.
- Centralizar integracoes externas.
- Centralizar chamadas ao Supabase em repositories, services ou modulos de feature.
- Centralizar autorizacao de funcionalidades em feature entitlements.
- Separar UI, dominio, dados e infraestrutura.
- Evitar duplicacao de logica.
- Registrar decisoes relevantes em documentacao.

## Regras de UX

- Interface responsiva e mobile-first.
- Acessibilidade por padrao.
- Navegacao por teclado.
- Focus visivel.
- Labels reais em formularios.
- Contraste adequado.
- Nao depender apenas de cor para comunicar status.
- Toda tela remota deve ter loading, skeleton, vazio, erro, retry e feedback.
- Drag-and-drop deve ter alternativa acessivel.

## Internacionalizacao

- Idiomas obrigatorios: `pt-BR`, `es`, `en`.
- Nao escrever texto fixo de interface diretamente em componentes.
- Persistir idioma no perfil/preferencias do usuario.

## Temas

- Suportar claro, escuro e system.
- Suportar paletas predefinidas.
- Suportar cor primaria e cor de destaque personalizadas.
- Validar contraste para evitar combinacoes ilegiveis.
- Usar tokens semanticos.
- Nao aplicar cores escolhidas diretamente em componentes.
- Exigir contraste minimo de 4,5:1 para texto normal.
- Exigir contraste minimo de 3:1 para texto grande, elementos interativos, bordas relevantes e indicadores.
- Rejeitar combinacoes invalidas e sugerir alternativa valida.
- Exigir preview antes de salvar tema personalizado.
- Permitir restaurar tema padrao.
- Persistir preferencias no banco.

## Trial e assinaturas

- Nao ha plano gratuito permanente.
- Trial gratuito dura 3 dias.
- Trial concede acesso equivalente ao Pro.
- Trial inicia no primeiro login valido apos confirmacao de email.
- Inicio do trial deve ser idempotente.
- Multiplos logins nao podem reiniciar ou prolongar trial.
- Fim do trial deve ser calculado no backend ou banco.
- Depois do trial expirado, usuario ainda pode fazer login e acessar configuracoes/assinatura.
- Dados do usuario nao devem ser apagados ao fim do trial.
- Funcionalidades protegidas devem ser bloqueadas por entitlements centralizados.
- Planos internos: `essential`, `pro`, `pro_ai`.
- `pro_ai` e futuro, nao deve ser exibido nem implementado agora.
- Nao hardcode nomes comerciais, permissoes ou condicoes como `plan === "pro"`.
- Nao implementar checkout, cobranca, precos ou webhooks sem autorizacao.

## Banco de dados

- UUID como PK.
- Timestamps nas tabelas de dominio.
- Foreign keys explicitas.
- Indices para consultas frequentes.
- Constraints para enums e invariantes.
- Policies RLS documentadas.
- Storage com paths iniciados por `user_id`.
- Tipos TypeScript gerados a partir do Supabase.
- Pre-requisitos de conteudos devem usar `study_topic_prerequisites`, nao arrays.
- Ciclos de pre-requisitos devem ser validados no dominio com testes.
- Sessoes de estudo devem usar `duration_seconds` e nao depender apenas de duracao enviada pelo client.

## Qualidade antes de concluir tarefas

Sempre que houver implementacao de codigo:

- executar lint;
- executar typecheck;
- executar testes relevantes;
- executar build quando aplicavel;
- atualizar documentacao afetada;
- informar pendencias e riscos.

## Ordem de desenvolvimento

Seguir o roadmap por fases. Nao avancar para funcionalidades de fases futuras sem aprovacao explicita.

Fase atual apos estes documentos: aguardar validacao e entao executar somente a Fase 0.
