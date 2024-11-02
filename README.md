# MATLAB Report: Model Verification and Statistical Analysis

This repository contains MATLAB scripts and functions created to verify various regression models through rigorous statistical analysis. The tasks include verifying models for autocorrelation, homoscedasticity, collinearity, and stability. The analysis also features advanced model selection techniques like forward stepwise regression.

## Project Tasks Overview

### Task 3.1: Verification of an Autoregressive Model 
**Verification Steps**:
1. **Autocorrelation of Residuals**:
   - Check the autocorrelation of residuals for the first 10 lags.
2. **Collinearity Check**:
   - Analyze the multicollinearity among variables using Variance Inflation Factors (VIFs) or other suitable metrics.
3. **Interpretation**:
   - Provide a comprehensive interpretation of the results.

**Significance Level**: \( \alpha = 1\% \)

### Task 3.2: Verification of Price Model 
**Verification Steps**:
1. **Homoscedasticity Check**:
   - Use tests such as White's test or Breusch-Pagan test to assess constant variance of residuals.
2. **Parameter Stability Check**:
   - Verify the stability of parameters over time using appropriate diagnostic tools.
3. **Interpretation**:
   - Analyze and explain the findings in detail.

**Significance Level**: \( \alpha = 1\% \)

### Task 3.3: Model Verification with 'report data33.csv' (Choose One of the Options Below)

#### Option 1: Basic Model Verification 
**Verification Steps**:
1. **Autocorrelation Check**:
   - Use the LM test for autocorrelation on the residuals for the first 20 lags.
2. **Homoscedasticity Check**:
   - Perform White's test to evaluate homoscedasticity.
3. **Collinearity Check**:
   - Analyze multicollinearity with VIFs.
4. **Interpretation**:
   - Provide insights based on the test results.
5. **Collinearity Insight**:
   - Identify two correlated variables if collinearity is detected.

#### Option 2: Comprehensive Model Verification and Stepwise Regression
**Verification Steps**:
1. **Autocorrelation Check**:
   - Conduct the LM test for the first 20 lags and use the Q-test for deeper analysis.
2. **Homoscedasticity Check**:
   - Perform the White test and the Breusch-Pagan LM test.
3. **Collinearity Check**:
   - Utilize VIFs and conditional number analysis.
4. **Model Interpretation**:
   - Offer a detailed explanation of all test results.
5. **Maximum Significance Level \( \alpha \)**:
   - Determine the highest significance level for confirming homoscedasticity and no autocorrelation.

**Forward Stepwise Regression**:
1. Start with an empty model.
2. Add variables step-by-step based on the lowest p-value from the t-test.
3. Include variables with p-values lower than \( \alpha = 5\% \).
4. Display the added variable's name at each step.
5. Repeat until no variables meet the inclusion criteria.
6. Verify the newly created model:
   - Check the autocorrelation of residuals using the Q-test.
   - Assess homoscedasticity with the Breusch-Pagan LM test.
   - Review collinearity using the conditional number.
7. **Final Interpretation**:
   - Summarize the model's verification results and determine the maximum significance level for stating the absence of homoscedasticity and autocorrelation.

## Programming Language
- The analysis is performed using **MATLAB**, known for its comprehensive suite of statistical tools and data analysis capabilities.
