% Y - изначальные ошибки
% X - первоначальная матрица X
% возвращаем сумму квадратов ошибок
% основа функции – white_test
function RSS = secondary_regression(Y, X)

Y = Y .* Y;
y_mean = sum(Y) / length(Y);

[n, k] = size(X);
X2 = X.*X;
X = [X, X2];
X = [ones(n, 1), X];
[n, k] = size(X);
for i = 1:k-1
    for j = i+1:k
        if X(:, i) == X(:, j)
            X(:, j) = zeros(n, 1);
        end
    end
end
for i = flip(1:k)
    if X(:, i) == zeros(n, 1)
        X(:, i) = [];
    end
end

beta = (X' * X) \ X' * Y;
prediction = X * beta;
error = Y - prediction;
RSS = error' * error;

end