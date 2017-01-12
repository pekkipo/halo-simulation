
METAKR = which('planetsorbitskernels.txt');
cspice_furnsh ( METAKR );

% Set initial state
R0 = [1441893.99780414;-714789.877498610;-698421.856243787];
V0 = [-0.00181347353676022;-0.00775519839178187;-0.00267104564885495];
init_epoch = 9.982928485909765e+08;

final_epoch = 10000.140558185330e+006;


init_state = [R0; V0];


global G;
G = 6.673e-20;
global L2frame;
L2frame = true;
global checkrkv89_emb
checkrkv89_emb = false;
global rkv89emb_lastpiece;
rkv89emb_lastpiece = false;
global RKV_89_emb_check
RKV_89_emb_check = false;
global ODE87_check;
ODE87_check = false;


% Initial guess
dV = [-0.00234439794209358;-0.00239804821203765;-0.00874185935583752];

deltaV = fsolve(@evaluate_V_test, dV);
 
 disp(deltaV);
 Init_state = init_state;
 Init_state(4:6,:) = Init_state(4:6,:)+ deltaV;

% choose integrator - ONE
rkv_89emb = true;
rkv_89 = false;
ode_45 = false;
ode_113 = false;
ode_87 = false;
abm_8 = false;

% CHECK THE FORCE MODEL USED

%% RKV89
if rkv_89emb 
[t, y0state, output_state, y0state_E] = simple_rkv89emb_maneuvers(@simplified_force_model, init_epoch , Init_state);
end
%% ODE87
if ode_87
    [t, y0state, output_state, y0state_E] = full_ode87(@full_force_model, [init_epoch final_epoch] , Init_state);
end

%% ODE45
if ode_45
 options = odeset('Events',@event_handler, 'MaxStep', 2700, 'InitialStep', 60);
 solution = ode45(@full_force_model,[init_epoch final_epoch],Init_state,options);
 epochs = solution.x;
 orbit = solution.y;
 output_state = EcenToL2frame( orbit, epochs );
end

if ode_113
 options = odeset('Events',@event_handler, 'MaxStep', 2700, 'InitialStep', 60);
 solution = ode113(@full_force_model,[init_epoch final_epoch],Init_state,options);
 epochs = solution.x;
 orbit = solution.y;
 output_state = EcenToL2frame( orbit, epochs );
end

% Graphical check of the orbit part
figure
hold on
plot3(output_state(1,:),output_state(2,:),output_state(3,:),'r','LineWidth',2)

