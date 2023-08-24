clear all

%% Variable Declarations
% Declare Global variables to pass into the differential equations
global g cw air_density r m states wind_x_speed wind_y_speed wind_z_speed

% States are used to toggle functions, states() are either 0 or 1
states(1) = 1;       % Toggle for Gravity
states(2) = 1;   % Toggle for Friction
states(3) = 1;  % Toggle for Magnus
states(4) = 1;     % Toggle for Spin Decay
states(5) = 1;          % Toggle for Wind

% Take Values needed in calculation
g = 9.81 * states(1);
cw = 0.4;
air_density = 1.29;
r = 0.006 / 2;      % m
m = 0.0003;         % kg

velocity = 100;      % m/s
angle_initial = 45; % deg
height = 5;       % m
spin = 6000;        % rpm
t_end = 50; %s

wind_x_speed = 10;
wind_y_speed = 0;
wind_z_speed = 10;




%% ODE Solver
tspan = [0 t_end];                                                      % Timespan for the Simulation starts at 0 and ends at User specified time

x0 = 0;                                                                 % x 	Downrange distance from coordinate Origin is 0
vx = velocity* cos(angle_initial * pi/180);                             % x'	Downrange velocity is the X component of the initial Velocity Vector
y0 = 0;																	% y		Crossrange distance from coordinate Origin is 0
vy = 0;																	% y'	Crossrange velocity is 0
z0 = height;                                                            % z 	Vertical distance from coordinate Origin is the Height of the Barrel
vz = velocity * sin(angle_initial * pi/180);                            % z'	Vertical velocity is the Y component of the initial Velocity Vector
theta = 0;                                                              % θ 	Total Rotations, 0 at beginning
omega = spin/60 * 2 * pi;                                               % θ'	Rotation Rate in [rad/s]

y0 = [x0 vx y0 vy z0 vz theta omega];                                   % Define the starting values as y0: with y0(1:8) = [x, x', y, y', z, z', θ, θ']

options = odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@events);        % Options for the ODE Solver


% Prepare timing measurement of solvers
timing(1:9) = 0;

tic;
[t_ode45,y_ode45] =     ode45(@Airsoft, tspan, y0, options);            % Call the ODE Selver and give out the results into t and y
timing(1) = toc; tic;
[t_ode23,y_ode23] =     ode23(@Airsoft, tspan, y0, options);            % Call the ODE Selver and give out the results into t and y
timing(2) = toc; tic;
[t_ode113,y_ode113] =   ode113(@Airsoft, tspan, y0, options);           % Call the ODE Selver and give out the results into t and y
timing(3) = toc; tic;
[t_ode78,y_ode78] =     ode78(@Airsoft, tspan, y0, options);            % Call the ODE Selver and give out the results into t and y
timing(4) = toc; tic;
[t_ode89,y_ode89] =     ode89(@Airsoft, tspan, y0, options);            % Call the ODE Selver and give out the results into t and y
timing(5) = toc; tic;
[t_ode15s,y_ode15s] =   ode15s(@Airsoft, tspan, y0, options);           % Call the ODE Selver and give out the results into t and y
timing(6) = toc; tic;
[t_ode23s,y_ode23s] =   ode23s(@Airsoft, tspan, y0, options);           % Call the ODE Selver and give out the results into t and y
timing(7) = toc; tic;
[t_ode23t,y_ode23t] =   ode23t(@Airsoft, tspan, y0, options);           % Call the ODE Selver and give out the results into t and y
timing(8) = toc; tic;
[t_ode23tb,y_ode23tb] = ode23tb(@Airsoft, tspan, y0, options);          % Call the ODE Selver and give out the results into t and y
timing(9) = toc;

plot3(y_ode45(:,1), y_ode45(:,3), y_ode45(:,5), 'b');                     % Blue line for ode45 results
hold on
plot3(y_ode23(:,1), y_ode23(:,3), y_ode23(:,5), 'r');                 % Red line for ode23 results
plot3(y_ode113(:,1), y_ode113(:,3), y_ode113(:,5), 'g');              % Green line for ode113 results
plot3(y_ode78(:,1), y_ode78(:,3), y_ode78(:,5), 'm');                 % Magenta line for ode78 results
plot3(y_ode89(:,1), y_ode89(:,3), y_ode89(:,5), 'c');                 % Cyan line for ode89 results
plot3(y_ode15s(:,1), y_ode15s(:,3), y_ode15s(:,5), 'y');              % Yellow line for ode15s results
plot3(y_ode23s(:,1), y_ode23s(:,3), y_ode23s(:,5), 'k');              % Black line for ode23s results
plot3(y_ode23t(:,1), y_ode23t(:,3), y_ode23t(:,5), 'Color', [0.5 0.5 0.5]);  % Gray line for ode23t results
plot3(y_ode23tb(:,1), y_ode23tb(:,3), y_ode23tb(:,5), 'Color', [0.7 0.2 0.2]);  % Brown color for ode23tb results
axis equal

xlabel('X [m]');  % Add labels to the axes
ylabel('Z [m]');
title('ODE Solver Comparison - 3D');
legend('ode45', 'ode23', 'ode113', 'ode78', 'ode89', 'ode15s', 'ode23s', 'ode23t', 'ode23tb');
grid on;  % Add grid lines to the plot
hold off;  % Release the hold on the plot

figure
label_bar = categorical({'ode45', 'ode23', 'ode113', 'ode78', 'ode89', 'ode15s', 'ode23s', 'ode23t', 'ode23tb'});
label_bar = reordercats(label_bar,{'ode45', 'ode23', 'ode113', 'ode78', 'ode89', 'ode15s', 'ode23s', 'ode23t', 'ode23tb'});
bar(label_bar,timing);
xlabel('ODE Solver');  % Add labels to the axes
ylabel('Time [s]');
title('ODE Solver Time Comparison');

% Adjust the y-axis limits
ylim([0, max(timing) * 1.1]);
figure

%% Differential Equations
function dy = Airsoft(t,y) % (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧ Magic 
    global g cw air_density r m states wind_x_speed wind_y_speed wind_z_speed
    
	% Crossection Area of Projectile
    A = pi * r^2;
	
	% Gravity
    gravity = g;
    
    %% Air Resistance
	
	% Relative Velocities
	% Subtract the Windspeed from the groundspeed to get the airspeed
    airspeed_x = y(2) + ( - wind_x_speed * states(5) );
    airspeed_y = y(4) + ( - wind_y_speed * states(5) );
	airspeed_z = y(6) + ( - wind_z_speed * states(5) );
	
	% Air Resistance Force
	% Calculate the Air Resistance Force based on the airspeed
    air_resistance_x = 1/2 * cw * air_density * A * airspeed_x^2 * sign(airspeed_x) * -1 * states(2);
	air_resistance_y = 1/2 * cw * air_density * A * airspeed_y^2 * sign(airspeed_y) * -1 * states(2);
    air_resistance_z = 1/2 * cw * air_density * A * airspeed_z^2 * sign(airspeed_z) * -1 * states(2);

    %% Magnus Force
	% Calculate the Magnitude of the airspeed
    total_velocity = sqrt(airspeed_x^2 + airspeed_y^2 + airspeed_z^2);

	% Calculate the Magnitude of the Magnus Force
    F_Magnus = 4/3 * pi * air_density * r^3 * y(8) * total_velocity;
	
	% Construct a vector with the direction and magnitude of the Airspeed
	Velocityvector = [airspeed_x airspeed_y airspeed_z];
	
	% Scale the Vector to length 1
	mag_v = Velocityvector / total_velocity;
	
	% Get the Flight Azimuth direction in XY
	angle_az = atan2(y(2),y(4)); % Problemstelle
    
    % The Cross product AxB is the Azimuth rotated by 90 deg (z component = 0)
	mag_cross = [sin(angle_az + pi/2) cos(angle_az + pi/2) 0];
	
    % Vector A (Velocityvector) and the Cross Product AxB is given, calculate b
	% A, AxB and B are all 90° from each other, so A crossed AxB is B
	mag_b = - cross(mag_v, mag_cross);
    
	% B points in the direction of the Magnusforce with length 1
	% Get the individual components
    magnus_x = F_Magnus * mag_b(1) * states(3);
	magnus_y = F_Magnus * mag_b(2) * states(3);
    magnus_z = F_Magnus * mag_b(3) * states(3);
    
    %% Spin decay
	% nu & I
    nu = 17.8 * 10^-6;
    I = 2/5 * m * r^2;           % I = 2/5 * m * r^2
    % Torque
    T = -8 * pi * r^3 * nu * y(8) * states(4);
    
    %% Functions for Differential Solving
    dy(1,1) = y(2);                                                         % x'  = y(2)
    dy(2,1) = air_resistance_x/m + magnus_x/m;                              % x'' = FORCES DOWNRANGE
	dy(3,1) = y(4);															% y'  = y(4)
	dy(4,1) = air_resistance_y/m + magnus_y/m;								% x'' = FORCES CROSSRANGE
    dy(5,1) = y(6);                                                         % z'  = y(6)
    dy(6,1) = - gravity + air_resistance_z/m + magnus_z/m;                  % z'' = FORCES IN VERTICAL
    dy(7,1) = y(8);                                                         % θ'  = y(8)
    dy(8,1) = T/I;                                                          % θ'' = FORCES IN ROTATION
end

%% Event detection
% Abort Simulaiton once Object hits the Ground 
function [value,isterminal,direction] = events(t,y)
    value = y(5);           % Monitor Altitude
    isterminal = 1;         % 1: Abort solver, 0: Continue regardless of event
    direction = 0;          % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end