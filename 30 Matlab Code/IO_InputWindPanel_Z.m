function IO_InputWindPanel_Z(app)
     % Create time values for Plot
    t = linspace(0, app.tspan_end, 2500);
	
	% Check Sine 01
    if app.SwitchSine01_3.Value == 1
        app.LampSine01_3.Color = [1.00,0.00,0.00];
        app.Spinner_PhaseAngle01_3.Enable = "On";
        app.Spinner_Amplitude01_3.Enable = "On";
        app.Spinner_Offset01_3.Enable = "On";
        app.Spinner_Period01_3.Enable = "On";
        z_sine01 = sine01(t,app);
    else
        app.LampSine01_3.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle01_3.Enable = "Off";
        app.Spinner_Amplitude01_3.Enable = "Off";
        app.Spinner_Offset01_3.Enable = "Off";
        app.Spinner_Period01_3.Enable = "Off";
        z_sine01 = zeros(size(t));
    end

    % Check Sine 02
    if app.SwitchSine02_3.Value == 1
        app.LampSine02_3.Color = [0.00,1.00,0.00];
        app.Spinner_PhaseAngle02_3.Enable = "On";
        app.Spinner_Amplitude02_3.Enable = "On";
        app.Spinner_Offset02_3.Enable = "On";
        app.Spinner_Period02_3.Enable = "On";
        z_sine02 = sine02(t,app);
    else
        app.LampSine02_3.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle02_3.Enable = "Off";
        app.Spinner_Amplitude02_3.Enable = "Off";
        app.Spinner_Offset02_3.Enable = "Off";
        app.Spinner_Period02_3.Enable = "Off";
        z_sine02 = zeros(size(t));
    end

    % Check Sine 03
    if app.SwitchSine03_3.Value == 1
        app.LampSine03_3.Color = [0.00,0.00,1.00];
        app.Spinner_PhaseAngle03_3.Enable = "On";
        app.Spinner_Amplitude03_3.Enable = "On";
        app.Spinner_Offset03_3.Enable = "On";
        app.Spinner_Period03_3.Enable = "On";
        z_sine03 = sine03(t,app);
    else
        app.LampSine03_3.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle03_3.Enable = "Off";
        app.Spinner_Amplitude03_3.Enable = "Off";
        app.Spinner_Offset03_3.Enable = "Off";
        app.Spinner_Period03_3.Enable = "Off";
        z_sine03 = zeros(size(t));
    end
    
	% Constuct the Values out of the 3 individual sine functions
    z_sineTotal = z_sine01 + z_sine02 + z_sine03;
    
	% Adjust the X axis of the Plot window
    xlim(app.WindPlot_3,[0,app.tspan_end]);
    
	% Adjust the Y axis of the Plot Window
    if min([z_sine01, z_sine02, z_sine03, z_sineTotal]) < -1 || max([z_sine01, z_sine02, z_sine03, z_sineTotal]) > 1
        ylim(app.WindPlot_3, [min([z_sine01, z_sine02, z_sine03, z_sineTotal]) , max([z_sine01, z_sine02, z_sine03, z_sineTotal])] );
    else
        ylim(app.WindPlot_3, [-1,1]);
    end
	
	% Plot the individual Sine functions
    plot(app.WindPlot_3, t, z_sine01 , 'r', t, z_sine02, 'g', t, z_sine03, 'b');
    hold(app.WindPlot_3, 'on');
	% Plot the Combined Sine Function
    plot(app.WindPlot_3, t, z_sineTotal, 'w', 'LineWidth', 3);
    hold(app.WindPlot_3, 'off');

	% Export the Values
    tog_01 = app.SwitchSine01_3.Value;
    tog_02 = app.SwitchSine02_3.Value;
    tog_03 = app.SwitchSine03_3.Value;
    app.SIM_Wind_Z_Properties = [
        app.Spinner_Period01_3.Value
        app.Spinner_PhaseAngle01_3.Value * pi/180 
        app.Spinner_Amplitude01_3.Value
        app.Spinner_Offset01_3.Value
        
        app.Spinner_Period02_3.Value
        app.Spinner_PhaseAngle02_3.Value * pi/180 
        app.Spinner_Amplitude02_3.Value
        app.Spinner_Offset02_3.Value
        
        app.Spinner_Period03_3.Value
        app.Spinner_PhaseAngle03_3.Value * pi/180 
        app.Spinner_Amplitude03_3.Value
        app.Spinner_Offset03_3.Value
        
    ];
    app.SIM_Wind_Z_Properties(2:4) = app.SIM_Wind_Z_Properties(2:4) * tog_01;
    app.SIM_Wind_Z_Properties(6:8) = app.SIM_Wind_Z_Properties(6:8) * tog_02;
    app.SIM_Wind_Z_Properties(10:12) = app.SIM_Wind_Z_Properties(10:12) * tog_03;
end

function y = sine01(t,app)
    phaseAngle = app.Spinner_PhaseAngle01_3.Value * pi/180;
    amplitude = app.Spinner_Amplitude01_3.Value;
    offset = app.Spinner_Offset01_3.Value;
    period = app.Spinner_Period01_3.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine02(t,app)
    phaseAngle = app.Spinner_PhaseAngle02_3.Value * pi/180;
    amplitude = app.Spinner_Amplitude02_3.Value;
    offset = app.Spinner_Offset02_3.Value;
    period = app.Spinner_Period02_3.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine03(t,app)
    phaseAngle = app.Spinner_PhaseAngle03_3.Value * pi/180;
    amplitude = app.Spinner_Amplitude03_3.Value;
    offset = app.Spinner_Offset03_3.Value;
    period = app.Spinner_Period03_3.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end