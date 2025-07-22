options(repos = "https://cloud.r-project.org")

local_lib <- "./R_packages"
if (dir.exists(local_lib)) {
    cat("Local library found at:", local_lib, "\n")
} else {
    cat("Local library not found. Create directory and install package...\n")
    dir.create(local_lib, showWarnings = FALSE, recursive = TRUE)

    # Install packages
    install.packages("ggplot2", lib = local_lib)
    install.packages("dplyr", lib = local_lib)
    install.packages("seminr", lib = local_lib)
}


# Load packages
library(ggplot2, lib.loc = local_lib)
library(dplyr, lib.loc = local_lib)
library(seminr, lib.loc = local_lib)

data <- read.csv("data.csv")

set.seed(2025)

measurement_model <- constructs(
    composite("PU", multi_items("PU", 1:5)),
    composite("PEOU", multi_items("PEOU", c(1,2,4))),
    composite("HAB", multi_items("HAB", 1:3)),
    composite("SAT", multi_items("SAT", 1:2)),
    composite("CONF", multi_items("CONF", 1:3)),
    composite("PI", multi_items("PI", 1:2))
)
structural_model <- relationships(
    paths(from = "PU", to = "PI"), # H1
    paths(from = "PEOU", to = "PI"), # H2
    paths(from = "SAT", to = "PI"), # H3
    paths(from = "HAB", to = "PI"), # H4
    paths(from = "PU", to = "SAT"), # H5
    paths(from = "PEOU", to = "SAT"), # H6
    paths(from = "CONF", to = "SAT"), # H7
    paths(from = "PEOU", to = "PU"), # H8
    paths(from = "CONF", to = "PU"), # H9
    paths(from = "CONF", to = "PEOU") # H10
)

model <- estimate_pls(data = data,
    measurement_model = measurement_model,
    structural_model = structural_model,
    inner_weights = path_weighting,
    missing = mean_replacement,
    missing_value = "-99")

# Summarize the model results
summ <- summary(model)
path_matrix <- summ$paths

print("Indicator loadings (>0.4 , >0.708):")
write.table(summ$loadings, sep="\t", quote=FALSE, na="_")

print("Indicator reliability:")
write.table(summ$loadings^2, sep="\t", quote=FALSE, na="_")

# Inspect the construct reliability metrics
# summ$reliability
print("$reliability (alpha>0.7, AVE>0.5):")
write.table(summ$reliability, sep="\t", quote=FALSE, na="_")

print("HTMT (<0.85):")
write.table(summ$validity$htmt, sep="\t", quote=FALSE, na="_")

# Print the results to console first to verify
print("Path Coefficients:")
# print(path_matrix)
write.table(path_matrix, sep="\t", quote=FALSE, na="")

bs_model <- bootstrap_model(seminr_model = model,
    nboot = 10000,
    cores = NULL)

# Store the summary of the bootstrapped model
bs_model_summary <- summary(bs_model)

print("# Inspect the bootstrapped structural paths")
# bs_model_summary$bootstrapped_paths
write.table(bs_model_summary$bootstrapped_paths, sep="\t", quote=FALSE, na="")

print("")

print("# Inspect the bootstrapped indicator loadings")
# bs_model_summary$bootstrapped_loadings
write.table(bs_model_summary$bootstrapped_loadings, sep="\t", quote=FALSE, na="")

