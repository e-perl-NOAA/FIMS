#!/usr/bin/env bash
set -euo pipefail

command -v Rscript >/dev/null || {
  echo "Install R from https://cran.r-project.org/ before running this script." >&2
  exit 1
}
command -v julia >/dev/null || {
  echo "Install Julia 1.10 or later and add its bin directory to PATH." >&2
  exit 1
}

Rscript --vanilla -e '
  options(repos = c(CRAN = "https://cloud.r-project.org"))
  if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
  pak::pak(if (file.exists("DESCRIPTION")) "local::." else "NOAA-FIMS/FIMS")
  FIMS::setup_julia()
'
