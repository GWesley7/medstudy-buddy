export const supportedLocales = ["pt-BR", "es", "en"] as const;

export type Locale = (typeof supportedLocales)[number];

export const defaultLocale: Locale = "pt-BR";

export const translations = {
  "pt-BR": {
    "app.name": "MedStudy Buddy",
    "app.phase": "Fundacao tecnica",
    "app.skipToContent": "Pular para o conteudo",
    "nav.dashboard": "Dashboard",
    "nav.exams": "Provas",
    "nav.schedule": "Cronograma",
    "nav.flashcards": "Flashcards",
    "nav.focus": "Foco",
    "nav.progress": "Progresso",
    "nav.subscription": "Assinatura",
    "nav.settings": "Configuracoes",
    "nav.openMenu": "Abrir menu",
    "nav.closeMenu": "Fechar menu",
    "common.phaseBadge": "Placeholder da Fase 2",
    "common.future": "Funcionalidade sera implementada em fase posterior.",
    "common.backDashboard": "Voltar ao dashboard",
    "language.label": "Idioma",
    "language.pt-BR": "Portugues",
    "language.es": "Espanhol",
    "language.en": "Ingles",
    "theme.label": "Tema",
    "theme.light": "Claro",
    "theme.dark": "Escuro",
    "theme.system": "Sistema",
    "dashboard.title": "Dashboard",
    "dashboard.description":
      "Resumo inicial para validar navegacao, tema, idioma e estrutura do produto.",
    "dashboard.currentDate": "Data de referencia",
    "dashboard.today": "Plano de hoje",
    "dashboard.todayDescription":
      "Espaco reservado para as sessoes planejadas do dia.",
    "dashboard.exam": "Proxima prova",
    "dashboard.examDescription":
      "Aqui aparecera a prova prioritaria quando o dominio for implementado.",
    "dashboard.focus": "Foco individual",
    "dashboard.focusDescription":
      "Pomodoro e sons ambientes serao conectados as tarefas em fase futura.",
    "exams.title": "Provas",
    "exams.description":
      "Gestao de provas sera implementada depois da fundacao tecnica.",
    "schedule.title": "Cronograma",
    "schedule.description":
      "O cronograma adaptativo sera construido sem IA nas proximas fases.",
    "flashcards.title": "Flashcards",
    "flashcards.description":
      "Decks, cartoes e revisao espacada entram em fase posterior.",
    "focus.title": "Foco",
    "focus.description":
      "Modo de foco individual sera tarefa, Pomodoro e sons, sem salas ou chamadas.",
    "progress.title": "Progresso",
    "progress.description":
      "Metricas reais serao calculadas a partir de tarefas e sessoes persistidas.",
    "subscription.title": "Assinatura",
    "subscription.description":
      "Trial, assinatura e entitlements serao preparados sem pagamento real nesta etapa.",
    "settings.title": "Configuracoes",
    "settings.description":
      "Preferencias, idioma e tema ficarao centralizados nesta area.",
    "notFound.title": "Pagina nao encontrada",
    "notFound.description": "A rota solicitada nao existe nesta fundacao.",
  },
  es: {
    "app.name": "MedStudy Buddy",
    "app.phase": "Fundacion tecnica",
    "app.skipToContent": "Saltar al contenido",
    "nav.dashboard": "Panel",
    "nav.exams": "Examenes",
    "nav.schedule": "Cronograma",
    "nav.flashcards": "Flashcards",
    "nav.focus": "Foco",
    "nav.progress": "Progreso",
    "nav.subscription": "Suscripcion",
    "nav.settings": "Configuracion",
    "nav.openMenu": "Abrir menu",
    "nav.closeMenu": "Cerrar menu",
    "common.phaseBadge": "Placeholder de la Fase 2",
    "common.future": "La funcionalidad se implementara en una fase posterior.",
    "common.backDashboard": "Volver al panel",
    "language.label": "Idioma",
    "language.pt-BR": "Portugues",
    "language.es": "Espanol",
    "language.en": "Ingles",
    "theme.label": "Tema",
    "theme.light": "Claro",
    "theme.dark": "Oscuro",
    "theme.system": "Sistema",
    "dashboard.title": "Panel",
    "dashboard.description":
      "Resumen inicial para validar navegacion, tema, idioma y estructura del producto.",
    "dashboard.currentDate": "Fecha de referencia",
    "dashboard.today": "Plan de hoy",
    "dashboard.todayDescription":
      "Espacio reservado para las sesiones planificadas del dia.",
    "dashboard.exam": "Proximo examen",
    "dashboard.examDescription":
      "Aqui aparecera el examen prioritario cuando se implemente el dominio.",
    "dashboard.focus": "Foco individual",
    "dashboard.focusDescription":
      "Pomodoro y sonidos ambientales se conectaran a las tareas en una fase futura.",
    "exams.title": "Examenes",
    "exams.description":
      "La gestion de examenes se implementara despues de la fundacion tecnica.",
    "schedule.title": "Cronograma",
    "schedule.description":
      "El cronograma adaptativo se construira sin IA en las proximas fases.",
    "flashcards.title": "Flashcards",
    "flashcards.description":
      "Mazos, tarjetas y repeticion espaciada entran en una fase posterior.",
    "focus.title": "Foco",
    "focus.description":
      "El foco individual sera tarea, Pomodoro y sonidos, sin salas ni llamadas.",
    "progress.title": "Progreso",
    "progress.description":
      "Las metricas reales se calcularan desde tareas y sesiones persistidas.",
    "subscription.title": "Suscripcion",
    "subscription.description":
      "Trial, suscripcion y entitlements se prepararan sin pago real en esta etapa.",
    "settings.title": "Configuracion",
    "settings.description":
      "Preferencias, idioma y tema quedaran centralizados en esta area.",
    "notFound.title": "Pagina no encontrada",
    "notFound.description": "La ruta solicitada no existe en esta fundacion.",
  },
  en: {
    "app.name": "MedStudy Buddy",
    "app.phase": "Technical foundation",
    "app.skipToContent": "Skip to content",
    "nav.dashboard": "Dashboard",
    "nav.exams": "Exams",
    "nav.schedule": "Schedule",
    "nav.flashcards": "Flashcards",
    "nav.focus": "Focus",
    "nav.progress": "Progress",
    "nav.subscription": "Subscription",
    "nav.settings": "Settings",
    "nav.openMenu": "Open menu",
    "nav.closeMenu": "Close menu",
    "common.phaseBadge": "Phase 2 placeholder",
    "common.future": "This feature will be implemented in a later phase.",
    "common.backDashboard": "Back to dashboard",
    "language.label": "Language",
    "language.pt-BR": "Portuguese",
    "language.es": "Spanish",
    "language.en": "English",
    "theme.label": "Theme",
    "theme.light": "Light",
    "theme.dark": "Dark",
    "theme.system": "System",
    "dashboard.title": "Dashboard",
    "dashboard.description":
      "Initial summary to validate navigation, theme, language, and product structure.",
    "dashboard.currentDate": "Reference date",
    "dashboard.today": "Today plan",
    "dashboard.todayDescription":
      "Reserved space for the planned sessions of the day.",
    "dashboard.exam": "Next exam",
    "dashboard.examDescription":
      "The priority exam will appear here once the domain is implemented.",
    "dashboard.focus": "Individual focus",
    "dashboard.focusDescription":
      "Pomodoro and ambient sounds will connect to tasks in a future phase.",
    "exams.title": "Exams",
    "exams.description":
      "Exam management will be implemented after the technical foundation.",
    "schedule.title": "Schedule",
    "schedule.description":
      "The adaptive schedule will be built without AI in the next phases.",
    "flashcards.title": "Flashcards",
    "flashcards.description":
      "Decks, cards, and spaced repetition will arrive in a later phase.",
    "focus.title": "Focus",
    "focus.description":
      "Individual focus will be task, Pomodoro, and sounds, with no rooms or calls.",
    "progress.title": "Progress",
    "progress.description":
      "Real metrics will be calculated from persisted tasks and sessions.",
    "subscription.title": "Subscription",
    "subscription.description":
      "Trial, subscription, and entitlements will be prepared without real payment at this stage.",
    "settings.title": "Settings",
    "settings.description":
      "Preferences, language, and theme will be centralized in this area.",
    "notFound.title": "Page not found",
    "notFound.description":
      "The requested route does not exist in this foundation.",
  },
} as const;

export type TranslationKey = keyof (typeof translations)[typeof defaultLocale];
