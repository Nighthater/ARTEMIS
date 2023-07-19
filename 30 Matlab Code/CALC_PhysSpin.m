% Calculate the Spin of an Object depending on its Speed and Hop-Up
function CALC_PhysSpin(app)
    max_rpm = app.BB_Velocity_Initial / app.BB_Diameter * 60;   % RPM = v / d * 60
    app.BB_Spin_Initial = max_rpm * app.BB_Hop_Up / 100;        % RPM_True = RPM * %
    
    omega = app.BB_Spin_Initial / 60;                           % omega (RPS) = RPM / (60s / min)
    I = 2/5 * app.BB_Mass * (app.BB_Diameter / 2).^2;           % I = 2/5 * m * r^2
    app.BB_Erot_Initial = 0.5 * I * omega;                      % E_rot = 1/2 * I * omega
end