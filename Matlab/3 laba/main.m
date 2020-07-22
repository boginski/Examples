clc;
clear all;

name_file = 'date.xlsx';
date = importdata(name_file);

x = date(:,1);
y = date(:,2);


%   Creating the matrix X
t = (x - min(x)) / (max(x) - min(x)) * 2 * pi;
x0 = ones(length(y),1);
x_sin = sin(t);
x_sin2 = sin(t).*sin(t);
X = [x0, x_sin, x_sin2, x.*x, log(x)]; %%добавлены избыточные факторы

[error, beta, beta_left, beta_right, y_left, y_right, standardized_error] = regression(X, y, 0.05); %% последние два фактора – лишние
X = [x0, x_sin, x_sin2];
[error, beta, beta_left, beta_right, y_left, y_right] = regression(X, y, 0.05);

% Visualization
scale_x = min(x):0.01:max(x);
scale_t = (scale_x - min(scale_x)) / (max(scale_x) - min(scale_x)) * 2 * pi;
X_approximation = [ones(length(scale_x), 1), sin(scale_t)', (sin(scale_t) .* sin(scale_t))'];
approximation = X_approximation * beta;
grid on; hold on;
plot(x, y, '.r');
plot(scale_x, approximation, 'b');
plot(x, y_left, 'k');
plot(x, y_right, 'k');

% Новый код
% 1
figure;
plot(x, error, '.k');
title('Error');
figure;
plot(x, standardized_error, '.k');
title('Standardized error');
anova(error, x, 55, 0.05);
% 2
white_test(error, X, 0.05);
gq_test(error, X, 0.05);
% 3
figure;
lags = 50;
autocorr(error, 'NumLags', lags);
disp('Ljung–Box Q test');
lbqtest(error, 'Lags', lags, 'DOF', lags - size(X, 2))
% 4
figure;
histfit(error);
figure;
normplot(error);
intervals = 10;
% количество степеней свободы в функции chi2gof: nbins - 1 - nparams
% Должно быть nbins - k - 2
disp('Pearsons chi-squared test');
chi2gof(standardized_error, 'NBins', intervals, 'NParams', size(X, 2) + 1)