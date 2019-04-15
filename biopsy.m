tumor_center = mean(tumor(:, :));

t = [0:0.05:5]';
T1 = p560Craigh.fkine(qz);
T3 = transl(tumor_center) * troty(-135, 'deg');
T2 = T3 * transl(0, 0, -0.2);
trplot(T2, 'length', 0.5, 'color', 'k', 'frame', 'R')
q1 = qz;
q2 = p560Craigh.ikine(T2);
q3 = p560Craigh.ikine(T3);

trajectory1 = jtraj(q1, q2, t);

Ts = ctraj(T2, T3, length(t)); 
trajectory2 = p560Craigh.ikine(Ts);

q = [trajectory1; 
    trajectory2;
    flipud(trajectory2); %reverse path
    flipud(trajectory1)];

view(15, 20);
axis([0.4, 1.2, -0.4, 0.4, 0.9, 1.7])

p560Craigh.plot(q, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)