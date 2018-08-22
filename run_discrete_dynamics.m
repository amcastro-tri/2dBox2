function [tt, xx, fn, ft, vn, vt, vn_err, vt_err] = run_discrete_dynamics(x0, sim_time, params)

h = params.h;
nc_max = size(params.geometry(), 2);

nsteps = ceil(sim_time/h);
xx = zeros(nsteps, 6);
fn = zeros(nsteps, nc_max);
ft = zeros(nsteps, nc_max);
tt = zeros(nsteps, 1);
vn = zeros(nsteps, nc_max);
vt = zeros(nsteps, nc_max);
xp = zeros(nsteps, nc_max);
vn_err = zeros(nsteps, 1);
vt_err = zeros(nsteps, 1);
for it=1:nsteps
    tt(it) = it * h;
    [x, fn(it,:), ft(it,:), vn(it,:), vt(it,:), xp(it,:), vn_err(it), vt_err(it)] = box_discrete_update(it, x0, params);   
    
    xx(it, :) = x;
    x0 = x;
end