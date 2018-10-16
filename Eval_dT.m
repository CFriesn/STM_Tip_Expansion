function dT = Eval_dT(t,T,varargin)
if ~isempty(varargin)
    par = varargin{1};
end

%First get the current heat input for the system, in Joules/s
Qlas = par.Laser.Func(t,par)/1E3;

%Next, need the heat capacity for the system. Should be sum of the tip and
%holder heat capacities
if par.Model.DynamicC
    par.Model.Holder.V = pi*(par.Model.Holder.Radius^2)*par.Vars.Current(2);
    par.Model.Holder.Mass = par.Model.Holder.V * par.Model.Holder.Material.DensityFunc(293);
    
    par.Model.Tip.V = pi*(par.Model.Tip.Radius^2)*par.Vars.Current(3);
    par.Model.Tip.Mass = par.Model.Tip.V * par.Model.Tip.Material.DensityFunc(293);
    
    par.Vars.C_Tip = par.Model.Tip.Material.CFunc(T)*par.Model.Tip.Mass;
    par.Vars.C_Holder = par.Model.Holder.Material.CFunc(T)*par.Model.Holder.Mass;  
    par.Vars.C_System = par.Vars.C_Tip + par.Vars.C_Holder;
end

%Then, calculate the change in temperature
dT = (Qlas - par.Vars.Current(1)/1E3*(T-par.Model.TSTM_0))./par.Vars.C_System;

%Hermann mod, I guess to ensure stable start?
% dT(t < par.Laser.t_PowerChange_Window(1)) = 0;
