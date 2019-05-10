function [outX, outY] = polar2cartesian(data)
    [steps cols] = size(data);
    for i=1:steps
        for j=2:361
            a = (j-1)/180*pi;
            outX(i, j-1) = data(i, j)*cos(a);
            outY(i, j-1) = data(i, j)*sin(a);
        end
    end
end

