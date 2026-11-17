# KM7-01 — Mittelwertsvergleich: z-Test und t-Test
# Setup-Ritual: RStudio-Projekt pmm-km7-01, alles in analyse.R

library(tidyverse)

daten <- read_csv("daten/betriebsdaten.csv", show_col_types = FALSE)

# --- 1. Vorhersagen prüfen -------------------------------------------------
cat("=== 1. Gültige Messungen und Mittelwerte ===\n")
kennzahlen <- daten |>
  group_by(maschine) |>
  summarise(n = sum(!is.na(masse_mm)),
            mittel = mean(masse_mm, na.rm = TRUE),
            sd = sd(masse_mm, na.rm = TRUE),
            .groups = "drop")
print(kennzahlen)
# M1 37 / 10,0005 / 0,0315 · M2 39 / 9,9769 / 0,0400 · M3 40 / 10,0627 / 0,0696
# Größter Abstand zum Sollmaß: M3 mit +0,0627 mm (ca. 6 Hundertstel).

# --- 2. Ungepaarter Vergleich M1 gegen M3 (Welch) -------------------------
cat("\n=== 2. Welch-t-Test M1 vs M3 ===\n")
vergleich <- daten |> filter(maschine %in% c("M1", "M3"))
t13 <- t.test(masse_mm ~ maschine, data = vergleich)
print(t13)
# H0: mu_M1 = mu_M3   H1: mu_M1 != mu_M3
# t = -5,1132 · df = 55,272 · p = 4,092e-06
# 95-%-CI (M1 - M3): [-0,08659 ; -0,03783] mm
# M3 liegt also mindestens 0,0378 mm und höchstens 0,0866 mm über M1.
# Das ganze Intervall liegt innerhalb der Toleranz von +/- 0,15 mm.

# Vergleich M1 vs M2 (für Aufgabe 5)
t12 <- t.test(masse_mm ~ maschine,
              data = daten |> filter(maschine %in% c("M1", "M2")))
cat("M1 vs M2 p =", format.pval(t12$p.value), "\n")

# --- 3. Gepaarter Vergleich der Chargenmittel -----------------------------
cat("\n=== 3. Gepaarter t-Test (Chargenmittel M3 vs M1) ===\n")
chargen <- daten |>
  group_by(maschine, charge) |>
  summarise(mm = mean(masse_mm, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = maschine, values_from = mm)

diff <- chargen$M3 - chargen$M1
cat("Differenzen:", paste(round(diff, 6), collapse = ", "), "\n")
cat("positiv:", sum(diff > 0), " negativ:", sum(diff < 0), "\n")

t_paart <- t.test(chargen$M3, chargen$M1, paired = TRUE)
print(t_paart)
# t = 5,9822 · df = 9 · p = 0,000207

# 3d: t von Hand nachrechnen
t_differenzen <- mean(diff) / (sd(diff) / sqrt(length(diff)))
s <- kennzahlen |> filter(maschine == "M1")
se_messwerte <- sqrt(kennzahlen$sd[1]^2 / kennzahlen$n[1] +
                     kennzahlen$sd[3]^2 / kennzahlen$n[3])
t_messwerte <- (kennzahlen$mittel[1] - kennzahlen$mittel[3]) / se_messwerte
cat("t über Differenzen:", t_differenzen, "\n")
cat("t über Messwerte  :", t_messwerte, "\n")
# Nur der Wert über die Differenzen (5,9822) stimmt mit R überein.
# Der gepaarte Test nutzt die Streuung der 10 Differenzen (0,0335), nicht
# die Streuung der Einzelmessungen — die Chargenstreuung fällt heraus.

cat("\nKM7-01: Skript vollständig durchgelaufen.\n")
