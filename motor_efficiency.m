function [eff]=motor_efficiency(Torque_motor_on_route,rpm_speed_on_route)
%%%%% Motor efficiency
%%%%% Specific on this case; that motor
eff=0;
    if (0 < Torque_motor_on_route) && (Torque_motor_on_route)< 2800&& (0 < rpm_speed_on_route ) && (rpm_speed_on_route< 500)
        eff=70;
    
    elseif (0 < Torque_motor_on_route) && (Torque_motor_on_route < 2800) && (500 < rpm_speed_on_route) && (rpm_speed_on_route < 800)
        eff = 90;
        
    elseif (0 < Torque_motor_on_route) && (Torque_motor_on_route < 1000) && (800 < rpm_speed_on_route) && (rpm_speed_on_route < 2000)     
        eff = 93;
        
    elseif (0 < Torque_motor_on_route) && (Torque_motor_on_route < 800) && (2000 < rpm_speed_on_route) && (rpm_speed_on_route < 3000)     
        eff = 70;
        
    end        
    
end