function cP = Cu_SpecificHeat_LowT(T)
%Units: J/(g*K)
% Source: Heat capacity of reference materials: Cu and W (jpcrd263)

% kB = 1.3806488E-23; %J/K
% Avo = 6.022E23;

% NAkB = 8.3143; %kb*Avo 

%Properties for W

rho = 19.25E-6; %g/m^3 (density r.t. (need better value))
AMU = 183.84; %g/mol (atomic mass units)

a0 = 4.89287;
a1 = -57.51701;
a2 = 238.2039;
a3 = -345.4283;
a4 = 275.8975;
a5 = -132.5425;
a6 = 38.17399;
a7 = -6.07962;
a8 = 0.4118687;

%12pi^4/5 = 234
cP = 1/AMU*(a0 + a1.*(T./100) + a2.*(T./100)^2 + a3.*(T./100)^3 + a4.*(T./100)^4 + a5.*(T./100)^5 + a6.*(T./100)^6 + a7.*(T./100)^7 + a8.*(T./100)^8);