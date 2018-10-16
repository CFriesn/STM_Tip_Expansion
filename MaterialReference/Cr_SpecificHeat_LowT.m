function cV = Cr_SpecificHeat_LowT(T)
%Units: J/(g*K)
% Source: General 630K Debye temperature
% Debye model (described e.g. in Kittel)
%Valid for ~T<0.1TD
%For Cr, T<63K should be valid



% kB = 1.3806488E-23; %J/K
% Avo = 6.022E23;

NAkB = 8.3143; %kb*Avo 

%Properties for Cr
TD = 630; %[K] Debye temperature
AMU = 51.996; %[g/mol] Atomic mass

%12pi^4/5* = 234

cV = 234*NAkB*(1/AMU)*(T/TD).^3;
% if max(T)>70
%     warning(['T = ' num2str(max(T)) '. Cr cV function only valid up to 70K']);
% end
% 
% if T<=70;
%     cV = 234*NAkB*(1/AMU)*(T/TD).^3;
% % molar heat capacity at RT : 23.35 J/(mol*K)
% elseif (T>70) && (T<=290);
%     cV = 234*NAkB*(1/AMU)*(70/TD)^3; 
%     % Temperature out f range of Debye model. Simply assign 70K value
%     if final;
%         par.DebyeRange = false;
%     end
%     
% else 
%     cV = 23.35/AMU; %valid for 290 K < T < 320 K
%     
% end