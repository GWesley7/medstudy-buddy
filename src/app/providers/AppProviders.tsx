import type { PropsWithChildren } from "react";
import { Toaster } from "sonner";
import { I18nProvider } from "@/lib/i18n/I18nProvider";
import { QueryProvider } from "@/app/providers/QueryProvider";
import { ThemeProvider } from "@/app/providers/ThemeProvider";

export function AppProviders({ children }: PropsWithChildren) {
  return (
    <QueryProvider>
      <ThemeProvider>
        <I18nProvider>
          {children}
          <Toaster richColors />
        </I18nProvider>
      </ThemeProvider>
    </QueryProvider>
  );
}
