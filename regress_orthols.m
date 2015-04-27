
function stat = regress_orthols (x, y)

% REGRESS_ORTHOLS Least-squares Orthogonal Regression
%   REGRESS_ORTHOLS (x, y) finds the orthogonal regression
%   line for the x, y data and returns estimates of
%   slope, intercept, sigma_slope, and sigma_intercept

stat = regress_ls (x, y);
n = length (x);
mean_x = mean (x);
mean_y = mean (y);
sig_x = std (x);
sig_y = std (y);
u = x - mean_x;
v = y - mean_y;
sum_v2 = sum (v .* v);
sum_u2 = sum (u .* u);
sum_uv = sum (u .* v);
part1 = sum_v2 - sum_u2;
part2 = sqrt ((sum_u2 - sum_v2) ^ 2.0 + 4.0 * sum_uv * sum_uv);
b(1) = (part1 + part2) / (2.0 * sum_uv);
b(2) = (part1 - part2) / (2.0 * sum_uv);
r = sum_uv / sqrt (sum_u2 * sum_v2);
if sign (b(1)) == sign (stat(1))
    stat(1) = b(1);
else
    stat(1) = b(2);
end
stat(2) = mean_y - stat(1) * mean_x;
stat(3) = stat(1) * sqrt ((1.0 - r * r) / n) / r;
stat(4) = sqrt (((sig_y - sig_x * stat(1)) ^ 2) / n + (1.0 - r) * stat(1) * ...
      (2.0 * sig_x * sig_y + (mean_x * stat(1) * (1.0 + r) / (r * r))));

end

