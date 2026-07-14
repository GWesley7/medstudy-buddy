# Checklist de Desenvolvimento - MedStudy Buddy V2

## Antes de iniciar uma tarefa

- [ ] Ler `docs/MEDSTUDY_BUDDY_V2_ESPECIFICACAO_CODEX.md` quando a tarefa envolver produto, arquitetura ou dominio.
- [ ] Verificar se a tarefa conflita com a documentacao V2.
- [ ] Confirmar a fase atual do `docs/ROADMAP.md`.
- [ ] Garantir que a tarefa nao avanca para fases futuras sem autorizacao.
- [ ] Verificar se havera impacto em banco, Supabase, deploy ou variaveis de ambiente.
- [ ] Pedir autorizacao antes de qualquer migration, `db push`, deploy ou acao remota sensivel.

## Durante a implementacao

- [ ] Manter escopo pequeno.
- [ ] Seguir a organizacao por feature.
- [ ] Colocar regra de negocio fora de componentes visuais.
- [ ] Usar TypeScript strict.
- [ ] Manter `noImplicitAny` habilitado.
- [ ] Manter `strictNullChecks` habilitado.
- [ ] Manter `noUncheckedIndexedAccess` habilitado quando viavel.
- [ ] Evitar `any`.
- [ ] Usar TanStack Query para dados remotos.
- [ ] Centralizar chamadas ao Supabase em repositories, services ou modulos de feature.
- [ ] Usar React Hook Form + Zod em formularios.
- [ ] Adicionar estados loading, erro, vazio, sucesso e retry quando houver dados remotos.
- [ ] Garantir acessibilidade basica.
- [ ] Nao expor valores de `.env.local`.
- [ ] Nao criar codigo relacionado a Daily.co, WebRTC ou IA ativa.
- [ ] Nao hardcode planos, nomes comerciais ou permissoes em paginas/componentes.

## Quando houver banco

- [ ] Criar migration pequena e revisavel.
- [ ] Validar a ordem de dependencia das migrations.
- [ ] Fazer revisao estatica do SQL.
- [ ] Incluir constraints.
- [ ] Incluir indices necessarios.
- [ ] Incluir RLS.
- [ ] Documentar policies.
- [ ] Revisar grants e revokes explicitamente.
- [ ] Planejar trial/assinatura de forma auditavel quando a tarefa tocar acesso protegido.
- [ ] Testar RLS.
- [ ] Nao usar `service_role` no frontend.
- [ ] Gerar tipos TypeScript apos aplicacao autorizada.
- [ ] Nunca executar `db push` sem autorizacao.
- [ ] Nunca modificar banco remoto sem autorizacao.

## Quando houver UI

- [ ] Verificar responsividade mobile, tablet e desktop.
- [ ] Garantir labels reais em formularios.
- [ ] Garantir foco visivel.
- [ ] Garantir contraste adequado.
- [ ] Validar temas personalizados com 4,5:1 para texto normal e 3:1 para texto grande/interativos/bordas relevantes.
- [ ] Garantir preview antes de salvar tema personalizado.
- [ ] Garantir restauracao do tema padrao quando houver personalizacao.
- [ ] Garantir que status nao dependam apenas de cor.
- [ ] Verificar textos longos em botoes, cards e tabelas.
- [ ] Usar chaves de traducao nos textos finais.

## Quando houver algoritmo

- [ ] Centralizar configuracoes.
- [ ] Cobrir regras com testes unitarios.
- [ ] Documentar entradas e saidas.
- [ ] Evitar efeitos colaterais ocultos.
- [ ] Explicar sobrecarga ao usuario.
- [ ] Preservar tarefas concluidas.
- [ ] Preservar tarefas bloqueadas.
- [ ] Registrar historico quando houver replanejamento.
- [ ] Validar ciclos quando houver pre-requisitos de conteudo.

## Quando houver assinatura, trial ou entitlements

- [ ] Usar planos internos `essential`, `pro`, `pro_ai`.
- [ ] Nao exibir nem implementar `pro_ai`.
- [ ] Nao criar checkout, cobranca, precos ou webhooks sem autorizacao.
- [ ] Iniciar trial apenas no primeiro login valido apos confirmacao de email.
- [ ] Garantir inicio de trial idempotente.
- [ ] Calcular fim do trial no backend ou banco.
- [ ] Nao apagar dados quando o trial expirar.
- [ ] Permitir login, configuracoes e assinatura apos expiracao.
- [ ] Bloquear funcionalidades protegidas por camada central de entitlements.
- [ ] Evitar condicoes espalhadas como `plan === "pro"`.

## Quando houver sessoes de estudo

- [ ] Persistir sessoes no Supabase.
- [ ] Sincronizar sessoes entre dispositivos.
- [ ] Usar `duration_seconds`.
- [ ] Nao depender apenas de duracao enviada pelo client.
- [ ] Validar `ended_at` posterior a `started_at`.
- [ ] Bloquear duracao negativa.
- [ ] Mitigar sessoes absurdamente longas.
- [ ] Avaliar regra para sessoes simultaneas conflitantes.

## Antes de concluir uma tarefa com codigo

- [ ] Executar `npm run format:check`.
- [ ] Executar `npm run lint`.
- [ ] Executar `npm run typecheck` se disponivel.
- [ ] Executar `npm run test:run`.
- [ ] Executar `npm run build`.
- [ ] Corrigir todos os erros.
- [ ] Atualizar documentacao afetada.
- [ ] Informar testes executados e resultados.
- [ ] Informar riscos e pendencias.

## Antes de concluir uma tarefa apenas documental

- [ ] Confirmar que nenhum codigo foi alterado.
- [ ] Confirmar que nenhuma dependencia foi instalada.
- [ ] Confirmar que Supabase e banco remoto nao foram alterados.
- [ ] Informar documentos criados ou alterados.
- [ ] Listar duvidas e riscos.

## Antes de commit

- [ ] Confirmar autorizacao explicita do usuario.
- [ ] Revisar `git status`.
- [ ] Garantir que `.env.local` e segredos nao estao versionados.
- [ ] Garantir que `dist`, `node_modules` e arquivos temporarios nao estao incluidos.
- [ ] Escrever mensagem clara e objetiva.
