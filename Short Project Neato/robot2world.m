function [xs_out, ys_out] = robot2world(data_x, data_y, xs, ys, thetas)
    [steps cols] = size(data_x);
    for i=1:steps
%         RF = transl(xs(1,i),ys(1,i),0);
        for j=1:360
            RF = transl(xs(1,i),ys(1,i),0)*trotz(mod(thetas(1,i)+pi/2,2*pi));
            point = [data_x(i, j) data_y(i, j) 0];
            point = h2e(RF*e2h(point'));
            xs_out(i, j) = point(1);
            ys_out(i, j) = point(2);
        end
    end
end