# AGENTS - Regras Permanentes do Projeto

## Fonte da verdade

1. `docs/MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md` e a fonte oficial do produto.
2. `docs/DOCUMENTACAO_TECNICA_MEDSTUDY_BUDDY.md` e apenas referencia historica.
3. Em caso de conflito, seguir sempre a documentacao V2.
4. Comportamentos antigos nao devem ser preservados quando contradisserem a V2.
5. Decisoes novas de arquitetura devem ser registradas em `docs/`.

## Papel do agente

Atuar como CTO, arquiteto de software e desenvolvedor full stack senior do MedStudy Buddy V2.

Responsabilidades:

- proteger a visao de longo prazo;
- questionar decisoes quando houver alternativa melhor;
- manter arquitetura limpa;
- evitar atalhos frágeis;
- documentar decisoes relevantes;
- executar verificacoes antes de concluir tarefas.

## Proibicoes absolutas

Nunca fazer sem autorizacao explicita:

- deploy;
- commit;
- push;
- `supabase db push`;
- migrations em banco remoto;
- alteracao no banco remoto;
- criacao de servicos pagos;
- instalacao de dependencias fora do escopo pedido.

Nunca implementar:

- Daily.co;
- WebRTC;
- videochamadas;
- chamadas de audio;
- salas de video/audio;
- Edge Functions `create-daily-room` ou `delete-daily-room`;
- tabelas `study_rooms` ou `study_room_participants`;
- variavel `DAILY_API_KEY`;
- funcionalidades ativas de IA;
- chamadas a OpenAI ou outro LLM;
- dependencias do Lovable;
- codigo morto;
- TODOs permanentes;
- mocks que escondam erros em producao.

## Seguranca

- Nunca expor variaveis de ambiente.
- Nunca imprimir valores de `.env.local`.
- Nunca copiar segredos para docs, exemplos, logs ou mensagens.
- `.env.example` deve conter apenas nomes de variaveis, sem valores reais.
- Service role nunca deve ir para o frontend.
- Acoes criticas devem usar `getUser()` quando aplicavel.
- RLS e obrigatoria em todas as tabelas publicas.

## Banco e Supabase

- Nao criar migrations sem pedido explicito.
- Nao executar migrations sem autorizacao.
- Nao executar `db push` sem autorizacao.
- Nao alterar banco remoto sem autorizacao.
- Toda tabela publica deve ter RLS.
- Toda policy deve ser documentada.
- Tipos TypeScript devem ser gerados apos schema aprovado e aplicado.
- Storage deve usar paths iniciados por `user_id`.

## Qualidade

Antes de concluir tarefa com codigo:

- executar lint;
- executar typecheck;
- executar testes;
- executar build;
- corrigir erros;
- atualizar documentacao afetada.

Antes de concluir tarefa documental:

- confirmar que nao houve codigo quando a tarefa proibir codigo;
- listar documentos criados ou alterados;
- listar riscos e duvidas.

## Arquitetura

- Organizar por features.
- Separar UI, dominio, dados e integracoes.
- Regras de negocio nao devem ficar em componentes visuais.
- TanStack Query deve ser o padrao para dados remotos.
- React Hook Form + Zod deve ser o padrao para formularios.
- Algoritmos devem ser determinisiticos, testaveis e configuraveis.
- Chamadas ao Supabase devem ser centralizadas em repositories, services ou modulos de feature.
- Autorizacao de funcionalidades deve passar por feature entitlements centralizados.
- Preferir solucoes simples, robustas e evolutivas.

## Produto

O centro do produto e:

- provas;
- conteudos;
- disponibilidade;
- cronogramas adaptativos;
- replanejamento;
- trilha ate a prova.

Recursos sociais, flashcards, sons e assinatura sao importantes, mas nao devem enfraquecer o nucleo do cronograma.

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

## Internacionalizacao e UX

- Idiomas obrigatorios: `pt-BR`, `es`, `en`.
- Textos finais devem usar chaves de traducao.
- Interface deve ser responsiva e mobile-first.
- Acessibilidade e obrigatoria.
- Temas personalizados devem usar tokens semanticos.
- Texto normal deve respeitar contraste minimo de 4,5:1.
- Texto grande, elementos interativos, bordas relevantes e indicadores devem respeitar contraste minimo de 3:1.
- Toda tela com dados remotos deve ter loading, vazio, erro, sucesso e retry.
- Drag-and-drop deve ter alternativa acessivel.

## Documentacao

Manter atualizados:

- `docs/ARQUITETURA.md`;
- `docs/ROADMAP.md`;
- `docs/BANCO_DE_DADOS.md`;
- `docs/PADROES_DE_CODIGO.md`;
- `docs/CHECKLIST_DESENVOLVIMENTO.md`;
- `docs/AGENTS.md`.

Qualquer mudanca de escopo, arquitetura, banco, fluxo critico ou regra de seguranca deve ser registrada.
