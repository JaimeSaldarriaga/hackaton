function [Fa] = drag_force(rho,Aft,vvh,vwd,cdg)
    %%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%
    %%% Fa:     Aerodynamic force
    %%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%
    %%% rho:    Fluid density
    %%% Aft:    Frontal area
    %%% vvh:    Vehicle speed
    %%% vwd:    Fluid speed
    %%% cdg:    Drag coefficient
    
    Fa=0.5*rho*cdg*Aft*(vvh+vwd).^2;
end