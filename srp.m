function solar_a = srp(type, earth, sun, sat)
% SRP solar radiation pressure
    % Simplified, considers perependicular light
    
   % https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19980201681.pdf
   % based on this, my approx value of acceleration is 1.5 e-12 km/s^2 at 
   % L2

% type = 0 - L2env paper formula
% type = 1 - Montebruck formula
% USE - 1, Montenbruck p 75, equation 3.75 . r(.) - geocentrical position of the sun

% Constants
A = 1e-6; % m2 264 1e-6 - in km2
refl = 0.8; % -
Crefl = 1+refl; % -
m = 6000; %kg
% AU would change with time, so better do this:
% AU = sqrt((earth.x - sun.x)^2 + (earth.y - sun.y)^2 + (earth.z - sun.z)^2);
% AU = 149597970691; % in km should be 149.6*10^6!
%AU = 149.6*10^6; 
AU = 149597870.691;
%AU = sqrt((earth.x - sun.x)^2 + (earth.y - sun.y)^2 + (earth.z - sun.z)^2);
%c = 299792458; % m/s
c = 299792458; % m/s
P0 = -(4.5598*(10^(-6)))*10^3; % N/m2 = kg/m*s2 -0.00455; %Actually i have to multiply by a 1000
%P0 = 4.56; % N/km^2
% 1 microN/m2 = 1 000 000 microN/km^2. (4.56 * 10^-6) N/m^2 = (4.56 *
% 10^6)*10^-6) N/km^2 = 4.56 N/km^2

%P0 = -(1367/c)*10^3;

% Pedro's version
%P0 = -(4.56*10^(3)); 

%flux = 1367/c; % provided that c is km/s -> flux kg/s3 / km s = kg/s2km 
% flux would be 0.00456 which is what i had before
% solar_a = (P0)*Crefl*(A/m)*(r_vector/r3)*(AU^2);

% GET INFO ABOUT THE sun
 r_vector = sun.coords;
 r3 = (sqrt((sun.x)^2 + (sun.y)^2 +  (sun.z)^2))^3; % With this option max deviation around 400
 
  %r_vector = sat.coords - sun.coords; % max deviation is about 8000
  %r3 = sqrt(r_vector(1)^2 + r_vector(2)^2 + r_vector(3)^2)^3;
 
 if type == 2 % Gives 362 km deviation instead if 415 with 1 type
   sp_light = 299792.458; % ch
   flux = 1367;
   fluxPressure = 1367/sp_light;
   nominalSun = 149597870.651;
   %nominalSun = sqrt(sun.x^2 + sun.y^2 + sun.z^2);
     
   sunSat = sat.coords - sun.coords;
   sunDistance = sqrt(sunSat(1)^2 + sunSat(2)^2 + sunSat(3)^2);
   
   % sunSat = sun.coords;
   % sunDistance = (sqrt((sun.x)^2 + (sun.y)^2 +  (sun.z)^2))^3; 
 
   
   % Make a unit vector for the force direction
   forceVector(1) = sunSat(1) / sunDistance;
   forceVector(2) = sunSat(2) / sunDistance;
   forceVector(3) = sunSat(3) / sunDistance;
   
   distancefactor = nominalSun / sunDistance;
   %Convert m/s^2 to km/s^2
   distancefactor = distancefactor*distancefactor; % ch
   
   mag =  Crefl * fluxPressure * A * (distancefactor/m);
   
   solar_a(1) = mag * forceVector(1);
   solar_a(2) = mag * forceVector(2);
   solar_a(3) = mag * forceVector(3);
     
 end
 
% unit_vector = [sat.vx; sat.vy; sat.vz]/(sqrt(sat.vx^2 + sat.vy^2 + sat.vz^2));

if type == 0
    solar_a = (1340*A*Crefl)/(m*c); % 1340 flux at L2 in w/m2 = kg/s3
   % solar_a = solar_a*unit_vector;
elseif type == 1
    % divide by 10^3 as P0 value in k/m*s2, while I need kilometers
    solar_a = (P0)*Crefl*(A/m)*(r_vector/r3)*(AU^2);
    % Works! Kinda..now the difference in orbits is quite big
end
end

