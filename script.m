%% 1
[xs, ys, thetas] = pose_integration(0, 0, pi/2, data_enc(:, 6), data_enc(:, 7), width);
steps = length(data_enc(:,1));

%% 2
lm_polar = lds_dis./1000;
[lm_cart_x lm_cart_y] = polar2cartesian(lm_polar);
lm_rob_x = lm_cart_x;
lm_rob_y =(lm_cart_y+0.095);

%% 3
[lm_world_x lm_world_y] = robot2world(lm_rob_x, lm_rob_y, xs, ys, thetas);

for index=1:steps
    plot(xs, ys);
    hold on;
    axis([-3 3 -2 4])
    for i=1:4 % plotting the 4 Land Marks
        circle (LandMark(i,:)',0.15)
    end
    
    %axis equal
    scatter(lm_world_x(index, :), lm_world_y(index, :));
    scatter(ldx(index,:), ldy(index,:))
    %hold on
    %if(mod(index, 24)==0)
    plot_ellipse(pk.signals.values(1:2,1:2,index),[trajec(index,1), trajec(index,2)],'g'); % Plotting the covariance matrix 
    %end
    pause(0.01);
    clf
end