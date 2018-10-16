function cP = W_SpecificHeat_LowT(T)
%Units: J/(g*K)
% Source: 'Heat capacity of reference materials: Cu and W' (jpcrd263)
%http://aip.scitation.org/doi/pdf/10.1063/1.555728

%Properties for W
AMU = 183.84; %g/mol (atomic mass units)

a0 = 7.828;
a1 = -83.953;
a2 = 317.322;
a3 = -463.671;
a4 = 377.553;
a5 = -185.286;
a6 = 54.498;
a7 = -8.853;
a8 = 0.610;

%Includes 1/AMU factor for conversion from mol -> g
cP = 1/AMU*(a0 + a1.*(T./100) + a2.*(T./100)^2 + a3.*(T./100)^3 + a4.*(T./100)^4 + a5.*(T./100)^5 + a6.*(T./100)^6 + a7.*(T./100)^7 + a8.*(T./100)^8);