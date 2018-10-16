function alpha = W_LinearExpansionW(T)
%The TPRC Data Series. Touloukian,
% Kirby R.K, Taylor R.E. and Desai P.D.
% Volume 12:  Thermal Expansion-Metallic Elements and Alloys
% New York, Washington 1970.  p. 209-218
%(ADA129115) 

%Valid ~55 K < T < 120 K
a = -5.5475E-6;
b = 2.39531E-7;
c = -3.01611E-9;
d = 1.95992E-11;
e = -5.08502E-14;
if T>120;% || T<50
    warning('Warning: Temp out of confidence range of linear expansion model');
end
alpha = (a + b*T + c*T.^2 + d*T.^3 + e*T.^4); % 1/K