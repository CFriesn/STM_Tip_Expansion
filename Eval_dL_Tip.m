function dL = Eval_dL_Tip(t,L,varargin)

if ~isempty(varargin)
    par = varargin{1};
end

%First need expansion coefficient at these times (calculated in previous
%step)
% Alpha = interp1(par.Data.t_ModelData,par.Data.Alpha_Tip,t);
% dT = interp1(par.Data.t_ModelData,par.Data.dT_ModelData,t);

ind = find(par.Data.t_ModelData>t,1);
if ind > 1
    Alpha = (par.Data.Alpha_Tip(ind-1)+par.Data.Alpha_Tip(ind))/2;
    dT = (par.Data.dT_ModelData(ind-1)+par.Data.dT_ModelData(ind))/2;
elseif ind == 1
    Alpha = par.Data.Alpha_Tip(1);
    dT = par.Data.dT_ModelData(1);
elseif isempty(ind)
    Alpha = par.Data.Alpha_Tip(end);
    dT = par.Data.dT_ModelData(end);
end

dL = Alpha.*L.*dT;

end
