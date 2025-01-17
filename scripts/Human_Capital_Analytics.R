# Human Capital Analytics
# Author: Joao Pedro Jacomossi
# Description: This script analyzes employee turnover data to identify patterns, build predictive models,
#              and provide actionable recommendations.

library(ggplot2)
library(gridExtra)
library(dplyr)
library(gplots)
library(cluster)
library(Boruta)
library(randomForest)
library(caret)
library(class)
library(fastDummies)
library(factoextra)
library(rpart)
library(rpart.plot)
library(e1071)
library(pROC)
library(neuralnet)
library(cluster)
library(factoextra)
library(plotly)


# ====================================
#  Data Loading
# ====================================

employee.df<-read.csv("Employee.csv")

#Checking first rows
head(employee.df)

#Checking original structure
str(employee.df)

# ====================================
# Data Preprocessing
# ====================================

# -------------------------------
# 1. Rename Variables
# -------------------------------
# Renaming 'sales' to 'department'
names(employee.df)[names(employee.df) == "sales"] <- "department"

# -------------------------------
# 2. Convert Variables to Factors
# -------------------------------
# Convert categorical variables to factors
employee.df$department <- as.factor(employee.df$department)
employee.df$salary <- as.factor(employee.df$salary)

# Convert binary numeric variables to factors
employee.df$Work_accident <- as.factor(employee.df$Work_accident)
employee.df$left <- as.factor(employee.df$left)
employee.df$promotion_last_5years <- as.factor(employee.df$promotion_last_5years)

# Check structure of the modified dataframe
str(employee.df)

# -------------------------------
# 3. Create New Variable (Impact Score)
# -------------------------------
# Calculate weighted impact score
impact_score <- with(employee.df, 
                     (ifelse(time_spend_company <= 3, 0, 
                             ifelse(time_spend_company <= 6, 0.5, 1)) * 0.4) +
                       (ifelse(salary == "low", 0, 
                               ifelse(salary == "medium", 0.5, 1)) * 0.2) +
                       (ifelse(last_evaluation < 0.6, 0, 
                               ifelse(last_evaluation <= 0.8, 0.5, 1)) * 0.4))

# Round the calculated values
impact_score <- round(impact_score, 2)

# Add impact score as a new column
employee.df$impact_score <- impact_score

# -------------------------------
# 4. Inspect Data
# -------------------------------
# View the updated dataframe
head(employee.df)

# Check structure of the dataframe
str(employee.df)

# -------------------------------
# 5. Analyze Impact Score Distribution
# -------------------------------
# Counts of each impact_score to see distribution
score_counts <- employee.df %>%
  count(impact_score)

# View distribution counts
print(score_counts)


# ====================================
# Exploratory Data Analysis (EDA)
# ====================================

# -------------------------------
# 1. Summary Statistics and Distributions
# -------------------------------

#======= Summary Statistics ==========

summary(employee.df)

#=========== Histograms ==============

# Histogram for 'satisfaction_level'
p1 <- ggplot(employee.df, aes(x = satisfaction_level)) +
  geom_histogram(binwidth = 0.05, fill = "steelblue", color = "black") +
  labs(title = "Satisfaction Level", x = "Satisfaction Level", y = "Frequency") +
  theme_minimal()

# Histogram for 'last_evaluation'
p2 <- ggplot(employee.df, aes(x = last_evaluation)) +
  geom_histogram(binwidth = 0.05, fill = "steelblue", color = "black") +
  labs(title = "Last Evaluation", x = "Last Evaluation Score", y = "Frequency") +
  theme_minimal()

# Histogram for 'number_project'
p3 <- ggplot(employee.df, aes(x = number_project)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Number of Projects", x = "Projects Count", y = "Frequency") +
  theme_minimal()

# Histogram for 'average_montly_hours'
p4 <- ggplot(employee.df, aes(x = average_montly_hours)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "black") +
  labs(title = "Average Monthly Hours", x = "Hours", y = "Frequency") +
  theme_minimal()

# Histogram for 'time_spend_company'
p5 <- ggplot(employee.df, aes(x = time_spend_company)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Time Spent in Company", x = "Years", y = "Frequency") +
  theme_minimal()

# Histogram for 'impact_score'
p6 <- ggplot(employee.df, aes(x = impact_score)) +
  geom_histogram(binwidth = 0.1, fill = "steelblue", color = "black") +
  labs(title = "Impact Score", x = "Score", y = "Frequency") +
  theme_minimal()

# Arranging all plots in a grid
grid.arrange(p1, p2, p3, p4, p5, p6, ncol = 3)
 
#=========== Boxplots ==============

# Boxplot for 'satisfaction_level'
b1 <- ggplot(employee.df, aes(x = "", y = satisfaction_level)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Satisfaction Level", x = "", y = "Satisfaction Level") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Boxplot for 'last_evaluation'
b2 <- ggplot(employee.df, aes(x = "", y = last_evaluation)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Last Evaluation", x = "", y = "Last Evaluation Score") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Boxplot for 'number_project'
b3 <- ggplot(employee.df, aes(x = "", y = number_project)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Number of Projects", x = "", y = "Projects Count") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Boxplot for 'average_montly_hours'
b4 <- ggplot(employee.df, aes(x = "", y = average_montly_hours)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Average Monthly Hours", x = "", y = "Hours") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Boxplot for 'time_spend_company'
b5 <- ggplot(employee.df, aes(x = "", y = time_spend_company)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Time Spent in Company", x = "", y = "Years") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Boxplot for 'impact_score'
b6 <- ggplot(employee.df, aes(x = "", y = impact_score)) +
  geom_boxplot(fill = "steelblue", color = "black") +
  labs(title = "Impact Score", x = "", y = "Score") +
  theme_minimal() +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank())

# Arranging all plots in a grid
grid.arrange(b1, b2, b3, b4, b5, b6, ncol = 3)

# -------------------------------
# 2. Visual Exploration of Relationships
# -------------------------------

#=========== Scatterplots ==============

# Scatterplot of Tenure vs Last Evaluation
ggplot(employee.df, aes(x = factor(time_spend_company), y = last_evaluation, color = factor(left))) +
  geom_jitter(alpha = 0.5, width = 0.2, height = 0.2) +
  scale_color_manual(values = c("blue", "red")) +  # Inverted colors
  labs(title = "Tenure vs Last Evaluation",
       x = "Tenure (Years)",
       y = "Last Evaluation",
       color = "Left"
  ) +  
  theme_minimal()+
  ylim(0, 1)

# Scatterplot of Salary vs Last Evaluation
ggplot(employee.df, aes(x = factor(salary, levels = c("high", "medium", "low")), y = last_evaluation, color = left)) +
  geom_jitter(width = 0.2, height = 0.2, alpha = 0.6) +
  labs(
    title = "Salary vs Last Evaluation",
    x = "Salary",
    y = "Last Evaluation",
    color = "Left"
  ) +
  theme_minimal() +
  scale_color_manual(values = c("0" = "blue", "1" = "red")) +
  ylim(0, 1)

# Scatterplot of Salary vs Time Spent in Company
ggplot(employee.df, aes(x = factor(salary, levels = c("high", "medium", "low")), y = factor(time_spend_company), color = left)) +
  geom_jitter(width = 0.2, height = 0.2, alpha = 0.6) +
  labs(
    title = "Salary vs Time Spent in Company ",
    x = "Salary",
    y = "Tenure (Years)",
    color = "Left"
  ) +
  theme_minimal() +
  scale_color_manual(values = c("0" = "blue", "1" = "red"))

# Scatterplot of Last Evaluation vs Satisfaction Level
ggplot(employee.df, aes(x = last_evaluation, y = satisfaction_level, color = factor(left))) +
  geom_jitter(alpha = 0.7, width = 0.2, height = 0.2) +
  labs(title = "Scatterplot of Last Evaluation vs Satisfaction Level",
       x = "Last Evaluation",
       y = "Satisfaction Level",
       color = "Left") +
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Stayed", "Left")) +
  scale_x_continuous(limits = c(0, 1)) +  # Limit x-axis to 0-1 (limited axis to avoid confusion since original values only go from 0 to 1)
  scale_y_continuous(limits = c(0, 1)) +  # Limit y-axis to 0-1
  theme_minimal()

#=========== Overall Turnover Rate =============

#number of employees who left
num_left <- sum(employee.df$left == 1)
#total number of employees
total_employees <- nrow(employee.df)
#overall turnover rate
avg_turnover_rate <- (num_left / total_employees) * 100
avg_turnover_rate

#=========== Turnover Rate Accross Different Variables ==============

#--------turnover rate by department--------

# Calculate turnover rate for each department
turnover_by_department <- employee.df %>%
  group_by(department) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100 )

turnover_by_department

#creating bar plot
barplot<-ggplot(turnover_by_department, aes(x = reorder(department, -turnover_rate), y = turnover_rate, fill = turnover_rate > avg_turnover_rate)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("TRUE" = "darkblue", "FALSE" = "lightblue"), 
                    labels = c("Below Overall Average", "Above Overall Average")) +
  labs(title = "Turnover Rate by Department",
       x = "Department",
       y = "Turnover Rate (%)",
       fill = "Turnover Rate") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#creating stacked bar plot
stacked_bar_plot<-ggplot(employee.df, aes(x = department, fill = factor(left))) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "salmon")) +  # Soft red and soft blue
  labs(x = "Department", y = "Count", fill = "Left", title = "Stacked Bar Plot of Department by 'Left' Variable") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#combining plots
grid.arrange(barplot, stacked_bar_plot, ncol = 2)

#------------turnover rate by Salary---------------

# Calculate turnover rate for each salary category
turnover_by_salary <- employee.df %>%
  group_by(salary) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_salary

# Plot 
ggplot(turnover_by_salary, aes(x = factor(salary, levels = c("high", "medium", "low")), y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Salary Category",
       x = "Salary Category",
       y = "Turnover Rate (%)") 

# Filter data for employees who stayed and left
stayed_data <- employee.df %>% filter(left == 0)
left_data <- employee.df %>% filter(left == 1)

# Calculate salary distributions
salary_distribution_all <- prop.table(table(employee.df$salary))
salary_distribution_stayed <- prop.table(table(stayed_data$salary))
salary_distribution_left <- prop.table(table(left_data$salary))

# Combine salary data into a single data frame
salary_combined <- data.frame(
  Category = "Salary",
  Status = rep(c("All", "Stayed", "Left"), each = 3),
  Subcategory = rep(names(salary_distribution_all), 3),
  Proportion = c(
    salary_distribution_all,
    salary_distribution_stayed,
    salary_distribution_left
  )
)

# Reorder Subcategory levels
salary_combined$Subcategory <- factor(
  salary_combined$Subcategory,
  levels = c("high", "medium", "low") 
)

# Plot salary distribution
ggplot(salary_combined, aes(x = Subcategory, y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Salary Distribution by Employee Status",
    x = "Salary Category",
    y = "Proportion"
  ) +
  theme_minimal() +
  theme(legend.title = element_blank())

#------------turnover rate by Tenure---------------

# Calculate turnover rate by tenure
turnover_by_tenure <- employee.df %>%
  group_by(time_spend_company) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_tenure

#converting to factor for plotting
turnover_by_tenure$time_spend_company <- as.factor(turnover_by_tenure$time_spend_company)

# Plot the turnover rate by tenure
ggplot(turnover_by_tenure, aes(x = time_spend_company, y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Tenure",
       x = "Years at Company",
       y = "Turnover Rate (%)")

#------------turnover rate by Promotion---------------

# Calculate turnover rate by promotion in the last 5 years
turnover_by_promotion <- employee.df %>%
  group_by(promotion_last_5years) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )
turnover_by_promotion

# Plot the turnover rate by promotion in the last 5 years
ggplot(turnover_by_promotion, aes(x = as.factor(promotion_last_5years), y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +  # Single fill specification
  labs(
    title = "Turnover Rate by Promotion in Last 5 Years",
    x = "Promotion in Last 5 Years (0 = No, 1 = Yes)",
    y = "Turnover Rate (%)"
  ) +
  theme(legend.position = "none")

# Calculate promotion distributions (only for promotion = 1)
promotion_distribution_all <- prop.table(table(employee.df$promotion_last_5years))[2]
promotion_distribution_stayed <- prop.table(table(stayed_data$promotion_last_5years))[2]
promotion_distribution_left <- prop.table(table(left_data$promotion_last_5years))[2]


# Combine promotion data (only for promotion = 1) into a single data frame
promotion_combined <- data.frame(
  Category = "Promotion",
  Status = c("All", "Stayed", "Left"),
  Subcategory = "Promoted (1)",
  Proportion = c(
    promotion_distribution_all,
    promotion_distribution_stayed,
    promotion_distribution_left
  )
)

promotion_combined

#  Plot promotion distribution (only for promotion = 1)
ggplot(promotion_combined, aes(x = Status, y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Promotion Distribution by Employee Status (Promoted Only)",
    x = "Employee Status",
    y = "Proportion of Employees Promoted",
    fill = "Status"
  ) +
  theme_minimal() +
  theme(legend.title = element_blank())


#------------chi-squared test---------------
# Create a contingency table
table_promotion_turnover <- table(employee.df$promotion_last_5years, employee.df$left)

# Perform Chi-squared test
chisq_test <- chisq.test(table_promotion_turnover)
print(chisq_test)

#---------Turnover Analysis by Promotion Status and Tenure----------

#Filter employees who have been in the company for less than 5 years
short_tenure_df <- employee.df %>%
  filter(time_spend_company < 5)

# Calculate the percentage of employees who got promoted
promotion_percentage_short_tenure <- short_tenure_df %>%
  summarise(
    num_promoted = sum(promotion_last_5years == 1),
    total = n(),
    percentage_promoted = (num_promoted / total) * 100
  )

# Print the percentage of promoted employees
promotion_percentage_short_tenure

# Calculate the turnover rate by promotion status for employees with less than 5 years tenure
turnover_by_promotion_short_tenure <- short_tenure_df %>%
  group_by(promotion_last_5years) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_promotion_short_tenure

# Plot
ggplot(turnover_by_promotion_short_tenure, aes(x = as.factor(promotion_last_5years), y = turnover_rate, fill = as.factor(promotion_last_5years))) +
  geom_bar(stat = "identity") +
  labs(title = "Turnover Rate by Promotion Status for Employees with Less Than 5 Years Tenure",
       x = "Promotion in Last 5 Years (0 = No, 1 = Yes)",
       y = "Turnover Rate (%)") +
  theme(legend.position = "none")

# Filter employees who have been in the company for at least 5 years or more
long_tenure_df <- employee.df %>%
  filter(time_spend_company >= 5)

# Calculate the percentage of employees who got promoted
promotion_percentage <- long_tenure_df %>%
  summarise(
    num_promoted = sum(promotion_last_5years == 1),
    total = n(),
    percentage_promoted = (num_promoted / total) * 100
  )

promotion_percentage

# Calculate the turnover rate by promotion status for employees with at least 5 years tenure
turnover_by_promotion_long_tenure <- long_tenure_df %>%
  group_by(promotion_last_5years) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_promotion_long_tenure

# Plot the turnover rate by promotion status for employees with at least 5 years tenure
ggplot(turnover_by_promotion_long_tenure, aes(x = as.factor(promotion_last_5years), y = turnover_rate, fill = as.factor(promotion_last_5years))) +
  geom_bar(stat = "identity") +
  labs(title = "Turnover Rate by Promotion Status for Employees with 5+ Years Tenure",
       x = "Promotion in Last 5 Years (0 = No, 1 = Yes)",
       y = "Turnover Rate (%)") +
  theme(legend.position = "none")

#---------Turnover Rate vs Last Evaluation-----------

# Calculate turnover rate by last evaluation score
turnover_by_evaluation <- employee.df %>%
  group_by(last_evaluation) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

# Plot the turnover rate by last evaluation score using a bar plot
ggplot(turnover_by_evaluation, aes(x = last_evaluation, y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.8) +
  labs(title = "Turnover Rate by Last Evaluation Score",
       x = "Last Evaluation Score",
       y = "Turnover Rate (%)") +
  theme_minimal()

# Create bins of 0.1 for last_evaluation scores
turnover_by_evaluation <- employee.df %>%
  mutate(last_evaluation_bin = cut(last_evaluation, breaks = seq(0, 1, by = 0.1), include.lowest = TRUE)) %>%
  group_by(last_evaluation_bin) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_evaluation
# Plot the turnover rate by last evaluation score bins using a bar plot
ggplot(turnover_by_evaluation, aes(x = last_evaluation_bin, y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Last Evaluation Score (Binned)",
       x = "Last Evaluation Score ",
       y = "Turnover Rate (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#---------Turnover Rate vs Number of Projects-----------

# Calculate turnover rate by number of projects
turnover_by_projects <- employee.df %>%
  group_by(number_project) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

#converting to factor for plotting
turnover_by_projects$number_project <- as.factor(turnover_by_projects$number_project)

# Plot the turnover rate by number of projects
ggplot(turnover_by_projects, aes(x = number_project, y = turnover_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Number of Projects",
       x = "Number of Projects",
       y = "Turnover Rate (%)")

#---------Turnover Rate vs Work Accident-----------

# Calculate turnover rate by work accident
turnover_by_accident <- employee.df %>%
  group_by(Work_accident) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_accident

# Plot the turnover rate by work accident
ggplot(turnover_by_accident, aes(x = as.factor(Work_accident), y = turnover_rate, fill = as.factor(Work_accident))) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Work Accident",
       x = "Work Accident (0 = No, 1 = Yes)",
       y = "Turnover Rate (%)") +
  theme(legend.position = "none")

##---------Turnover Rate vs Hours Worked-----------

employee2.df<-employee.df
# Create bins for average monthly hours with right-exclusive intervals and clear labels
employee2.df$hours_category <- cut(employee.df$average_montly_hours, 
                                   breaks = c(90, 145, 200, 255, 311), 
                                   labels = c("Low (90 to <145)", "Moderate(145 to <200)", "High(200 to <255)", "Very High (255 to <310)"),
                                   right = FALSE)  # Ensures intervals are left-inclusive, right-exclusive


# Calculate turnover rate by average monthly hours worked
turnover_by_hours <- employee2.df %>%
  group_by(hours_category) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

turnover_by_hours

# Plot the turnover rate by average monthly hours worked
ggplot(turnover_by_hours, aes(x = hours_category, y = turnover_rate, fill = hours_category)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Turnover Rate by Average Monthly Hours Worked",
       x = "Average Monthly Hours",
       y = "Turnover Rate (%)") +
  theme(legend.position = "none")

# Calculate turnover rate by average monthly hours worked
turnover_by_hours_individual <- employee2.df %>%
  group_by(average_montly_hours) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

print(turnover_by_hours_individual,n=215)

# Plot the turnover rate by individual average monthly hours worked using an area chart
ggplot(turnover_by_hours_individual, aes(x = average_montly_hours, y = turnover_rate, group = 1, fill = turnover_rate)) +
  geom_area(alpha = 0.6, color = "steelblue") +
  labs(title = "Turnover Rate by Individual Average Monthly Hours Worked",
       x = "Average Monthly Hours",
       y = "Turnover Rate (%)") +
  theme_minimal() +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  theme(legend.position = "none")


# Calculate average turnover rate based on observed trends from area chart
average_turnover_trend_df <- turnover_by_hours_individual %>%
  mutate(
    range = case_when(
      average_montly_hours >= 96 & average_montly_hours <= 125 ~ "96 to 125",
      average_montly_hours >= 126 & average_montly_hours <= 161 ~ "126 to 161",
      average_montly_hours >= 162 & average_montly_hours <= 216 ~ "162 to 216",
      average_montly_hours >= 217 & average_montly_hours <= 287 ~ "217 to 287",
      average_montly_hours >= 288 & average_montly_hours <= 310 ~ "288 to 310"
    )
  ) %>%
  group_by(range) %>%
  summarise(average_turnover = mean(turnover_rate))

# Print the results
average_turnover_trend_df

#---------Turnover Rate vs Satisfaction-----------

employee.df$left <- as.numeric(as.character(employee.df$left))
# Create the turnover_by_satisfaction data frame
turnover_by_satisfaction <- employee.df %>%
  group_by(satisfaction_level) %>%
  summarise(turnover_rate = mean(left, na.rm = TRUE) * 100, .groups = 'drop') %>%
  arrange(satisfaction_level) 

# Plot
ggplot(turnover_by_satisfaction, aes(x = satisfaction_level, y = turnover_rate, group = 1, fill = turnover_rate)) +
  geom_area(alpha = 0.6, color = "steelblue") +
  labs(title = "Turnover Rate by Satisfaction Level",
       x = "Satisfaction Level",
       y = "Turnover Rate (%)") +
  theme_minimal() +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  theme(legend.position = "none")

#---------Turnover Rate vs Impact Score-----------

employee2.df$impact_score <- factor(employee2.df$impact_score, 
                                    levels = c("0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1"))


# Calculate turnover rate by impact_score
turnover_by_impact <- employee2.df %>%
  group_by(impact_score) %>%
  summarise(
    num_left = sum(left == 1),
    total = n(),
    turnover_rate = (num_left / total) * 100
  )

bar_plot<-ggplot(turnover_by_impact, aes(x = impact_score, y = turnover_rate, fill = impact_score)) +
  geom_bar(stat = "identity", fill= "steelblue") +
  labs(title = "Turnover Rate by Impact Score",
       x = "Impact Score",
       y = "Turnover Rate (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

stacked_plot<-ggplot(employee.df, aes(x = factor(impact_score), fill = factor(left))) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = c("0" = "skyblue", "1" = "salmon")) +  # Named colors
  labs(x = "Impact Score", y = "Count", fill = "Left", title = "Stacked Bar Plot of Impact Score by 'Left' Variable") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#combining plots
grid.arrange(bar_plot, stacked_plot, ncol = 2)

#=========== Analyzing Tenure vs Other Variables==============

#---------Salary Distribution by Tenure-----------

#Summarize the data with percentages
salary_distribution <- employee.df %>%
  group_by(time_spend_company, salary) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(time_spend_company) %>%
  mutate(percentage = count / sum(count) * 100) %>%
  ungroup()

# Print all rows of the salary_distribution data frame with percentages
print(salary_distribution, n = Inf)

# Create a stacked bar plot to visualize the frequency of each salary category by years spent in the company
ggplot(salary_distribution, aes(x = factor(time_spend_company), y = count, fill = salary)) +
  geom_bar(stat = "identity") +
  labs(title = "Salary Distribution by Tenure",
       x = "Years Spent in Company",
       y = "Number of Employees",
       fill = "Salary Category") +
  theme_minimal() +
  scale_fill_manual(values = c("low" = "lightblue", "medium" = "lightgreen", "high" = "salmon")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#---------Promotion Percentage by Tenure-----------

#Confirming structure
str(employee.df)

# Convert promotion_last_5years from factor to numeric
employee.df <- employee.df %>%
  mutate(promotion_last_5years = as.numeric(as.character(promotion_last_5years)))

# Summarize the total number of employees and number of promotions by years of tenure
promotion_summary <- employee.df %>%
  group_by(time_spend_company) %>%
  summarise(
    total_count = n(),
    promotion_count = sum(promotion_last_5years),
    .groups = 'drop'
  ) %>%
  mutate(
    promotion_percentage = (promotion_count / total_count) * 100
  )

# Plot the promotion percentage across years of tenure
ggplot(promotion_summary, aes(x = factor(time_spend_company), y = promotion_percentage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    x = "Years of Tenure",
    y = "Promotion Percentage",
    title = "Promotion Percentage Across Years of Tenure"
  ) +
  theme_minimal()

promotion_summary

#--------- Satisfaction Level by Tenure-----------

# Plot 1: Average Satisfaction Level vs. Time Spent at Company
avg_satisfaction_plot <- employee.df %>%
  group_by(time_spend_company) %>%
  summarize(avg_satisfaction_level = mean(satisfaction_level, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_satisfaction_level)) +
  geom_line(color = 'blue') +
  geom_point(color = 'blue') +
  labs(title = 'Average Satisfaction Level vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Satisfaction Level') +
  theme_minimal()

#--------- Number of Projects  by Tenure-----------

# Plot 2: Number of Projects vs. Time Spent at Company
number_projects_plot <- employee.df %>%
  group_by(time_spend_company) %>%
  summarize(avg_number_projects = mean(number_project, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_number_projects)) +
  geom_line(color = 'green') +
  geom_point(color = 'green') +
  labs(title = 'Average Number of Projects vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Number of Projects') +
  theme_minimal()

#--------- Last Evaluation by Tenure-----------

# Plot 3: Average Last Evaluation vs. Time Spent at Company
avg_last_evaluation_plot <- employee.df %>%
  group_by(time_spend_company) %>%
  summarize(avg_last_evaluation = mean(last_evaluation, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_last_evaluation)) +
  geom_line(color = 'purple') +
  geom_point(color = 'purple') +
  labs(title = 'Average Last Evaluation vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Last Evaluation') +
  theme_minimal()

#--------- Workload by Tenure-----------

# Plot 4: Average Monthly Hours vs. Time Spent at Company
avg_monthly_hours_plot <- employee.df %>%
  group_by(time_spend_company) %>%
  summarize(avg_monthly_hours = mean(average_montly_hours, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_monthly_hours)) +
  geom_line(color = 'red') +
  geom_point(color = 'red') +
  labs(title = 'Average Monthly Hours vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Monthly Hours') +
  theme_minimal()

#putting plots together
grid.arrange(avg_satisfaction_plot, number_projects_plot,
             avg_last_evaluation_plot, avg_monthly_hours_plot,
             ncol = 2)


#---------Tenure vs Other Variables separated by left vs stayed---------

# Plot 1
avg_satisfaction_plot <- employee.df %>%
  group_by(time_spend_company, left) %>%
  summarize(avg_satisfaction_level = mean(satisfaction_level, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_satisfaction_level, color = as.factor(left))) +
  geom_line() +
  geom_point() +
  labs(title = 'Average Satisfaction Level vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Satisfaction Level',
       color = 'Left Status') +
  scale_color_manual(values = c("blue", "red"), labels = c("Stayed", "Left")) +
  theme_minimal()

# Plot 2
number_projects_plot <- employee.df %>%
  group_by(time_spend_company, left) %>%
  summarize(avg_number_projects = mean(number_project, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_number_projects, color = as.factor(left))) +
  geom_line() +
  geom_point() +
  labs(title = 'Average Number of Projects vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Number of Projects',
       color = 'Left Status') +
  scale_color_manual(values = c("blue", "red"), labels = c("Stayed", "Left")) +
  theme_minimal()

# Plot 3
avg_last_evaluation_plot <- employee.df %>%
  group_by(time_spend_company, left) %>%
  summarize(avg_last_evaluation = mean(last_evaluation, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_last_evaluation, color = as.factor(left))) +
  geom_line() +
  geom_point() +
  labs(title = 'Average Last Evaluation vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Last Evaluation',
       color = 'Left Status') +
  scale_color_manual(values = c("blue", "red"), labels = c("Stayed", "Left")) +
  theme_minimal()

# Plot 4
avg_monthly_hours_plot <- employee.df %>%
  group_by(time_spend_company, left) %>%
  summarize(avg_monthly_hours = mean(average_montly_hours, na.rm = TRUE)) %>%
  ggplot(aes(x = time_spend_company, y = avg_monthly_hours, color = as.factor(left))) +
  geom_line() +
  geom_point() +
  labs(title = 'Average Monthly Hours vs. Time Spent at Company',
       x = 'Time Spent at Company (Years)',
       y = 'Average Monthly Hours',
       color = 'Left Status') +
  scale_color_manual(values = c("blue", "red"), labels = c("Stayed", "Left")) +
  theme_minimal()

# Putting plots together
grid.arrange(avg_satisfaction_plot, number_projects_plot,
             avg_last_evaluation_plot, avg_monthly_hours_plot,
             ncol = 2)

# ====================================
# Hypothesis Testing
# ====================================

# Chi-Square for salary and left
table_salary_left <- table(employee.df$salary, employee.df$left)
chisq.test(table_salary_left)
# Chi-Square for accident and left
table_accident_left <- table(employee.df$Work_accident, employee.df$left)
chisq.test(table_accident_left)

# ====================================
# Predictor Analysis and Relevancy
# ====================================

# -------------------------------
# 1. Correlation Analysis
# -------------------------------

#=========== Correlation Matrix =============

# Convert columns to numeric
employee.df$number_project <- as.numeric(employee.df$number_project)
employee.df$average_montly_hours <- as.numeric(employee.df$average_montly_hours)
employee.df$time_spend_company <- as.numeric(employee.df$time_spend_company)
employee.df$Work_accident <- as.numeric(employee.df$Work_accident)
employee.df$promotion_last_5years <- as.numeric(employee.df$promotion_last_5years)
employee.df$left <- as.numeric(employee.df$left)
employee.df$impact_score <- as.numeric(employee.df$impact_score)

# Calculate the correlation matrix 
cor_matrix <- cor(employee.df %>% select(satisfaction_level, left,last_evaluation, number_project, average_montly_hours, time_spend_company, Work_accident, promotion_last_5years, impact_score), use = "complete.obs")
cor_matrix
heatmap.2(cor_matrix, 
          Rowv = FALSE, 
          Colv = FALSE, 
          dendrogram = "none",
          cellnote = round(cor_matrix, 2),
          notecol = "black", 
          key = FALSE, 
          trace = 'none', 
          margins = c(10, 10),
          col = colorRampPalette(c("blue", "white", "red"))(100),
          cexRow = 0.9,   
          cexCol = 0.9)   

#=========== Handling Redundancy =============

# Excluding highly correlated feature 'impact score'
employee.df <- subset(employee.df, select = -impact_score)
head(employee.df)
str(employee.df)

#=========== Chi-Squared Tests =============

employee.df$Work_accident <- as.factor(employee.df$Work_accident)
employee.df$left <- as.factor(employee.df$left)
employee.df$promotion_last_5years <- as.factor(employee.df$promotion_last_5years)

# Chi-squared test between 'left' and 'work_accident'
contingency_work_accident <- table(employee.df$left, employee.df$Work_accident)
chi_squared_work_accident <- chisq.test(contingency_work_accident)
print("Chi-squared test between 'left' and 'Work_accident':")
print(chi_squared_work_accident)

# Chi-squared test between 'left' and 'promotion_last_5years'
contingency_promotion_last5years <- table(employee.df$left, employee.df$promotion_last_5years)
chi_squared_promotion_last5years <- chisq.test(contingency_promotion_last5years)
print("Chi-squared test between 'left' and 'promotion_last_5years':")
print(chi_squared_promotion_last5years)

# Chi-squared test between 'left' and 'department'
contingency_department <- table(employee.df$left, employee.df$department)
chi_squared_department <- chisq.test(contingency_department)
print("Chi-squared test between 'left' and 'department':")
print(chi_squared_department)

# Chi-squared test between 'left' and 'salary'
contingency_salary <- table(employee.df$left, employee.df$salary)
chi_squared_salary <- chisq.test(contingency_salary)
print("Chi-squared test between 'left' and 'salary':")
print(chi_squared_salary)

# ====================================
# K-Means Clusters
# ====================================
head(employee.df)

#=========== Variable Selection=============

# Filter for employees who left and exclude specified variables
employee_clustering_data <- employee.df %>%
  filter(left == 1) %>%
  select(-left, -Work_accident, -department, -promotion_last_5years, -salary)

# Standardize numerical variables
employee_clustering_data_scaled <- scale(employee_clustering_data)

#=========== Determining Number of K: "Elbow Plot"=============

# Optimal number of clusters using the Elbow Method
fviz_nbclust(employee_clustering_data_scaled, kmeans, method = "wss") +
  labs(subtitle = "Elbow Method for Optimal Number of Clusters")

#=========== Applying K-Means Algorithm=============

# Apply K-means clustering
set.seed(123)
employee_clusters <- kmeans(employee_clustering_data_scaled, centers = 3, nstart = 100)

#=========== Performance Evaluation =============

# Silhouette analysis for clustering quality
dist_employee <- dist(employee_clustering_data_scaled)  # Calculate the distance matrix
silhouette_employee <- silhouette(employee_clusters$cluster, dist_employee)  # Compute silhouette values

# Plot silhouette values
plot(silhouette_employee, col = 1:3, border = NA, 
     main = "Silhouette Plot for Employee Clusters")

#=========== Cluster Profile Analysis =============

# Add cluster assignments back to the filtered dataset
employee_clustering_data <- employee_clustering_data %>%
  mutate(Cluster = as.factor(employee_clusters$cluster))

# Cluster centers
employee_centers <- as.data.frame(t(employee_clusters$centers))
colnames(employee_centers) <- paste0("Cluster", 1:3)
rownames(employee_centers) <- colnames(employee_clustering_data_scaled)

employee_centers_long <- employee_centers %>%
  as.data.frame() %>%
  mutate(Variable = rownames(employee_centers)) %>%
  pivot_longer(cols = starts_with("Cluster"), names_to = "Cluster", values_to = "Value")

# Create the bar plot
plot_ly(employee_centers_long, 
        x = ~Cluster, 
        y = ~Value, 
        color = ~Variable, 
        type = 'bar') %>%
  layout(
    title = "Cluster Centers by Variable",
    xaxis = list(title = "Clusters"),
    yaxis = list(title = "Cluster Centers"),
    barmode = 'group'
  )


# ===================================================
# Analyzing of Salary and Promotions Across Clusters
# ===================================================

# Add salary and promotion columns directly from employee.df
employee_clustering_data$salary <- employee.df$salary[employee.df$left == 1]
employee_clustering_data$promotion_last_5years <- employee.df$promotion_last_5years[employee.df$left == 1]

summary(employee_clustering_data)

# Calculate salary distribution by cluster
salary_distribution <- table(employee_clustering_data$Cluster, employee_clustering_data$salary)

# Convert to proportions
salary_proportions <- prop.table(salary_distribution, margin = 1)

# View results
print(salary_proportions)

# Calculate promotion distribution by cluster
promotion_distribution <- table(employee_clustering_data$Cluster, employee_clustering_data$promotion_last_5years)

# Convert to proportions
promotion_proportions <- prop.table(promotion_distribution, margin = 1)

# View results
print(promotion_proportions)

# ===================================================
#  Data Partitioning
# ===================================================
 
set.seed(123)
# Calculate the number of rows for each set
total_rows <- nrow(employee.df)
train_rows <- round(0.7 * total_rows)
validation_rows <- round(0.2 * total_rows)

# Create the indices for each set
train_indices <- sample(seq_len(total_rows), size = train_rows)
remaining_indices <- setdiff(seq_len(total_rows), train_indices)
validation_indices <- sample(remaining_indices, size = validation_rows)
test_indices <- setdiff(remaining_indices, validation_indices)

# Split the dataset
train_set <- employee.df[train_indices, ]
validation_set <- employee.df[validation_indices, ]
test_set <- employee.df[test_indices, ]

# ===================================================
#  Feature Selection
# ===================================================

# -------------------------------
# 1. Feature Selection: Boruta
# -------------------------------

boruta_output <- Boruta(left ~ ., data = train_set, doTrace = 2)

# Print the Boruta output
print(boruta_output)

# Get the important features
important_features <- getSelectedAttributes(boruta_output, withTentative = T)
print(important_features)
par(mar = c(10, 4, 2, 2))
plot(boruta_output, cex.axis = 0.7, las = 2, main = "Boruta - Feature Importance")

# -----------------------------------------------------------------------
# 2. Feature Selection and Model Fitting with Stepwise Logistic Regression
# -----------------------------------------------------------------------

# Fit a logistic regression model using glm
full_model <- glm(left ~ ., data = train_set, family = binomial)

# Perform stepwise regression 
stepwise_model <- step(full_model, direction = "backward", trace = TRUE)

# Summary of the final model
summary(stepwise_model)


# ===================================================
#  Model Fitting
# ===================================================

# -------------------------------------------
# 1. Logistic Regression (Stepwise)
# -------------------------------------------

# The logistic regression model was already fitted during feature selection

#Summary of the model for reference
summary(stepwise_model)

# ----------------------------------------
# 2. Decision Tree 
# ----------------------------------------

decision_tree_model <- rpart(left ~ ., data = train_set, method = "class")
decision_tree_model

# Plot the decision tree
rpart.plot(decision_tree_model, split.font = 1 ,shadow.col="gray", varlen = -18,  cex = 0.8)

# ---------------------------------------
# 3. Random Forest
# ---------------------------------------

set.seed(123)
# Fit a Random Forest model
rf_model <- randomForest(left ~ ., data = train_set, importance = TRUE, ntree = 500)
rf_model

# Print feature importance
print(importance(rf_model))
varImpPlot(rf_model, type =2)
varImpPlot(rf_model, type =1)


#============ Normalizing Dataset to fit Neural Networks and KNN ===============

# Creating copies of partitions to normalize
train_set2 <- train_set
validation_set2 <- validation_set
test_set2 <- test_set

# Convert columns to numeric for train_set2
train_set2$Work_accident <- as.numeric(as.character(train_set2$Work_accident))
train_set2$left <- as.numeric(as.character(train_set2$left))
train_set2$promotion_last_5years <- as.numeric(as.character(train_set2$promotion_last_5years))

# Convert columns to numeric for validation_set2
validation_set2$Work_accident <- as.numeric(as.character(validation_set2$Work_accident))
validation_set2$left <- as.numeric(as.character(validation_set2$left))
validation_set2$promotion_last_5years <- as.numeric(as.character(validation_set2$promotion_last_5years))

# Convert columns to numeric for test_set2
test_set2$Work_accident <- as.numeric(as.character(test_set2$Work_accident))
test_set2$left <- as.numeric(as.character(test_set2$left))
test_set2$promotion_last_5years <- as.numeric(as.character(test_set2$promotion_last_5years))

# Convert categorical variables to dummy variables for train_set2
train_set2_dummies <- dummy_cols(train_set2, 
                                 select_columns = c("department", "salary"),
                                 remove_first_dummy = FALSE)

# Convert categorical variables to dummy variables for validation_set2
validation_set2_dummies <- dummy_cols(validation_set2, 
                                      select_columns = c("department", "salary"),
                                      remove_first_dummy = FALSE)

# Convert categorical variables to dummy variables for test_set2
test_set2_dummies <- dummy_cols(test_set2, 
                                select_columns = c("department", "salary"),
                                remove_first_dummy = FALSE)

# Remove original categorical columns for train_set2_dummies
train_set2_dummies <- subset(train_set2_dummies, select = -c(department, salary))

# Remove original categorical columns for validation_set2_dummies
validation_set2_dummies <- subset(validation_set2_dummies, select = -c(department, salary))

# Remove original categorical columns for test_set2_dummies
test_set2_dummies <- subset(test_set2_dummies, select = -c(department, salary))

# Step 1: Compute min and max from the training set only
train_min <- apply(train_set2_dummies, 2, min)
train_max <- apply(train_set2_dummies, 2, max)

# Step 2: Define normalization function
normalize <- function(x, min, max) {
  (x - min) / (max - min)
}

# Step 3: Normalize training set using training min and max
train_set2_dummies_norm <- as.data.frame(mapply(function(x, min, max) {
  normalize(x, min, max)
}, train_set2_dummies, train_min, train_max))

# Step 4: Normalize validation set using training min and max
validation_set2_dummies_norm <- as.data.frame(mapply(function(x, min, max) {
  normalize(x, min, max)
}, validation_set2_dummies, train_min, train_max))

# Step 5: Normalize test set using training min and max
test_set2_dummies_norm <- as.data.frame(mapply(function(x, min, max) {
  normalize(x, min, max)
}, test_set2_dummies, train_min, train_max))

# ---------------------------------------
# 4. Neural Networks
# ---------------------------------------

#============ NN Model 1 ===============
set.seed(123)
#fitting model to data
NN_model<-neuralnet(left~., data=train_set2_dummies_norm, hidden =1)

# Plotting the neural network model
plot(NN_model)
#summary
summary(NN_model)
#weights
NN_model$weights
#info
NN_model$result.matrix

#============ NN Model 2 ===============
set.seed(123)
NN_model2<-neuralnet(left~., data=train_set2_dummies_norm, hidden = 2)
#plot
plot(NN_model2)
#info
NN_model2$result.matrix

# ---------------------------------------
# 5. KNN
# ---------------------------------------

#finding best k 
knn.tuning <- tune.knn(x = select(train_set2_dummies_norm, -left),
                       y = as.factor(train_set2_dummies_norm$left),
                       k = 1:30)
# View tuning results
summary(knn.tuning)
print(knn.tuning)
plot(knn.tuning)

#fitting model based on best k
knn_predictions <- knn(train = select(train_set2_dummies_norm, -left), 
                       test = select(validation_set2_dummies_norm, -left), 
                       cl = train_set2_dummies_norm$left,  
                       k = 1)


#choosing alternative k=7
knn_predictions2 <- knn(train = select(train_set2_dummies_norm, -left), 
                        test = select(validation_set2_dummies_norm, -left), 
                        cl = train_set2_dummies_norm$left,  
                        k = 7,
                        prob = TRUE)

# ===================================================
#  Performance Evaluation
# ===================================================

# -------------------------------------------
# 1. Logistic Regression (Stepwise)
# -------------------------------------------
stepwise_preds <- predict(stepwise_model, newdata = validation_set, type = "response")

# Convert probabilities to class predictions
stepwise_class_preds <- ifelse(stepwise_preds > 0.5, 1, 0)

#confusion matrix 1
confusion_matrix_lreg<-confusionMatrix(as.factor(stepwise_class_preds), validation_set$left, positive = "1")
confusion_matrix_lreg

#testing different threshold
stepwise_class_preds_improved <- ifelse(stepwise_preds > 0.3, 1, 0)

#confusion matrix 2
confusion_matrix_lreg_improved<-confusionMatrix(as.factor(stepwise_class_preds_improved), validation_set$left, positive = "1")
confusion_matrix_lreg_improved

#ROC Curve
roc_curve_stepwise <- roc(validation_set$left, stepwise_preds)

#AUC
auc_score_stepwise<-auc(roc_curve_stepwise)
auc_score_stepwise

#plot
plot(roc_curve_stepwise, main = "ROC Curve for Stepwise Regression Model", lwd = 2)

# -------------------------------------------
# 2. Decision Tree
# -------------------------------------------

#predictions
tree_pred <- predict(decision_tree_model, validation_set, type = "class")

#performance evaluation
confusion_matrix_tree <- confusionMatrix(tree_pred ,validation_set$left, positive = "1")
print(confusion_matrix_tree)

# Predict probabilities on the validation set
tree_pred_prob <- predict(decision_tree_model, validation_set, type = "prob")

# ROC Curve
roc_curve_tree <- roc(validation_set$left, tree_pred_prob[, 2])

# AUC
auc_score_tree <- auc(roc_curve_tree)
auc_score_tree

# Plot 
plot(roc_curve_tree, main = "ROC Curve for Decision Tree Model", lwd = 2)


# -------------------------------------------
# 3. Random Forest
# -------------------------------------------

###random forest predictions
rf_predictions<-predict(rf_model, newdata = validation_set)

#random forests predictions as probabilities#######
rf_probabilities <- predict(rf_model, newdata = validation_set, type = "prob")[, 2]

#confusion matrix
confusion_matrix_rf<-confusionMatrix(as.factor(rf_predictions), as.factor(validation_set$left), positive = "1")
confusion_matrix_rf


# ROC Curve
roc_curve_rf <- roc(validation_set$left, rf_probabilities)

# AUC
auc_score_rf <- auc(roc_curve_rf)
auc_score_rf

#Plot
plot(roc_curve_rf, main = "ROC Curve for Random Forest Model", lwd = 2)

# -------------------------------------------
# 4. Neural Networks 
# -------------------------------------------

#============ NN Model 1 ===============
# predictions
nn_pred<-compute(NN_model, validation_set2_dummies_norm )

pred_results_nn<-nn_pred$net.result

NN_model$result.matrix

#evaluating performance
predicted_classes_nn <- ifelse(pred_results_nn > 0.5, 1, 0)
confusion_matrix_NN <- confusionMatrix(as.factor(predicted_classes_nn), as.factor(validation_set2_dummies_norm$left), positive = "1")
print(confusion_matrix_NN)

#ROC Curve
roc_curve_nn <- roc(validation_set2_dummies_norm$left, pred_results_nn[,1])
plot(roc_curve_nn, main = "ROC Curve for Neural Network Model (hidden = 1)", lwd = 2)

# AUC
auc_score_nn <- auc(roc_curve_nn)
auc_score_nn

#Plot
plot(roc_curve_nn, main = "ROC Curve for Neural Network Model (hidden = 1)", lwd = 2)

#============ NN Model 2 ===============
#predictions
nn_pred2<-compute(NN_model2, validation_set2_dummies_norm )
pred_results_nn2<-nn_pred2$net.result

#evaluating performance
predicted_classes_nn2 <- ifelse(pred_results_nn2 > 0.5, 1, 0)
confusion_matrix_NN2 <- confusionMatrix(as.factor(predicted_classes_nn2), as.factor(validation_set2_dummies_norm$left), positive = "1")
print(confusion_matrix_NN2)

#improving model by adjusting threshold
predicted_classes_nn2_improved <- ifelse(pred_results_nn2 > 0.3, 1, 0)
confusion_matrix_NN2_improved<- confusionMatrix(as.factor(predicted_classes_nn2_improved), as.factor(validation_set2_dummies_norm$left), positive = "1")
print(confusion_matrix_NN2_improved)

#ROC Curve
roc_curve_nn2 <- roc(validation_set2_dummies_norm$left, pred_results_nn2[,1])

#AUC
auc_score_nn2 <- auc(roc_curve_nn2)
auc_score_nn2

#Plot
plot(roc_curve_nn2, main = "ROC Curve for Neural Network Model (hidden = 2)", lwd = 2)

# -------------------------------------------
# 5. KNN
# -------------------------------------------

confusion_matrix_knn <- confusionMatrix(as.factor(knn_predictions), as.factor(validation_set2_dummies_norm$left), positive = "1")
print(confusion_matrix_knn)

confusion_matrix_knn2 <- confusionMatrix(as.factor(knn_predictions2), as.factor(validation_set2_dummies_norm$left), positive = "1")
print(confusion_matrix_knn2)

# Extract probabilities for the positive class
positive_probs <- ifelse(knn_predictions2 == "1", attr(knn_predictions2, "prob"), 1 - attr(knn_predictions2, "prob"))

#ROC Curve
roc_curve_knn <- roc(response = validation_set2_dummies_norm$left, predictor = positive_probs, levels = c("0", "1"))

#AUC
auc_score_knn <- auc(roc_curve_knn)
auc_score_knn

#Plot
plot(roc_curve_knn, main = "ROC Curve for KNN")

# -------------------------------------------
# ROC CURVES COMPARISON
# -------------------------------------------
plot(roc_curve_tree, col = "blue", lwd = 2, main = "ROC Curves Comparison", 
     xlab = "Specificity", ylab = "Sensitivity")
lines(roc_curve_rf, col = "red", lwd = 2)
lines(roc_curve_nn, col = "green", lwd = 2)
lines(roc_curve_nn2, col = "purple", lwd = 2)
lines(roc_curve_stepwise, col = "orange", lwd = 2)
lines(roc_curve_knn, col = "black", lwd = 2)

# Add a legend
legend("bottomright", 
       legend = c("Decision Tree", "Random Forest", "Neural Network 1", 
                  "Neural Network 2", "Logistic Regression", "KNN"), 
       col = c("blue", "red", "green", "purple", "orange", "black"), 
       lwd = 2, cex = 0.6)


# ===================================================
#  TEST PHASE
# ===================================================

# -------------------------------------------
# Applying Model to Test Set
# -------------------------------------------
test_pred<-predict(rf_model, newdata = test_set)

# -------------------------------------------
# Performance Evaluation
# -------------------------------------------
final_confusion_matrix<-confusionMatrix(as.factor(test_pred), as.factor(test_set$left), positive = "1")
final_confusion_matrix

# ===================================================
#  Model Implementation Phase
# ===================================================

#creating final dataset with only current employees
employee_final.df<- subset(employee.df, left == 0)
head(employee_final.df)

#applying final model to filtered dataset as probabilities
rf_final_predictions<- predict(rf_model, newdata = employee_final.df, type = "prob")
rf_final_predictions

# Extract probabilities of class 1 (employee leaving)
rf_final_predictions[, "1"]

# Add these probabilities as a new column to the dataset
employee_final.df$probability_leaving <- rf_final_predictions[, "1"]

head(employee_final.df)

employee_final.df$turnover_risk <- ifelse(
  employee_final.df$probability_leaving <= 0.1, "Low Risk",
  ifelse(employee_final.df$probability_leaving > 0.1 & employee_final.df$probability_leaving < 0.3, "Low-Moderate Risk",
         ifelse(employee_final.df$probability_leaving >= 0.3 & employee_final.df$probability_leaving < 0.5, "Moderate Risk", 
                "High Risk"))
)


# Convert turnover_risk to a factor with ordered levels
employee_final.df$turnover_risk <- factor(
  employee_final.df$turnover_risk,
  levels = c("Low Risk", "Low-Moderate Risk", "Moderate Risk", "High Risk"),
  ordered = TRUE
)

# Display the first few rows to check the new column
head(employee_final.df)

#Adding column impact score back to identify which of the employees leaving are more significant 
#and requires more urgency
current_employees<-employee.df
current_employees$impact_score<-impact_score
current_employees<-subset(current_employees, left==0)
impact_score<-current_employees$impact_score
employee_final.df$impact_score<-impact_score

head(employee_final.df)

# Filter and sort for each risk category
low_risk <- employee_final.df %>%
  filter(turnover_risk == "Low Risk") %>%
  arrange(desc(impact_score), desc(probability_leaving))

low_moderate_risk <- employee_final.df %>%
  filter(turnover_risk == "Low-Moderate Risk") %>%
  arrange(desc(impact_score), desc(probability_leaving))

moderate_risk <- employee_final.df %>%
  filter(turnover_risk == "Moderate Risk") %>%
  arrange(desc(impact_score), desc(probability_leaving))

high_risk <- employee_final.df %>%
  filter(turnover_risk == "High Risk") %>%
  arrange(desc(impact_score), desc(probability_leaving))

# Display the first few rows for each category
View(head(low_risk, n=10))
View(head(low_moderate_risk, n=10))
View(head(moderate_risk, n=10))
View(head(high_risk,n =10))

# Filter out the "Low Risk" category
filtered_data <- employee_final.df %>%
  filter(turnover_risk != "Low Risk")

# Count of employees by turnover risk category
risk_counts <- filtered_data %>%
  group_by(turnover_risk) %>%
  summarise(count = n()) 

# Plot count distribution with labels
ggplot(risk_counts, aes(x = turnover_risk, y = count, fill = turnover_risk)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = count), vjust = -0.5) +  # Add count labels
  labs(title = "Count of Employees by Risk Category",
       x = "Risk Category",
       y = "Count") +
  theme_minimal() +
  theme(legend.position = "none")

# ===================================================
#  Post Implementation EDA
# ===================================================

# Filtering employees with 0 probability of leaving
safe_employees <- subset(employee_final.df, probability_leaving == 0)

# -------------------------------------------
# Summary Stats and Histograms 
# -------------------------------------------

#Summary Statistics
summary(safe_employees)

# Satisfaction Level Histogram
plot_satisfaction <- ggplot(safe_employees, aes(x = satisfaction_level)) +
  geom_histogram(binwidth = 0.05, fill = "salmon", color = "black") +
  labs(title = "Satisfaction Level", x = "Satisfaction Level", y = "Frequency")

# Last Evaluation Histogram
plot_evaluation <- ggplot(safe_employees, aes(x = last_evaluation)) +
  geom_histogram(binwidth = 0.05, fill = "salmon", color = "black") +
  labs(title = "Last Evaluation", x = "Last Evaluation", y = "Frequency")

# Average Monthly Hours Histogram
plot_hours <- ggplot(safe_employees, aes(x = average_montly_hours)) +
  geom_histogram(binwidth = 10, fill = "salmon", color = "black") +
  labs(title = "Average Monthly Hours", x = "Average Monthly Hours", y = "Frequency")

# Number of Projects Assigned Histogram
plot_projects <- ggplot(safe_employees, aes(x = number_project)) +
  geom_histogram(binwidth = 1, fill = "salmon", color = "black") +
  labs(title = "Number of Projects Assigned", x = "Number of Projects Assigned", y = "Frequency")

# Grid them together
grid.arrange(plot_satisfaction, plot_evaluation, plot_hours, plot_projects, ncol = 2)

# -------------------------------------------
# Salary and Promotions Comparison
# -------------------------------------------

#obtaining dataset for employees who left
left_employees<- subset(employee.df,left==1)

#summary
summary(left_employees)

#promotion rate for employees who left
promotion_rate_left <- sum(left_employees$promotion_last_5years == 1) / sum(left_employees$promotion_last_5years == 1 | left_employees$promotion_last_5years == 0)
promotion_rate_left

# promotion rate for employees who are still employed
promotion_rate_safe <- sum(safe_employees$promotion_last_5years == 1) / sum(safe_employees$promotion_last_5years == 1 | safe_employees$promotion_last_5years == 0)
promotion_rate_safe

#promotion rates for both groups
promotion_rates <- data.frame(
  group = c("Employees Who Left", "No-Risk Employees"),
  promotion_rate = c(promotion_rate_left, promotion_rate_safe)
)
promotion_rates

ggplot(promotion_rates, aes(x = group, y = promotion_rate, fill = group)) +
  geom_bar(stat = "identity", width = 0.6) +
  labs(title = "Promotion Rates of Employees Who Left vs No-Risk Employees",
       x = "Employee Group",
       y = "Promotion Rate",
       fill = NULL) +  # Removes the legend title
  theme_minimal()


# salary percentage for safe_employees
salary_distribution_safe <- as.data.frame(table(safe_employees$salary))
colnames(salary_distribution_safe) <- c("salary", "count")
salary_distribution_safe$percentage <- (salary_distribution_safe$count / sum(salary_distribution_safe$count)) * 100
salary_distribution_safe$group <- "No risk Employees"

# salary percentage for left_employees
salary_distribution_left <- as.data.frame(table(left_employees$salary))
colnames(salary_distribution_left) <- c("salary", "count")
salary_distribution_left$percentage <- (salary_distribution_left$count / sum(salary_distribution_left$count)) * 100
salary_distribution_left$group <- "Employees Who Left"

# Combine the two datasets
combined_salary_distribution <- rbind(salary_distribution_safe, salary_distribution_left)
combined_salary_distribution

#Plot
ggplot(combined_salary_distribution, aes(x = salary, y = percentage, fill = group)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6) +
  labs(title = "Salary Distribution (%) for No-Risk Employees and Employees Who Left",
       x = "Salary Category",
       y = "Percentage (%)",
       fill = NULL) +  
  theme_minimal() +
  scale_y_continuous(labels = scales::percent_format(scale = 1))

# -------------------------------------------
# Satisfaction Improvement Analysis
# -------------------------------------------

# Run Boruta directly on the dataset
set.seed(123)  
boruta_result <- Boruta(satisfaction_level ~ .-left-time_spend_company, data = employee.df, doTrace = 2)

# Print results
print(boruta_result)

#Plot
par(mar = c(10 , 4, 2, 2))
plot(boruta_result, cex.axis = 0.7, las = 2, main = "Boruta - Feature Importance")

