function [ xs, ys, thetas ] = pose_integration( x_ini, y_ini, theta_ini, wheel_l, wheel_r, width)
    steps = size(wheel_l);
    xs(1) = x_ini;
    ys(1) = y_ini;
    thetas(1) = theta_ini;
    for i=2:steps
        L = (wheel_l(i)-wheel_l(i-1));
        R = (wheel_r(i)-wheel_r(i-1));
        S = width/2;
        
        delta_th = (R-L)/(2*S);
        delta_d = (R+L)/2;
        V = [delta_d^2       0;
             0          delta_th^2];
        
%         xs(i) = xs(i-1) + (delta_d + V(1,1))*cos(thetas(i-1) + delta_th + V(2,2));
%         ys(i) = ys(i-1) + (delta_d + V(1,1))*sin(thetas(i-1) + delta_th + V(2,2));
%         
%           
        xs(i) = xs(i-1) + (delta_d *cos(thetas(i-1) + delta_th));
        ys(i) = ys(i-1) + (delta_d *sin(thetas(i-1) + delta_th));
        
        thetas(i) = mod((thetas(i-1) + delta_th), 2*pi);
    end

end

