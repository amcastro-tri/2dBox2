lengths = [0.05, 0.1];
m = 0.1;
g = 9.81;
I = m * (lengths(1)^2 + lengths(2)^2)/12.0;
stiction_tolerance = 1.0e-5;
relative_tolerance = 1e-3;
mu = 0.5;
y0 = 0.3;
vx0 = -1.0;
vy0 = 0.0;
w0 = 0.0;
sim_time = 2.0;
h = 1.0e-3;

penetration_allowance = 1.0e-3;

% Estimate contact stiffness/damping
damping_ratio = 1.0;
k = m*g/penetration_allowance;
omega = sqrt(k/m);
time_scale = 1.0/omega
d = damping_ratio * time_scale / penetration_allowance;

% Save parameters into a struct
params.lengths = lengths;
params.m = m;
params.I = I;
params.g = g;
params.stiction_tolerance = stiction_tolerance;
params.relative_tolerance = relative_tolerance;
params.k = k;
params.d = d;
params.mu = mu;
params.h = h;

x0 = [0; y0; 0; 
      vx0; vy0; w0];

nsteps = ceil(sim_time/h);
xx = zeros(nsteps, 6);
fn = zeros(nsteps, 4);
ft = zeros(nsteps, 4);
tt = zeros(nsteps, 1);
vn = zeros(nsteps, 4);
vt = zeros(nsteps, 4);
xp = zeros(nsteps, 4);
vn_err = zeros(nsteps, 1);
vt_err = zeros(nsteps, 1);
for it=1:nsteps
    tt(it) = it * h;
    [x, fn(it,:), ft(it,:), vn(it,:), vt(it,:), xp(it,:), vn_err(it), vt_err(it)] = box_discrete_update(it, x0, params);
    
%     if (any(fn(it,:) > 0))
%         fn(it,:)
%         ft(it,:)
%         
%         error('Contact at step: %d\n', it);
%     end
    
    xx(it, :) = x;
    x0 = x;
end
