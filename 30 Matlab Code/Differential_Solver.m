function [te,ye] = Differential_Solver(gravity,tspan_end)
    global g    
    g = gravity;
    % Mahlzeit wann Pause
    tspan = [0 tspan_end];
    x0 = 0; u0 = 10; z0 = 0; v0 = 10;
    y0 = [x0 u0 z0 v0];
    options = odeset('RelTol',1.0e-6);
    [te,ye] = ode45(@dgl_only_gravity, tspan, y0, options);
end


function dy = dgl_only_gravity(t,y)
    global g
    dy(1,1) = y(2);
    dy(2,1) = 0;
    dy(3,1) = y(4);
    dy(4,1) = -g;
end
