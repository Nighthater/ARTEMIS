function [v] = Calculate_Velocity(BB_Energy_Initial,BB_Mass)
    v = sqrt(2*BB_Energy_Initial/BB_Mass);
end