function alpha = Cr_LinearExpansion(T)
%R.B. Roberts et al. Thermal Expansion of Cr and Cr-V Alloys
%Physica 119B 1983

%Valid ~0K<T<100K
a = -32E-10;
b = 2E-12;

for i = 1:length(T);
    
alpha(i,1) = a*T(i) + b*T(i).^3; % in 1/K

% linear thermal expansion at RT: 4.9 µm/(m·K) (at 25 °C)
    if alpha(i,1) > 4.9E-6;
    
        alpha(i,1) = 4.9E-6;

    end

end