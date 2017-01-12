function [ desired_t_for_maneuver, state_at_desired_t , state_Earth] = find_T_foryzero( initials, init_state, ytol )
%FIND CLOSEST TO Y=0 point 
%   Uses binary search 
        
        global force_model;
        
        found = false;
        int_step = 0.1;

        initials = initials(1):int_step:initials(length(initials));
        desired_t_for_maneuver = 0;
        state_at_desired_t = zeros(6,1);
        yvalue = 0; 

        while ~found
            if strcmp(force_model,'full')
            [ti, oiE] = ode45(@full_force_model, initials, init_state);
            elseif strcmp(force_model,'simple')
            [ti, oiE] = ode45(@simple_force_model, initials, init_state);
            elseif strcmp(force_model,'simple_srp')
            [ti, oiE] = ode45(@simple_srp_force_model, initials, init_state);
            end
            %[ti, oiE] = ode45(@full_force_model, initials, init_state);  
            ti = ti';
            oiE = oiE';
            oiE = [oiE;ti];
            oi = zeros(7,length(ti)); 
            L2_points = cspice_spkezr('392', ti, 'J2000', 'NONE', '399');           
            oiEminusL2 = oiE;
            oiEminusL2(1:6,:) = oiE(1:6,:) - L2_points;
            
            % Convert to L2centered
            xform = cspice_sxform('J2000','L2CENTERED', ti);
            for g = 1:length(ti) 
                oi(1:6,g) = xform(:,:,g)*oiEminusL2(1:6,g);
                oi(7,g) = ti(g);
            end
           
            % Check from which side we approach zero. Check the first value
            syms negative_positive;
            if oi(2,1) < 0
               negative_positive = true;
            else 
               negative_positive = false;
            end
            
            center_epoch = floor(length(ti)/2); 
            center_state = oi(1:6,center_epoch);
            center_stateE = oiE(1:6,center_epoch);
            ycenter = oi(2,center_epoch);
            center_t = oi(7,center_epoch);

            if negative_positive == true
                % Goes from negative to positive
                if ycenter >= yvalue 
                    initials = [initials(1) center_t]; 
                end

                if ycenter < yvalue 
                    initials = [center_t initials(length(initials))]; 
                    init_state = center_stateE;
                end
                
            else
                % Goes from positive to negative
                if ycenter >= yvalue 
                    initials = [center_t initials(length(initials))]; 
                    init_state = center_stateE; 
                end

                if ycenter < yvalue 
                    initials = [initials(1) center_t]; 
                end
            
            end
             left_border = yvalue - ytol;
             right_border = yvalue + ytol;
             
             if ycenter <= right_border && ycenter >= left_border 
                 [closest_value, N] = min((abs(oi(2,:))));
                 desired_t_for_maneuver = oi(7,N);
                 state_at_desired_t = oi(1:6,N);
                 state_Earth = oiE(1:6,N);
                 disp(closest_value);
                 found = true;       
             end
            
        end
end



