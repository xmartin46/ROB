% This set of instructions burn the tumor with a laser tool. The hole is no necessary to be big, the surgeons forecast half
% radius of the tumor equivalent sphere. To burn the tumor, assume the tool irradiate heat like a
% sphere shape of 4mm radius. Take care not burn healthy biological tissues.

tumor = pointWR;
t = [0:0.05:5]';

[mean_radius, radiusX, radiusY, radiusZ] = compute_radius(tumor);
radiusX = radiusX * 0.7071 - 0.004; %1/sqrt(2)
radiusY = radiusY * 0.7071 - 0.004; %1/sqrt(2)
radiusZ = radiusZ * 0.7071 - 0.004; %1/sqrt(2)

vX = 0.004;
vY = 0.004;
vZ = 0.004;
radius = mean_radius ./ 2;
tumor_center = mean(tumor(:, :));
T_trepanation = transl(tumor_center) * transl(0.06, 0, 0) * troty(70, 'deg');

Ts_trepanation = zeros(4, 4, length(t));

diameterX = radiusX * 2;
diameterY = radiusY * 2;
diameterZ = radiusZ * 2;

a = 1;
t_x = (ceil(diameterX/0.004));
t_y = (ceil(diameterY/0.004));
t_z = (ceil(diameterZ/0.004));

for i = 0:t_x
   for j = 0:t_y
        for k = 0:t_z
            if (mod(j, 2) == mod(i, 2))
                offs_z = -radiusZ+k*vZ;
            else
                offs_z = -radiusZ+(t_z-k)*vZ;
            end
            
            if (mod(i, 2)==0)
                offs_y = -radiusY+j*vY;
            else
                offs_y = -radiusY+(t_y-j)*vY;
            end
            burningPoints(a, :) = tumor_center + [-radiusX+i*vX offs_y offs_z];
            a = a + 1;
       end
    end
end

scatter3(tumor(:, 1), tumor(:, 2), tumor(:, 3), 12, 'r', 'filled')

for i=1:length(t)
    a = (t(i)/t(end))*(2*pi);
    c = [cos(a)*radius
         sin(a)*radius
         0];
    Ts_trepanation(:,:,i) = transl(c) *  trotz(a+pi)* troty(-45, 'deg') * trotx(180, 'deg');
    Ts_trepanation(:,:,i) = T_trepanation * Ts_trepanation(:,:,i);
    Ts_trepanation(:,:,i) = Ts_trepanation(:,:,i);
end

%% Trajectory 1: qn -> trepanation pre
T_trepanation_start = Ts_trepanation(:, :, 1);
T_trepanation_pre = T_trepanation_start * transl(0, 0, -0.1);
q_trepanation_pre = p560.ikine6s(T_trepanation_pre, 'run');
traj_1 = jtraj(qn, q_trepanation_pre, t);

p560.plot(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 2: trepanation pre -> trepanation start
T_traj_2 = ctraj(T_trepanation_pre, T_trepanation_start, length(t)); 
traj_2 = p560.ikine6s(T_traj_2, 'run');

p560.plot(traj_2, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 3: trepanation
traj_3 = p560.ikine6s(Ts_trepanation, 'run');
n = 2; % number of loops
traj_3 = repmat(traj_3, n, 1);

p560.plot(traj_3, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 4: trepanation start -> burningLaser start 
burningLaser_start = burningPoints(1, :);
prova = T_trepanation_start;
prova(1:3, 4) = burningLaser_start;
T_traj_4 = ctraj(T_trepanation_start, prova, length(t)); 
traj_4 = p560.ikine6s(T_traj_4, 'run');

p560.plot(traj_4, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 5: burningLaser
for i = 1:size(burningPoints)
    prova(:, :, i) = T_trepanation_start;
    prova(1:3, 4, i) = burningPoints(i, :);
end
traj_5 = p560.ikine6s(prova, 'run');

p560.plot(traj_5, 'fps', 60, 'trail', {'r', 'LineWidth', 1}, 'zoom', 2)

%% Trajectory 4R: burningLaser end -> trepanation start
burningLaser_end = burningPoints(end, :);
prova = T_trepanation_start;
prova(1:3, 4) = burningLaser_end;
T_traj_4r = ctraj(prova, T_trepanation_start, length(t)); 
traj_4r = p560.ikine6s(T_traj_4r, 'run');

p560.plot(traj_4r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 2R: trepanation start -> trepanation pre
traj_2r = flipud(traj_2);

p560.plot(traj_2r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 1R: trepanation pre -> qn
traj_1r = flipud(traj_1);

p560.plot(traj_1r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)