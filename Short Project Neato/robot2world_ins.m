function [xs, ys] = robot2world_ins(data_x, data_y, x_ini, y_ini, theta_ini)
    [steps cols] = size(data_x);
    for j=1:360
        RF = transl(x_ini,y_ini,0)*trotz(mod(theta_ini,2*pi));
        point = [data_x(j) data_y(j) 0];
        point = h2e(RF*e2h(point'));
        xs(j) = point(1);
        ys(j) = point(2);
    end
end