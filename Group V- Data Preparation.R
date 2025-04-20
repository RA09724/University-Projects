# Group v
# Sarvein Rao A/L Sathiah, TP071496
# Vasshan Raj A/L Ganesan. TP070649
# Cayrosha Kamine, TP078519

# =====================================================================
# Hypothesis
# A customer’s loan purpose, credit amount, savings status, job and age 
# significantly influence their credit risk.
# =====================================================================


# Load packages
library(plyr)
library(dplyr)
library(ggplot2)
library(DataExplorer)
library(stats)
library(rpart)
library(rpart.plot)
library(reshape2)
library(caret)
library(randomForest)
library(caTools)
library(VIM)
library(DescTools)
library(vcd)



# Data Import

file_path <- "C:\\Users\\Sarvein Rao\\Downloads\\5. credit_risk_classification.csv"
data <- read.csv(file_path)

# Data Exploration
View(data)
plot_missing(data)
ncol(data)
nrow(data)
str(data)



# Data Cleaning

# Standardize column names to lowercase for consistency
names(data) <- tolower(names(data))  

 

# Cleaning Each Independent Variable

# 1. Cleaning the purpose column

# Replace empty strings with NA and remove whitespaces
data$purpose <- tolower(trimws(replace(data$purpose, data$purpose == '', NA)))  
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
mode_purpose <- getmode(data$purpose)  

# Replace NA with mode for purpose column
data$purpose <- replace(data$purpose, is.na(data$purpose), mode_purpose)  

# 2. Cleaning the credit amount column
credit_amount_median <- median(data$credit_amount, na.rm = TRUE)
data$credit_amount <- ifelse(is.na(data$credit_amount), credit_amount_median, data$credit_amount)

# Remove any outliers that are more than 3 standard deviations away from the mean
credit_amount_mean <- mean(data$credit_amount, na.rm = TRUE)
credit_amount_sd <- sd(data$credit_amount, na.rm = TRUE)

# Filter out extreme outliers beyond 3 SD
data <- data %>%
  filter(abs(credit_amount - credit_amount_mean) <= 3 * credit_amount_sd)

data$credit_amount <- as.numeric(data$credit_amount)  # Ensure column is numeric 

# 3. Cleaning the age column
data$age <- as.numeric(data$age)  # Convert to numeric
data$age <- round(data$age)  # Round off decimal values
median_age <- median(data$age, na.rm = TRUE)  # Calculate median
data$age[is.na(data$age)] <- median_age  # Replace NA with median

# 4. Cleaning the job column

# Replace empty strings with NA and remove whitespaces
data$job <- tolower(trimws(replace(data$job, data$job == '', NA)))  
mode_job <- getmode(data$job)  

# Replace NA with mode for job column
data$job <- replace(data$job, is.na(data$job), mode_job) 

# 5. Cleaning the savings status column

# Replace empty strings with NA and remove whitespaces
data$savings_status <- replace(data$savings_status, data$savings_status == '', NA)  
data <- kNN(data, variable = "savings_status", k = 5, imp_var = FALSE)  # KNN imputation
data$savings_status <- tolower(data$savings_status)  # Convert to lowercase

# Recheck missing values in the cleaned data
plot_missing(data)

