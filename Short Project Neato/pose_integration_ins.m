function [ x, y, theta ] = pose_integration_ins( x_ini, y_ini, theta_ini, wheel_l_d, wheel_r_d, width)
    L = wheel_l_d ./ 1000;
    R = wheel_r_d ./ 1000;

    S = width/(2 * 1000);

    delta_th = (R-L)/(2*S);
    delta_d = (R+L)/2;
    V = [0.02^2       0;
         0          (0.5*pi/180)^2];

    V = randn(1, 2) * V;

    x = x_ini + (delta_d + V(1))*cos(theta_ini + delta_th + V(2));
    y = y_ini + (delta_d + V(1))*sin(theta_ini + delta_th + V(2));
    theta = mod((theta_ini + delta_th + V(2)), 2*pi);
end

