import { lazy, Suspense, useMemo } from "react";
import { createBrowserRouter, Link, RouterProvider } from "react-router-dom";
import { AppShell } from "@/components/layout/AppShell";
import { RouteFallback } from "@/components/shared/RouteFallback";
import { useI18n } from "@/lib/i18n/useI18n";

const DashboardPage = lazy(() => import("@/pages/DashboardPage"));
const PlaceholderPage = lazy(() => import("@/pages/PlaceholderPage"));
const NotFoundPage = lazy(() => import("@/pages/NotFoundPage"));

function createAppRouter() {
  return createBrowserRouter([
    {
      element: <AppShell />,
      children: [
        { path: "/", element: <DashboardPage /> },
        {
          path: "/exams",
          element: (
            <PlaceholderPage
              descriptionKey="exams.description"
              titleKey="exams.title"
            />
          ),
        },
        {
          path: "/schedule",
          element: (
            <PlaceholderPage
              descriptionKey="schedule.description"
              titleKey="schedule.title"
            />
          ),
        },
        {
          path: "/flashcards",
          element: (
            <PlaceholderPage
              descriptionKey="flashcards.description"
              titleKey="flashcards.title"
            />
          ),
        },
        {
          path: "/focus",
          element: (
            <PlaceholderPage
              descriptionKey="focus.description"
              titleKey="focus.title"
            />
          ),
        },
        {
          path: "/progress",
          element: (
            <PlaceholderPage
              descriptionKey="progress.description"
              titleKey="progress.title"
            />
          ),
        },
        {
          path: "/subscription",
          element: (
            <PlaceholderPage
              descriptionKey="subscription.description"
              titleKey="subscription.title"
            />
          ),
        },
        {
          path: "/settings",
          element: (
            <PlaceholderPage
              descriptionKey="settings.description"
              titleKey="settings.title"
            />
          ),
        },
        { path: "*", element: <NotFoundPage /> },
      ],
    },
  ]);
}

export function AppRouter() {
  const router = useMemo(() => createAppRouter(), []);

  return (
    <Suspense fallback={<RouteFallback />}>
      <RouterProvider router={router} />
    </Suspense>
  );
}

export function HomeLink() {
  const { t } = useI18n();

  return (
    <Link className="text-sm font-medium text-primary hover:underline" to="/">
      {t("common.backDashboard")}
    </Link>
  );
}
