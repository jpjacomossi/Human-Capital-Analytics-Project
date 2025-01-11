# Human Capital Analytics: Addressing Employee Turnover

## Table of Contents
1. [Background and Overview](#background-and-overview)
2. [Data Structure Overview](#data-structure-overview)
3. [Executive Summary](#executive-summary)
4. [Insights Deep Dive](#insights-deep-dive)
   - [Turnover Drivers](#turnover-drivers)
   - [Turnover Profiles and Cluster Performance](#turnover-profiles-and-cluster-performance)
   - [Impact Score Methodology](#impact-score-methodology)
   - [Turnover Risk Categorization](#turnover-risk-categorization)
   - [Predictive Modeling Insights](#predictive-modeling-insights)
   - [Retention Insights](#retention-insights)
5. [Recommendations](#recommendations)
6. [Tools and Technologies](#tools-and-technologies)

## Background and Overview
In today’s competitive business environment, an organization’s success relies heavily on its human capital. Talent retention is critical to maintaining a competitive edge, fostering innovation, and achieving long-term business goals. High employee turnover not only disrupts productivity but also incurs significant costs in hiring, onboarding, and training replacements. 

This project focuses on leveraging analytics to address high employee turnover at a medium-sized engineering company. By analyzing a dataset provided by the HR department containing information on 14,999 employees across 10 variables, the goal is to uncover the factors contributing to resignations, develop employee turnover profiles, and predict which current employees are at risk of leaving. These insights will empower the organization to implement data-driven retention strategies and enhance workforce stability.

Key areas of focus include:
1. **Exploratory Data Analysis (EDA)** to identify patterns and factors contributing to turnover.
2. **Employee Profiling** Using K-Means clustering to segment former employees into distinct categories based on shared characteristics.
3. **Predictive Modeling** to assess the likelihood of turnover among current employees.
4. **Strategic Recommendations** to address the factors contributing to turnover, guided by the insights obtained from the analysis.

By understanding the root causes of employee turnover and proactively identifying at-risk individuals, this analysis aims to improve retention, enhance employee satisfaction, and sustain organizational effectiveness.

## Data Structure Overview

The dataset consists of 11,428 employee records and includes the following key variables:

### Original Variables:
- **satisfaction_level**: Employee satisfaction score (0–1.00).
- **last_evaluation**: Most recent performance evaluation score (0–1.00).
- **number_project**: Total number of projects assigned.
- **average_monthly_hours**: Average hours worked per month.
- **time_spend_company**: Years at the company.
- **Work_accident**: Work accident indicator (1 = Yes, 0 = No).
- **left**: Turnover status (1 = Employee left, 0 = Employee stayed).
- **promotion_last_5years**: Promotion in the last 5 years (1 = Yes, 0 = No).
- **department**: Employee's department (e.g., Sales, Technical, Support).
- **salary**: Salary level categorized as "low," "medium," or "high."

### Derived Variables: 
- **impact_score**: A composite metric combining salary, tenure, and performance evaluation to measure an employee's contribution to organizational goals.
  
### Model-Generated Variables:
- **probability_leaving**: Predicted probability of an employee leaving the company (0–1.00).
- **turnover_risk**: Risk category based on predicted probability ("Low Risk," "Moderate Risk," "High Risk").


## Executive Summary
This project addresses high employee turnover at an engineering company by identifying the reasons behind employee departures and predicting which current employees are at risk of leaving. The analysis provides actionable insights to guide strategic retention efforts and improve workforce stability.

### Key Findings

#### 1. Factors Influencing Turnover
- Dissatisfaction, low salaries, limited career advancement opportunities, and imbalanced workloads are significant contributors to turnover.
- Turnover rates are particularly high during mid-tenure periods (years 4–6).

#### 2. Profiles of Employees Who Left (Clustering Analysis)
- **Disengaged Employees**: Low performers with minimal projects and short tenures, often leaving due to insufficient support or engagement.
- **Overworked Achievers**: High performers with heavy workloads, leaving due to burnout and unrecognized contributions.
- **Stagnated Employees**: Long-tenured, highly satisfied, and strong performers who left due to a lack of growth and promotion opportunities.

#### 3. Predictive Modeling Results
- The Random Forest model achieved the following results:
  - **Accuracy (99.07%)**: The proportion of total predictions (leave vs. stay) that were correct.
  - **Sensitivity (96.47%)**: The model's ability to correctly identify employees who are at risk of leaving (true positives).
  - **Precision (99.39%)**: Among employees predicted to leave, the proportion that actually left, demonstrating the model’s reliability in identifying true risks.
- The model flagged:
  - **8 high-risk employees**
  - **19 moderate-risk employees**
  - **218 low-moderate-risk employees**
    
- Employees at each risk category were ranked using an **impact score** which was designed to identify employees whose departures would have a significant organizational impact, helping HR allocate resources effectively and prioritize retention efforts for critical roles.


These findings equip HR with a proactive, data-driven framework to improve employee satisfaction and foster a stable and engaged workforce.

## Insights Deep Dive

### 1. Turnover Drivers
- **Salary Impact**:
  - 6.63% of high-salary employees leave, compared to 29.7% of low-salary employees and 20.4% of medium-salary employees.
  - Among employees who left, 60.8% were in the low-salary group, while only 2.3% were in the high-salary group. This overrepresentation highlights low salary as a key driver of turnover (Figure 6.10).

- **Performance Evaluation**:
  - Turnover rates vary significantly across performance evaluation scores (last evaluation):
    - **Low Performers**: Employees with evaluation scores between 0.4 and 0.5 exhibit the highest turnover rate (43.1%).
    - **Medium Performers**: Employees with scores between 0.6 and 0.7 have the lowest turnover rate (2.46%).
    - **High Performers**: Employees with scores between 0.9 and 1 show an elevated turnover rate (32.7%), above the overall average of 23.8%.
  - These trends suggest:
    - Low performers leave due to underperformance and potential lack of fit.
    - High performers may leave due to seeking better opportunities in terms of salary and professional growth, despite their strong contributions to the organization.

- **Tenure and Promotions**:
  - Turnover peaks at year 5, coinciding with the lowest promotion rates (1.15% at year 5 and 1.37% at year 4). In contrast, employees with a tenure of 7+ years, who experience the highest promotion rates, show zero turnover (Figure 6.25).
  - Employees not promoted in the last five years have a turnover rate approximately 4 times higher (24.2%) than those who were promoted (5.96%) (Figure 6.13).

- **Workload and Satisfaction**:
  - Turnover rates exceed 30% for employees with low (90–145 hours) or very high workloads (255–310 hours) (Figure 6.20).
  - Employees in the optimal workload range (162–216 hours) show the lowest turnover rate of 2.11% (Figure 6.21).
  - Turnover reaches 100% among the most dissatisfied employees, underscoring the critical role of satisfaction in retention. In contrast, turnover rates for generally satisfied employees’ range between 12.5% and 25%, indicating significantly better retention in this group 

---

### 2. Turnover Profiles and Cluster Performance

#### **Cluster Metrics**
- **Overall Silhouette Width**: 0.73 (indicating strong clustering quality).
  - **Cluster 1 (Disengaged Employees)**:
    - Silhouette Width: 0.82
    - Employees: 1,649
    - Represents the most cohesive and distinct cluster.
  - **Cluster 2 (Overworked Achievers)**:
    - Silhouette Width: 0.67
    - Employees: 963
    - Strong clustering quality but with slightly less separation from neighboring clusters.
  - **Cluster 3 (Stagnated Employees)**:
    - Silhouette Width: 0.64
    - Employees: 959
    - Lower but still acceptable clustering quality.

#### **Profile Descriptions**
1. **Disengaged Employees** (Cluster 1):
   - Minimal involvement (low projects, fewer hours) and low performance.
   - Likely to leave early in tenure due to lack of support and motivation.

2. **Overworked Achievers** (Cluster 2):
   - High performance, heavy workloads, but low satisfaction.
   - Left due to burnout and lack of recognition.

3. **Stagnated Employees** (Cluster 3):
   - Long-tenured, satisfied, and strong performers but left due to limited career growth opportunities and low salaries.

#### **Key Observations Across Clusters**
- **Salary Distribution**:
  - Over 60% of employees in all clusters fall into the low-salary category (Table 10.5).
- **Promotion Rates**:
  - Promotions are rare across all clusters, with less than 1% receiving promotions in the last five years (Table 10.6).
- These trends suggest systemic issues affecting all clusters, amplifying specific pain points within each group.

---

### 3. Impact Score Methodology
The **Impact Score** is a composite metric designed to prioritize employees who contribute the most to the organizational goals. It incorporates three key criteria:

#### **Criteria and Scoring**
1. **Time Spent in Company**:
   - Scoring:
     - 0 for tenure ≤ 3 years.
     - 0.5 for tenure between 4 and 6 years.
     - 1 for tenure > 6 years.
   - **Weight**: 40% (0.4).

2. **Salary Level**:
   - Scoring:
     - 0 for "low" salary.
     - 0.5 for "medium" salary.
     - 1 for "high" salary.
   - **Weight**: 20% (0.2).

3. **Last Evaluation Score**:
   - Scoring:
     - 0 for evaluation < 0.6.
     - 0.5 for evaluation between 0.6 and 0.8.
     - 1 for evaluation > 0.8.
   - **Weight**: 40% (0.4).

#### **Formula**
The Impact Score is calculated as:

***Impact Score = (0.4 × Time Score) + (0.2 × Salary Score) + (0.4 × Evaluation Score)***

- Incorporating salary into the formula ensures that employees in more critical roles are differentiated from others, even if they have similar evaluation scores and tenures. This helps HR better identify which employees contribute most to organizational priorities.

---

### 4. Turnover Risk Categorization
- Employees were categorized based on their predicted probability of leaving:
  - **Low Risk**: ≤ 0.1
  - **Low-Moderate Risk**: 0.1 < Probability ≤ 0.3
  - **Moderate Risk**: 0.3 < Probability ≤ 0.5
  - **High Risk**: > 0.5
- The categorization ensures HR can easily identify employees at varying levels of turnover risk, providing a structured way to prioritize retention efforts.

---

### 5. Predictive Modeling Insights
- The dataset was partitioned into training (70%), validation (20%), and testing (10%) sets to ensure robust model evaluation.
- The Random Forest model was selected due to its superior performance:
  - **Accuracy**: 99.07% - Correctly classified employees who stayed or left.
  - **Sensitivity**: 96.47% - Effectively identified employees at risk of leaving.
  - **Precision**: 99.39% - Ensured predicted at-risk employees were truly at risk.
- The model categorized employees into four risk groups:
  - **High Risk**: 8 employees.
  - **Moderate Risk**: 19 employees.
  - **Low-Moderate Risk**: 218 employees.
  - **Low Risk**: 11,183 employees.

---
### 6. Insights on Retention

Retention is influenced by factors such as salary, promotion rates, workload, and performance metrics. By analyzing employees with no risk of leaving (as predicted by the model with a **probability of leaving = 0**) compared to those who left, several key insights emerged:

- **Salary Distribution**:
  - Employees with higher salaries are more likely to stay, with 10.7% of no-risk employees earning high salaries compared to only 2.3% among those who left.
  - Conversely, 60.8% of employees who left were in the low-salary group, compared to 40.9% of no-risk employees. Addressing salary disparities could significantly improve retention.

- **Promotion Rates**:
  - No-risk employees had a promotion rate of 2.07%, nearly four times higher than the 0.53% rate for employees who left. This highlights the importance of providing career growth opportunities to reduce turnover.

- **Optimal Ranges for Key Metrics**:
  - Employees who remain with the company tend to fall within these ranges for key variables:
    - Satisfaction Level: 0.62–1.
    - Last Evaluation: 0.59–1.
    - Average Monthly Hours: 166–229.
    - Number of Projects: 3–4.
  - Employees outside these ranges, such as those with low satisfaction or extreme workloads, are more likely to leave. Balancing these metrics can help improve retention.

- **Factors Influencing Satisfaction**:
  - Improving workforce satisfaction is critical to maximizing employee retention. To better understand what influences satisfaction, the Boruta algorithm was applied to the dataset, using satisfaction level as the target variable.
  - The variables `left` and `time_spent_company` were excluded due to their redundancy and self-evident relationships with satisfaction. The analysis focused on the entire dataset, including both current and former employees, to capture broader drivers of satisfaction.
  - The analysis identified **number of projects** and **average monthly hours worked** as the two most significant predictors of satisfaction. Ensuring these variables remain within the recommended ranges is crucial for achieving retention goals (Figure 18.5).

- **Observations on Employees Who Stayed vs. Left**:
  - Employees who stayed showed steady values for satisfaction, workload, and performance, indicating balanced engagement.
  - Employees who left often exhibited extremes, such as low satisfaction or excessive workloads, or high performance without recognition, leading to dissatisfaction.

By focusing on these factors, the company can implement targeted strategies to enhance retention, including addressing salary gaps, increasing promotion opportunities, balancing workloads, and proactively identifying at-risk employees based on satisfaction, evaluation, and workload metrics.

## Recommendations

The primary objective of this section is to provide actionable recommendations to the HR department for maximizing employee retention. By leveraging insights from the analysis, HR can implement targeted interventions to enhance satisfaction, productivity, and overall organizational stability. These data-driven strategies aim to minimize turnover rates and foster a more engaged and committed workforce.

### 1. Enhance Employee Satisfaction
- Satisfaction is the most significant factor influencing turnover.
- Ensure employee satisfaction scores remain above **0.6** to reduce the risk of departures.
- Regular surveys and feedback sessions can help identify dissatisfaction early and address concerns proactively.

### 2. Support Employee Performance
- Employees with performance scores above **0.6** show the lowest risk of leaving.
- HR should provide resources, training, and support to employees performing below this threshold to enhance their success and engagement.

### 3. Balance Workloads
- Assign employees an optimal number of projects between **3 and 4** to prevent burnout and maintain satisfaction.
- Ensure average monthly working hours remain within **160 to 220 hours**, avoiding overwork while maintaining productivity.

### 4. Increase Promotion Opportunities
- Employees at no risk of leaving had four times the promotion rate compared to those who left.
- Providing more transparent and frequent promotion opportunities can significantly improve retention, particularly for mid-tenure employees.

### 5. Improve Salary Structures
- Higher salaries are strongly associated with no-risk employees.
- Review and adjust salary structures, especially for high-performing and critical employees, to align with market standards and internal equity.

### 6. Proactively Engage with At-Risk Employees
- Conduct one-on-one meetings with employees identified as at risk of leaving to understand their concerns and explore potential solutions.
- Addressing individual challenges, such as workload or lack of career growth, can help prevent unnecessary turnover.

### 7. Address Systemic Issues
- The analysis revealed systemic issues, such as low promotion rates and salary disparities, as broad challenges affecting all employees.
- HR should focus on long-term structural improvements to address these foundational problems and build a more supportive organizational culture.

## Tools and Technologies

### Programming Language
- **R**: Used for data preprocessing, analysis, modeling, and visualization.

### Libraries and Packages
- **Data Preprocessing**: `dplyr`, `fastDummies`
- **Visualization**: `ggplot2`, `plotly`, `gplots`, `gridExtra`
- **Clustering and Feature Selection**: `cluster`, `factoextra`, `Boruta`
- **Modeling and Machine Learning**: `randomForest`, `caret`, `rpart`, `rpart.plot`, `e1071`, `neuralnet`
- **Evaluation and Metrics**: `pROC`, `class`

### Development Tools
- **RStudio**: Integrated Development Environment for R programming.
- **GitHub**: For version control and collaboration.

