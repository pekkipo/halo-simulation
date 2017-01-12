function [ deltaV ] = calculate_maneuver(init_guess)

% Use either fsolve or newtonraphson
% Almost no difference. fsolve seems to be a bit faster though

    % Initial guess
    dV = init_guess;
    deltaV = fsolve(@evaluation, dV);
    %deltaV = newtonraphson(@evaluation, dV);
    disp(deltaV);
end

