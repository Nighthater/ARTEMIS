function Differential_Solver(app)
    global g
    if app.Bool_Gravity == true
        g = app.SIM_Gravity;
    else
        g = 0;
    end
    tspan = [0 app.tspan_end];
    x0 = 0;
    vx = app.BB_Velocity_Initial* cos(app.BB_Angle_Initial * pi/180);                                           %Sine
    z0 = app.BB_Height_Initial;
    vz = app.BB_Velocity_Initial * sin(app.BB_Angle_Initial * pi/180);                                           %Cosine
    y0 = [x0 vx z0 vz];
    options = odeset('RelTol',1.0e-6,'Events',@events);
    [t,y] = ode45(@dgl_only_gravity, tspan, y0, options);
    
    app.ODE_t = t;
    app.ODE_y = y(:,3);
    app.ODE_x = y(:,1);

    Ekin_x = 1/2 * app.BB_Mass * y(:,2) .^2;
    Ekin_y = 1/2 * app.BB_Mass * y(:,4) .^2;
    E_pot = app.BB_Mass * g * y(:,3);

    app.ODE_Ekin = Ekin_x + Ekin_y;
    app.ODE_Epot = E_pot;

end


function dy = dgl_only_gravity(t,y)
    global g
    dy(1,1) = y(2);
    dy(2,1) = 0;
    dy(3,1) = y(4);
    dy(4,1) = -g; %a<d<aod<ad  %% <-God i wish i knew what i typed there...
end

function [value,isterminal,direction] = events(t,y)
    % Eventdetection
    value=y(3);
    isterminal = 1; % 1: Abort solver, 0: Continue regardless of event
    direction = 0; % -1: Only if Derivative is negative, 1: Only if Derivative is Positive, 0: Detect all events
end