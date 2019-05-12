function [ xs, ys, thetas ] = pose_integration( x_ini, y_ini, theta_ini, wheel_l, wheel_r, width)
    steps = size(wheel_l);
    wheel_l = wheel_l ./ 1000;
    wheel_r = wheel_r ./ 1000;
    xs(1) = x_ini;
    ys(1) = y_ini;
    thetas(1) = theta_ini;
    for i=2:steps
        L = (wheel_l(i)-wheel_l(i-1));
        R = (wheel_r(i)-wheel_r(i-1));
        S = width/(2 * 1000);
        
        delta_th = (R-L)/(2*S);
        delta_d = (R+L)/2;
        V = [0.02^2       0;
             0          (0.5*pi/180)^2];
        
        V = randn(1, 2) * V;
        V=[0 0];
         
        xs(i) = xs(i-1) + (delta_d + V(1))*cos(thetas(i-1) + delta_th + V(2));
        ys(i) = ys(i-1) + (delta_d + V(1))*sin(thetas(i-1) + delta_th + V(2));
        thetas(i) = mod((thetas(i-1) + delta_th + V(2)), 2*pi);
    end
end

