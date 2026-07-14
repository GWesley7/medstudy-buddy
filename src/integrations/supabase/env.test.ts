import { describe, expect, it } from "vitest";
import { validateSupabaseEnv } from "@/integrations/supabase/env";

describe("validateSupabaseEnv", () => {
  it("accepts a valid Supabase environment shape", () => {
    expect(
      validateSupabaseEnv({
        VITE_SUPABASE_URL: "https://example.supabase.co",
        VITE_SUPABASE_PUBLISHABLE_KEY: "publishable-key",
      }),
    ).toEqual({
      VITE_SUPABASE_URL: "https://example.supabase.co",
      VITE_SUPABASE_PUBLISHABLE_KEY: "publishable-key",
    });
  });

  it("rejects missing required values without exposing secrets", () => {
    expect(() => validateSupabaseEnv({})).toThrow(
      "Invalid Supabase environment configuration",
    );
  });

  it("adds setup guidance in development without including values", () => {
    expect(() =>
      validateSupabaseEnv(
        {
          VITE_SUPABASE_URL: "not-a-url",
          VITE_SUPABASE_PUBLISHABLE_KEY: "",
        },
        { mode: "development" },
      ),
    ).toThrow(".env.local");
  });
});
