function alpha = Cr_LinearExpansion_Fit(T)
% fit to table in G. K. White et al.:Thermal expansion of Cr and CrV alloys. I. Experiment

%Valid ~0K<T<125K

a = 4.00255E-8;
b = -2.43678E-8;
c = 3.24612E-9;
d = -2.11043E-10;
e = 6.92099E-12;
f = -1.19205E-13;
g = 1.13202E-15;
h = -5.62361E-18;
j = 1.13979E-20;

for i = 1:length(T);
    
alpha(i,1) = a + b*T(i) + c*T(i).^2 + d*T(i).^3 + e*T(i).^4 + f*T(i).^5 + g*T(i).^6 + h*T(i).^7 + j*T(i).^8; % in 1/K

% linear thermal expansion at RT: 4.9 µm/(m·K) (at 25 °C)
    if T(i) > 130;
    
        alpha(i,1) = 4.9E-6;

    end

end

