% Checks for toggled switches, sets the Bool Values and sets the Indicator Lamps on the Interface
function IO_ToggleFunctions(app)
    app.Bool_Gravity = app.Toggle_gravity.Value;
    app.Bool_AirFriction = app.Toggle_friction.Value;
    app.Bool_MagnusEffect = app.Toggle_magnus.Value;
    app.Bool_SpinDecay = app.Toggle_spin_decay.Value;
    app.Bool_Wind = app.Toggle_wind.Value;

    if(app.Bool_Gravity == 1)
        app.Lamp_Gravity.Color = [0.00,1.00,0.00];
        app.Spinner_gravity.Enable = "On";
    else
        app.Lamp_Gravity.Color = [0.65,0.65,0.65];
        app.Spinner_gravity.Enable = "Off";
    end

    if(app.Bool_AirFriction == 1)
        app.Lamp_AirFriction.Color = [0.00,1.00,0.00];
    else
        app.Lamp_AirFriction.Color = [0.65,0.65,0.65];
    end

    if(app.Bool_MagnusEffect == 1)
        app.Lamp_MagnusEffect.Color = [0.00,1.00,0.00];
    else
        app.Lamp_MagnusEffect.Color = [0.65,0.65,0.65];
    end

    if(app.Bool_SpinDecay == 1)
        app.Lamp_SpinDecay.Color = [0.00,1.00,0.00];
    else
        app.Lamp_SpinDecay.Color = [0.65,0.65,0.65];
    end

    if(app.Bool_Wind == 1)
        app.Lamp_Wind.Color = [0.00,1.00,0.00];
    else
        app.Lamp_Wind.Color = [0.65,0.65,0.65];
    end
end
