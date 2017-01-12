function [Earth, Sun, Moon, Jupiter, Venus, Mars, Saturn] = create_structure( bodies, t, observer)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global G;
global L2frame;

aberration = 'NONE';

% if L2frame
%     xform = cspice_sxform('J2000','L2CENTERED', t); % 6x6xN - N dims in t, here is 1
% end

    for pl=1:length(bodies) 
    
    field1 = 'name';  value1 = bodies{1,pl};
    field2 = 'x';  value2 = [];
    field3 = 'y';  value3 = [];
    field4 = 'z';  value4 = [];
    field5 = 'vx';  value5 = [];
    field6 = 'vy';  value6 = [];
    field7 = 'vz';  value7 = [];
    field8 = 'mass'; value8 = [];
    field9 = 'GM'; value9 = [];
    field10 = 'coords'; value10 = [];
        if pl == 1
        Earth = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Earth.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Earth.mass = (Earth.GM)/G;
        
        Earth_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%         if L2frame == true
%              Earth_coords = xform*Earth_coords;
%         end
        Earth.x = Earth_coords(1);
        Earth.y = Earth_coords(2);
        Earth.z = Earth_coords(3);
        Earth.vx = Earth_coords(4);
        Earth.vy = Earth_coords(5);
        Earth.vz = Earth_coords(6);
        Earth.coords = Earth_coords(1:3);
        elseif pl == 2
        Sun = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Sun.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Sun.mass = (Sun.GM)/G;  
        
        Sun_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Sun_coords = xform*Sun_coords;
%         end
        Sun.x = Sun_coords(1);
        Sun.y = Sun_coords(2);
        Sun.z = Sun_coords(3);
        Sun.vx = Sun_coords(4);
        Sun.vy = Sun_coords(5);
        Sun.vz = Sun_coords(6);
        Sun.coords = Sun_coords(1:3);
        elseif pl == 3
        Moon = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Moon.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Moon.mass = (Moon.GM)/G;
        Moon_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Moon_coords = xform*Moon_coords;
%         end
        Moon.x = Moon_coords(1);
        Moon.y = Moon_coords(2);
        Moon.z = Moon_coords(3);
        Moon.vx = Moon_coords(4);
        Moon.vy = Moon_coords(5);
        Moon.vz = Moon_coords(6);
        Moon.coords = Moon_coords(1:3);
        elseif pl == 4
        Jupiter = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Jupiter.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Jupiter.mass = (Jupiter.GM)/G;
        Jupiter_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Jupiter_coords = xform*Jupiter_coords;
%         end
        Jupiter.x = Jupiter_coords(1);
        Jupiter.y = Jupiter_coords(2);
        Jupiter.z = Jupiter_coords(3);
        Jupiter.vx = Jupiter_coords(4);
        Jupiter.vy = Jupiter_coords(5);
        Jupiter.vz = Jupiter_coords(6);
        Jupiter.coords = Jupiter_coords(1:3);
        elseif pl == 5
        Venus = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Venus.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Venus.mass = (Venus.GM)/G;
        Venus_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Venus_coords = xform*Venus_coords;
%         end
        Venus.x = Venus_coords(1);
        Venus.y = Venus_coords(2);
        Venus.z = Venus_coords(3);
        Venus.vx = Venus_coords(4);
        Venus.vy = Venus_coords(5);
        Venus.vz = Venus_coords(6);
        Venus.coords = Venus_coords(1:3);
        elseif pl == 6
        Mars = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Mars.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Mars.mass = (Mars.GM)/G;
        Mars_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Mars_coords = xform*Mars_coords;
%         end
        Mars.x = Mars_coords(1);
        Mars.y = Mars_coords(2);
        Mars.z = Mars_coords(3);
        Mars.vx = Mars_coords(4);
        Mars.vy = Mars_coords(5);
        Mars.vz = Mars_coords(6);
        Mars.coords = Mars_coords(1:3);
        elseif pl == 7
        Saturn = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,value8,field9,value9,field10,value10);
        Saturn.GM = cspice_bodvrd( bodies{2,pl}, 'GM', 1 );
        Saturn.mass = (Saturn.GM)/G;
        Saturn_coords = cspice_spkezr ( bodies{2,pl}, t, 'J2000', aberration, observer );
%          if L2frame == true
%              Saturn_coords = xform*Saturn_coords;
%         end
        Saturn.x = Saturn_coords(1);
        Saturn.y = Saturn_coords(2);
        Saturn.z = Saturn_coords(3);
        Saturn.vx = Saturn_coords(4);
        Saturn.vy = Saturn_coords(5);
        Saturn.vz = Saturn_coords(6);
        Saturn.coords = Saturn_coords(1:3);
        end
    end

end