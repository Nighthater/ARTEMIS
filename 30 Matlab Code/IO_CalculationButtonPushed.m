function IO_CalculationButtonPushed(app)
    % Call InputWindPanel just to be sure
    IO_InputWindPanel(app);
	IO_InputWindPanel_Y(app);
    IO_InputWindPanel_Z(app);

    
    app.Button_StartCalculation.Enable ="off";                              % Turn button off
    
    app.Lamp_Feedback.Color = [1.00,1.00,0.00];                             % Turn Lamp Yellow
    pause(0.1);
    
    if app.Bool_2D3D == 1
        Differential_Solver(app);                                               % Run the Solver

        plot(app.Plot2D_xz,app.ODE_x,app.ODE_z);                                % x-z Plot
        plot(app.Plot2D_tz,app.ODE_t,app.ODE_z);                                % z-t Plot   
        plot(app.Plot2D_tv,app.ODE_t,app.ODE_v);                                % v-t Plot  
        area(app.Plot2D_tE1,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);             % Energy Plot (Kinetic & Potential)
    
        plot3(app.Plot3D_Trajectory,app.ODE_x,app.ODE_y,app.ODE_z);             % x-y-z 3D-plot 
        axis(app.Plot3D_Trajectory, 'equal');									% Set the Axis distances equal
        
        area(app.Plot2D_tE2,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);             % Energy Plot (Kinetic & Potential)
        plot(app.Plot2D_tEkin,app.ODE_t,app.ODE_Ekin);                          % Kinetic Energy Plot
        plot(app.Plot2D_tEpot,app.ODE_t,app.ODE_Epot);                          % Potential Energy Plot
        plot(app.Plot2D_tErot,app.ODE_t,app.ODE_Erot);                          % Rotational Energy Plot
    
        plot(app.Plot2D_tv2,app.ODE_t,app.ODE_v);                               % v-t Plot 
        plot(app.Plot2D_tvx,app.ODE_t,app.ODE_vx);                              % vx-t Plot
        plot(app.Plot2D_tvy,app.ODE_t,app.ODE_vy);                              % vy-t Plot
        plot(app.Plot2D_tvz,app.ODE_t,app.ODE_vz);                              % vz-t Plot
    
        plot(app.Plot2D_tx,app.ODE_t,app.ODE_x);                                % x-t Plot
        plot(app.Plot2D_ty,app.ODE_t,app.ODE_y);                                % y-t Plot
        plot(app.Plot2D_tz2,app.ODE_t,app.ODE_z);                               % z-t Plot
    else
        Differential_Solver_2D(app);                                               % Run the Solver

        plot(app.Plot2D_xz,app.ODE_x,app.ODE_z);                                % x-z Plot
        plot(app.Plot2D_tz,app.ODE_t,app.ODE_z);                                % z-t Plot   
        plot(app.Plot2D_tv,app.ODE_t,app.ODE_v);                                % v-t Plot  
        area(app.Plot2D_tE1,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);             % Energy Plot (Kinetic & Potential)
    
        plot3(app.Plot3D_Trajectory,app.ODE_x,(app.ODE_x-app.ODE_x),app.ODE_z); % x-z 3D-plot 
        axis(app.Plot3D_Trajectory, 'equal');									% Set the Axis distances equal
        
        
        area(app.Plot2D_tE2,app.ODE_t,[app.ODE_Ekin,app.ODE_Epot]);             % Energy Plot (Kinetic & Potential)
        plot(app.Plot2D_tEkin,app.ODE_t,app.ODE_Ekin);                          % Kinetic Energy Plot
        plot(app.Plot2D_tEpot,app.ODE_t,app.ODE_Epot);                          % Potential Energy Plot
        plot(app.Plot2D_tErot,app.ODE_t,app.ODE_Erot);                          % Rotational Energy Plot
    
        plot(app.Plot2D_tv2,app.ODE_t,app.ODE_v);                               % v-t Plot 
        plot(app.Plot2D_tvx,app.ODE_t,app.ODE_vx);                              % vx-t Plot
        plot(app.Plot2D_tvy,[0,app.tspan_end],[0 0]);                               % vy-t Plot 
        plot(app.Plot2D_tvz,app.ODE_t,app.ODE_vz);                              % vz-t Plot
    
        plot(app.Plot2D_tx,app.ODE_t,app.ODE_x);                                % x-t Plot
        plot(app.Plot2D_ty,[0, app.tspan_end],[0 0]);                           % y-t Plot
        plot(app.Plot2D_tz2,app.ODE_t,app.ODE_z);                               % z-t Plot
    end


    pause(0.2);                                                             % Wait some time so it looks like the program is working really hard
    app.Lamp_Feedback.Color = [0.00,1.00,0.00];                             % Turn Lamp Green
    
    app.Button_StartCalculation.Enable ="on";                               % Turn button back on
end