function [f] = sumofsineFit(a,b)


% Ensure column vectors
x = a(:);
y = b(:);

% Look for not finite numbers and ignore
Iok = isfinite(x) & isfinite(y);

% Look for outliers and ignore
%thres = 30;             % critical value for outliers
%Iout = x <= thres & y <= thres;

% Combine tests
I = Iok  ;%& Iout;

% Calculate fit
f = fit(x(I),y(I),'sin6') ;
 

end
