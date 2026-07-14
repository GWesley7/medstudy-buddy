import { HomeLink } from "@/app/router/AppRouter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { useI18n } from "@/lib/i18n/useI18n";

export default function NotFoundPage() {
  const { t } = useI18n();

  return (
    <section>
      <Card>
        <CardHeader>
          <CardTitle className="text-3xl">{t("notFound.title")}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-muted-foreground">{t("notFound.description")}</p>
          <HomeLink />
        </CardContent>
      </Card>
    </section>
  );
}
