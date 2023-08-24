clear all

v = linspace(0,300,300);

r = 0.006 / 2;      % m
air_density = 1.29;
spin = 5000/60 * 2 * pi; % 5000 rpm
A = r^2 * pi;

F_M1 = 4/3 * pi * air_density * r^3 * spin * v;

S = (r * spin)./v;
C_L = S * 0.4 * 2;
F_M2 = 0.5 * C_L * air_density * A .* v .* v;


plot(v, F_M1, v, F_M2);
legend('Physikerforum', 'Alan M. Nathan');
xlabel('velocity [m/s]');
ylabel('Magnus force [N]');