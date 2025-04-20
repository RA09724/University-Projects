# ----------------------------------------------

# Objective 1: To analyze the relationship of a customers specific loan purpose on their credit class
# Sarvein Rao A/L Sathiah, TP071496

# ----------------------------------------------

# Descriptive Analytics

# ----------------------------------------------
# Analysis 1-1: How are different loan purposes distributed across good and bad credit class
# and is there a strong relationship between the two variables?

# Count the number of good and bad credit for each loan purpose
credit_counts <- data %>%
  group_by(purpose) %>%
  summarise(
    good_count = sum(class == "good"),
    bad_count = sum(class == "bad"),
    total_count = n()
  ) %>%
  arrange(desc(total_count))

print("Good and Bad Credit Counts by Loan Purpose:")
print(credit_counts)

# Visualization: Purpose vs Credit Class 

ggplot(data, aes(x = purpose, fill = class)) +
  geom_bar(position = "dodge") +
  geom_text(stat = "count",aes(label = ..count..), position = position_dodge(width = 1.2), vjust = -0.3, size = 3) +
  coord_flip() +
  labs(title = "Credit Class by Loan Purpose", x = "Loan Purpose", y = "Count of Customers") +
  scale_fill_manual(values = c("good" = "blue", "bad" = "red")) +
  theme_minimal()

# A Chi-Square Test is done here to examine the relationship of the two columns
purpose_chi <- chisq.test(table(data$purpose, data$class))  
print(purpose_chi)


# ----------------------------------------------

# Diagnostic Analytics

# ----------------------------------------------
# Analysis 1-2: Identify the purposes most commonly associated with 'bad' credit

# Calculate the proportion of bad credit for each purpose
bad_credit_proportions <- data %>%
  group_by(purpose) %>%
  summarise(
    bad_count = sum(class == "bad"),
    total_count = n(),
    proportion_bad = bad_count / total_count
  ) %>%
  arrange(desc(proportion_bad))

print("Purposes most associated with bad credit (proportion):")
print(bad_credit_proportions)

# Visualization: Proportion of Bad Credit with Text Labels
ggplot(bad_credit_proportions, aes(x = reorder(purpose, -proportion_bad), 
                                   y = proportion_bad)) +
  geom_col(fill = "red") +
  geom_text(aes(label = scales::percent(proportion_bad, accuracy = 0.1)), # Add text labels as percentages
            vjust = -0.1, color = "black", size = 3) +    
  coord_flip() +
  labs(title = "Proportion of Bad Credit by Loan Purpose", x = "Loan Purpose", y = "Proportion of Bad Credit"
  ) +
  theme_minimal()



# ----------------------------------------------

# Predictive Analytics

# ----------------------------------------------

# Analysis 1-3: Does Good Credit Score Affect Certain Loan Purposes?
# To get the proportion of Good Credit Likelihood by Purpose
good_credit_prob <- data %>%
  group_by(purpose) %>%
  summarise(
    good_credit_prop = mean(class == "good") * 100,  # Convert to percentage
    total_count = n()
  ) %>%
  arrange(desc(good_credit_prop))

print("Good credit likelihood by purpose (percentage):")
print(good_credit_prob)

# Visualization: Likelihood of the proportion of Good Credit
ggplot(good_credit_prob, aes(x = reorder(purpose, good_credit_prop), 
                             y = good_credit_prop)) +
  geom_segment(aes(xend = reorder(purpose, good_credit_prop), yend = 0), color = "blue") +
  geom_point(color = "darkgreen", size = 4) +
  geom_text(aes(label = paste0(round(good_credit_prop, 1), "%")), 
            hjust = -0.2, color = "black", size = 4) +
  labs(title = "Proportion of Good Credit Based on Loan Purpose", x = "Loan Purpose", y = "Proportion of Good Credit (%)") +
  coord_flip() +
  theme_minimal()


# Analysis 1-4: Logistic Regression Analysis for Predicting Good Credit Risk Based on Loan Purpose
# Convert the target variable to binary: 1 for good credit, 0 for bad credit
data$class_binary <- ifelse(data$class == "good", 1, 0)
# Split the data into training and testing sets (80-20 split)
set.seed(123)
split <- sample.split(data$class_binary, SplitRatio = 0.8)
train_set <- subset(data, split == TRUE)
test_set <- subset(data, split == FALSE)
# Train a logistic regression model on the training set
logir_model <- glm(class_binary ~ purpose, data = train_set, family = "binomial")  
summary(logir_model)

# Predict probabilities on the test set
logir_pred_probs <- predict(logir_model, newdata = test_set, type = "response")
logir_pred <- ifelse(logir_pred_probs > 0.5, 1, 0)

# Evaluate the model using a confusion matrix
logir_conf_matrix <- confusionMatrix(as.factor(logir_pred), 
                                     as.factor(test_set$class_binary))
print("Logistic Regression Confusion Matrix:")
print(logir_conf_matrix)

# Visualization: Logistic Regression Predictions
ggplot(test_set, aes(x = purpose, y = logir_pred_probs)) +
  geom_point(aes(color = as.factor(class_binary)), 
             position = position_jitter(width = 0.1, height = 0)) +
  coord_flip() +
  stat_smooth(method = "glm", method.args = list(family = "binomial"), 
              se = TRUE, color = "blue") +
  facet_wrap(~ class_binary) +
  labs(title = "Logistic Regression: Predicted Probabilities",
       x = "Loan Purpose", y = "Predicted Probability of Good Credit", color = "Actual Class") +
  theme_minimal()


# Analysis 1-5: Using Decision tree to predict the credit class of each specific purpose
# Convert `purpose` to factor
data$purpose <- as.factor(data$purpose)  
data$class <- as.factor(data$class)      

# Split the Data into Training and Testing Sets
set.seed(123)  # For reproducibility
train_indices <- sample(seq_len(nrow(data)), size = 0.8 * nrow(data)) 
train_data <- data[train_indices, ]
test_data <- data[-train_indices, ]

# Train the decision tree model
tree_model <- rpart(class ~ purpose , data = train_data, method = "class", cp = 0.01)                             

# Visualize the Decision Tree
rpart.plot(tree_model, type = 4, extra = 104, main = "Decision Tree for Credit Risk Classification")

# Evaluate the Model on Test Data and Predict credit class probabilities for test data
tree_predictions <- predict(tree_model, newdata = test_data, type = "class")

# Generate a confusion matrix to evaluate model performance
conf_matrix <- confusionMatrix(tree_predictions, test_data$class)
print(conf_matrix)  


# ----------------------------------------------

# Prescriptive Analytics

# ----------------------------------------------
# Analysis 1-6: What purpose is more likely to have Good credit compared to having bad credit and will their loan be approved

data_rf <- data
data_rf$class_factor <- as.factor(data_rf$class) 
data_rf$purpose <- as.factor(data_rf$purpose)

# Convert 'purpose' to a factor with the specific loan purposes listed
data_rf$purpose <- factor(data_rf$purpose, 
                          levels = c("new car", "furniture/equipment", "radio/tv", "other", 
                                      "education", "business", "domestic appliance", 
                                      "repairs", "used car", "retraining"))

# Split data into training and testing sets
set.seed(123)
train_indices <- sample(seq_len(nrow(data_rf)), size = 0.8 * nrow(data_rf))
train_data_rf <- data_rf[train_indices, ]
test_data_rf <- data_rf[-train_indices, ]

# Train the Random Forest Model
rf_purpose_model <- randomForest(class_factor ~ purpose, data = train_data_rf, 
                                 ntree = 500, importance = TRUE)

# Print model summary
print(rf_purpose_model)

# Feature Importance Analysis for 'Purpose' and its Impact on Credit Class
importance_rf <- importance(rf_purpose_model)  
var_imp_df <- data.frame(
  Feature = rownames(importance_rf),
  Importance = importance_rf[, 1])

# Sort the feature importance based on the 'purpose' column
purpose_importance <- var_imp_df %>% 
  filter(grepl("purpose", Feature)) %>%
  arrange(desc(Importance))

# Print importance of loan purpose
print("Importance of loan purpose in predicting credit class:")
print(purpose_importance)


# Predict class probabilities for test data
rf_pred_probs <- predict(rf_purpose_model, newdata = test_data_rf, type = "prob")[, 2]

# Add predicted probability to test data
test_data_rf$predicted_prob_good <- rf_pred_probs

# Set recommendation threshold for 'good' credit probability (e.g., 0.5 for low probability)
recommendation_threshold <- 0.5

# Create recommendation based on the predicted probability
test_data_rf$recommendation <- ifelse(test_data_rf$predicted_prob_good < recommendation_threshold, 
                                      "Bad: Loan approval rejected", 
                                      "Good: Loan approval likely")

# Show the recommendations by loan purpose
recommendations_by_purpose <- test_data_rf %>%
  group_by(purpose, recommendation) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

print("Loan Purposes with Recommendations for Action:")
print(recommendations_by_purpose)

# Visualize the recommendations by loan purpose
ggplot(recommendations_by_purpose, aes(x = purpose, y = count, fill = recommendation)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = count), position = position_dodge(width = 0.8), vjust = -0.5) +
  labs(title = "Recommendations by Loan Purpose", x = "Loan Purpose", y = "Count") +
  scale_fill_manual(values = c("red", "green")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# ----------------------------------------------

# Objective 2: To analyze the relationship of the credit amount on their credit class
# Sarvein Rao A/L Sathiah, TP071496

# ----------------------------------------------

# Descriptive Analytics

# ----------------------------------------------
# Analysis 2-1: How credit amount is distributed and varies across the credit class 

# Visualize distribution of the credit amount column
ggplot(data, aes(x = credit_amount, fill = class, color = class)) +
  geom_density(alpha = 0.5, size = 1) +
  scale_fill_manual(values = c("red", "blue")) +
  scale_color_manual(values = c("red", "blue")) +
  labs(title = "Density Plot of Credit Amount by Class", x = "Credit Amount", y = "Density") +
  theme_minimal()


# ----------------------------------------------

# Diagnostic Analytics

# ----------------------------------------------
# Analysis 2-2: What is the Relationship Between Credit Amount and Credit Class

# Violin plot to compare credit amount with the credit class
ggplot(data, aes(x = class, y = credit_amount, fill = class)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  labs(title = "Violin Plot of Credit Amount by Class", x = "Class", y = "Credit Amount") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), legend.position = "none")

#Perform a t-test to compare means of credit amount between good and bad credit
credit_ttest <- t.test(credit_amount ~ class, data = data)
print(credit_ttest)


# ----------------------------------------------

# Predictive Analytics

# ----------------------------------------------
# Analysis 2-3: Can credit amount predict the outcome of credit classification for each purpose?

# Linear regression model to predict credit amount based on class and purpose
lr_creditA_model <- lm(credit_amount ~ class + purpose, data = data)
summary(lr_creditA_model)

# Predicted values from the model
data$predicted_credit_amount <- predict(lr_creditA_model, newdata = data)

# Replace NAs in predicted values with the median or a default value
data$predicted_credit_amount[is.na(data$predicted_credit_amount)] <- median(data$predicted_credit_amount, na.rm = TRUE)

# Scatter plot of actual vs predicted credit amount
ggplot(na.omit(data), aes(x = credit_amount, y = predicted_credit_amount)) +
  geom_point(aes(color = class), alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "black", linetype = "dashed") +
  labs(title = "Actual vs Predicted Credit Amount", x = "Actual Credit Amount", y = "Predicted Credit Amount") +
  theme_minimal()

# R-squared (R²) and Root Mean Square Error (RMSE) values to assess the linear regression model's performance 
rsq <- summary(lr_creditA_model)$r.squared
rmse <- sqrt(mean((data$credit_amount - data$predicted_credit_amount)^2))

print(paste("R-squared: ", rsq))
print(paste("RMSE: ", rmse))

