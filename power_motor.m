function [Pm] = power_motor(Ft,vvh)
    %%%%%%%%%% Output %%%%%%%%%%%%%
    %%% Pm:     Power motor
    %%%%%%%%%% Input %%%%%%%%%%%%%%
    %%% vvh:    Vehicle speed

Pm=Ft.*vvh;
end