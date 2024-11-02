clear all
close all
clc

%% Load the data
t = readtable('report_data33.csv');

t = t(strcmp(t.sex, 'female'), :);

% Convert birthday column to datetime format
t.birthday = datetime(t.birthday, 'InputFormat', 'dd-MMM-yyyy');

% Filter rows based on month
t = t(month(t.birthday) == 3, :);

t_20 = t(1:20, :); %first 20 females

Y = t.wage;
X(:,1) = t.Experience;
X(:,2) = t.Skills;
X(:,3) = t.Years_in_company;
X(:,4) = t.supervisors_assessment;
X(:,5) = t.motivation;

N = length(Y);
K = size(X,2);

%% Check the autocorrelation of the residuals for 20 first lags with LM test
[betas L] = OLS(X, Y);

%alpha = 1 % - significance level
e = Y - X*betas;

p = 20; %20 lags

y_aux = e(p+1:end);
for i = 1:20
    x_aux(:,i) = e(p+1-i:end-i);
end

x_aux = [X(p+1:end,:) x_aux];
beta_aux = OLS(x_aux, y_aux);
u = y_aux-x_aux*beta_aux;
LM = (N-p)*(1-var(u)/var(y_aux));
p_LM = 1-chi2cdf(LM, p) 
disp('The p-value from LM test (p_LM) is 0.2091 and it is bigger that 0.01 (significance level), so residuals are not autocorrelated, so we should NOT reject hypothesis H0.')

%% Check the homoscedasticity with White test

beta = OLS(X,Y);
e = Y-X*beta;
ii=1;
for i=1:K
    for j=1:i
        X_aux(:, ii) = X(:,i).*X(:,j);
        ii = ii+1;
    end
end

X2=[ones(N,1) X X_aux];
beta_aux = OLS(X2, e.^2);
U = e.^2-X2*beta_aux;
R2 = 1-var(U)/var(e.^2);

White = R2*N; %~chi2(m)
m = K+K*(K+1)/2;
p_White = 1-chi2cdf(White, m)
disp('The p-value from White test (p_White) is 0.0317 and it is bigger that 0.01 (significance level), so residuals are homoscedastic, so we should NOT reject hypothesis H0.')

%% Check the Collinearity with VIFs

VIF = [];
for i = 1:5 %we have 5 variables
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

disp('Experience and Years_in_company are correlated, both of them have values VIF bigger than 10 - there is strong collinearity.')

%% What is the maximum significance level α for which we can say that the residuals are homoscedastic and not autocorrelated?
disp('The significance level should NOT be bigger than 0.8895 to be not autocorrelated. But it also should NOT be bigger than 0.0317 to be homoscedastic. Summing up - the maximum significance level should be 0.0317 to say that the residuals are homoscedastic and not autocorrelated.')

%% Choose optimal model with forward stepwise regression

N = length(Y);
K = size(X,2);
[betas L se] = OLS2(X, Y);
p_spr = myttest(betas, se, N, K);
alpha = 0.05;

for i = 1:length(p_spr)
    if p_spr(i) < alpha
        fprintf('Variable with corresponding number %d is relevant\n', i);
    end
end

%experience, skills, motivation

% Start with empty model
model = [];
while true
    p = myttest(betas, se, N, K);
    %disp(p)
    %[min_p, idx] = min(p(setdiff(1:K, model)));
    %[min_p, idx] = min(p(~ismember(1:length(p), model)));
    p(model) = 1;
    [min_p, idx] = min(p);
    if min_p < alpha
        model = [model, idx];
        X_new = X(:, model);
        [betas, L, se] = OLS2(X_new, Y);
        K = length(model);
        fprintf('Variable %d added to the model\n', model(end));
    else
        break
    end
end

N = length(Y);
K_new = size(X_new,2);

%% Check the autocorrelation of the residuals for 20 first lags with Q-test

betas = OLS(X_new,Y);
e = Y - X_new*betas;

p = 20; %lags

rho = autocorr(e, p);
rho(1) = [];

Q = N*(N+2)*sum(rho.^2./(N-(1:20)'));
p_Q = 1-chi2cdf(Q, p) %0.35 > 0.05 - residuals are not autocorrelated, we cant rejest H0 hypothesis
disp('The p-value from Q test (p_Q) is 0.0948 and it is bigger that 0.01 (significance level), so residuals are not autocorrelated, so we should NOT reject hypothesis H0.')

%% Check the homoscedasticity with Breusch-Pagan LM test

g=e.^2/(sum(e.^2)/N)-1;
z = X_new;
BP = 0.5*g'*z*(z'*z)^(-1)*z'*g;
p_BP=1-chi2cdf(BP,K_new)
disp('The p-value from BP test (p_BP) is 0.1517 and it is bigger that 0.01 (significance level), so residuals are homoscedastic, so we should NOT reject hypothesis H0.')

%% Check the Collinearity with Conditional number

x2 = X_new - mean(X_new);
ei = eig(x2'*x2);
CI = sqrt(max(ei)./ei);
CN = max(CI)/min(CI)
%CN > 20 - possible collinearity
disp('Value CN from Conditional number test is 1.7801 and it is not bigger than 20, so the variables are NOT collinear.')

%% What is the maximum significance level α for which we can say that the residuals are homoscedastic and not autocorrelated?
disp('The significance level should NOT be bigger than 0.0948 to be not autocorrelated and it also should NOT be bigger than 0.1517 to be homoscedastic. Summing up - the maximum significance level should be 0.0948 to say that the residuals are homoscedastic and not autocorrelated.')
