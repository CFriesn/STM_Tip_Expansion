function cP = Mo_SpecificHeat_LowT(T)
%Units: J/(g*K)
% Source: http://www.nist.gov/srd/upload/jpcrd313.pdf (jpcrd313.pdf)
% T_Debye = 430 K
gamma = 1.85E-3; % J/mol/K^2

%valid for 4K < T < 293K

TD = 430; %K
AMU = 95.95; %g/mol (atomic mass units)

cP = (gamma*T + (1943.75/TD^3)*T.^3)/AMU;