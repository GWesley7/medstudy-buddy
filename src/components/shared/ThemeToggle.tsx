import { Monitor, Moon, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { useI18n } from "@/lib/i18n/useI18n";

const themeOptions = [
  { icon: Sun, value: "light" },
  { icon: Moon, value: "dark" },
  { icon: Monitor, value: "system" },
] as const;

type ThemeValue = (typeof themeOptions)[number]["value"];

export function ThemeToggle() {
  const { setTheme, theme = "system" } = useTheme();
  const { t } = useI18n();
  const [mounted, setMounted] = useState(false);

  useEffect(() => setMounted(true), []);

  if (!mounted) {
    return <div className="h-9 w-[8.25rem]" aria-hidden="true" />;
  }

  return (
    <fieldset className="grid gap-1">
      <legend className="text-xs font-medium text-muted-foreground">
        {t("theme.label")}
      </legend>
      <div className="flex rounded-md border border-border bg-card p-1">
        {themeOptions.map(({ icon: Icon, value }) => {
          const isActive = theme === value;

          return (
            <Button
              aria-label={t(`theme.${value}`)}
              aria-pressed={isActive}
              className="size-8 p-0"
              key={value}
              onClick={() => setTheme(value satisfies ThemeValue)}
              size="sm"
              type="button"
              variant={isActive ? "default" : "ghost"}
            >
              <Icon className="size-4" aria-hidden="true" />
            </Button>
          );
        })}
      </div>
    </fieldset>
  );
}
