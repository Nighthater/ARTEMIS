function [t,y] = Differential_Solver(app)
    global g
    g = app.SIM_Gravity;
    tspan = [0 app.tspan_end];
    x0 = 0; vx = 5; z0 = 10; v0 = 10;
    y0 = [x0 vx z0 v0];
    options = odeset('RelTol',1.0e-6,'Events',@events);
    [t,y] = ode45(@dgl_only_gravity, tspan, y0, options);
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