function [avh]=acelerate_vehicle(vvh,dpp,pst,abrk,afwd,vlim,vmin)
    %%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%
    %%% avh:     Vehicle acceleration
    %%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%
    %%% vvh:    Vehicle speed
    %%% dpp:    Vehicle position
    %%% pst:    Stop position
    %%% abrk:   Braking accelaration
    %%% afwd:   Forward acceleration
    %%% vlim:   Limit Speed
    %%% vmin:   Minimum speed.
    
    index = find(pst(:,1)>dpp);
    p_nxt_stop = pst(index(1),1);
    t_nxt_stop = pst(index(1),2);
    d_nxt_stop = p_nxt_stop - dpp;
    braking_distance = -vvh^2/(2*abrk);
    
    if( d_nxt_stop < braking_distance)
        if (t_nxt_stop == 1)
            vlow = vmin;
        else
            vlow = 2.80; 
        end

        if (vvh > vlow)
            avh = abrk;
        else
            avh = 0.0;
        end
    else
        
        if (vvh > vlim)
            avh = 0.0;
        else
            avh = afwd;
        end
    end
end