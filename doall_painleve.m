% Painleve paradox case.

% Rod's properties.
rod_length = 0.2;
half_length = rod_length/2;
m = 0.1;
g = 9.81;
I = m * rod_length * rod_length / 12.0;
mu = 1.5;  % > 4/3


% Initial conditions (satisfying contraint vn=0 at t=0).
theta0 = -20 / 180 * pi;
w0 = -1.5 * (2 * pi);
vx0 = 2.0;
vy0 = -rod_length/2*w0*cos(-theta0); % Notice w0 has the sign of phi (negative)
y0 = rod_length/2*sin(-theta0);


% Prameters defined in SJ Hogan 2017.
omega = sqrt(g/half_length);  % Angular velocity reference scale.
alpha = 3;
theta1 = atan(0.5*(mu*alpha-sqrt((mu*alpha)^2-4*(1+alpha))))
P = [theta1, csc(theta1)]
phi = -w0/omega % dimensionless angular velocity
theta = -theta0

% Solver parameters.
stiction_tolerance = 1.0e-4;
relative_tolerance = 1e-6; %INVESTIGATE!: Some convergence issues observed for small time step (1e-5) and tole=1e-3 at the singularity in fn.
FB_lambda = 1.0;

% Time stepping.
h = 1.0e-3;
sim_time = 0.3;

% Define the geometry for the rod
nc_max = 2;
p_BoC = zeros(2, nc_max);
p_BoC(:, 1) = [-rod_length; 0]/2;
p_BoC(:, 2) = [rod_length; 0]/2;
rod = @() p_BoC;

% Save parameters into a struct
params.m = m;
params.I = I;
params.g = g;
params.stiction_tolerance = stiction_tolerance;
params.relative_tolerance = relative_tolerance;
params.FB_lambda = FB_lambda;
params.mu = mu;
params.h = h;
params.geometry = rod;

[tt, xx, fn, ft, vn, vt, vn_err, vt_err] = run_discrete_dynamics([0; y0; theta0; vx0; vy0; w0], sim_time, params);

psi=-xx(:,3);
w = -xx(:,6);
a = 1/m*(1+3*cos(psi).*(cos(psi)-mu*sin(psi)));
b = g*(half_length*w.*w./g.*sin(psi)-1);