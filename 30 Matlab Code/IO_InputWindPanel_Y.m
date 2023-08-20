function IO_InputWindPanel_Y(app)
    % Check Sine 01
    t = linspace(0, app.tspan_end, 2500);

    if app.SwitchSine01_2.Value == 1
        app.LampSine01_2.Color = [1.00,0.00,0.00];
        app.Spinner_PhaseAngle01_2.Enable = "On";
        app.Spinner_Amplitude01_2.Enable = "On";
        app.Spinner_Offset01_2.Enable = "On";
        app.Spinner_Period01_2.Enable = "On";
        y_sine01 = sine01(t,app);
    else
        app.LampSine01_2.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle01_2.Enable = "Off";
        app.Spinner_Amplitude01_2.Enable = "Off";
        app.Spinner_Offset01_2.Enable = "Off";
        app.Spinner_Period01_2.Enable = "Off";
        y_sine01 = zeros(size(t));
    end

    % Check Sine 02
    if app.SwitchSine02_2.Value == 1
        app.LampSine02_2.Color = [0.00,1.00,0.00];
        app.Spinner_PhaseAngle02_2.Enable = "On";
        app.Spinner_Amplitude02_2.Enable = "On";
        app.Spinner_Offset02_2.Enable = "On";
        app.Spinner_Period02_2.Enable = "On";
        y_sine02 = sine02(t,app);
    else
        app.LampSine02_2.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle02_2.Enable = "Off";
        app.Spinner_Amplitude02_2.Enable = "Off";
        app.Spinner_Offset02_2.Enable = "Off";
        app.Spinner_Period02_2.Enable = "Off";
        y_sine02 = zeros(size(t));
    end

    % Check Sine 03
    if app.SwitchSine03_2.Value == 1
        app.LampSine03_2.Color = [0.00,0.00,1.00];
        app.Spinner_PhaseAngle03_2.Enable = "On";
        app.Spinner_Amplitude03_2.Enable = "On";
        app.Spinner_Offset03_2.Enable = "On";
        app.Spinner_Period03_2.Enable = "On";
        y_sine03 = sine03(t,app);
    else
        app.LampSine03_2.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle03_2.Enable = "Off";
        app.Spinner_Amplitude03_2.Enable = "Off";
        app.Spinner_Offset03_2.Enable = "Off";
        app.Spinner_Period03_2.Enable = "Off";
        y_sine03 = zeros(size(t));
    end
    

    y_sineTotal = y_sine01 + y_sine02 + y_sine03;
    
    xlim(app.WindPlot_2,[0,app.tspan_end]);
    
    if min([y_sine01, y_sine02, y_sine03, y_sineTotal]) < -1 || max([y_sine01, y_sine02, y_sine03, y_sineTotal]) > 1
        ylim(app.WindPlot_2, [min([y_sine01, y_sine02, y_sine03, y_sineTotal]) , max([y_sine01, y_sine02, y_sine03, y_sineTotal])] );
    else
        ylim(app.WindPlot_2, [-1,1]);
    end
    plot(app.WindPlot_2, t, y_sine01 , 'r', t, y_sine02, 'g', t, y_sine03, 'b');
    hold(app.WindPlot_2, 'on');
    plot(app.WindPlot_2, t, y_sineTotal, 'w', 'LineWidth', 3);
    hold(app.WindPlot_2, 'off');

    app.SIM_Wind_Y_Properties = [
        app.Spinner_Period01_2.Value
        app.Spinner_PhaseAngle01_2.Value * pi/180 
        app.Spinner_Amplitude01_2.Value
        app.Spinner_Offset01_2.Value
        
        app.Spinner_Period02_2.Value
        app.Spinner_PhaseAngle02_2.Value * pi/180 
        app.Spinner_Amplitude02_2.Value
        app.Spinner_Offset02_2.Value
        
        app.Spinner_Period03_2.Value
        app.Spinner_PhaseAngle03_2.Value * pi/180 
        app.Spinner_Amplitude03_2.Value
        app.Spinner_Offset03_2.Value
        
    ];
end

function y = sine01(t,app)
    phaseAngle = app.Spinner_PhaseAngle01_2.Value * pi/180;
    amplitude = app.Spinner_Amplitude01_2.Value;
    offset = app.Spinner_Offset01_2.Value;
    period = app.Spinner_Period01_2.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine02(t,app)
    phaseAngle = app.Spinner_PhaseAngle02_2.Value * pi/180;
    amplitude = app.Spinner_Amplitude02_2.Value;
    offset = app.Spinner_Offset02_2.Value;
    period = app.Spinner_Period02_2.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine03(t,app)
    phaseAngle = app.Spinner_PhaseAngle03_2.Value * pi/180;
    amplitude = app.Spinner_Amplitude03_2.Value;
    offset = app.Spinner_Offset03_2.Value;
    period = app.Spinner_Period03_2.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end