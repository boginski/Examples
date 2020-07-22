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
x_abs_sin = sin(t).*sin(t);
X = [x0, x_sin, x_abs_sin];

[err, beta, beta_left, beta_right, y_left, y_right] = regression(X, y, 0.01);

% Visualization
scale_x = min(x):0.01:max(x);
scale_t = (scale_x - min(scale_x)) / (max(scale_x) - min(scale_x)) * 2 * pi;
X_approximation = [ones(length(scale_x), 1), sin(scale_t)', (sin(scale_t) .* sin(scale_t))'];
approximation = X_approximation * beta;
approximation_left = X_approximation * beta_left;
approximation_right = X_approximation * beta_right;
grid on; hold on;
plot(x, y, '.r');
plot(scale_x, approximation, 'b');
plot(scale_x, approximation_left, 'k');
plot(scale_x, approximation_right, 'k');

% The resulting coefficients: beta(1) = 12.5 beta(2) = 9.41 beta(3) = 6.80