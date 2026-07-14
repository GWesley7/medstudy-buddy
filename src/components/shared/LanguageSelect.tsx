import { useI18n } from "@/lib/i18n/useI18n";
import { supportedLocales, type Locale } from "@/lib/i18n/translations";

export function LanguageSelect() {
  const { locale, setLocale, t } = useI18n();

  return (
    <label className="grid gap-1 text-xs font-medium text-muted-foreground">
      <span>{t("language.label")}</span>
      <select
        aria-label={t("language.label")}
        className="h-9 rounded-md border border-input bg-background px-2 text-sm text-foreground shadow-sm outline-none focus-visible:ring-2 focus-visible:ring-ring"
        onChange={(event) => setLocale(event.target.value as Locale)}
        value={locale}
      >
        {supportedLocales.map((supportedLocale) => (
          <option key={supportedLocale} value={supportedLocale}>
            {t(`language.${supportedLocale}`)}
          </option>
        ))}
      </select>
    </label>
  );
}
