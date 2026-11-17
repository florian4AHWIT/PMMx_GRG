# HÜ 2026-09-15: Setup-Prüfung (R, RStudio, Git, GitHub)
# Ausführen: Rscript setup-check.R  oder  Ctrl+Shift+S in RStudio

cat("R-Version:      ", R.version.string, "\n", sep = "")
cat("Plattform:      ", R.version$platform, "\n", sep = "")
cat("RStudio aktiv:  ", Sys.getenv("RSTUDIO") == "1", "\n", sep = "")

# Benötigte Pakete
pakete <- c("tidyverse", "palmerpenguins")
for (p in pakete) {
  cat(sprintf("%-16s %s\n", paste0(p, ":"), requireNamespace(p, quietly = TRUE)))
}

library(tidyverse)
library(palmerpenguins)

# Daten-Verifikation: erwartet 344 Zeilen, 8 Spalten
cat("\nglimpse(penguins):\n")
glimpse(penguins)
cat(sprintf("\nZeilen: %d  Spalten: %d\n", nrow(penguins), ncol(penguins)))
stopifnot(nrow(penguins) == 344, ncol(penguins) == 8)
cat("Daten-Verifikation: OK\n")

# Git-Konfiguration und Remote
cat("\nGit user.name:  ", system2("git", c("config", "--global", "user.name"), stdout = TRUE), "\n", sep = "")
cat("Git user.email: ", system2("git", c("config", "--global", "user.email"), stdout = TRUE), "\n", sep = "")
cat("Git remote:\n")
cat(system2("git", c("remote", "-v"), stdout = TRUE), sep = "\n")
