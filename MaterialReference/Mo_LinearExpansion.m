function alpha = Mo_LinearExpansion(T)
%Units: Unitless 
%The TPRC Data Series. Touloukian,
% Kirby R.K, Taylor R.E. and Desai P.D.
% Volume 12:  Thermal Expansion-Metallic Elements and Alloys
% New York, Washington 1970.  p. 209-218
%(ADA129115) http://cryogenics.nist.gov/MPropsMAY/Molybdenum/Molybdenum_rev.htm

%Valid ~20 K < T < 350 K
a = -90.912613;
b = -0.127173;
c = 0.00266801;
d = -5.0432E-06;
e = 3.5183E-09;
if T>350;% || T<20
    warning('Warning: Temp out of confidence range of linear expansion model');
end

delT = 0.1;

T = T+delT;
alphaHigh = (a + b*T + c*T.^2 + d*T.^3 + e*T.^4)*10.^-5; %unitless ((L(T)-L(293K))/L(293K))
T = T-2*delT;
alphaLow = (a + b*T + c*T.^2 + d*T.^3 + e*T.^4)*10.^-5;
%Reference is in terms of ((L(T)-L(293K))/L(293K)), need to convert to
%differential
alpha = (alphaHigh-alphaLow)/(2*delT);