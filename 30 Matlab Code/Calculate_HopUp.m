% Calculate the Velocity of an Object depending on its Energy and Mass

function [rpm,BB_Energy_Rot] = Calculate_HopUp(BB_Velocity_Initial,BB_Diameter,BB_Hop_Up)
    max_rpm = BB_Velocity_Initial / BB_Diameter;
    rpm = max_rpm * BB_Hop_Up / 100;
end