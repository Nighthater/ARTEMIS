clear all
g = 9.81; % Erdbeschleunigung in m/s^2
m = 0.006; % Masse Papierkugel in kg
d = 0.065; % Durchmesser in m
cw = 1.2; % Widerstandsbeiwert (dimensionslos)
rho = 1.25; % Luftdichte in kg/m^3
r0 = [ 0; 0; 0 ]; % Anfangsposition in m
v0 = [ 20; 0; 20 ]; % Anfangsgeschwindigkeit in m/s
vW = [ 0; 5; 0 ]; % konstante Windgeschwindigkeit in m/s
h = 0.02; % kleines Zeitintervall in s
tE = 60; % fiktiver Endzeitpunkt in s

% Konstante
kappa = rho/2 * cw * ( pi/4 * d^2 ) ;

% Flugbahn punktweise durch numerische Integration ermittelt
t=0; r=r0; v=v0;
plot3(r(1),r(2),r(3),'ok','MarkerSize',5), hold on
while t < tE

% Luftwiderstand
vrel = v - vW;
FW = -kappa*sqrt(vrel.'*vrel)*vrel;

% Beschleunigungs -Vektor
a = FW/m + [ 0; 0; -g ];

% update Zeit , Weg - und Geschwindigkeitsvektor
th = t + h;
vh = v + a*h;
rh = r + v*h + a*0.5*h^2;

plot3(rh(1),rh(2),rh(3),'ok','MarkerSize',5)

% Abbruch falls Punktmasse in den Boden eindringt
if rh(3) <= 0, break , end

% update Zeit , Geschwindigkeit und Lage
t = th; v = vh; r = rh;

end

% Graphik -Einstellungen
set(gca ,'FontSize' ,15), axis('equal'), grid on
xlabel('x / m'), ylabel('y / m'), zlabel('z / m')

% Zeitpunkt und Lage des Auftreffens durch Interpolation
p = -r(3)/(rh(3)-r(3));
ta = t + p*(th -t); disp(['Auftreffzeitpunkt =',num2str(ta), 's'])