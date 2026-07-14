import { z } from "zod";

type SupabaseEnvSource = Record<string, string | boolean | undefined>;

type ValidateSupabaseEnvOptions = {
  mode?: string;
};

const supabaseEnvSchema = z.object({
  VITE_SUPABASE_URL: z.string().url("VITE_SUPABASE_URL must be a valid URL."),
  VITE_SUPABASE_PUBLISHABLE_KEY: z
    .string()
    .min(1, "VITE_SUPABASE_PUBLISHABLE_KEY is required."),
});

export type SupabaseEnv = z.infer<typeof supabaseEnvSchema>;

export function validateSupabaseEnv(
  source: SupabaseEnvSource,
  options: ValidateSupabaseEnvOptions = {},
): SupabaseEnv {
  const result = supabaseEnvSchema.safeParse({
    VITE_SUPABASE_URL: source.VITE_SUPABASE_URL,
    VITE_SUPABASE_PUBLISHABLE_KEY: source.VITE_SUPABASE_PUBLISHABLE_KEY,
  });

  if (!result.success) {
    const invalidKeys = result.error.issues
      .map((issue) => {
        const key = issue.path.join(".");
        return key ? `${key}: ${issue.message}` : issue.message;
      })
      .join("; ");

    const developmentHint =
      options.mode === "development"
        ? " Configure .env.local with VITE_SUPABASE_URL and VITE_SUPABASE_PUBLISHABLE_KEY. Do not commit real values."
        : "";

    throw new Error(
      `Invalid Supabase environment configuration: ${invalidKeys}.${developmentHint}`,
    );
  }

  return result.data;
}
