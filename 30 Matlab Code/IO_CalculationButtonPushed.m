function IO_CalculationButtonPushed(app)
    % Confirm with Lamp Flash
    % Turn button off
    app.Button_StartCalculation.Enable ="off";
    % Funky Animation
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];
    pause(0.1);
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];
    pause(0.1);
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];
    
    
    % Actual code goes 'ere
    % ...
    % Input for Simulation
    % 
    % Initial conditions
    % q0
    % tspan
    % 
    % 
    % 
    % 
    app.tspan_end = 50;
    [te,ye] = Differential_Solver(app);
    plot(app.Plot2D_Trajectory,te,ye,'x','LineWidth',5);

    % Funky Animation
    pause(1.0);
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];
    pause(0.2);
    % Turn button on
    app.Button_StartCalculation.Enable ="on";
end