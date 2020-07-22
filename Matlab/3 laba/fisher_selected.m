% select - выбранные номера проверяемых параметров по возрастанию
% H0: все beta(k) = 0, где k принадлежит select
% H1: существует такой beta(k) != 0, где k принадлежит select
function fisher_selected(X, Y, select, alpha)
[n, k] = size(X);
beta = X' * X \ X' * Y;
prediction = X * beta;
error = Y - prediction;
RSS = error' * error;

q = length(select);

X_H0 = X;
% "Выкидываем" параметры, которые оцениваем
for i = flip(select)
    X_H0(:, i) = [];
end
beta_H0 = X_H0' * X_H0 \ X_H0' * Y;
prediction_H0 = X_H0 * beta_H0;
error_H0 = Y - prediction_H0;
RSS_H0 = error_H0' * error_H0;

if (RSS_H0 - RSS) / RSS * (n - k) / q > finv(1 - alpha, q, n - k)
    disp('A significant parameter is found:')
    disp(select)
    disp('')
else
    disp('The selected parameters are insignificant:')
    disp(select)
    disp('')
end
end

