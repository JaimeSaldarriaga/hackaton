function [Fg] = gravitational_force(mvh, ag)
    %%%%%%%%%% Output %%%%%%%%%%%%%%%%%
    %%% Fg:         Gravitational force
    %%%%%%%%%% Input %%%%%%%%%%%%%%%%%%
    %%% mvh:        Vehicle mass
    %%% ag:         Gravitational acceleration
    %%% thetagr:    Inclination grades
    
    Fg=mvh*ag;
end