import {
  useCallback,
  useEffect,
  useMemo,
  useState,
  type PropsWithChildren,
} from "react";
import { I18nContext, type I18nContextValue } from "@/lib/i18n/i18nContext";
import {
  defaultLocale,
  supportedLocales,
  translations,
  type Locale,
} from "@/lib/i18n/translations";

const languageStorageKey = "medstudy-language";

function isSupportedLocale(value: string): value is Locale {
  return supportedLocales.some((locale) => locale === value);
}

function detectInitialLocale(): Locale {
  if (typeof window === "undefined") {
    return defaultLocale;
  }

  const storedLocale = window.localStorage.getItem(languageStorageKey);
  if (storedLocale && isSupportedLocale(storedLocale)) {
    return storedLocale;
  }

  const browserLocale = window.navigator.language;
  if (isSupportedLocale(browserLocale)) {
    return browserLocale;
  }

  const shortBrowserLocale = browserLocale.split("-")[0];
  if (shortBrowserLocale === "pt") {
    return "pt-BR";
  }

  if (shortBrowserLocale && isSupportedLocale(shortBrowserLocale)) {
    return shortBrowserLocale;
  }

  return defaultLocale;
}

export function I18nProvider({ children }: PropsWithChildren) {
  const [locale, setLocaleState] = useState<Locale>(detectInitialLocale);

  const setLocale = useCallback((nextLocale: Locale) => {
    setLocaleState(nextLocale);
    window.localStorage.setItem(languageStorageKey, nextLocale);
  }, []);

  useEffect(() => {
    document.documentElement.lang = locale;
  }, [locale]);

  const value = useMemo<I18nContextValue>(() => {
    return {
      locale,
      setLocale,
      t: (key) => translations[locale][key] ?? translations[defaultLocale][key],
    };
  }, [locale, setLocale]);

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}
