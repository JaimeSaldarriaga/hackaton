%%% import data
format long
[archivo,directorio]=uigetfile({
    '*.xlsx;*.xls;*.xltx;*.xlt','Archivos Excel(*.xlsx; *.xls; *.xltx; *.xlt)';
    '*.txt;*.csv;','Archivos de texto(*.txt; *.csv;)';
    '*.prn;*.dif;','Otros archivos(*.prn; *.dif;)';
    '*.*','Todos los archivos(*.*)'
},'Selecciones un archivo');
datageo = xlsread(fullfile(directorio,archivo));
long=datageo(:,1);
lat=datageo(:,2);
alt=datageo(:,3);

indices = find(alt<1449); 
alt(indices) = 1449;
long(1550:2221) = long(2221:-1:1550); 
lat(1550:2221) = lat(2221:-1:1550); 
alt(1550:2221) = alt(2221:-1:1550);

Rea=6371;
grrd=pi()/180;
dlat=grrd.*(diff(lat));
dlon=grrd.*(diff(long));

a = sin(dlat ./ 2) .* sin(dlat ./ 2) + cos(grrd .* lat(1)).* cos(grrd .* lat(2)) .* sin(dlon / 2).* sin(dlon./ 2);
c = 2 * asin(sqrt(a));

d=Rea.*c.*1000;
fprintf('La distancia total en m de la ruta  %f\n',sum(d))
fprintf('La distancia total del recorrido en km en el día %f\n', sum(d).*25.0/1000)

%%%%% Lienearising of displacement vector
drl=zeros(1,length(d));
drl(1,1) = d(1);
for drr=2:1:length(d)
    drl(1,drr)=drl(1,drr-1)+d(drr);
end
drl = [0 drl(1:end)];

%%%% Change slope in steep region.
indices = find(drl>=3362 & drl <=3438);

Y1 = alt(indices(1)); 
X1 = drl(indices(1)); 
Y2 = alt(indices(end)); 
X2 = drl(indices(end));
m = (Y2-Y1)/(X2-X1); 
alt(indices) = m*(drl(indices)-X1)+Y1;

%%%% Smoothing of the altitude values due to high slope values.
k = 20; 
alt = movmean(alt,k);

diffalt = diff(alt);
slope_percent = diffalt./d*100;

figure(),
subplot(1,2,1) 
hold off
plot(long,lat,'--k')
hold on
init = 1550;
fin = 2221;
plot(long(init:fin),lat(init:fin),'-r',"linewidth",2);
title('Trayecto ruta 283')
xlabel('longitud')
ylabel('latitud')
subplot(1,2,2), plot(drl,alt,'--k')
title('Carcaterísticas topográficas de la ruta')
xlabel('Distancia de la ruta (m)')
ylabel('Altura al nivel del mar (m)')

figure()
hold off
plot(drl,alt)
hold on
plot(drl(init:fin),alt(init:fin),'-r',"linewidth",2)
title('Trayecto ruta 283')
xlabel('Distancia de la ruta (m)')
ylabel('Altura sobre el nivel del mar (m)')

figure()
plot(drl(2:end),slope_percent,'k')
title('Trayecto ruta')
xlabel('Distancia de la ruta (m)')
ylabel('Pendiente del trayecto (%)')

