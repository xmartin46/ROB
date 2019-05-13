%% 1
load('Work_Space_Localization_Short_project.mat')



%[x1 y1] = 




Robot = [0 -0.2 0 1;0.4 0 0 1;0 0.2 0 1]';
for index=1:steps
    plot(xs, ys);
    hold on;
    %plot(trajec(:, 1), trajec(:, 2));
    
    axis([-3 3 -2 4])
    for i=1:length(LandMark)
        circle (LandMark(i,:)',0.15);
        [CalculatedLandMarks(i, 1) CalculatedLandMarks(i, 2)] = nearest_to(LandMark(i, 1), LandMark(i, 2), lm_world_x(index, :), lm_world_y(index, :), 2, 2);
        circle (CalculatedLandMarks(i,:)', 0.15, 'color', 'r');
    end
    scatter(lm_world_x(index, :), lm_world_y(index, :));
    %axis equal
    %scatter(ldx(index,:), ldy(index,:))
    
    if (mod(index, 128) == 1)
        [xs, ys, thetas] = pose_integration(0, 0, pi/2, data_enc(:, 6), data_enc(:, 7), width);
        
        %% 6
        if(index > 1)
            [e_x e_y e_theta] = similarity_transform(LandMark', CalculatedLandMarks');
            xs = xs - e_x;
            ys = ys - e_y;
            thetas = thetas - e_theta;
        end
        
        steps = length(data_enc(:,1));
        % xs = trajec(:, 1)';
        % ys = trajec(:, 2)';
        % thetas = trajec(:, 3)';
        thetas = thetas - pi/2;
        %% 2
        lm_polar = lds_dis./1000;
        [lm_cart_x lm_cart_y] = polar2cartesian(lm_polar);
        lm_rob_x = lm_cart_x;
        lm_rob_y = lm_cart_y;

        %% 3
        [lm_world_x lm_world_y] = robot2world(lm_rob_x, lm_rob_y, xs, ys, thetas);
        
        
    end
    
    Robot_tr=transl(xs(1,index),ys(1,index),0)*trotz(mod(thetas(1,index)+pi/2,2*pi))*Robot;% moving the robot
    patch(Robot_tr(1,:), Robot_tr(2,:),'b');
    
    plot_ellipse(pk.signals.values(1:2,1:2,index),[trajec(index,1), trajec(index,2)],'g'); % Plotting the covariance matrix 

    pause(0.01);
    clf
end