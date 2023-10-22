 % Código calculo de energía conusmida en un vehículo

 clc, clear, close all

% Load positions of stops.
stop_position

%%% Define masses:
m_chassis = 1610; %
m_carbody = 2200; %
m_pax     = 41*68*1.0; %
m_emotor  = 224; %
m_coolant = 50; %
m_mcu     = 5; %
m_battery = 1200; %
mvh = m_chassis+m_carbody+m_pax+m_emotor+m_coolant+m_mcu+m_battery; %

disp("Mass of the vehicle "+ string(mvh)+" [kg]")

% Set vehicle properties
abrk =-1.0;         % Braking acceleration
vlim = 60.0/3.6;
vmin = 0.0;%2.8;         % m/s  
ag=9.81;            % Gravitational acceleration m/s^2
rho=1.2;            % Fluid density kg/m^3 in Medellin / literatura 1.184 / simulacion 1.181
Aft=6;              % Frontal area m^2
vwd=2.5;            % Wind speed m/s
vwr=0.375;          % Wheel radius m
cdg=0.65;           % Drag coefficient
r_transm_total = 3.636; % Total transission ratio.
Tmax = 550*r_transm_total;   % Maximum engine torque (considering differential).
eff = 0.7;    % Engine efficiency
tpd = 20;     % Trips per day

mcurve = xlsread('torque_voltaje_motor.xlsx');

% Initial conditions
vvh = 1.0;            % Initial velocity
dpp = 1.0;            % Initial position
dt =  0.05;          % Diferential time seconds

% Topological conditions
geo_trans;                        % Arroja en radianes
rx = drl';
ry = alt;

% Higth points
rxx=diff(rx);                 % Difference longitudinal distance
ryy=diff(ry);                 % Difference height distance
dxx = rx(1:end-1);
thetapr = ryy./rxx;
thetagr=atan(thetapr);  % Todo Check if atan is the best function to use data on grades.

dmax=dxx(end); 
i = 0;
t_cumulative = 0.0;
report = zeros(10000,15);

while (dpp <= dmax)
    i = i + 1;
    thetai = interp1(dxx,thetagr,dpp);
    [afwd,vlim] = max_acceleration(thetai);
    
    [avh] = acelerate_vehicle(vvh,dpp,pst,abrk,afwd,vlim,vmin);
    
    Fg  = gravitational_force(mvh, ag);
    Fn  = Fg*cos(thetai);
    Fgx = Fg*sin(thetai);
    Fa  = drag_force(rho,Aft,vvh,vwd,cdg);
    Fi  = inertial_force(mvh,avh);
    Fr  = rolling_force(Fn,vvh);
    
    Ft = Fgx + Fa + Fi + Fr; 
    
    [avh, Tm, Ft, Fi, Tf, rpm] = check_engine_force(avh,vvh,Ft,Fgx,Fa,Fi,Fr,mvh,vwr,vmin,r_transm_total,mcurve);
    
    t_cumulative = t_cumulative + dt;
    report(i,1) = dpp;
    report(i,2) = avh;
    report(i,3) = vvh; 
    report(i,4) = Ft;
    report(i,5) = Tm;
    report(i,6) = thetai;
    report(i,7) = Fi;
    report(i,8) = Tf/4.0; 
    report(i,9) = Ft*vvh*dt ;
    report(i,10) = Fr ;
    report(i,11) = rpm ;
    report(i,12) = t_cumulative ;
    report(i,13) = Ft*vvh; 
    report(i,14) = Fn;
    report(i,15) = Fa;
    report(i,16) = Fgx;

    vvh = vvh + avh*dt;
    dpp = dpp + vvh*dt;
   
end

Torque_motor_on_route = report(1:i,5);
rpm_speed_on_route = report(1:i,11);
total_distance_trip = tpd*sum(d)./1000;  

disp( "Energia total: "   +    string(tpd*sum(report(1:i,9))/3.6e6/eff) + " [kWh]")
disp( "Eficiencia energética: " + string((tpd*sum(report(1:i,9))/3.6e6/eff)./total_distance_trip) + " [kWh/km Performance]")
disp( "Velocidad promedio: " + string  (sum(report(1:i,3)*3.6)./length(report(1:i,3)*3.6)) + "[km/h]")
disp( "Velocidad max km/h:  " + string  ((max(abs(report(1:i,3))))*3.6) + "[km/h]")
disp( "Velocidad min km/h:  " + string  ((min(abs(report(1:i,3))))*3.6) + "[km/h]")
disp( "Velocidad max rpm:  " + string  ((max(abs(report(1:i,3))./(vwr)))*60/(2*pi())) + "[rpm]")
disp( "Velocidad min rpm:  " + string  ((min(abs(report(1:i,3))./(vwr)))*60/(2*pi())) + "[rpm]")
disp( "Potencia max kW:  " + string  ((max(report(1:i,13)))./1000) + "[kW]")
disp( "Torque max Nm:  " + string  ((max(report(1:i,5)))) + "[Nm]")

figure()
plot(report(1:i,1),report(1:i,3)*3.6,'k')
title("Velocidad del vehiculo [km/h]")
xlabel('Distancia [m]')
ylabel('Velocidad [km/h]')

plot(report(1:i,1),tan(report(1:i,6))*100,'k')
title("Inclinacion de la via")
xlabel('Distancia [m]')
ylabel('Pendiente [%]')

figure()
plot(report(1:i,1),(report(1:i,9)./dt),'k')
title("Potencia instantanea (consumido)")
xlabel('Distancia [m]')
ylabel('Potencia [W]')

figure()
plot(report(1:i,1),report(1:i,2),'k')
xlabel('Distancia [m]')
ylabel('Aceleración [m/s^2]')
title("Aceleracion del vehiculo")

figure()
plot(report(1:i,1),report(1:i,10),'k')
title("Fuerza de rodadura")
xlabel('Distancia [m]')
ylabel('Fuerza de rodadura [N]')

figure()
plot(rx,ry,'k')
title("Topografia")
xlabel('Distancia [m]')
ylabel('Altura [msnm]')

figure()
plot(dxx,tan(thetagr)*100,'k')
title("Inclinacion de la via en porcentaje")
xlabel('Distancia [m]')
ylabel('Inclinación del terreno [%]')

% Divide route.
indices = find(pst(:,1)>=3600);
nstops_descend = indices(1);

figure()
plot(report(1:i,12),(report(1:i,9)./dt),"k")
title('Potencia ejercida por el vehículo')
xlabel('Tiempo [s]')
ylabel('Potencia [W]')

figure()
plot(report(1:i,12),report(1:i,2),"k")
title("Aceleracion promedio")
xlabel('Tiempo [s]')
ylabel('Aceleracion [m/s^2]')

figure()
plot(report(1:i,12),report(1:i,3)*3.6,"k")
title("Velocidad en el tiempo [km/h]")
xlabel('Tiempo [s]')
ylabel('Velocidad [km/h]')
