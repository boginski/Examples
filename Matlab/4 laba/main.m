clc;
clear all;

name_file = 'date.xlsx';
y = importdata(name_file);
n = size(y, 1);
x = (1:n)';

grid on; hold on;
plot(x, y, '.b');

figure;
lags = floor(n / 4);
autocorr(y, 'NumLags', lags);

X = [ones(n, 1), x, x.*x];
beta = (X' * X) \ X' * y;
pred = X * beta;
lin_error = y - pred;
figure;
autocorr(lin_error, 'NumLags', lags);

delta_y = zeros(n - 1, 1);
for i=1:n-1
    delta_y(i, 1) = y(i + 1, 1) - y(i, 1);
end
figure;
autocorr(delta_y, 'NumLags', lags);
%['ARD','TS','AR']
h = adftest(y, 'lags', 0, 'model','AR');

