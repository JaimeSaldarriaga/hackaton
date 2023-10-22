function [navh, nTm, nFt, nFi, nTf,rpm] = check_engine_force(avh,vvh,Ft,Fgx,Fa,Fi,Fr,mvh,vwr,vmin,r_transm_total,mcurve)
                                                    
    %%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%
    %%% navh:    Vehicle Acceleration.
    %%% nTm:     Max Torque.
    %%% nFt:     Traction Force.
    %%% nFi:     Inertial Force.
    %%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%
    %%% avh:    Vehicle acceleration
    %%% Tm:     Motor torque
    %%% Ft:     Traction Force
    %%% mvh:    Mass of vehicle
    %%% vwr:    Wheel radious
    
    Tw = Ft * vwr;      % Torque at the wheels
    Tm = Tw / r_transm_total;
    nTm = Tm;
    nFt = Ft;
    nFi = Fi;
    navh = avh;
    nTf = 0.0;
    
    
    omega = (vvh/vwr)*r_transm_total;
    rpm = omega*60/(2*pi);
    Tmax = motor_curve(omega,mcurve, 1);
    
    if Ft < 0
        nTm = 0;
        nFt = 0;
        nTf = Tw;
    
    else
        if (Tm > Tmax)
            
            nTm  = Tmax;
            nTw = nTm*r_transm_total;
            nFt  = nTw/vwr;
            nFi  = nFt-Fgx-Fa-Fr;
            navh = nFi/mvh;
            
            if navh <0 && vvh<vmin
                Tmax = motor_curve(omega,mcurve, 1);
                if (Tm > Tmax)
                    nTm  = Tmax;
                else
                    nTm = Tm;
                end
                
                nTw = nTm*r_transm_total;
                nFt  = nTw/vwr;
                nFi  = nFt-Fgx-Fa-Fr;
                navh = nFi/mvh;
            end
        end
    end
end