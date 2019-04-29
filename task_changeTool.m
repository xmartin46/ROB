% This set of instructions change the tool being used (by going to the
% table, simulating it picks a tool, and returning to the default pose).

tool_pos = toolt_size./2;

t1 = [0:0.05:5];
t2 = [0:0.05:0.5];

tool_posW = h2e(RFT * e2h(tool_pos'))';

T_tool = transl(tool_posW) * trotz(0, 'deg') * trotx(180, 'deg');

T_tool_start = transl(0, 0, 0.1) * T_tool;
trplot(T_tool, 'length', 0.5, 'color', 'k', 'frame', 'R')

%% Trajectory 1: qn -> tool start
q_tool_start = p560.ikine6s(T_tool_start, 'run');
traj_1 = jtraj(qn, q_tool_start, t1);

p560.plot(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 2: tool start -> pick tool
Ts = ctraj(T_tool_start, T_tool, length(t2)); 
traj_2 = p560.ikine6s(Ts, 'run');

p560.plot(traj_2, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 2R: pick tool -> tool start
traj_2r = flipud(traj_2);

p560.plot(traj_2r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%% Trajectory 1R: pick tool -> qn
traj_1r = flipud(traj_1);

p560.plot(traj_1r, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)