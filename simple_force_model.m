function yp = simple_force_model( t,y0 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global observer;
%observer = '399';%'EARTH';

%Use this for all bodies in solar system
planets = {'EARTH','SUN','MOON','JUPITER','VENUS','MARS','SATURN';'EARTH','SUN','301','5','VENUS','4','6'};

 % bodies - vector of structures
 % Create a structure for the satellite
sat = create_sat_structure(y0);

% Use this for all bodies in solar system
[earth, sun, moon, jupiter, venus, mars, saturn] = create_structure( planets, t, observer);

% spacecraft position and velocity
%Phi0 = reshape(y0(7:end), 6, 6);
 
%% Accelerations due to:

% GRAVITY

% y0 - satellite, rows: x y z vx vy vz
% Radiuses between the body and the satellite
R_earth = sqrt((sat.x - earth.x)^2 + (sat.y - earth.y)^2 +  (sat.z - earth.z)^2);
R_sun = sqrt((sun.x - sat.x)^2 + (sun.y - sat.y)^2 +  (sun.z - sat.z)^2);
R_moon = sqrt((moon.x - sat.x)^2 + (moon.y - sat.y)^2 +  (moon.z - sat.z)^2);

% Radiuses between celestial bodies
R_earth_sun = sqrt((sun.x - earth.x)^2 + (sun.y - earth.y)^2 +  (sun.z - earth.z)^2);
R_earth_moon = sqrt((moon.x - earth.x)^2 + (moon.y - earth.y)^2 +  (moon.z - earth.z)^2);

% Earth is a primary body here
earth_influence = -(earth.GM*(sat.coords - earth.coords))/((R_earth)^3);
sun_influence = (sun.GM*(((sun.coords - sat.coords)/R_sun^3) -  ((sun.coords - earth.coords)/R_earth_sun^3)));
moon_influence = (moon.GM*(((moon.coords - sat.coords)/R_moon^3) -  ((moon.coords - earth.coords)/R_earth_moon^3)));

a_earth_sat =  earth_influence + sun_influence + moon_influence;

global influence;

influence(:,1) = a_earth_sat;

total_a = a_earth_sat;



% create derivative vector
v3 = [y0(4);y0(5);y0(6)];
yp = [v3; total_a];

end
