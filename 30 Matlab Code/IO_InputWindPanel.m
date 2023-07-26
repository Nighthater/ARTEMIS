function IO_InputWindPanel(app)
    % Check Sine 01
    t = linspace(0, app.tspan_end, 2500);

    if app.SwitchSine01.Value == 1
        app.LampSine01.Color = [1.00,0.00,0.00];
        app.Spinner_PhaseAngle01.Enable = "On";
        app.Spinner_Amplitude01.Enable = "On";
        app.Spinner_Offset01.Enable = "On";
        app.Spinner_Period01.Enable = "On";
        y_sine01 = sine01(t,app);
    else
        app.LampSine01.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle01.Enable = "Off";
        app.Spinner_Amplitude01.Enable = "Off";
        app.Spinner_Offset01.Enable = "Off";
        app.Spinner_Period01.Enable = "Off";
        y_sine01 = zeros(size(t));
    end

    % Check Sine 02
    if app.SwitchSine02.Value == 1
        app.LampSine02.Color = [0.00,1.00,0.00];
        app.Spinner_PhaseAngle02.Enable = "On";
        app.Spinner_Amplitude02.Enable = "On";
        app.Spinner_Offset02.Enable = "On";
        app.Spinner_Period02.Enable = "On";
        y_sine02 = sine02(t,app);
    else
        app.LampSine02.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle02.Enable = "Off";
        app.Spinner_Amplitude02.Enable = "Off";
        app.Spinner_Offset02.Enable = "Off";
        app.Spinner_Period02.Enable = "Off";
        y_sine02 = zeros(size(t));
    end

    % Check Sine 03
    if app.SwitchSine03.Value == 1
        app.LampSine03.Color = [0.00,0.00,1.00];
        app.Spinner_PhaseAngle03.Enable = "On";
        app.Spinner_Amplitude03.Enable = "On";
        app.Spinner_Offset03.Enable = "On";
        app.Spinner_Period03.Enable = "On";
        y_sine03 = sine03(t,app);
    else
        app.LampSine03.Color = [0.65,0.65,0.65];
        app.Spinner_PhaseAngle03.Enable = "Off";
        app.Spinner_Amplitude03.Enable = "Off";
        app.Spinner_Offset03.Enable = "Off";
        app.Spinner_Period03.Enable = "Off";
        y_sine03 = zeros(size(t));
    end
    

    y_sineTotal = y_sine01 + y_sine02 + y_sine03;
    
    xlim(app.WindPlot,[0,app.tspan_end]);
    
    if min([y_sine01, y_sine02, y_sine03, y_sineTotal]) < -1 || max([y_sine01, y_sine02, y_sine03, y_sineTotal]) > 1
        ylim(app.WindPlot, [min([y_sine01, y_sine02, y_sine03, y_sineTotal]) , max([y_sine01, y_sine02, y_sine03, y_sineTotal])] );
    else
        ylim(app.WindPlot, [-1,1]);
    end
    plot(app.WindPlot, t, y_sine01 , 'r', t, y_sine02, 'g', t, y_sine03, 'b');
    hold(app.WindPlot, 'on');
    plot(app.WindPlot, t, y_sineTotal, 'w', 'LineWidth', 3);
    hold(app.WindPlot, 'off');
end

function y = sine01(t,app)
    phaseAngle = app.Spinner_PhaseAngle01.Value * pi/180;
    amplitude = app.Spinner_Amplitude01.Value;
    offset = app.Spinner_Offset01.Value;
    period = app.Spinner_Period01.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine02(t,app)
    phaseAngle = app.Spinner_PhaseAngle02.Value * pi/180;
    amplitude = app.Spinner_Amplitude02.Value;
    offset = app.Spinner_Offset02.Value;
    period = app.Spinner_Period02.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
end

function y = sine03(t,app)
    phaseAngle = app.Spinner_PhaseAngle03.Value * pi/180;
    amplitude = app.Spinner_Amplitude03.Value;
    offset = app.Spinner_Offset03.Value;
    period = app.Spinner_Period03.Value;
    y = sin(2*pi*(t / period) + phaseAngle) * amplitude + offset;
    %y = sin((t + phaseAngle) / period) * amplitude + offset;
end