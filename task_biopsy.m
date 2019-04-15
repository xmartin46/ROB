tumor_center = mean(tumor(:, :));

t = [0:0.05:5]';

T_biopsy_end = transl(tumor_center) * troty(-135, 'deg');
T_biopsy_start = T_biopsy_end * transl(0, 0, -0.2);

trplot(T_biopsy_end, 'length', 0.5, 'color', 'k', 'frame', 'R')

view(15, 20);
axis([0.4, 1.2, -0.4, 0.4, 0.9, 1.7])

%% Trajectory 1: qn -> biopsy start
q_biopsy_start = p560.ikine6s(T_biopsy_start, 'run');
traj_1 = jtraj(qn, q_biopsy_start, t);

p560.plot(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_1, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 2: biopsy
Ts = ctraj(T_biopsy_start, T_biopsy_end, length(t)); 
traj_2 = p560.ikine6s(Ts, 'run');
traj_2r = flipud(traj_2);
traj_2loop = [traj_2; traj_2r];

p560.plot(traj_2loop, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_2loop, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2})