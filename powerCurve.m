function p = powercurve(v,prated)
% fcnpowercurve.m 
% 
% This function models the power curve for a fictitious wind turbine.  The
% model is constructed as a piece-wise function to more accurately account
% for the cut-on and cut-out speeds.  
% 
% Usage: p = fcnpowercurve(v,prated)
% 
% Inputs:
% v = wind speed at hub height (m/s)
% prated = rated turbine power (W)
% 
% Outputs:
% p = electrical power from wind turbine (W)

% Copyright 2009 - 2011 MathWorks, Inc.
%   Author(s): T. Schultz, 6/23/2009

% Constants
von = 3;        % cut-on speed (m/s)
vc = 12.5;        % corner speed (m/s)
vout = 22;      % cut-out speed (m/s)

p = zeros(size(v));

% Create model
% Below cut-on
p(v < von) = 0;
% Ramp up (use model)
I = (v >= von & v < vc);
p(I) = prated*normcdf(v(I)/vout,0.3507,0.1051);
% At rated power
p(v >= vc & v <= vout) = prated;
% Above cut-out
p(v > vout) = 0;

% [EOF]