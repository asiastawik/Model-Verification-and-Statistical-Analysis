clear all
close all
clc

%% Load the data
load('report_data2.mat')

X(:,1) = Price(7:end-1);
Y = Price(7+1:end);

X(:,2) = Consumption(7+1:end);
X(:,3) = Consumption(7:end-1);

%significance level is 0.1 ~ 1%

N = length(Y);
K = size(X,2);

%%  Check the homoscedasticity - BP test

beta = OLS(X, Y');
e = Y'-X*beta;
g=e.^2/(sum(e.^2)/N)-1;
z = X;
BP = 0.5*g'*z*(z'*z)^(-1)*z'*g;
p_BP=1-chi2cdf(BP,K);

disp('Significance level is 0.1.')
disp('The p-value from BP test (p_BP) is 0.9874 and it is bigger that 0.1 (significance level), so residuals residuals are homoscedastic, so we should NOT reject hypothesis H0.')

%% Check the Stability of the parameters

cusumtest(X, Y)
disp('The blue lines fits between intervals - then we can say that our parameters are stable.')

