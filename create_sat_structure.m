function sat = create_sat_structure( coords )
%UNTITLED3 Summary of this function goes here
%   Gets coordinates and velocities as an input
%   In script gets orbit.y 
%   In force_model_function get y0 as an input

coords = coords(1:6);

        field1 = 'name'; value1 = 'Satellite';
        field2 = 'x'; value2 = coords(1);
        field3 = 'y'; value3 = coords(2);
        field4 = 'z'; value4 = coords(3);
        field5 = 'vx'; value5 = coords(4);
        field6 = 'vy'; value6 = coords(5);
        field7 = 'vz'; value7 = coords(6);
        field8 = 'mass'; value8 = 6000;
        field9 = 'GM'; value9 = 0;
        field10 = 'coords'; value10 = [coords(1);coords(2);coords(3)];
        sat = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6, field7,value7, field8,value8, field9,value9, field10,value10);

end

