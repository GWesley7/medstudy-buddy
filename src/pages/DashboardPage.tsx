import { CalendarDays, ClipboardList, Timer } from "lucide-react";
import { format } from "date-fns";
import type { Locale as DateFnsLocale } from "date-fns";
import { enUS, es, ptBR } from "date-fns/locale";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useI18n } from "@/lib/i18n/useI18n";
import type { Locale as AppLocale } from "@/lib/i18n/translations";

const dateLocales: Record<AppLocale, DateFnsLocale> = {
  "pt-BR": ptBR,
  es,
  en: enUS,
};

const dashboardCards = [
  {
    descriptionKey: "dashboard.todayDescription",
    icon: ClipboardList,
    titleKey: "dashboard.today",
  },
  {
    descriptionKey: "dashboard.examDescription",
    icon: CalendarDays,
    titleKey: "dashboard.exam",
  },
  {
    descriptionKey: "dashboard.focusDescription",
    icon: Timer,
    titleKey: "dashboard.focus",
  },
] as const;

export default function DashboardPage() {
  const { locale, t } = useI18n();
  const formattedDate = format(new Date(), "PPP", {
    locale: dateLocales[locale],
  });

  return (
    <section className="space-y-8">
      <div className="space-y-3">
        <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          {t("common.phaseBadge")}
        </p>
        <h2 className="text-3xl font-semibold tracking-tight sm:text-4xl">
          {t("dashboard.title")}
        </h2>
        <p className="max-w-2xl text-muted-foreground">
          {t("dashboard.description")}
        </p>
        <p className="text-sm text-muted-foreground">
          {t("dashboard.currentDate")}: {formattedDate}
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        {dashboardCards.map(({ descriptionKey, icon: Icon, titleKey }) => (
          <Card key={titleKey}>
            <CardHeader>
              <div className="mb-3 flex size-10 items-center justify-center rounded-md bg-primary/10 text-primary">
                <Icon aria-hidden="true" className="size-5" />
              </div>
              <CardTitle>{t(titleKey)}</CardTitle>
              <CardDescription>{t(descriptionKey)}</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-muted-foreground">
                {t("common.future")}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>
    </section>
  );
}
