function [error, beta, beta_left, beta_right, y_left, y_right, standardized_error] = regression(X, Y, alpha)
[n, k] = size(X);
y_mean = sum(Y) / length(Y);
B = inv(X' * X);
beta = (X' * X) \ X' * Y;
beta_left = zeros(k, 1);
beta_right = zeros(k, 1);
prediction = X * beta;
error = Y - prediction;
RSS = error' * error;
S2 = RSS / (n - k);
R2 = 1 - RSS / ((Y - y_mean)' * (Y - y_mean));
disp('R2 = ');
disp(R2);

%   Hypothesis testing – importance.
%   H0: beta(i) = 0 for all i.
%   H1: exists beta(i) != 0
importance = R2 / (1 - R2) * (n - k) > finv(1 - alpha, k, n - k);
if importance
    disp('The model is importance.');
else
    disp('The model is not importance. Must create a new matrix X.');
end

disp('Importance of the factors:');
if importance
    for i = 1:k
        %   Hypothesis testing k-st parameter – importance.
        %   H0: beta(k) = 0.
        %   H1: beta(k) != 0.
        disp(i);
        if abs(beta(i) / sqrt(S2) / sqrt(B(i, i))) > tinv(1 - alpha / 2, n - k)
            disp('Important.');
            disp('Confidence interval:');
            beta_left(i, 1) = beta(i) - tinv(1 - alpha / 2, n - k) * sqrt(S2) * sqrt(B(i, i));
            beta_right(i, 1) = beta(i) + tinv(1 - alpha / 2, n - k) * sqrt(S2) * sqrt(B(i, i));
            disp([beta(i) - tinv(1 - alpha / 2, n - k) * sqrt(S2) * sqrt(B(i, i)), beta(i) + tinv(1 - alpha / 2, n - k) * sqrt(S2) * sqrt(B(i, i))]);
            disp(' ');
        else
            disp('Unimportant.');
            disp(' ');
        end
    end
    %   Confidence interval for y
    y_left = ones(length(Y), 1);
    y_right = ones(length(Y), 1);
    for i = 1:length(Y)
    delta = tinv(1 - alpha / 2, n - k) * sqrt(S2) * sqrt(X(i, :) * B * X(i, :)');
    y_left(i) = prediction(i) - delta;
    y_right(i) = prediction(i) + delta;
    end
    disp('Сoefficients:');
    disp(beta);
    disp(' ');
    %%% Новый код
    %
    %fisher_selected(X, Y, [k-1, k], alpha);
    %
    H = X * ((X' * X) \ X');
    standardized_error = zeros(n, 1);
    for i = 1:n
        standardized_error(i) = error(i) / sqrt(S2) / sqrt(1 - H(i,i));
    end
end
end