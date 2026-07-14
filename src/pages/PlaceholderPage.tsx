import { HomeLink } from "@/app/router/AppRouter";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useI18n } from "@/lib/i18n/useI18n";
import type { TranslationKey } from "@/lib/i18n/translations";

export default function PlaceholderPage({
  descriptionKey,
  titleKey,
}: {
  descriptionKey: TranslationKey;
  titleKey: TranslationKey;
}) {
  const { t } = useI18n();

  return (
    <section className="space-y-5">
      <Card>
        <CardHeader>
          <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
            {t("common.phaseBadge")}
          </p>
          <CardTitle className="text-3xl">{t(titleKey)}</CardTitle>
          <CardDescription>{t(descriptionKey)}</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm text-muted-foreground">{t("common.future")}</p>
          <HomeLink />
        </CardContent>
      </Card>
    </section>
  );
}
