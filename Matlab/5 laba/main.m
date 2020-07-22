clc;
clear all;

pcorr = [0.2, -0.44]';
a1 = 0.3;
a2 = -0.5;
for i = 3:100
    pcorr(i, 1) = a1 * pcorr(i - 1, 1) + a2 * pcorr(i - 2, 1);
end
stem(pcorr);

name_file = 'date.xlsx';
y = importdata(name_file);
y = diff(y);
n = size(y, 1);
lags = 25;

autocorr(y, 'NumLags', lags);
figure;
parcorr(y, 'NumLags', lags);


p = 3;
X = zeros(n - p, p);
for i = flip(1:n-p)
        X(i, :) = flip(y(n-i-p+1:n-i, 1));
end
y_lin = flip(y(p+1:n,1));
beta = (X' * X) \ X' * y_lin;
pred = X * beta;
lin_error = y_lin - pred;
figure;
autocorr(lin_error, 'NumLags', floor(size(lin_error, 1) / 4));
sigma_lin_error = lin_error' * lin_error / size(lin_error, 1);
disp(p);
disp(sigma_lin_error);
disp(' ');

p = 4;
X = zeros(n - p, p);
for i = flip(1:n-p)
        X(i, :) = flip(y(n-i-p+1:n-i, 1));
end
y_lin = flip(y(p+1:n,1));
beta = (X' * X) \ X' * y_lin;
pred = X * beta;
lin_error = y_lin - pred;
figure;
autocorr(lin_error, 'NumLags', floor(size(lin_error, 1) / 4));
sigma_lin_error = lin_error' * lin_error / size(lin_error, 1);
disp(p);
disp(sigma_lin_error);
disp(' ');

p = 7;
X = zeros(n - p, p);
for i = flip(1:n-p)
        X(i, :) = flip(y(n-i-p+1:n-i, 1));
end
y_lin = flip(y(p+1:n,1));
beta = (X' * X) \ X' * y_lin;
pred = X * beta;
lin_error = y_lin - pred;
figure;
autocorr(lin_error, 'NumLags', floor(size(lin_error, 1) / 4));
sigma_lin_error = lin_error' * lin_error / size(lin_error, 1);
disp(p);
disp(sigma_lin_error);
disp(' ');
% 
% predict_y = zeros(150, 1);
% for_pred = flip(y(n-p+1:n,1));
% for i = 1:150
%     predict_y(i, 1) = for_pred' * beta;
%     for_pred = [predict_y(i, 1); for_pred(1:p-1)];
% end
% 
% y = importdata(name_file);
% n = size(y, 1);
% for i =1:150
%     y(n+i,1) = y(n+i-1, 1) + predict_y(i, 1);
% end
% 
% n = size(y, 1);
% x = 1:n;
% figure;
% plot(x(1:900), y(1:900), '.b');
% hold on;
% plot(x(901:1050),y(901:1050), '.r');
% hold off;