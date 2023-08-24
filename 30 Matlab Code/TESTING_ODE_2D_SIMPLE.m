clear all

%% Variable Declarations
% Declare Global variables to pass into the differential equations
global g

% States are used to toggle functions, states() are either 0 or 1
states(1) = 1;       % Toggle for Gravity
states(2) = 1;   % Toggle for Friction
states(3) = 1;  % Toggle for Magnus
states(4) = 1;     % Toggle for Spin Decay
states(5) = 1;          % Toggle for Wind

% Take Values needed in calculation
g = 10 * states(1);
cw = 0.4;
air_density = 1.29;
r = 0.006 / 2;      % m
m = 0.0003;         % kg

%velocity = 100;      % m/s
%angle_initial = 45; % deg
%height = 5;       % m
%spin = 6000;        % rpm
%t_end = 50; %s

velocity = sqrt(200);      % m/s
angle_initial = 45;             % deg
height = 10;                    % m
spin = 0;                    % rpm
t_end = 5; %s

wind_x_speed = 0;
wind_z_speed = 0;




%% ODE Solver
tspan = [0 t_end];                                                      % Timespan for the Simulation starts at 0 and ends at User specified time

x0 = 0;                                                                 % x 	Downrange distance from coordinate Origin is 0
vx = velocity* cos(angle_initial * pi/180);                             % x'	Downrange velocity is the X component of the initial Velocity Vector
z0 = height;                                                            % z 	Vertical distance from coordinate Origin is the Height of the Barrel
vz = velocity * sin(angle_initial * pi/180);                            % z'	Vertical velocity is the Y component of the initial Velocity Vector
theta = 0;                                                              % θ 	Total Rotations, 0 at beginning
omega = spin/60 * 2 * pi;                                               % θ'	Rotation Rate in [rad/s]

y0 = [x0 vx z0 vz];                                   		% Define the starting values as y0: with y0(1:8) = [x, x', y, y', z, z', θ, θ']

%options = odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@events);        % Options for the ODE Solver
options = odeset('RelTol',1e-6,'Events',@events);        % Options for the ODE Solver

% Prepare timing measurement of solvers
timing(1:9) = 0;


[t_ode45,y_ode45] =  ode45(@Airsoft, tspan, y0, options);            % Call the ODE Selver and give out the results into t and y


plot(y_ode45(:,1), y_ode45(:,3), 'b', 'LineWidth', 1.5);                     % Blue line for ode45 results
x = y_ode45(:,1);
z = y_ode45(:,3);

%% Differential Equations
function dy = Airsoft(t,y) % (ﾉ◕ヮ◕)ﾉ*:･ﾟ✧ Magic 
    global g
    

	% Gravity
    gravity = g;

    
    %% Functions
    dy(1,1) = y(2);                                                         % x'  = y(2)
    dy(2,1) = 0;                              % x'' = FORCES IN HORIZONTAL
    dy(3,1) = y(4);                                                         % z'  = y(4)
    dy(4,1) = - gravity;                  % z'' = FORCES IN VERTICAL
end

%% Event detection
% Abort Simulaiton once Object hits the Ground 
function [value,isterminal,direction] = events(t,y)
    value = y(3);           % Monitor Altitude
    isterminal = 1;         % 1: Abort solver, 0: Continue regardless of event
    direction = 0;          % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end