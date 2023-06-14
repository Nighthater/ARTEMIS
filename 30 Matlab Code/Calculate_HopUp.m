% Calculate the Velocity of an Object depending on its Energy and Mass

function [rpm,BB_Spin_Energy] = Calculate_HopUp(BB_Velocity_Initial,BB_Diameter,BB_Hop_Up,BB_Mass)
    max_rpm = BB_Velocity_Initial / BB_Diameter * 60;
    rpm = max_rpm * BB_Hop_Up / 100;
    
    omega = rpm / 60;
    I = 2/5 * BB_Mass * (BB_Diameter / 2).^2;
    BB_Spin_Energy = 0.5 * I * omega;
end