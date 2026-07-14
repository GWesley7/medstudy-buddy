import { ThemeProvider as NextThemeProvider } from "next-themes";
import type { PropsWithChildren } from "react";

export function ThemeProvider({ children }: PropsWithChildren) {
  return (
    <NextThemeProvider
      attribute="class"
      defaultTheme="system"
      disableTransitionOnChange
      enableSystem
      storageKey="medstudy-theme"
    >
      {children}
    </NextThemeProvider>
  );
}
