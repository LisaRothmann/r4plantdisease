
# Messy Data Escape Room — Groundnut Crisis

## Files
- peanut_survey_2025.csv — main survey data (messy by design)
- peanut_field_info.csv — field metadata (messy by design)
- answer_key.R — example cleaning pipeline in R (facilitator use)
- quality_checks.R — quick script to validate winning conditions
- (output) peanut_survey_cleaned.csv — created by answer_key.R

## Suggested run order (for students)
1) Import both CSVs into R.
2) Clean column names, fix types, parse dates, standardise text, split lat/long.
3) Normalise field IDs (`F###`) in both datasets.
4) Convert area units to hectares in field info.
5) Join on `field_id`.
6) De-duplicate rows and ensure core columns have no missing values.
7) Save the final cleaned dataset as `peanut_survey_cleaned.csv`.

## Facilitator
- Use `answer_key.R` as a reference solution.
- Use `quality_checks.R` on cleaned outputs to score teams.

