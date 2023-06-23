clear all

slices = 600;

% diameter = 6; %ft
diameter = 6; %ft

radius = diameter / 2;

step = 2*radius / slices;

rho = 0.0023769; % slugs/ft^3
spin = 100; % revs/sec
v = 330; %ft/s

F_Magnus = 0;
x=0;
y=0;
for i = 1:slices/2
    alpha = acos(((i-1)*step+step)/radius);
    radius_n = radius * sin(alpha);
    
    F_M = 4*pi^2*spin*v*rho*radius_n^2*step;
    F_Magnus = F_Magnus + F_M;

    x(i) = i*step;
    y(i) = radius_n;

end
F_Magnus
plot(x,y)
hold on