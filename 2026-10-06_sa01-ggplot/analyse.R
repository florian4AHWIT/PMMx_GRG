# SA-01 — Daten visualisieren mit ggplot2
# Läuft komplett durch: Ctrl+Shift+S

library(tidyverse)
library(palmerpenguins)

dir.create("plots", showWarnings = FALSE, recursive = TRUE)

# ---------------------------------------------------------------------------
# 1. Setup + erstes Ritual
# ---------------------------------------------------------------------------
glimpse(penguins)
# 344 Zeilen, 8 Spalten; species: factor; body_mass_g: integer

# ---------------------------------------------------------------------------
# 2. Die Grammatik übertragen (Zielbild der Stunde)
# ---------------------------------------------------------------------------
p_ziel <- ggplot(penguins,
                 aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(x = "Flossengröße (mm)", y = "Körpermasse (g)")
if (interactive()) print(p_ziel)  # in RStudio anzeigen
ggsave("plots/02_zielplot.png", p_ziel, width = 7, height = 5, dpi = 120)

# Korrelation je Art (Beleg für die Antwort)
penguins |>
  drop_na(body_mass_g, flipper_length_mm) |>
  group_by(species) |>
  summarise(r = cor(flipper_length_mm, body_mass_g), .groups = "drop")

# ---------------------------------------------------------------------------
# 3a. Vorhersage: Farbe außen vs. innen in aes()
# ---------------------------------------------------------------------------
p_rot <- ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_point(color = "red")
p_arten <- ggplot(penguins, aes(x = species, y = body_mass_g, color = species)) +
  geom_point()
if (interactive()) { print(p_rot); print(p_arten) }
ggsave("plots/03a_alle_rot.png", p_rot, width = 7, height = 5, dpi = 120)
ggsave("plots/03a_nach_art.png", p_arten, width = 7, height = 5, dpi = 120)

# ---------------------------------------------------------------------------
# 3b. `+` am Zeilenanfang — Fehler absichtlich abfangen
# ---------------------------------------------------------------------------
fehler <- tryCatch({
  ggplot(penguins, aes(x = body_mass_g))
  + geom_histogram(binwidth = 250)
  "kein Fehler"
}, error = function(e) conditionMessage(e))
cat("3b Fehlermeldung:", fehler, "\n")
# "Cannot use `+` with a single argument." — R sieht die zweite Zeile als
# eigenen Ausdruck; das + hat links keinen Operanden.

# ---------------------------------------------------------------------------
# 4. Eigene Frage: Schnabellänge vs. Körpermasse, nach Art
# ---------------------------------------------------------------------------
p_eigen <- ggplot(penguins,
                  aes(x = bill_length_mm, y = body_mass_g, color = species)) +
  geom_point(alpha = 0.75) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
  labs(x = "Schnabellänge (mm)", y = "Körpermasse (g)",
       color = "Art",
       title = "Zusammenhang von Schnabellänge und Körpermasse")
if (interactive()) print(p_eigen)  # in RStudio anzeigen
ggsave("plots/04_eigene_frage.png", p_eigen, width = 7, height = 5, dpi = 120)

cat("\nSA-01: Skript vollständig durchgelaufen.\n")
