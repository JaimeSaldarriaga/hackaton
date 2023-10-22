function [afwd,vmax] = max_acceleration(thetagr)

    slope_pr = tan(thetagr)*100.0;

    if (slope_pr > 12.0) 
        afwd = 0.2;
        vmax = 10.0/3.6;
    elseif (slope_pr > 8.0)
        afwd = 0.5;
        vmax = 20.0/3.6;
    elseif (slope_pr > 4.0) 
        afwd = 0.7;  
        vmax = 40.0/3.6;
    else
        afwd = 1.2;
        vmax = 58.0/3.6;
    end
    
end