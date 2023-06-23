function IO_InputValues(app)
    % Transfer the GUI Input fields into variables
    app.BB_Ekin_Initial = app.Spinner_energy.Value;         % [J]
    app.BB_Mass = app.Spinner_mass.Value/1000;              % [kg]
    app.BB_Diameter = app.Spinner_diameter.Value/1000;      % [m]
    
    app.BB_Angle_Initial = app.Spinner_angle.Value;         % [°]
    app.BB_Height_Initial = app.Spinner_height.Value;          % [m]
    
    app.SIM_Gravity = app.Spinner_gravity.Value;            % [m/s²]
    app.SIM_Air_Density = app.Spinner_air_density.Value;    % [kg/m³]
    
    
    app.BB_Hop_Up = app.Knob_hopUp.Value;                   % [%]
    
    % Calculate initial conditions
    Calculate_Velocity(app);
    Calculate_HopUp(app);

    % Update Output fields for Initial conditions
    app.Output_velocity.Value = app.BB_Velocity_Initial;
    app.Output_Spin.Value = app.BB_Spin_Initial;

    app.Gauge_angle.Value = app.BB_Angle_Initial;
    app.Gauge_velocity.Value = app.BB_Velocity_Initial;
    app.Gauge_energy.Value = app.BB_Ekin_Initial;
end