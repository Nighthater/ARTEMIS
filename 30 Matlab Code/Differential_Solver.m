function Differential_Solver(app)
%% Variable Declarations
    % Declare Global variables to pass into the differential equations
    global g
    
    % Check if Gravity is enabled for the Simulation
    if app.Bool_Gravity == true
        % Gravity is enabled
        g = app.SIM_Gravity;   
    else
        % Gravity is disabled
        g = 0;
    end

%% ODE Solver
    tspan = [0 app.tspan_end];                                              % Timespan for the Simulation starts at 0 and ends at User specified time
    x0 = 0;                                                                 % Horizontal distance from coordinate Origin is 0
    vx = app.BB_Velocity_Initial* cos(app.BB_Angle_Initial * pi/180);       % Horizontal velocity is the X component of the initial Velocity Vector
    z0 = app.BB_Height_Initial;                                             % Vertical distance from coordinate Origin is the Height of the Barrel
    vz = app.BB_Velocity_Initial * sin(app.BB_Angle_Initial * pi/180);      % Vertical velocity is the Y component of the initial Velocity Vector
    y0 = [x0 vx z0 vz];                                                     % Define the starting values as y0(1) to y0(4) y0(1:4) = [x, x', z, z']

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
    global g
    dy(1,1) = y(2);
    dy(2,1) = 0;
    dy(3,1) = y(4);
    dy(4,1) = -g;
end

%% Event detection
function [value,isterminal,direction] = events(t,y)
    
    value=y(3);         % value to monitor
    isterminal = 1;     % 1: Abort solver, 0: Continue regardless of event
    direction = 0;      % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end