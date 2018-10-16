function alpha = Steel_LinearExpansion(T)
%Units: Unitless dL=alpha*L0*dT

%Cryogenic Material Properties Database
% Presented at the
% 11th International Cryocooler Conference
% June 20-22, 2000
% Keystone, Co

%Valid ~4 K < T < 300 K

a = -2.9546E+2;
b = -4.0518E-1;
c = 9.4014E-3;
d = -2.1098E-5;
e = 1.8780E-8;
% if T>300;% || T<4
%     warning('Warning: Temp out of confidence range of linear expansion model');
% end
delT = 0.1;

T = T+delT;
alphaHigh = (a + b*T + c*T.^2 + d*T.^3 + e*T.^4)*10.^-5; %unitless ((L(T)-L(293K))/L(293K))
T = T-2*delT;
alphaLow = (a + b*T + c*T.^2 + d*T.^3 + e*T.^4)*10.^-5;
%Reference is in terms of ((L(T)-L(293K))/L(293K)), need to convert to
%differential
alpha = (alphaHigh-alphaLow)/(2*delT);

