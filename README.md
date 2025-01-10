# Human Capital Analytics: Addressing Employee Turnover

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

#### 1. Turnover Drivers
- Dissatisfaction, low salaries, limited career advancement opportunities, and imbalanced workloads are significant contributors to turnover.
- Turnover rates are particularly high during mid-tenure periods (years 4–6).

#### 2. Employee Profiles Identified Through Clustering
- **Disengaged Employees**: Low performers with minimal projects and short tenures, often leaving due to insufficient support or engagement.
- **Overworked Achievers**: High performers with heavy workloads, leaving due to burnout and unrecognized contributions.
- **Stagnated Employees**: Long-tenured, highly satisfied, and strong performers who left due to a lack of growth and promotion opportunities.

#### 3. Predictive Modeling Results
- The Random Forest model achieved the following metrics:
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


## Recommendations

## Tools and Technologies
- **Languages**: R
- **Libraries**: `ggplot2`, `dplyr`, `caret`
- **Visualization Tools**: Tableau for interactive dashboards
- **Data Source**: Simulated HR dataset

## Contact

