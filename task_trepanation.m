% This set of instructions perform a trepanation (a circle with a 45 degree
% angle of incidence).

t = [0:0.05:5]';

radius = compute_radius(tumor) - 0.002;
tumor_center = mean(tumor(:, :));
T_trepanation = transl(tumor_center) * transl(0.06, 0, 0) * troty(70, 'deg');

Ts_trepanation = zeros(4, 4, length(t));

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

%% Trajectory 2R: trepanation start -> trepanation pre
traj_2r = flipud(traj_2);

p560.plot(traj_2r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 1R: trepanation pre -> qn
traj_1r = flipud(traj_1);

p560.plot(traj_1r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)