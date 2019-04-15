%%%%%%%%%%%%%%% V1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tumor_center = mean(tumor(:, :));
% 
% % Radi del tumor
% crani_radi = compute_radius(tumor);
% 
% % Ha de ser una mica m�s petit que el radi del crani
% trep_radi = crani_radi - 0.0021;
% 
% center = tumor_center;
% 
% x = 0.5 * cosd(45);
% z = 0.5 * sind(45);
% 
% center = center + ([x-0.05 0 z-0.05] ./ 10);
% % scatter3(center(:, 1), center(:, 2), center(:, 3), 12, 'k', 'filled')
% C = h2e(transl(center) *   e2h(roty(45, 'deg') * h2e(transl(-center) * e2h(circle(center, trep_radi, 'N', 200)))))';
% % scatter3(C(:, 1), C(:, 2), C(:, 3), 12, 'b', 'filled');
% 
% for i=1:50
%     Laser_Pose(:,:,i)= transl(C(i, :)) * troty(-135, 'deg');
% end
% 
% q = p560Craigh.ikine(Laser_Pose, 'run');
% view(15, 20);
% axis([0.4, 1.2, -0.4, 0.4, 0.9, 1.7])
% p560Craigh.plot(q, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% V2 (malament) %%%%%%%%%%%%%%%%%%%%%%
tumor_center = mean(tumor(:, :));

% Radi del tumor
crani_radi = compute_radius(tumor);

% Ha de ser una mica m�s petit que el radi del crani
trep_radi = crani_radi - 0.0021;

center = tumor_center;

x = 0.5;

center = center + ([x-0.05 0 0] ./ 10);
scatter3(center(:, 1), center(:, 2), center(:, 3), 50, 'k', 'filled')
C = h2e(transl(center) *   e2h(roty(90, 'deg') * h2e(transl(-center) * e2h(circle(center, trep_radi, 'N', 200)))))';
scatter3(C(:, 1), C(:, 2), C(:, 3), 12, 'b', 'filled');

for i=1:50
    Laser_Pose(:,:,i)= transl(C(i, :)) * troty(-135, 'deg');
end

q = p560Craigh.ikine(Laser_Pose, 'run');
view(15, 20);
axis([0.4, 1.2, -0.4, 0.4, 0.9, 1.7])
p560Craigh.plot(q, 'loop', 'fps', 60, 'trail', {'k', 'LineWidth', 2}, 'zoom', 2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%