# Human Capital Analytics: Addressing Employee Turnover

 ## Table of Contents
1. [Background and Overview](#background-and-overview)
2. [Data Structure Overview](#data-structure-overview)
3. [Executive Summary](#executive-summary)
4. [Insights Deep Dive](#insights-deep-dive)
   - [Turnover Drivers](#1-turnover-drivers)
   - [Turnover Profiles and Cluster Performance](#2-turnover-profiles-and-cluster-performance)
   - [Impact Score Methodology](#3-impact-score-methodology)
   - [Turnover Risk Categorization](#4-turnover-risk-categorization)
   - [Predictive Modeling Insights](#5-predictive-modeling-insights)
   - [Top 10 Priority Employees by Risk Category](#6-top-10-priority-employees-by-risk-category)
   - [Retention Insights](#7-retention-insights)
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

The dataset consists of 14,999 employee records and includes the following key variables:

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
- **Stagnated Employees**: Long-tenured and strong performers who, despite having high satisfaction scores, left due to a lack of growth and promotion opportunities.

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
  - Turnover rates are highest among low-salary employees (29.7%), followed by medium-salary (20.4%) and high-salary employees (6.63%). This demonstrates a clear relationship between lower salaries and higher turnover.
    <div align="center">
        <img src="https://github.com/user-attachments/assets/b856fe04-2c37-4ebc-832f-1f338bde14d5" alt="Turnover Rate by Salary Category" width="400" />
    </div>

  - Most employees fall into the low-salary group (48.8%), followed by medium-salary (42.9%) and high-salary (8.2%). Among employees who left, 60.8% were in the low-salary group, while only 2.3% were in the high-salary group, further highlighting the link between low salaries and turnover. Employees who stayed showed a more balanced distribution, with higher representation in the medium- and high-salary groups.
    <div align="center">
        <img src="https://github.com/user-attachments/assets/32eba86a-1a1f-48d7-aa96-9c347e3b7536" alt="Salary Distribution by Employee Status" width="550" />
    </div>

- **Performance Evaluation**:
  - Turnover rates vary significantly across performance evaluation scores (last evaluation):
    - **Low Performers**: Employees with evaluation scores between 0.4 and 0.5 exhibit the highest turnover rate (43.1%).
    - **Medium Performers**: Employees with scores between 0.6 and 0.7 have the lowest turnover rate (2.46%).
    - **High Performers**: Employees with scores between 0.9 and 1 show an elevated turnover rate (32.7%), above the overall average of 23.8%.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/ea6decd4-eddd-4377-9b54-343265eb2189" alt="Performance Evaluation Turnover Trends" width="550" />
    </div>

  - These trends suggest:
    - Low performers leave due to underperformance and potential lack of fit.
    - High performers may leave due to seeking better opportunities in terms of salary and professional growth, despite their strong contributions to the organization.

- **Tenure and Promotions**:
  - Turnover peaks at year 5, coinciding with the lowest promotion rates (1.15% at year 5 and 1.37% at year 4). In contrast, employees with a tenure of 7+ years, who experience the highest promotion rates, show zero turnover.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/43d5da35-58a3-47d3-9165-d4842ea725cd" alt="Turnover and Promotions Chart" width="500" />
    </div>

  - **Employees with Less than 5 Years of Tenure**:
    - **Promotions**:
      - 1.82% of employees with less than 5 years of tenure were promoted.
    - **Turnover Rates**:
      - Not Promoted: 20.9%
      - Promoted: 8.07%
    - Insight: Employees who were not promoted had a turnover rate over 2.5 times higher than those who were promoted, highlighting the importance of promotion in reducing early-career turnover.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/b8eb37a3-1a93-40aa-b7dd-40e86d3a1a35" alt="Turnover Rates - Less than 5 Years" width="400" />
    </div>

  - **Employees with 5+ Years of Tenure**:
    - **Promotions**:
      - 3.48% of employees with 5+ years of tenure were promoted.
    - **Turnover Rates**:
      - Not Promoted: 39.2%
      - Promoted: 1.04%
    - Insights:
      - Turnover rates for employees who were not promoted doubled when comparing those with less than 5 years of tenure (20.9%) to those with 5+ years of tenure (39.2%), demonstrating the accumulating negative impact of lack of recognition over time.
      - For employees who were promoted, turnover rates decreased significantly, dropping from 8.07% (less than 5 years tenure) to 1.04% (5+ years tenure). This highlights the role of timely promotions in fostering long-term employee retention.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/bdf4f085-56c1-4331-a006-1e63a6d14e1d" alt="Turnover Rates - 5+ Years" width="400" />
    </div>

    These findings highlight the importance of timely promotions in retaining employees.


- **Workload and Satisfaction**:
  - Turnover rates exceed 30% for employees with low (90–145 hours) or very high workloads (255–310 hours).

    <div align="center">
        <img src="https://github.com/user-attachments/assets/49bc41e5-b333-49e9-bcba-ed1c8eef2cc5" alt="Workload Turnover Rates" width="500" />
    </div>

  - Employees in the optimal workload range (162–216 hours) show the lowest turnover rate of 2.11%.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/e1dd359b-9499-4351-aa33-0d2412a996b5" alt="Optimal Workload Turnover Rate" width="500" />
    </div>

  - Turnover reaches 100% among the most dissatisfied employees, underscoring the critical role of satisfaction in retention. In contrast, turnover rates for generally satisfied employees range between 12.5% and 25%, indicating significantly better retention in this group.

    <div align="center">
        <img src="https://github.com/user-attachments/assets/b978cc45-4d0f-4790-a694-6d8f95ef1148" alt="Turnover by Satisfaction Level" width="500" />
    </div>

#### **Combined Metrics Analysis: Tenure, Satisfaction, Workload, and Performance Evaluation**
- The visualization below highlights critical trends in average satisfaction, workload, number of projects, and performance evaluation over tenure for employees who stayed versus those who left:

  <div align="center">
      <img width="650" alt="Combined Metrics Analysis" src="https://github.com/user-attachments/assets/2241144d-e5ff-42ff-96ad-953d2c40be0d" />
  </div>

- **Key Insights**:
  - **Year 2**:
    - Employees who left early in their tenure (around 2 years) display lower satisfaction levels than their peers who stayed, even though their workloads and evaluations are comparable or slightly higher. 
    - Interpretation: This indicates a possible misalignment of expectations or lack of engagement early in their tenure, leading to early exits.

  - **Year 3**:
    - Turnover at year 3 is characterized by even lower satisfaction levels, the worst evaluation scores, and minimal workloads.
    - Employees leaving at this stage may feel disconnected or undervalued, as they have lower workload responsibilities and poor evaluations. Intervention in recognition and support at this stage could reduce exits.

  - **Year 4**:
    - Turnover at year 4 shows the lowest satisfaction levels, high evaluation scores, and peak workloads among those leaving.
    - Year 4 marks a period of intense workload pressure and high performance expectations without adequate satisfaction, leading to burnout or disengagement. These employees may leave due to feeling overburdened and underappreciated.

  - **Years 5–6**:
    - Employees leaving at years 5–6 exhibit improved satisfaction levels, the highest evaluations, and high workloads (though slightly lower than year 4 leavers).
    - At this stage, employees are likely high performers who feel a lack of career progression or recognition. Despite their achievements, the absence of timely rewards such as promotions or raises likely drives them to seek opportunities elsewhere.

- **General Insight**:
  - The 4–6 year tenure period is critical for intervention as it represents a convergence of high workloads, strong performance, and a need for career advancement.
  - Providing timely rewards, recognition, and opportunities for growth during this window could significantly improve retention.
  - Early interventions (year 2) should focus on onboarding support and expectation alignment to prevent early turnover. Similarly, proactive engagement and workload management at year 4 could mitigate burnout and dissatisfaction.

---
### 2. Turnover Profiles and Cluster Performance

#### **Optimal Number of Clusters**
- The **Elbow Method** was used to determine the optimal value of k by evaluating the point where adding more clusters no longer significantly reduces within-cluster variance.

<div align="center">
    <img src="https://github.com/user-attachments/assets/5229f5a2-c9f5-4db1-af63-abc6866c4dd8" alt="Elbow Method Plot" width="500" />
</div>

- The Elbow Method plot shows a significant drop in within-cluster variance up to **k=3**, after which the improvement becomes minimal.  
- Based on this analysis, **k=3** was chosen as the optimal number of clusters.

#### **Cluster Metrics**

- **Overall Silhouette Width**: 0.73 (indicating strong clustering quality).

<div align="center">
    <img src="https://github.com/user-attachments/assets/e74dde92-d63d-4c00-a66a-1a035be0b52b" alt="Cluster Metrics Table" width="500" />
</div>

  - **Cluster 1**:
    - Silhouette Width: 0.82
    - Employees: 1,649
    - Represents the most cohesive and distinct cluster.
  - **Cluster 2**:
    - Silhouette Width: 0.67
    - Employees: 963
    - Strong clustering quality but with slightly less separation from neighboring clusters.
  - **Cluster 3**:
    - Silhouette Width: 0.64
    - Employees: 959
    - Lower but still acceptable clustering quality.

#### **Profile Descriptions**

<div align="center">
    <img src="https://github.com/user-attachments/assets/a21e7d74-c374-41a4-a8a3-89eef9a16b33" alt="Cluster Descriptions" width="600" />
</div>

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
  - Over 60% of employees in all clusters fall into the low-salary category.

<div align="center">
    <img src="https://github.com/user-attachments/assets/44d6b07b-efdb-457c-b601-ff7685bfa769" alt="Salary Distribution Chart" width="700" />
</div>

- **Promotion Rates**:
  - Promotions are rare across all clusters, with less than 1% receiving promotions in the last five years.

<div align="center">
    <img src="https://github.com/user-attachments/assets/6721a253-b316-4f13-86f5-86dc97baf2d4" alt="Promotion Rates Chart" width="500" />
</div>

These trends suggest low salaries and lack of promotions are systemic issues affecting all clusters, amplifying specific pain points within each group.


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
- The **Random Forest model** was selected due to its superior performance during validation:

  <div align="center">
    <img src="https://github.com/user-attachments/assets/33e7ac18-966a-4f17-9b31-39be0a9e17a8" alt="Random Forest Performance Metrics" width="600" />
  </div>

- On the **test set**, the Random Forest model demonstrated excellent performance, achieving: 
  - **Accuracy**: 99.07% - Correctly classified employees who stayed or left.
  - **Sensitivity**: 96.47% - Effectively identified employees at risk of leaving.
  - **Precision**: 99.39% - Ensured predicted at-risk employees were truly at risk.
- The model categorized employees into four risk groups:

  <div align="center">
      <img src="https://github.com/user-attachments/assets/1fda24e6-58cb-4e84-befa-783e74bd9e07" alt="Risk Categorization Chart" width="400" />
  </div>

  - **High Risk**: 8 employees - Immediate intervention is needed for these employees, as they are most likely to leave and may have a significant impact on the organization.
  - **Moderate Risk**: 19 employees - These employees show potential turnover risks and should be closely monitored to identify and address any emerging issues.
  - **Low-Moderate Risk**: 218 employee - While these employees are less likely to leave, they should still receive regular check-ins to prevent escalation.
  - **Low Risk**: 11,183 employees - Not displayed in the chart due to their overwhelming size. These employees are least likely to leave and represent a stable core of the workforce.
 
---
    
### 6. Top 10 Priority Employees by Risk Category

To prioritize retention efforts effectively, the **impact score** was used to identify the top 10 employees in each risk category prioritized by impact score and then by probability of leaving. These employees represent critical cases where turnover could significantly impact the organization.

#### **Low Risk Category**
These employees are less likely to leave but have a high impact score, highlighting their importance to the organization.

<div align="center">
    <img src="https://github.com/user-attachments/assets/a5f7c16c-03ac-47bf-9a34-e47b6d08c269" alt="Top 10 Priority Employees - Low Risk" width="800" />
</div>

#### **Low-Moderate Risk Category**
This group includes employees with a slightly elevated risk of turnover. Their high impact scores make them essential for retention efforts.

<div align="center">
    <img src="https://github.com/user-attachments/assets/e18bd115-710b-43a0-a43a-804f38d2ee0a" alt="Top 10 Priority Employees - Low-Moderate Risk" width="800" />
</div>

#### **Moderate Risk Category**
Employees in this category exhibit moderate turnover risk. They should be prioritized for interventions due to their significant contributions.

<div align="center">
    <img src="https://github.com/user-attachments/assets/91f8bebb-f22e-4344-8837-90536b6cf25c" alt="Top 10 Priority Employees - Moderate Risk" width="800" />
</div>

#### **High Risk Category**
This group represents employees most likely to leave the organization. Proactive measures are critical to retaining these high-impact individuals.

<div align="center">
    <img src="https://github.com/user-attachments/assets/c617dcc4-0eb2-44c3-9144-cc85e557f486" alt="Top 10 Priority Employees - High Risk" width="800" />
</div>

---

### 7. Retention Insights

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
- **Data Preprocessing**: `dplyr`, `fastDummies`,`tidyr`
- **Visualization**: `ggplot2`, `plotly`, `gplots`, `gridExtra`
- **Clustering and Feature Selection**: `cluster`, `factoextra`, `Boruta`
- **Modeling and Machine Learning**: `randomForest`, `caret`, `rpart`, `rpart.plot`, `e1071`, `neuralnet`
- **Evaluation and Metrics**: `pROC`, `class`



