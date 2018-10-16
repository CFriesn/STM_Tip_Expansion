function QLas = GetLaserPower(t,par)

% QLas = t>= par.Laser.t_Window(1) && t <= par.Laser.t_Window(2);
% 
% QLas = QLas*par.Laser.Q*par.Vars.Current(4);

powInd = find(par.Laser.t_PowerChange_Window <= t,1,'last');

QLas = par.Laser.Q(powInd)*par.Vars.Current(4);

