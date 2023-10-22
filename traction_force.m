function [Ft] = traction_force(Fi, Fg, Fr, Fa)
    %%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%
    %%% Ft:     Traction force
    %%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%
    %%% Fi:     Inertial force
    %%% Fg:     Gravitational force
    %%% Fr:     Rolling force
    %%% Fa:     Aerodynamic force

    Ft=Fi+Fg+Fr+Fa;
end