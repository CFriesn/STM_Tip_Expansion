function cP = Steel_SpecificHeat_LowT(T)
%Units: J/(g*K)

% Source: Cryogenic Material Properties Database
%for the material 304 SS
%http://cryogenics.nist.gov/MPropsMAY/304Stainless/304Stainless_rev.htm
%valid for 3K < T < 300K

% kB = 1.3806488E-23; %J/K
% Avo = 6.022E23;

%coefficients for calculating specific heat at temperature T, in units
%J/(kg*K)
a = 22.0061;
b = -127.5528;
c = 303.6470;
d = -381.0098;
e = 274.0328;
f = -112.9212;
g = 24.7593;
h = -2.239153;

% Final result, with 1E-3 for conversion kg->g
cP = 1E-3*10^(a + b*log10(T) + c*(log10(T)).^2 + d*(log10(T)).^3 + e*(log10(T)).^4 + f*(log10(T)).^5 + g*(log10(T)).^6 + h*(log10(T)).^7);