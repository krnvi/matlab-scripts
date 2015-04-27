function [m,c] = linearFit(x,y)


% Ensure column vectors
x = x(:);
y = y(:);

% Look for not finite numbers and ignore
Iok = isfinite(x) & isfinite(y);

% Look for outliers and ignore
%thres = 30;             % critical value for outliers
%Iout = x <= thres & y <= thres;

% Combine tests
I = Iok  ;%& Iout;

% Calculate fit
%[m,c] = fit(x(I),y(I),'poly1');
 [m,c] = polyfit(x(I),y(I),1) ;

end


