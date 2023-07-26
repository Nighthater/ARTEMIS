function IO_InputValues(app)
    % Transfer the GUI Input fields into variables
    app.BB_Mass = app.Spinner_mass.Value/1000;              % [kg]
    app.BB_Diameter = app.Spinner_diameter.Value/1000;      % [m]
    
    app.BB_Angle_Initial = app.Spinner_angle.Value;         % [°]
    app.BB_Height_Initial = app.Spinner_height.Value;       % [m]
    
    app.SIM_Gravity = app.Spinner_gravity.Value;            % [m/s²]
    app.SIM_Air_Density = app.Spinner_air_density.Value;    % [kg/m³]
    app.tspan_end = app.Spinner_tspan.Value;
    
    app.BB_Hop_Up = app.Knob_hopUp.Value;                   % [%]

    %Calculate v or Ekin depending if either is given as Input
    if app.Toggle_Ekin_v.Value == "v"                                       % Velocity is given
        app.Spinner_energy.Enable = "Off";
        app.Spinner_velocity.Enable = "On";
        app.BB_Velocity_Initial = app.Spinner_velocity.Value;               % [v]
        CALC_PhysEnergy(app);
        app.Spinner_energy.Value = app.BB_Ekin_Initial;                     % Update the Disabled Field
    else                                                                    % Energy is given
        app.Spinner_energy.Enable = "On";
        app.Spinner_velocity.Enable = "Off";
        app.BB_Ekin_Initial = app.Spinner_energy.Value;                     % [J]
        CALC_PhysVelocity(app);
        app.Spinner_velocity.Value = app.BB_Velocity_Initial;               % Update the Disabled Field

    end
    
    % Calculate initial conditions (Spin Velocity and Spin Energy at t=0)
    CALC_PhysSpin(app);

    % Update Output fields for Initial conditions
    app.Output_velocity.Value = app.BB_Velocity_Initial;
    app.Output_Spin.Value = app.BB_Spin_Initial;

    % Update Output Gauges for Initial conditions
    app.Gauge_angle.Value = app.BB_Angle_Initial;
    app.Gauge_velocity.Value = app.BB_Velocity_Initial;
    app.Gauge_energy.Value = app.BB_Ekin_Initial;
end
