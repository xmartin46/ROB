function [x, y] = polar2cartesian_ins(data)
    [steps cols] = size(data);
    for j=2:361
        a = (j-1)/180*pi;
        x(j-1) = data(j)*cos(a);
        y(j-1) = data(j)*sin(a);
    end
end

