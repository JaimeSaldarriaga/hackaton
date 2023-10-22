function [Fn] = normal_force(mvh, ag, thetagr)
    %%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%
    %%% Fn:         Normal force
    %%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%%
    %%% mvh:        Vehicle mass
    %%% ag:         Gravitational acceleration
    %%% thetagr:    Inclination grades 

    Fn=mvh*ag.*cos(thetagr);
end