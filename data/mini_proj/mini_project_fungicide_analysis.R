
# Mini-project: Fungicide inhibition plates (RCBD)

# Load packages
library(tidyverse)
library(agricolae) # for LSD test

# 1. Import data
data <- read_csv("fungicide_inhibition_rcbd.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

# 2. Transform factors
data <- data %>%
  mutate(
    treatment = as.factor(treatment),
    block = as.factor(block)
  )

# 3. Explore data
data %>% count(treatment, block)

# 4. ANOVA
model <- aov(zone_mm ~ treatment + block, data = data)
summary(model)

# 5. LSD test
lsd_result <- agricolae::LSD.test(model, "treatment", p.adj = "none")
print(lsd_result$groups)

# 6. Visualisation with LSD letters
ggplot(data, aes(x = treatment, y = zone_mm)) +
  geom_boxplot(fill = "skyblue", alpha = 0.5) +
  geom_jitter(width = 0.1, alpha = 0.6) +
  geom_text(data = lsd_result$groups %>%
              rownames_to_column("treatment") %>%
              rename(lsd_group = groups),
            aes(x = treatment, y = max(data$zone_mm) + 2, label = lsd_group),
            inherit.aes = FALSE) +
  labs(title = "Fungicide inhibition zones (mm)",
       x = "Treatment", y = "Zone of inhibition (mm)") +
  theme_minimal()
