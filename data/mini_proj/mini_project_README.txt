
# Mini-Project: Fungicide Inhibition Plates (RCBD)

## Scenario
You conducted an in vitro assay to evaluate three different fungicides (A, B, C) against a pathogen, using inhibition plates.
The experiment was arranged in a Randomized Complete Block Design (RCBD) with 3 blocks and 4 plates per fungicide per block.
A control treatment (no fungicide) was included.

## Tasks
1. Import the dataset (`fungicide_inhibition_rcbd.csv`) into R.
2. Tidy the data (ensure factor variables are correctly set).
3. Perform an ANOVA to test for treatment effects, accounting for blocks.
4. Conduct an LSD test to compare treatments.
5. Visualise results using `ggplot2`, adding LSD letters to indicate significant differences.

## Dataset Columns
- Block: Experimental block (factor)
- Treatment: Fungicide treatment or control
- Plate: Plate identifier
- Zone_mm: Diameter of inhibition zone in millimetres

## Files
- fungicide_inhibition_rcbd.csv — dataset
- mini_project_fungicide_analysis.R — example R script (facilitator)
