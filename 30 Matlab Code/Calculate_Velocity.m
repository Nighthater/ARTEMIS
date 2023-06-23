% Calculate the Velocity of an Object depending on its Energy and Mass

function Calculate_Velocity(app)
    app.BB_Velocity_Initial = sqrt(2*app.BB_Ekin_Initial/app.BB_Mass);
end