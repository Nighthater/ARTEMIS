% Calculate the Energy of an Object depending on its Velocity and Mass

function CALC_PhysEnergy(app)
    app.BB_Ekin_Initial = 1/2 * app.BB_Mass * app.BB_Velocity_Initial^2;    % E_kin = 1/2 * m * v^2
end