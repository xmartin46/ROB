%% 1
clear all
load('Work_Space_Localization_Short_project.mat')

steps = length(data_enc(:,1));
calib_flag = false;
Robot = [0 -0.2 0 1;0.4 0 0 1;0 0.2 0 1]';

xs(1) = 0;
ys(1) = 0;
thetas(1) = pi/2;

for index=2:steps
    wheel_l_d = data_enc(index, 6)-data_enc(index-1, 6);
    wheel_r_d = data_enc(index, 7)-data_enc(index-1, 7);
    [x, y, theta] = pose_integration_ins(xs(index-1), ys(index-1), thetas(index-1), wheel_l_d, wheel_r_d, width);
    xs(index) = x;
    ys(index) = y;
    thetas(index) = theta;
    grid on;
    subplot(1, 2, 2);
    hold on;
    plot(xs, ys);
    %plot(trajec(:, 1), trajec(:, 2));
    
    %% 2
    lm_polar = lds_dis(index,:)./1000;
    [lm_cart_x lm_cart_y] = polar2cartesian_ins(lm_polar);
    lm_rob_x = lm_cart_x;
    lm_rob_y = lm_cart_y;
    %% 3
    [lm_world_x lm_world_y] = robot2world_ins(lm_rob_x, lm_rob_y, xs(index), ys(index), thetas(index));
    scatter(lm_world_x(:), lm_world_y(:));

    axis([-3 3 -2 4])
    CalculatedLandMarks = [];
    for i=1:length(LandMark)
        circle (LandMark(i,:)',0.15);
        [l_x l_y] = nearest_to(LandMark(i, 1), LandMark(i, 2), lm_world_x(:), lm_world_y(:), 5, 1);
        if (~isnan(l_x) && ~isnan(l_y))
            CalculatedLandMarks = [CalculatedLandMarks; l_x l_y];
            circle ([l_x l_y], 0.15, 'color', 'r');
        end
    end

    if (mod(index, 64) == 0)
        calib_flag = true;
    end
    
    if (calib_flag && size(CalculatedLandMarks, 1)>=4)
        calib_flag = false;
        %% 6
        [e_x e_y e_theta] = similarity_transform(LandMark', CalculatedLandMarks');
        xs(index) = xs(index) - e_x;
        ys(index) = ys(index) - e_y;
        thetas(index) = thetas(index) + e_theta;
        
        pk.signals.values(1:2,1:2,:) = pk.signals.values(1:2,1:2,:)-pk.signals.values(1:2,1:2,index)*0.9;
    end
    
    Robot_tr=transl(xs(1,index),ys(1,index),0)*trotz(mod(thetas(1,index),2*pi))*Robot;% moving the robot
    patch(Robot_tr(1,:), Robot_tr(2,:),'b');
    
    plot_ellipse(pk.signals.values(1:2,1:2,index),[xs(index), ys(index)],'g'); % Plotting the covariance matrix 
    
    subplot(1, 2, 1);
    t = 0: 2*pi/359 : 2*pi;
%     P = polar(t, 4.5 * ones(size(t)));% to fix the limits
%     set(P, 'Visible', 'off')
    polar(t, lm_polar(1,2:361), '--g'); % Ploting the laser data wrt Robot frame
    
    pause(0.01);
    clf
end