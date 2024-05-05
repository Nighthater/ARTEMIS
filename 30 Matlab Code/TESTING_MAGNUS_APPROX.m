clear all

% 600 cylinder slices to approximate a sphere
slices = 600;

% Set diameter of Sphere
diameter = 6; %ft
radius = diameter / 2;

% Calculate stepwidth
step = 2*radius / slices;

% Units
rho = 0.0023769; % slugs/ft^3
spin = 100; % revs/sec
v = 330; %ft/s

% Output Variables
F_Magnus = 0;
x=0;
y=0;

% go through each slice
for i = 1:slices/2
	% Get Angle
    alpha = acos(((i-1)*step+step)/radius);
    
	% Calculate Radius
	radius_n = radius * sin(alpha);
    
	% Magnus force for Segment
    F_M = 4*pi^2*spin*v*rho*radius_n^2*step;
    
	% Add partial force to sum
	F_Magnus = F_Magnus + F_M;

    x(i) = i*step;
    y(i) = radius_n;

end
F_Magnus
plot(x,y)
hold on