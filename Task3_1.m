clear all
close all
clc

%% Load the data
load('report_data.mat') %change the data

X(:,1) = y(7:end-1);
X(:,2) = y(6:end-2);
X(:,3) = y(1:end-7);
Y = y(7+1:end);

%% Check the autocorrelation of the residuals for 10 first lags
[betas L] = OLS(X, Y');

%alpha = 1 % - significance level
e = Y' - X*betas;

N = length(Y);
p = 10; %10 lags
rho = autocorr(e, p);
rho(1) = [];
Q = N*(N+2)*sum(rho.^2./(N-(1:p)'));
p_Q = 1-chi2cdf(Q, p) 
disp('Significance level is 0.1.')
disp('The p-value from Q test (p_Q) is 0.8854 ant it is bigger that 0.1 (significance level), so residuals are not autocorrelated, so we should NOT reject hypothesis H0.')

y_aux = e(p+1:end);
for i = 1:10
    x_aux(:,i) = e(p+1-i:end-i);
end

x_aux = [X(p+1:end,:) x_aux];
beta_aux = OLS(x_aux, y_aux);
u = y_aux-x_aux*beta_aux;
LM = (N-p)*(1-var(u)/var(y_aux));
p_LM = 1-chi2cdf(LM, p) 
disp('The p-value from LM test (p_LM) is 0.7988 ant it is bigger that 0.1 (significance level), so residuals are not autocorrelated, so we should NOT reject hypothesis H0.')

%% Check the Collinearity

%vif
VIF = [];
for i = 1:3 %we have 3 variables
    y_vif = X(:,i) - mean(X(:,i)); 
    x_vif = X(:, [1:i-1 i+1:end]);
    beta_vif = OLS(x_vif, y_vif);
    e_vif = y_vif-x_vif*beta_vif;
    R2 = 1 - var(e_vif)/var(y_vif);
    vif = 1/(1-R2)
    if vif > 10
        disp('VIF value is bigger than 10 - strong collinearity.')
    elseif vif > 5
        disp('VIF value is bigger than 5 - possible collinearity.')
    else
        disp('VIF value is less than 5 - no collinearity.')
    end

    VIF = [VIF vif];
end

%conditional number
x2 = X - mean(X);
ei = eig(x2'*x2);
CI = sqrt(max(ei)./ei);
CN = max(CI)/min(CI)
%CN > 20 - possible collinearity
disp('The p-value from conditional number (CN) is 6.3084 ant it is bigger that 20, so there is no collinearity.')
