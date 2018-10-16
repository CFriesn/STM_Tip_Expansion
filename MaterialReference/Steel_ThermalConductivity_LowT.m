function k = Steel_ThermalConductivity_LowT(T)
% Source: Cryogenic Material Properties Database
%for the material 304 SS

%valid for 4K < T < 300K

%coefficients for calculating specific heat at temperature T
a = -1.4087;
b = 1.3982;
c = 0.2543;
d = -0.6260;
e = 0.2334;
f = 0.4256;
g = -0.4658;
h = 0.1650;
j = -0.0199;

% thermal conductivity in W/(m*K)
k = 10^(a + b*log10(T) + c*(log10(T))^2 + d*(log10(T))^3 + e*(log10(T))^4 + f*(log10(T))^5 + g*(log10(T))^6 + h*(log10(T))^7 + j*(log10(T))^8);