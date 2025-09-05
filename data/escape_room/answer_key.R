
# Groundnut "Messy Data Escape Room" — Answer Key (R)
# Required packages
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(janitor)

# 1) Import
survey <- readr::read_csv("peanut_survey_2025.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

field  <- readr::read_csv("peanut_field_info.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

# 2) Basic cleaning of survey
survey_clean <- survey %>%
  # trim whitespace columns that came through
  rename_with(~str_trim(.x, side = "both")) %>%
  # fix disease percent: remove % sign, coerce to numeric
  mutate(disease = str_to_title(disease),
         location = str_to_title(location),
         disease_ = str_remove(disease_, "%"),
         disease_ = as.numeric(disease_),
         notes = str_trim(notes)) %>%
  # parse mixed date formats robustly
  mutate(date_collected = parse_date_time(date_collected,
                                          orders = c("ymd", "dmy", "B d Y", "m/d/Y"))) %>%
  # split lat-long into two columns
  separate(lat_long, into = c("latitude","longitude"), sep = ",", remove = TRUE, convert = TRUE) %>%
  # normalise field ids to F###
  mutate(field_id = str_to_upper(field_id),
         field_id = str_remove_all(field_id, "\\s+"),
         field_num = as.integer(str_remove(field_id, "^F")),
         field_id = sprintf("F%03d", field_num)) %>%
  select(field_id, location, disease, disease_,
         date_collected, latitude, longitude, notes, extra_col) %>%
  rename(disease_pct = disease_) %>%
  # remove exact duplicates
  distinct()

# 3) Basic cleaning of field info
field_clean <- field %>%
  rename_with(~str_trim(.x, side = "both")) %>%
  mutate(field_id = str_to_upper(field_id),
         field_id = str_remove_all(field_id, "\\s+"),
         field_num = as.integer(str_remove(field_id, "^F")),
         field_id = sprintf("F%03d", field_num)) %>%
  separate(lat_long, into = c("latitude_f","longitude_f"), sep = ",", remove = TRUE, convert = TRUE) %>%
  # Convert area to hectares
  mutate(area_planted = str_replace_all(area_planted, "\\s+", " "),
         area_val = case_when(
           str_detect(area_planted, "ha")  ~ as.numeric(str_extract(area_planted, "\\d+\\.?\\d*")),
           str_detect(area_planted, "m2")  ~ as.numeric(str_extract(area_planted, "\\d+\\.?\\d*")) / 10000,
           TRUE ~ NA_real_
         ),
         cultivar = if_else(is.na(cultivar) | cultivar == "", NA_character_, cultivar)) %>%
  select(field_id, latitude_f, longitude_f, farm_location, cultivar, area_ha = area_val)

# 4) Join (left join is fine for analysis keyed to survey)
dat <- survey_clean %>%
  left_join(field_clean, by = "field_id")

# 5) Quality checks
stopifnot(!any(is.na(dat$field_id)))
stopifnot(!any(is.na(dat$location)))
stopifnot(!any(is.na(dat$disease_pct)))
stopifnot(!any(is.na(dat$date_collected)))
# cultivar can be missing in the raw, but for the "win condition" you could impute or flag:
# require no missing cultivar for the game:
# stopifnot(!any(is.na(dat$cultivar)))

# Output cleaned file
readr::write_csv(dat, "peanut_survey_cleaned.csv")

message("Cleaning complete. Output: peanut_survey_cleaned.csv")
