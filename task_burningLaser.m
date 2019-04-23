% Burn the tumor with a laser tool. The hole is no necessary to be big, the surgeons forecast half
% radius of the tumor equivalent sphere. To burn the tumor, assume the tool irradiate heat like a
% sphere shape of 4mm radius. Take care not burn healthy biological tissues.
tumor = pointWR;
t = [0:0.05:5]';

[mean_radius, radiusX, radiusY, radiusZ] = compute_radius(tumor)
% radiusX = radiusX * 1000; radiusY = radiusY * 1000; radiusZ = radiusZ * 1000;
vX = (radiusX)/4;
vY = (radiusY)/4;
vZ = (radiusZ)/4;
radius = mean_radius ./ 2;
tumor_center = mean(tumor(:, :));
T_trepanation = transl(tumor_center) * transl(0.06, 0, 0) * troty(70, 'deg');

Ts_trepanation = zeros(4, 4, length(t));

diameterX = radiusX * 2;
% pointsX = zeros((ceil((diameterX*1000 - 8)/4)), 3);
% for k = 1:(ceil((diameterX*1000 - 8)/4))
%     pointsX(k, :) = tumor_center + [-radiusX+k*vX 0 0];
% end
% 
diameterY = radiusY * 2;
% pointsY = zeros((ceil((diameterY*1000 - 8)/4)) + 1, 3);
% for k = 1:((ceil((diameterY*1000 - 8)/4)) + 1)
%     pointsY(k, :) = tumor_center + [0 -radiusY+k*vY 0];
% end
% 
diameterZ = radiusZ * 2;
% pointsZ = zeros((ceil((diameterZ*1000 - 8)/4)), 3);
% for k = 1:(ceil((diameterZ*1000 - 8)/4))
%     pointsZ(k, :) = tumor_center + [0 0 -radiusZ+k*vZ];
% end

a = 1;
for i = 1:(ceil((diameterX*1000 - 8)/4))
   for j = 1:((ceil((diameterY*1000 - 8)/4)) + 1)
        for k = 1:(ceil((diameterZ*1000 - 8)/4))
            burningPoints(a, :) = tumor_center + [-radiusX+i*vX -radiusY+j*vY -radiusZ+k*vZ];
            a = a + 1;
       end
    end
end

% % scatter3(pointsX(:, 1), pointsX(:, 2), pointsX(:, 3), 12, 'k', 'filled')
% scatter3(burningPoints(:, 1), burningPoints(:, 2), burningPoints(:, 3), 12, 'k', 'filled')
% hold on;
% % scatter3(pointsY(:, 1), pointsY(:, 2), pointsY(:, 3), 12, 'k', 'filled')
% % scatter3(pointsZ(:, 1), pointsZ(:, 2), pointsZ(:, 3), 12, 'k', 'filled')
% scatter3(tumor(:, 1), tumor(:, 2), tumor(:, 3), 12, 'r', 'filled')

for i=1:length(t)
    a = (t(i)/t(end))*(2*pi);
    c = [cos(a)*radius
         sin(a)*radius
         0];
    Ts_trepanation(:,:,i) = transl(c) *  trotz(a+pi)* troty(-45, 'deg') * trotx(180, 'deg');
    Ts_trepanation(:,:,i) = T_trepanation * Ts_trepanation(:,:,i);
    Ts_trepanation(:,:,i) = Ts_trepanation(:,:,i);
    %trplot(Ts_trepanation(:,:,i), 'length', 0.5, 'color', 'k')
end
%hold off;
%axis('equal');

%% Trajectory 1: qn -> trepanation pre
T_trepanation_start = Ts_trepanation(:, :, 1);
T_trepanation_pre = T_trepanation_start * transl(0, 0, -0.1);
q_trepanation_pre = p560.ikine6s(T_trepanation_pre, 'run');
traj_1 = jtraj(qn, q_trepanation_pre, t);

p560.plot(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 2: trepanation pre -> trepanation start
T_traj_2 = ctraj(T_trepanation_pre, T_trepanation_start, length(t)); 
traj_2 = p560.ikine6s(T_traj_2, 'run');

p560.plot(traj_2, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_2, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 3: trepanation
traj_3 = p560.ikine6s(Ts_trepanation, 'run');
n = 2; % number of loops
traj_3 = repmat(traj_3, n, 1);

p560.plot(traj_3, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_3, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 4: trepanation start -> burningLaser start 
burningLaser_start = burningPoints(1, :);
prova = T_trepanation_start;
prova(1:3, 4) = burningLaser_start;
T_traj_4 = ctraj(T_trepanation_start, prova, length(t)); 
traj_4 = p560.ikine6s(T_traj_4, 'run');

p560.plot(traj_4, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_2, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 5: burningLaser
for i = 1:size(burningPoints)
    prova(:, :, i) = T_trepanation_start;
    prova(1:3, 4, i) = burningPoints(i, :);
end
traj_5 = p560.ikine6s(prova, 'run');

p560.plot(traj_5, 'fps', 60, 'trail', {'g', 'LineWidth', 1}, 'zoom', 2)
%p560.plot3d(traj_5, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 4R: burningLaser end -> trepanation start
burningLaser_end = burningPoints(end, :);
prova = T_trepanation_start;
prova(1:3, 4) = burningLaser_end;
T_traj_4r = ctraj(prova, T_trepanation_start, length(t)); 
traj_4r = p560.ikine6s(T_traj_4r, 'run');

p560.plot(traj_4r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_4r, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 2R: trepanation start -> trepanation pre
traj_2r = flipud(traj_2);

p560.plot(traj_2r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_2r, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 1R: trepanation pre -> qn
traj_1r = flipud(traj_1);

p560.plot(traj_1r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_1r, 'fps', 60, 'trail', {'k', 'LineWidth', 2})