% Calculate the Spin of an Object depending on its Speed and Hop-Up
function CALC_PhysSpin(app)
    max_rpm = app.BB_Velocity_Initial / app.BB_Diameter * 60;
    app.BB_Spin_Initial = max_rpm * app.BB_Hop_Up / 100;
    
    omega = app.BB_Spin_Initial / 60;
    I = 2/5 * app.BB_Mass * (app.BB_Diameter / 2).^2;
    app.BB_Erot_Initial = 0.5 * I * omega;
end