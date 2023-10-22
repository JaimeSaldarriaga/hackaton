function [Fi] = inertial_force(mvh,avh)
    %%%%%%% Output %%%%%%%%%%%
    %%% Fi:     Inertial force
    %%%%%%% Input %%%%%%%%%%%%
    %%% mvh:    Vehicle mass
    %%% avh:    Vehicle acceleration
    
    Fi=mvh*avh;    
end

