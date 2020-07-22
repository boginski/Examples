%Тут только равное разбиение
function gq_test(error, X, alpha)
[n, k] = size(X);
n0 = floor(n * 0.4);
n1 = n0;
n2 = n0;
result = 0;
for i = 1:1
    unity = [X, error];
    unity = sortrows(unity, i);
    unity_left = unity(1:n1, :);
    unity_right = unity(n-n2:n, :);
    
    % Получим матрицы X и ошибки для левой и правых частей разбиения
    X_left = unity_left(:, 1:k);
    X_right = unity_right(:, 1:k);
    unity_left = unity_left(:, k+1);
    unity_right = unity_right(:, k+1);
    
    S12 = unity_left - X_left * ((X_left' * X_left) \ (X_left' * unity_left));
    S22 = unity_right - X_right * ((X_right' * X_right) \ (X_right' * unity_right));
    S12 = S12' * S12;
    S22 = S22' * S22;
    
    if S12 > S22
        if S12 / S22 * (n2 - k) / (n1 - k) > finv(1 - alpha, n1 - k, n2 - k)
            result = result + 1;
        end
    else
        if S22 / S12 * (n1 - k) / (n2 - k) > finv(1 - alpha, n2 - k, n1 - k)
            result = result + 1;
        end
    end
end
if result == 0
    disp('Goldfeld-Quandt test – passed.');
else
    disp('Goldfeld-Quandt test – fail.');
end
end