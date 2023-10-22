function [ait] = instan_acceleration(vvh,dt)
    %%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%
    %%% ait:    Instantaneous acceleration
    %%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%
    %%% vvh:    Vehicle speed
    %%% dt:     Diferencial time

    ait=diff(vvh)/diff(dt);
end