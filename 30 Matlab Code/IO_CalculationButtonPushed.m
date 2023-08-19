function IO_CalculationButtonPushed(app)
    % Call InputWindPanel just to be sure
    IO_InputWindPanel(app)

    
    app.Button_StartCalculation.Enable ="off";                              % Turn button off
    
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];                             % Turn Lamp Yellow, then Green, then back to Yellow
    pause(0.1);
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];
    pause(0.1);
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];
    
    Differential_Solver(app);                                               % Run Solver

    


    plot(app.Plot2D_Trajectory,app.ODE_x,app.ODE_y);                        % Plot stuff

    plot(app.Plot2D_Trajectory2,app.ODE_t,app.ODE_y);                        % Plot stuff

    plot(app.Plot3D_Trajectory,app.ODE_x,app.ODE_y);
    
    area(app.Plot2D_Energy,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);

    pause(1.0);                                                             % Wait some time so it looks like the program is working really hard
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];                             % Turn Lamp Green
    pause(0.2);
    app.Button_StartCalculation.Enable ="on";                               % Turn button on
end