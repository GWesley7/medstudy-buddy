import {
  BarChart3,
  BookOpen,
  CalendarDays,
  CreditCard,
  FileText,
  LayoutDashboard,
  Menu,
  Settings,
  Timer,
  X,
} from "lucide-react";
import { useState } from "react";
import { NavLink, Outlet } from "react-router-dom";
import { LanguageSelect } from "@/components/shared/LanguageSelect";
import { ThemeToggle } from "@/components/shared/ThemeToggle";
import { Button } from "@/components/ui/button";
import { useI18n } from "@/lib/i18n/useI18n";

const navigationItems = [
  { icon: LayoutDashboard, labelKey: "nav.dashboard", to: "/" },
  { icon: FileText, labelKey: "nav.exams", to: "/exams" },
  { icon: CalendarDays, labelKey: "nav.schedule", to: "/schedule" },
  { icon: BookOpen, labelKey: "nav.flashcards", to: "/flashcards" },
  { icon: Timer, labelKey: "nav.focus", to: "/focus" },
  { icon: BarChart3, labelKey: "nav.progress", to: "/progress" },
  { icon: CreditCard, labelKey: "nav.subscription", to: "/subscription" },
  { icon: Settings, labelKey: "nav.settings", to: "/settings" },
] as const;

export function AppShell() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { t } = useI18n();

  return (
    <div className="min-h-screen bg-background text-foreground">
      <a
        className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:rounded-md focus:bg-primary focus:px-3 focus:py-2 focus:text-primary-foreground"
        href="#main-content"
      >
        {t("app.skipToContent")}
      </a>

      <aside className="fixed inset-y-0 left-0 hidden w-72 border-r bg-card lg:block">
        <SidebarContent />
      </aside>

      <header className="sticky top-0 z-30 border-b bg-background/95 backdrop-blur lg:pl-72">
        <div className="flex min-h-16 items-center justify-between gap-3 px-4 sm:px-6">
          <div className="flex items-center gap-3">
            <Button
              aria-label={t("nav.openMenu")}
              className="lg:hidden"
              onClick={() => setIsMobileMenuOpen(true)}
              size="sm"
              type="button"
              variant="outline"
            >
              <Menu className="size-4" aria-hidden="true" />
            </Button>
            <div>
              <p className="text-sm font-medium text-muted-foreground">
                {t("app.name")}
              </p>
              <h1 className="text-lg font-semibold tracking-tight">
                {t("app.phase")}
              </h1>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <LanguageSelect />
            <ThemeToggle />
          </div>
        </div>
      </header>

      {isMobileMenuOpen ? (
        <div className="fixed inset-0 z-40 lg:hidden">
          <button
            aria-label={t("nav.closeMenu")}
            className="absolute inset-0 bg-background/70 backdrop-blur-sm"
            onClick={() => setIsMobileMenuOpen(false)}
            type="button"
          />
          <div className="relative h-full w-80 max-w-[calc(100vw-2rem)] border-r bg-card shadow-lg">
            <div className="flex justify-end p-3">
              <Button
                aria-label={t("nav.closeMenu")}
                onClick={() => setIsMobileMenuOpen(false)}
                size="sm"
                type="button"
                variant="ghost"
              >
                <X className="size-4" aria-hidden="true" />
              </Button>
            </div>
            <SidebarContent onNavigate={() => setIsMobileMenuOpen(false)} />
          </div>
        </div>
      ) : null}

      <main
        className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:ml-72"
        id="main-content"
      >
        <Outlet />
      </main>
    </div>
  );
}

function SidebarContent({ onNavigate }: { onNavigate?: () => void }) {
  const { t } = useI18n();

  return (
    <div className="flex h-full flex-col gap-6 p-5">
      <div className="rounded-lg border bg-background p-4">
        <p className="text-sm font-medium text-muted-foreground">
          {t("common.phaseBadge")}
        </p>
        <p className="mt-1 text-xl font-semibold">{t("app.name")}</p>
      </div>

      <nav aria-label="Navegacao principal" className="grid gap-1">
        {navigationItems.map(({ icon: Icon, labelKey, to }) => (
          <NavLink
            className={({ isActive }) =>
              [
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition",
                isActive
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:bg-secondary hover:text-secondary-foreground",
              ].join(" ")
            }
            end={to === "/"}
            key={to}
            onClick={onNavigate}
            to={to}
          >
            <Icon className="size-4" aria-hidden="true" />
            {t(labelKey)}
          </NavLink>
        ))}
      </nav>
    </div>
  );
}
