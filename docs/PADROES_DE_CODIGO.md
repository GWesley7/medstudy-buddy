# Padroes de Codigo - MedStudy Buddy V2

## 1. Principios obrigatorios

- Seguir a documentacao V2.
- TypeScript strict.
- `noImplicitAny` habilitado.
- `strictNullChecks` habilitado.
- `noUncheckedIndexedAccess` habilitado quando viavel.
- Sem `any` nao justificado.
- Clean Code.
- SOLID quando fizer sentido.
- DRY.
- KISS.
- Separation of Concerns.
- Componentizacao.
- Acessibilidade por padrao.
- Testabilidade desde a primeira implementacao.

## 2. Organizacao por feature

Cada dominio deve viver em `src/features/<feature>`.

Estrutura interna recomendada:

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

Nem toda feature precisa de todas as pastas. Criar apenas quando houver uso real.

## 3. Componentes

Regras:

- componentes devem ser pequenos;
- componentes visuais nao devem conter regra de negocio complexa;
- componentes de feature ficam dentro da feature;
- componentes compartilhados ficam em `components/shared`;
- primitives do design system ficam em `components/ui`;
- layout global fica em `components/layout`;
- usar props tipadas;
- evitar prop drilling excessivo.

## 4. Formularios

Padrao:

- React Hook Form;
- Zod;
- mensagens traduziveis;
- labels reais;
- erros acessiveis;
- estados disabled/loading durante submissao;
- validacao client-side e server-side quando sensivel.

## 5. Dados remotos

Padrao:

- TanStack Query para toda leitura remota;
- TanStack Query mutations para escrita remota;
- invalidacao explicita apos mutations;
- loading, erro, vazio, sucesso e retry em toda tela remota;
- nada de chamadas Supabase soltas dentro de componentes visuais.
- chamadas ao Supabase devem ficar centralizadas em repositories, services ou modulos de feature.

## 6. Servicos de dominio

Servicos devem:

- receber entradas explicitas;
- retornar dados tipados;
- nao depender de React;
- evitar acesso direto a UI;
- ser cobertos por testes quando contiverem regra relevante.

Exemplos:

- calculo de capacidade;
- geracao de cronograma;
- replanejamento;
- validacao de ciclos de pre-requisitos;
- repeticao espacada;
- validacao de contraste.

## 7. i18n

Idiomas obrigatorios:

- `pt-BR`;
- `es`;
- `en`.

Regras:

- nao escrever texto fixo de UI diretamente em componentes finais;
- usar chaves de traducao;
- datas e numeros devem respeitar locale;
- mensagens de erro e toasts devem ser traduziveis.

## 8. Estilo e UI

Regras:

- Tailwind CSS;
- shadcn/ui;
- Radix UI;
- Lucide React para icones;
- mobile-first;
- contraste adequado;
- temas personalizados devem usar tokens semanticos;
- cores escolhidas pelo usuario nao devem ser aplicadas diretamente em componentes;
- texto normal deve respeitar contraste minimo de 4,5:1;
- texto grande deve respeitar contraste minimo de 3:1;
- elementos interativos, bordas relevantes e indicadores importantes devem respeitar contraste minimo de 3:1;
- combinacoes invalidas devem ser rejeitadas;
- o sistema deve sugerir alternativa valida;
- deve existir preview antes de salvar tema personalizado;
- usuario deve conseguir restaurar o tema padrao;
- temas devem funcionar em light, dark e system;
- planejar utilitario central para calcular contraste, validar combinacoes, escolher foreground adequado, gerar preview e restaurar defaults;
- foco visivel;
- nao depender apenas de cor para status;
- respeitar `prefers-reduced-motion`;
- drag-and-drop deve ter alternativa acessivel.

## 9. Supabase

Regras:

- client centralizado;
- tipos gerados;
- nenhuma chave secreta no frontend;
- migrations pequenas;
- RLS em todas as tabelas publicas;
- policies documentadas;
- `getUser()` em acoes criticas;
- nao executar migrations sem autorizacao;
- nao executar `db push` sem autorizacao.
- pre-requisitos de conteudos devem usar tabela relacional, nao arrays;
- ciclos de pre-requisitos devem ser bloqueados na camada de dominio com testes.

## 10. Variaveis de ambiente

Regras:

- nunca imprimir valores reais;
- nunca copiar valores reais para docs ou exemplos;
- `.env.local` deve ficar ignorado;
- `.env.example` deve conter apenas nomes;
- service role nunca entra no frontend.

## 11. Testes

Usar:

- Vitest para dominio e utilitarios;
- React Testing Library para componentes;
- Playwright para E2E;
- pgTAP ou SQL tests para RLS.

Prioridades:

- algoritmo de cronograma;
- replanejamento;
- disponibilidade;
- RLS;
- autenticação;
- Pomodoro e sessoes;
- ciclos de pre-requisitos;
- validacao de contraste de temas;
- flashcards;
- fluxos principais do MVP.

## 12. Commits e alteracoes

Regras:

- nao fazer commit sem autorizacao;
- nao reverter alteracoes do usuario sem pedido explicito;
- manter mudancas pequenas e coerentes;
- atualizar documentacao junto de mudancas relevantes;
- nao deixar TODOs permanentes.

## 13. Proibicoes permanentes

Nao adicionar:

- Daily.co;
- WebRTC;
- videochamadas;
- chamadas de audio;
- tabelas de salas de video/audio;
- variavel `DAILY_API_KEY`;
- IA ativa;
- chamada a LLM;
- dependencias do Lovable;
- mocks que escondam erro em producao.

## 14. Trial, assinatura e feature entitlements

Nao ha plano gratuito permanente. O produto possui trial gratuito de 3 dias com acesso equivalente ao Pro.

Planos internos previstos:

- `essential`;
- `pro`;
- `pro_ai`.

Regras:

- `pro_ai` e reservado para o futuro;
- `pro_ai` nao deve ser exibido nem implementado agora;
- nao ha pagamento real no MVP inicial;
- nao implementar checkout, cobranca, precos ou webhooks nesta fase;
- nomes comerciais nao devem ser hardcoded;
- permissoes nao devem ser hardcoded em paginas ou componentes;
- componentes nao devem usar condicoes como `plan === "pro"`;
- autorizacao deve usar camada central de capacidades ou feature entitlements;
- planejar interfaces como `hasFeature`, `canAccessFeature` e `getCurrentEntitlements`.

Estados de assinatura previstos:

- `trialing`;
- `active`;
- `past_due`;
- `canceled`;
- `expired`;
- `paused`;
- `incomplete`.

Inicialmente podem ser usados:

- `trialing`;
- `active`;
- `expired`.

Regras de trial:

- iniciar no primeiro login valido apos confirmacao de email;
- ser idempotente;
- nao reiniciar ou prolongar por multiplos logins;
- calcular fim no backend ou banco;
- permitir login/configuracoes/assinatura apos expiracao;
- bloquear funcionalidades protegidas por camada central de entitlements;
- nao apagar dados do usuario ao fim do trial.

## 15. Autenticacao

Ordem obrigatoria do primeiro ciclo:

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

Depois disso, Google OAuth pode entrar na fase geral de autenticacao.

Facebook OAuth e Apple OAuth ficam fora do MVP inicial.
