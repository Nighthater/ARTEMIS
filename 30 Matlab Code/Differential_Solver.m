function Differential_Solver(app)
%% Variable Declarations
    % Declare Global variables to pass into the differential equations
    global g cw air_density r m states wind_x_params
    

    
    % Values needed in calculation
    g = app.SIM_Gravity;
    cw = 0.4; % TODO
    air_density = app.SIM_Air_Density;
    r = app.BB_Diameter / 2;
    m = app.BB_Mass;

    % Used to toggle functions
    states(1) = app.Bool_Gravity;       % Toggle for Gravity
    states(2) = app.Bool_AirFriction;   % Toggle for Friction
    states(3) = app.Bool_MagnusEffect;  % Toggle for Magnus
    states(4) = app.Bool_SpinDecay;     % Toggle for Spin Decay
    states(5) = app.Bool_Wind;          % Toggle for Wind

    wind_x_params(1:12) = app.SIM_Wind_X_Properties(1:12);
%% ODE Solver
    tspan = [0 app.tspan_end];                                              % Timespan for the Simulation starts at 0 and ends at User specified time

    x0 = 0;                                                                 % Horizontal distance from coordinate Origin is 0
    vx = app.BB_Velocity_Initial* cos(app.BB_Angle_Initial * pi/180);       % Horizontal velocity is the X component of the initial Velocity Vector
    z0 = app.BB_Height_Initial;                                             % Vertical distance from coordinate Origin is the Height of the Barrel
    vz = app.BB_Velocity_Initial * sin(app.BB_Angle_Initial * pi/180);      % Vertical velocity is the Y component of the initial Velocity Vector
    theta = 0;                                                              % Total Rotations, 0 at beginning
    omega = app.BB_Spin_Initial/60;                                         % Rotation Rate in [1/s]

    y0 = [x0 vx z0 vz theta omega];                                         % Define the starting values as y0: with y0(1:6) = [x, x', z, z', θ, θ']

    options = odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@events);                     % Options for the ODE Solver
    [t,y] = ode45(@dgl_only_gravity, tspan, y0, options);                   % Call the ODE Selver and give out the results into t and y
                                                                            % t are simply the time values
                                                                            % y(1:4) contains position and velocity in the same format as the starting values
    %% Exporting Results
    % Give the time and location data to the app Object for further usage
    % in other functions for plotting and evaluation.
    app.ODE_t = t;                                                          
    app.ODE_z = y(:,3);
    app.ODE_y = 0;
    app.ODE_x = y(:,1);

    % Calculate the Kinetic Energies and potential Energies and give it to
    % the app Object for further usage in other functions for plotting 
    % and evaluation.
    Ekin_x = 1/2 * app.BB_Mass * y(:,2) .^2;
    %Ekin_y = 0;
    Ekin_z = 1/2 * app.BB_Mass * y(:,4) .^2;
    E_pot = app.BB_Mass * g * y(:,3);
    app.ODE_Ekin = Ekin_x + Ekin_z;
    app.ODE_Epot = E_pot;
    
    app.ODE_v = sqrt(y(:,2).^2+y(:,4).^2);
    
    I = 2/5 * app.BB_Mass * (app.BB_Diameter / 2).^2;           % I = 2/5 * m * r^2
    app.ODE_Erot = 0.5 * I * y(:,6);

    app.ODE_vx = y(:,2);
    app.ODE_vy = 0;
    app.ODE_vz = y(:,4);

end

%% Differential Equations
function dy = dgl_only_gravity(t,y)
    global g cw air_density r m states wind_x_params
    
    A = pi * r^2;

    gravity = g * states(1);
    
    %% Air Resistance
    sine_01 = sin(2*pi*(t / wind_x_params(1)) + wind_x_params(2)) * wind_x_params(3) + wind_x_params(4);
    sine_02 = sin(2*pi*(t / wind_x_params(5)) + wind_x_params(6)) * wind_x_params(7) + wind_x_params(8);
    sine_03 = sin(2*pi*(t / wind_x_params(9)) + wind_x_params(10)) * wind_x_params(11) + wind_x_params(12);
    wind_speed_x = sine_01 + sine_02 + sine_03;

    relative_vel_x = y(2) + ( - wind_speed_x * states(5) );
    %relative_vel_z = y(4) + ( wind_speed_z * states(5) );

    air_resistance_x = 1/2 * cw * air_density * A * relative_vel_x^2 * sign(relative_vel_x) * -1 * states(2);
    air_resistance_z = 1/2 * cw * air_density * A * y(4)^2 * sign(y(4)) * -1 * states(2);

    %% Magnus
    total_velocity = sqrt( relative_vel_x^2 + y(4)^2 );

    %F_Magnus = (air_density * A) / 2 * y(6) * total_velocity;
    F_Magnus = 4/3 * pi * air_density * r^3 * y(6) * total_velocity;

    angle = atan2(y(4),relative_vel_x);

    magnus_x = F_Magnus * cos(angle + pi/2) * states(3);
    magnus_z = F_Magnus * sin(angle + pi/2) * states(3);
    
    %% Spin decay
    %decay = XXXX;
    
    %% Functions
    dy(1,1) = y(2);                                                         % x'  = y(2)
    dy(2,1) = air_resistance_x/m + magnus_x/m;                              % x'' = FORCES IN HORIZONTAL
    dy(3,1) = y(4);                                                         % z'  = y(4)
    dy(4,1) = - gravity + air_resistance_z/m + magnus_z/m;                  % z'' = FORCES IN VERTICAL
    dy(5,1) = y(6);                                                         % θ'  = y(6)
    dy(6,1) = 0;                                                            % θ'' = FORCES IN ROTATION
end

%% Event detection
function [value,isterminal,direction] = events(t,y)
    
    value=y(3);         % value to monitor
    isterminal = 1;     % 1: Abort solver, 0: Continue regardless of event
    direction = 0;      % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end