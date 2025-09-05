
# Quality check script for the Escape Room
library(readr); library(dplyr)

dat <- readr::read_csv("peanut_survey_cleaned.csv", show_col_types = FALSE)

checks <- list(
  snake_case_cols = all(grepl("^[a-z0-9_]+$", names(dat))),
  no_missing_core = !any(is.na(dat$field_id) | is.na(dat$location) |
                         is.na(dat$disease_pct) | is.na(dat$date_collected)),
  disease_titles   = all(dat$disease == tools::toTitleCase(dat$disease)),
  iso_dates        = all(grepl("^\\d{4}-\\d{2}-\\d{2}$", as.character(dat$date_collected))),
  numeric_pct      = is.numeric(dat$disease_pct),
  coords_split     = all(c("latitude", "longitude") %in% names(dat)),
  joined_ok        = all(c("cultivar","area_ha") %in% names(dat)),
  no_dupes         = nrow(dat) == nrow(dplyr::distinct(dat))
)

print(checks)
if (all(unlist(checks))) {
  message("✅ All checks passed — you escaped!")
} else {
  message("❌ Some checks failed — review your cleaning steps.")
}
