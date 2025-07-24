# Code trong file này được sử dụng cho RStudio thay vì chạy bằng lệnh Rscript.

library(dplyr)
library(seminr)
library(DiagrammeR)

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

summ <- summary(model)

bs_model <- bootstrap_model(seminr_model = model, nboot = 10000, cores = NULL)
summary_boot <- summary(bs_model)

# Dùng để kiểm tra mô hình đo lường:
summ$loadings
summ$reliability
summ$validity$htmt

# Dùng để kiểm tra mô hình cấu trúc:
summ$vif_antecedents
summary_boot$bootstrapped_paths
summary_boot$bootstrapped_total_paths
summ$paths
summ$fSquare

# Plot the models:
#plot(measurement_model)
#plot(structural_model)
#plot(bs_model, title = "PLS Model")
