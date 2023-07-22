function IO_CalculationButtonPushed(app)
    
    app.Button_StartCalculation.Enable ="off";                              % Turn button off

    
    
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];                             % Turn Lamp Yellow, then Green, then back to Yellow
    pause(0.1);
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];
    pause(0.1);
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];
    
    
    app.tspan_end = 50;                                                     % Set Max Time to 50s
    [t,y] = Differential_Solver(app);                                       % Run Solver
    
    app.ODE_t = t;
    app.ODE_y = y(:,3);
    app.ODE_x = y(:,1);
    
    Ekin_x = 1/2 * app.BB_Mass * y(:,2) .^2;
    Ekin_y = 1/2 * app.BB_Mass * y(:,4) .^2;
    app.ODE_Ekin = Ekin_x + Ekin_y;
    app.ODE_Epot = app.BB_Mass * app.SIM_Gravity * app.ODE_y;


    plot(app.Plot2D_Trajectory,y(:,1),y(:,3),'x','LineWidth',5);            % Plot stuff
    
    area(app.Plot2D_Energy,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);
    


    
    pause(1.0);                                                             % Wait some time so it looks like the program is working really hard
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];                             % Turn Lamp Green
    pause(0.2);
    app.Button_StartCalculation.Enable ="on";                               % Turn button on
end