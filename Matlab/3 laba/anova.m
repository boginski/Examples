% Однофакторный дисперсионный анализ
% cut – количество частей, на которые нужно разбить начальную выборку
% 1431 – размерность массива X делится нацело: 3, 9, 27, 53, 159, 477
% чтобы можно было использовать все данные
% H0 – равенство средних значений
function anova(error, X, cut, alpha)
[n, k] = size(X);
result = 0;
for i = 1:k
    unity = [X(:, i), error];
    unity = sortrows(unity, 1);
    
    new_length = floor (n / cut) * cut; % "новая" длина, чтобы можно было разбить на равные части
    unity = unity(1:new_length, 2);
    
    unity = reshape(unity, [], cut);
    mean_group = mean(unity);
    mean_all = mean(mean_group, 2);
    S02 = (mean_group - mean_all) * (mean_group - mean_all)';
    %mean_group = ones(new_length / cut, 1) * mean_group;
    unity = unity - mean_group;
    S2 = sum(unity .* unity, 'all');
    if S02 / S2 * (n - cut) / (cut - k) > finv(1 - alpha, cut - k, n - cut)
        result = result + 1;
    end
end
if result == 0
    disp('Analysis of variance – passed.');
else
    disp('Analysis of variance – fail.');
end
end