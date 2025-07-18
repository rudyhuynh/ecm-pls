options(repos = "https://cloud.r-project.org")

local_lib <- "./R_packages"
dir.create(local_lib, showWarnings = FALSE, recursive = TRUE)

# Install packages
install.packages("ggplot2", lib = local_lib)
install.packages("dplyr", lib = local_lib)
install.packages("seminr", lib = local_lib)
install.packages("knitr", lib = local_lib)
install.packages("stringr", lib = local_lib)
install.packages("tidyr", lib = local_lib)

# Load packages
library(ggplot2, lib.loc = local_lib)
library(dplyr, lib.loc = local_lib)
library(seminr, lib.loc = local_lib)
library(knitr, lib.loc = local_lib)
library(stringr, lib.loc = local_lib)
library(tidyr, lib.loc = local_lib)

# Read data
data <- read.csv("output/data.csv")

# Generate Data Analysis Report
cat("=== DATA ANALYSIS REPORT ===\n\n")

# Basic dataset information
cat("Dataset Overview:\n")
cat("- Total responses:", nrow(data), "\n")
cat("- Total variables:", ncol(data), "\n\n")

# Job Analysis
cat("=== JOB ANALYSIS ===\n\n")

# Define job categories
job_categories <- c(
  "Bac si / Duoc si",
  "Du hoc sinh", 
  "Hoc sinh / Sinh vien",
  "Kinh doanh",
  "Nhan vien van phong",
  "Tu do (Freelancer)"
)

# Parse multiple job values
parse_jobs <- function(job_string) {
  jobs <- c()
  for (category in job_categories) {
    if (grepl(category, job_string, fixed = TRUE)) {
      jobs <- c(jobs, category)
    }
  }
  return(jobs)
}

# Create job frequency table
job_counts <- data.frame(
  Job = job_categories,
  Count = 0,
  Percentage = 0
)

for (i in 1:nrow(data)) {
  job_string <- as.character(data$job[i])
  parsed_jobs <- parse_jobs(job_string)
  
  for (job in parsed_jobs) {
    job_counts$Count[job_counts$Job == job] <- job_counts$Count[job_counts$Job == job] + 1
  }
}

job_counts$Percentage <- round((job_counts$Count / nrow(data)) * 100, 2)

# Display job frequency table
cat("Job Distribution Table:\n")
print(kable(job_counts, row.names = FALSE))
cat("\n")

# Create bar chart for job distribution
p1 <- ggplot(job_counts, aes(x = reorder(Job, Count), y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.7) +
  coord_flip() +
  labs(title = "Job Distribution",
       x = "Job Category",
       y = "Number of Respondents") +
  theme_minimal() +
  geom_text(aes(label = paste0(Count, " (", Percentage, "%)")), 
            hjust = -0.1, size = 3)

print(p1)

# Age distribution
cat("\n=== AGE ANALYSIS ===\n\n")
age_table <- data %>%
  count(age) %>%
  mutate(percentage = round(n/sum(n)*100, 2)) %>%
  arrange(desc(n))

cat("Age Distribution Table:\n")
print(kable(age_table, col.names = c("Age Group", "Count", "Percentage (%)"), row.names = FALSE))

# Age distribution chart
p2 <- ggplot(age_table, aes(x = reorder(age, n), y = n)) +
  geom_bar(stat = "identity", fill = "lightcoral", alpha = 0.7) +
  coord_flip() +
  labs(title = "Age Distribution",
       x = "Age Group",
       y = "Number of Respondents") +
  theme_minimal() +
  geom_text(aes(label = paste0(n, " (", percentage, "%)")), 
            hjust = -0.1, size = 3)

print(p2)

# Language learning analysis
cat("\n=== LANGUAGE LEARNING ANALYSIS ===\n\n")
learning_table <- data %>%
  count(is_learning_new_language) %>%
  mutate(percentage = round(n/sum(n)*100, 2))

cat("Currently Learning New Language:\n")
print(kable(learning_table, col.names = c("Learning Status", "Count", "Percentage (%)"), row.names = FALSE))

# Flashcard app usage
flashcard_table <- data %>%
  count(has_using_flashcard_app) %>%
  mutate(percentage = round(n/sum(n)*100, 2))

cat("\nFlashcard App Usage:\n")
print(kable(flashcard_table, col.names = c("Using Flashcard App", "Count", "Percentage (%)"), row.names = FALSE))

# Platform usage analysis
cat("\n=== PLATFORM USAGE ANALYSIS ===\n\n")
platform_data <- data %>%
  filter(!is.na(platform) & platform != "") %>%
  pull(platform)

# Parse platforms (similar to job parsing)
platforms <- c("Android", "iOS", "Web", "Window", "Mac")
platform_counts <- data.frame(
  Platform = platforms,
  Count = 0,
  Percentage = 0
)

for (platform_string in platform_data) {
  for (platform in platforms) {
    if (grepl(platform, platform_string, fixed = TRUE)) {
      platform_counts$Count[platform_counts$Platform == platform] <- 
        platform_counts$Count[platform_counts$Platform == platform] + 1
    }
  }
}

platform_counts$Percentage <- round((platform_counts$Count / length(platform_data)) * 100, 2)
platform_counts <- platform_counts[platform_counts$Count > 0, ]

cat("Platform Usage Distribution:\n")
print(kable(platform_counts, row.names = FALSE))

# Platform usage chart
p3 <- ggplot(platform_counts, aes(x = reorder(Platform, Count), y = Count)) +
  geom_bar(stat = "identity", fill = "lightgreen", alpha = 0.7) +
  coord_flip() +
  labs(title = "Platform Usage Distribution",
       x = "Platform",
       y = "Number of Users") +
  theme_minimal() +
  geom_text(aes(label = paste0(Count, " (", Percentage, "%)")), 
            hjust = -0.1, size = 3)

print(p3)

# Gender distribution
cat("\n=== GENDER ANALYSIS ===\n\n")
gender_table <- data %>%
  filter(!is.na(gender) & gender != "") %>%
  count(gender) %>%
  mutate(percentage = round(n/sum(n)*100, 2))

cat("Gender Distribution:\n")
print(kable(gender_table, col.names = c("Gender", "Count", "Percentage (%)"), row.names = FALSE))

# Cross-analysis: Job vs Age
cat("\n=== CROSS ANALYSIS: JOB vs AGE ===\n\n")

# Create a simplified job-age cross table
job_age_data <- data %>%
  select(job, age) %>%
  filter(!is.na(job) & !is.na(age))

# For cross-analysis, we'll take the primary job (first mentioned)
job_age_data$primary_job <- sapply(job_age_data$job, function(x) {
  for (category in job_categories) {
    if (grepl(category, x, fixed = TRUE)) {
      return(category)
    }
  }
  return("Other")
})

cross_table <- job_age_data %>%
  count(primary_job, age) %>%
  pivot_wider(names_from = age, values_from = n, values_fill = 0)

cat("Job vs Age Cross-tabulation:\n")
print(kable(cross_table, row.names = FALSE))

# Summary statistics for key variables
cat("\n=== SUMMARY STATISTICS ===\n\n")

# Perceived Usefulness (PU) scores
pu_vars <- paste0("PU", 1:5)
pu_scores <- data %>%
  select(all_of(pu_vars)) %>%
  summarise_all(list(mean = ~mean(., na.rm = TRUE), 
                     sd = ~sd(., na.rm = TRUE))) %>%
  gather(variable, value) %>%
  separate(variable, c("Variable", "Statistic"), sep = "_") %>%
  pivot_wider(names_from = Statistic, values_from = value) %>%
  mutate(mean = round(mean, 2), sd = round(sd, 2))

cat("Perceived Usefulness (PU) Statistics:\n")
print(kable(pu_scores, row.names = FALSE))

cat("\n=== REPORT COMPLETE ===\n")
cat("Generated on:", Sys.time(), "\n")