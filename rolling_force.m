function [Fr] = rolling_force(Fn,vvh)
    %%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%
    %%% Fr:     Rolling force
    %%% crr:    Tire rolling resistance coefficient
    %%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%
    %%% vvh:    Vehicle speed
    %%% Fn:     Normal force 
    
    crr=0.01*(1+((3.6/100.00)*vvh));
    Fr=Fn.*crr;
end