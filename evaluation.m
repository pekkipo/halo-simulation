function [ystar] = evaluation(dV)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

global R0;
global V0;
global start_time;

global force_model;

init_state = [R0; V0+dV];

if strcmp(force_model,'full')
   [t, y0state] = RKV89(@full_force_model, start_time, init_state);
elseif strcmp(force_model,'simple')
   [t, y0state] = RKV89(@simple_force_model, start_time, init_state);
elseif strcmp(force_model,'simple_srp')
   [t, y0state] = RKV89(@simple_srp_force_model, start_time, init_state);
end

    ystar = [y0state(4);y0state(6)];

    disp(ystar);

end

