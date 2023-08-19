function Differential_Solver(app)
%% Variable Declarations
    % Declare Global variables to pass into the differential equations
    global g cw air_density r m
    
    % Check if Gravity is enabled for the Simulation
    if app.Bool_Gravity == true
        % Gravity is enabled
        g = app.SIM_Gravity;   
    else
        % Gravity is disabled
        g = 0;
    end

    % Alternative Gravity check

    g = app.SIM_Gravity * app.Bool_Gravity;
    cw = 0.4 * app.Bool_AirFriction;
    air_density = app.SIM_Air_Density;
    r = app.BB_Diameter/2;
    m = app.BB_Mass;

%% ODE Solver
    tspan = [0 app.tspan_end];                                              % Timespan for the Simulation starts at 0 and ends at User specified time

    x0 = 0;                                                                 % Horizontal distance from coordinate Origin is 0
    vx = app.BB_Velocity_Initial* cos(app.BB_Angle_Initial * pi/180);       % Horizontal velocity is the X component of the initial Velocity Vector
    z0 = app.BB_Height_Initial;                                             % Vertical distance from coordinate Origin is the Height of the Barrel
    vz = app.BB_Velocity_Initial * sin(app.BB_Angle_Initial * pi/180);      % Vertical velocity is the Y component of the initial Velocity Vector
    theta = 0;                                                              % Total Rotations, 0 at beginning
    omega = app.BB_Spin_Initial/60;                                         % Rotation Rate in [1/s]

    y0 = [x0 vx z0 vz theta omega];                                         % Define the starting values as y0: with y0(1:6) = [x, x', z, z', θ, θ']

    options = odeset('RelTol',1.0e-6,'Events',@events);                     % Options for the ODE Solver
    [t,y] = ode45(@dgl_only_gravity, tspan, y0, options);                   % Call the ODE Selver and give out the results into t and y
                                                                            % t are simply the time values
                                                                            % y(1:4) contains position and velocity in the same format as the starting values
%% Exporting Results
    % Give the time and location data to the app Object for further usage
    % in other functions for plotting and evaluation.
    app.ODE_t = t;                                                          
    app.ODE_y = y(:,3);
    app.ODE_x = y(:,1);

    % Calculate the Kinetic Energies and potential Energies and give it to
    % the app Object for further usage in other functions for plotting 
    % and evaluation.
    Ekin_x = 1/2 * app.BB_Mass * y(:,2) .^2;
    Ekin_y = 1/2 * app.BB_Mass * y(:,4) .^2;
    E_pot = app.BB_Mass * g * y(:,3);
    app.ODE_Ekin = Ekin_x + Ekin_y;
    app.ODE_Epot = E_pot;

end

%% Differential Equations
function dy = dgl_only_gravity(t,y)
    global g cw air_density r m
    
    A = pi * r^2;

    gravity = g;
    air_resistance_x = 1/2 * cw * air_density * A * y(2)^2 * sign(y(2)) * -1;
    air_resistance_z = 1/2 * cw * air_density * A * y(4)^2 * sign(y(4)) * -1;

    total_velocity = sqrt( y(2)^2 + y(4)^2 );
    %F_Magnus = (air_density * A) / 2 * y(6) * total_velocity;
    F_Magnus = 4/3 * pi * air_density * r^3 * y(6) * total_velocity;

    angle = atan2(y(4),y(2));

    magnus_x = F_Magnus * cos(angle + pi/2);
    magnus_z = F_Magnus * sin(angle + pi/2);
    
    dy(1,1) = y(2);                                                         % x'  = y(2)
    dy(2,1) = air_resistance_x/m + magnus_x/m;                                             % x'' = FORCES IN HORIZONTAL
    dy(3,1) = y(4);                                                         % z'  = y(4)
    dy(4,1) = - gravity + air_resistance_z/m + magnus_z/m;                                   % z'' = FORCES IN VERTICAL
    dy(5,1) = y(6);                                                         % θ'  = y(6)
    dy(6,1) = 0;                                                            % θ'' = FORCES IN ROTATION
end

%% Event detection
function [value,isterminal,direction] = events(t,y)
    
    value=y(3);         % value to monitor
    isterminal = 1;     % 1: Abort solver, 0: Continue regardless of event
    direction = 0;      % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end