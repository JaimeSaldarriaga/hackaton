function Tmax = motor_curve(omega,mcurve,mode)
    %%% Omega    
    omega_rpm = omega*60/(2*pi);    
    Tmax = interp1(mcurve(:,1),mcurve(:,mode+1),omega_rpm);
end