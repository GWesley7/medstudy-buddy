import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, it } from "vitest";
import { App } from "@/app/App";
import { renderWithProviders } from "@/test/renderWithProviders";

describe("App", () => {
  beforeEach(() => {
    window.localStorage.clear();
    window.localStorage.setItem("medstudy-language", "pt-BR");
    window.history.pushState({}, "", "/");
    document.documentElement.className = "";
  });

  it("renders the dashboard placeholder", async () => {
    renderWithProviders(<App />);

    expect(
      await screen.findByRole(
        "heading",
        { name: /dashboard/i },
        { timeout: 5_000 },
      ),
    ).toBeInTheDocument();
  });

  it("renders the not found page for unknown routes", async () => {
    window.history.pushState({}, "", "/unknown-route");
    renderWithProviders(<App />);

    expect(
      await screen.findByRole("heading", { name: /pagina nao encontrada/i }),
    ).toBeInTheDocument();
  });

  it("changes the active language", async () => {
    const user = userEvent.setup();
    renderWithProviders(<App />);

    await user.selectOptions(await screen.findByLabelText(/idioma/i), "en");

    expect(
      await screen.findByRole("heading", { name: /dashboard/i }),
    ).toBeInTheDocument();
    expect(screen.getByText(/technical foundation/i)).toBeInTheDocument();
  });

  it("toggles between light and dark themes", async () => {
    const user = userEvent.setup();
    renderWithProviders(<App />);

    await user.click(await screen.findByRole("button", { name: /escuro/i }));

    expect(document.documentElement).toHaveClass("dark");
  });
});
