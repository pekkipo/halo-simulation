clc
clear all

% DESCRIPTION
    % Main script for orbit simulation
    % Vary initial condition and number of revolutions required
    % Maneuvers are calculated automatically within the process of
    % integration and saved in a mat file afterwards
   

%% Load kernels
METAKR = 'kernels.txt';
cspice_furnsh ( METAKR );
planets_name_for_struct = {'EARTH','SUN','MOON','JUPITER','VENUS','MARS','SATURN';'EARTH','SUN',...
                           '301','5','VENUS','4','6'};

%% MAIN INTERFACE 
  
% VARIABLE PARAMETERS
    % Satellite initial position and velocity w.r.t the Earth center
    initial_state =  [-5.618445118318512e+005;  -1.023778587192635e+006;  -1.522315532439711e+005;...
                      5.343825699573794e-001;  -2.686719669693540e-001;  -1.145921728828306e-001];
    % Initial time
    initial_epoch = 958.910668311133e+006;

    % Required number of integrations
    n_integrations = 4;
    
    % These three global parameters are important. They affect a few internal
    % functions
    
    % Define the primary body 
    global observer;
    observer = 'EARTH'; % or '399'
    
    % Used force model
    global force_model;
    force_model = 'full'; % SUN EARTH MOON PLANETS SRP
    %force_model = 'simple'; % SUN EARTH MOON
    %force_model = 'simple_srp'; % SUN EARTH MOON SRP

% FIXED PARAMETERS
    global G;
    G = 6.673e-20;
    
    global L2frame;
    L2frame = true;
    
%% Integration

sat = create_sat_structure(initial_state);
orbit = [];
epochs = [];
complete = false;
init_t = initial_epoch;
init_state = initial_state;

% PARAMETERS. Do not change
% Shows the consecutive number of the maneuver applied
maneuver_number = 1;

n = 1;

deltaVs = [];
      
% These global values are passed into the evalutaion.m function
global R0;
global V0;
global start_time;
     
 while ~complete
            
     % Automatic maneuver calculation

     R0 = init_state(1:3);
     V0 = init_state(4:6);
     start_time = init_t;
     
     initial_guess = [0.0132567757055320;-0.0162165135037194;0.00404055680235709]; 
     
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      % Uncomment this if you want different initial guesses for different
%      % maneuvers. Amount of dVs should be consistent with n_integrations
%      % parameter!
%           dV1 = [ 13.2564555936480e-003;-16.2165165077280e-003;4.03554711782661e-003];
%           dV2 = [0.0182667725875410;0.0190859273702657;-0.000766113817858150];
%           dV3 = [0.00501315973604774;0.0101117482930497;0.00951736755737261];
%           dV4 = [-7.68035502635079e-003;-3.25624481701962e-003;-7.58156510220702e-003];
%           dV5 = [-0.00292609048213780;-0.00337127345260950;0.00828755056518065];
%           dV6 = [-0.002355831016669;-0.002402859984804;-0.008729136657509]; 
%           ...and so on
%      
%           initial_guesses = {dV1;dV2;dV3;dV4;dV5;dV6};
%           deltaV = calculate_maneuver(initial_guesses{n});
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % Calculate the maneuver
     deltaV = calculate_maneuver(initial_guess);
     % Add the maneuver to the array
     deltaVs = [deltaVs, deltaV];
     
     init_state(1:6) = init_state(1:6) + [0;0;0;deltaV(1);deltaV(2);deltaV(3)];
        
     % Propagate the orbit with the corresponding force model
     if strcmp(force_model,'full')
        [t, y0state, orbit_part, y0state_E] = RKV89(@full_force_model, init_t , init_state);
     elseif strcmp(force_model,'simple')
         [t, y0state, orbit_part, y0state_E] = RKV89(@simple_force_model, init_t , init_state);
     elseif strcmp(force_model,'simple_srp')
         [t, y0state, orbit_part, y0state_E] = RKV89(@simple_srp_force_model, init_t , init_state);
     end
     % OUTPUT INFO
         % t - epochs of current orbit part
         % y0state - state where y = 0 in L2 frame
         % orbit_part - positions and velocities of the sat
         % y0state_E - state where y=0 in L2 frame expressed in Earth-centered
         % coordinates
     
     orbit = [orbit, orbit_part];
     epochs = [epochs, t];
     
     % Change the values for the next orbit part integration
     init_t = t(end);
     init_state = y0state_E;
            
     maneuver_number = maneuver_number + 1;
            
     n = n+1;
     if n > n_integrations 
        complete = true; 
     end
 
 end
        
 
 % Write array with maneuvers into a data file
 save('automatic_maneuvers.mat','deltaVs');
 

%% PLOTTING
figure(1)
view(3)
grid on
hold on
plot3(0,0,0,'*r'); % nominal L2 point
plot3(orbit(1,:),orbit(2,:),orbit(3,:),'b'); % orbit
set(gca,'fontsize',16)

figure(2)
subplot(2,1,1)
view(2)
plot(0,0,'*r')
grid on
hold on
plot(orbit(1,:),orbit(2,:), 'b')
subplot(2,1,2)
view(2)
plot(0,0,'*r')
grid on
hold on
plot(orbit(2,:),orbit(3,:), 'b')

figure(3)
subplot(2,1,1)
view(2)
plot(0,0,'*r')
grid on
hold on
plot(orbit(1,:),orbit(3,:), 'b')
subplot(2,1,2)
view(2)
plot(-1495169.45429399,1062.45491122111,'*m');
grid on
hold on
plot(0,0,'*r')
plot(orbit(1,:),orbit(2,:), 'b')

%% PLOTS INFO
figure(1)
title('HALO orbit around L2 SEM.');
legend('Nominal L2 point', 'Full model','Location','northeast');
set(gca,'fontsize',16)
xlabel('X, km');
ylabel('Y, km');
zlabel('Z, km');     

figure(2)
subplot(2,1,1)
title('SEM L2 Halo, X-Y plane');
legend('L2', 'Halo orbit');
set(gca,'fontsize',16)
ylabel('Y, km');
xlabel('X, km');
subplot(2,1,2)
title('SEM L2 Halo, Y-Z plane');
legend('L2', 'Halo orbit');
set(gca,'fontsize',16)
ylabel('Z, km');
xlabel('Y, km');

figure(3)
subplot(2,1,1)
title('SEM L2 Halo, X-Z plane');
legend('L2', 'Halo orbit');
set(gca,'fontsize',16)
ylabel('Z, km');
xlabel('X, km');
subplot(2,1,2)
title('SEM L2 Halo, 3D');
legend('Earth','L2', 'Halo orbit','Location','northwest');
set(gca,'fontsize',16)
xlabel('X, km');
ylabel('Y, km');
zlabel('Z, km');
        
 
        
        