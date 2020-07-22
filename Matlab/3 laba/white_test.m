% Y - изначальные ошибки
% X - первоначальная матрица X
function white_test(Y, X, alpha)
Y = Y .* Y;
y_mean = sum(Y) / length(Y);

[n, k] = size(X);
X2 = X.*X;
X = [X, X2];
X = [ones(n, 1), X];
[n, k] = size(X);
for i = 1:k-1
    for j = i+1:k
        if isequal (X(:, j), X(:, i)) 
            X(:, j) = zeros(n, 1);
        end
    end
end
for i = flip(1:k)
    if isequal (X(:, i), zeros(n, 1))
        X(:, i) = [];
    end
end

beta = (X' * X) \ X' * Y;
prediction = X * beta;
error = Y - prediction;
RSS = error' * error;
R2 = 1 - RSS / ((Y - y_mean)' * (Y - y_mean));
[n, k] = size(X);
if n * R2 > chi2inv(1 - alpha, k - 1)
    disp('White test – fail.')
else
    disp('White test – passed.');
end
end