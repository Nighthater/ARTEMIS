% Calculate the Velocity of an Object depending on its Energy and Mass

function CALC_PhysVelocity(app)
    app.BB_Velocity_Initial = sqrt(2*app.BB_Ekin_Initial/app.BB_Mass); % v = sqrt(2*E_Kin/m)
end