t = [0:0.05:5]';

% Radi. Ha de ser una mica més petit que el radi del tumor.
radius = compute_radius(tumor) - 0.002;
tumor_center = mean(tumor(:, :));
T_trepanation = transl(tumor_center) * transl(0.06, 0, 0) * troty(70, 'deg');

Ts_trepanation = zeros(4, 4, length(t));

%hold on;
for i=1:length(t)
    a = (t(i)/t(end))*(2*pi) + pi;
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

view(15, 20);
axis([0.4, 1.2, -0.4, 0.4, 0.9, 1.7])


%% Trajectory 1: qn -> trepanation start
T_trepanation_start = Ts_trepanation(:, :, 1);
q_trepanation_start = p560.ikine6s(T_trepanation_start, 'run');
traj_1 = jtraj(qn, q_trepanation_start, t);

p560.plot(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_1, 'fps', 60, 'trail', {'k', 'LineWidth', 2})

%% Trajectory 2: trepanation
traj_2 = p560.ikine6s(Ts_trepanation, 'run');

p560.plot(traj_2, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%p560.plot3d(traj_2, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2})