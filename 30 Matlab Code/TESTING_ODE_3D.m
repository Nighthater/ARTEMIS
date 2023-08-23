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

velocity = 10;      % m/s
angle_initial = 10; % deg
height = 1.8;       % m
spin = 1000;        % rpm
t_end = 50; %s

% Whe wind parameters contain the parameters for 3 sine functions that define the wind in the simulation
wind_x_speed = 0;
wind_y_speed = 0;
wind_z_speed = 0;




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
[t_ode45,y_ode45] =     ode45(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode23,y_ode23] =     ode23(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode113,y_ode113] =   ode113(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode78,y_ode78] =     ode78(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode89,y_ode89] =     ode89(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode15s,y_ode15s] =   ode15s(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode23s,y_ode23s] =   ode23s(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode23t,y_ode23t] =   ode23t(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y
[t_ode23tb,y_ode23tb] = ode23tb(@Airsoft, tspan, y0, options);                            % Call the ODE Selver and give out the results into t and y




plot(t_ode45, y_ode45(:,5), 'b', 'LineWidth', 1.5);  % Blue line for ode45 results
hold on
plot(t_ode23, y_ode23(:,5), 'r', 'LineWidth', 1.5);  % Red line for ode23 results
plot(t_ode113, y_ode113(:,5), 'g', 'LineWidth', 1.5);  % Green line for ode113 results
plot(t_ode78, y_ode78(:,5), 'm', 'LineWidth', 1.5);  % Magenta line for ode78 results
plot(t_ode89, y_ode89(:,5), 'c', 'LineWidth', 1.5);  % Cyan line for ode89 results
plot(t_ode15s, y_ode15s(:,5), 'y', 'LineWidth', 1.5);  % Yellow line for ode15s results
plot(t_ode23s, y_ode23s(:,5), 'k', 'LineWidth', 1.5);  % Black line for ode23s results
plot(t_ode23t, y_ode23t(:,5), 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5);  % Gray line for ode23t results
plot(t_ode23tb, y_ode23tb(:,5), 'Color', [0.7 0.2 0.2], 'LineWidth', 1.5);  % Custom color for ode23tb results

xlabel('Time');  % Add labels to the axes
ylabel('ODE Solution');
title('ODE Solver Comparison');
legend('ode45', 'ode23', 'ode113', 'ode78', 'ode89', 'ode15s', 'ode23s', 'ode23t', 'ode23tb');
grid on;  % Add grid lines to the plot
hold off;  % Release the hold on the plot

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