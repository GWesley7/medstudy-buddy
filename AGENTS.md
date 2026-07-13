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
- Evitar `any`; quando inevitavel, justificar localmente.
- Manter regras de negocio fora de componentes visuais.
- Usar TanStack Query para estado remoto.
- Usar React Hook Form e Zod para formularios.
- Usar migrations SQL versionadas.
- Aplicar RLS em todas as tabelas publicas.
- Validar dados no frontend e, quando houver fluxo sensivel, no server.
- Nunca expor segredos no frontend.
- Persistir sessoes de estudo no banco.
- Usar `localStorage` apenas para cache ou preferencias nao criticas.
- Criar testes para regras de dominio importantes.

## Regras de arquitetura

- Organizar codigo por features.
- Preferir componentes pequenos e reutilizaveis.
- Centralizar configuracoes de algoritmo.
- Centralizar validacoes.
- Centralizar integracoes externas.
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
- Persistir preferencias no banco.

## Banco de dados

- UUID como PK.
- Timestamps nas tabelas de dominio.
- Foreign keys explicitas.
- Indices para consultas frequentes.
- Constraints para enums e invariantes.
- Policies RLS documentadas.
- Storage com paths iniciados por `user_id`.
- Tipos TypeScript gerados a partir do Supabase.

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
