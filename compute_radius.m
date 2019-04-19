function [mean_radius, radiusX, radiusY, radiusZ] = compute_radius(tumor)
    % X
    x_max = find(tumor(:, 1) == max(tumor(:, 1)));
    x_min = find(tumor(:, 1) == min(tumor(:, 1)));
    x = tumor(x_max(3), 1);
    y = tumor(x_min(2), 1);
%     x1 = [x(1, 1) y(1, 1)];
%     y1 = [x(1, 2) y(1, 2)];
%     z1 = [x(1, 3) y(1, 3)];
%     line(x1, y1, z1);
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
    radiusX = (sqrt(sum((x - y) .^ 2)))/2;

    % Y
    y_max = find(tumor(:, 2) == max(tumor(:, 2)));
    y_min = find(tumor(:, 2) == min(tumor(:, 2)));
    x = tumor(y_max(1), 2);
    y = tumor(y_min(1), 2);
%     x1 = [x(1, 1) y(1, 1)];
%     y1 = [x(1, 2) y(1, 2)];
%     z1 = [x(1, 3) y(1, 3)];
%     line(x1, y1, z1);
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
    radiusY = (sqrt(sum((x - y) .^ 2)))/2;

    % Z
    z_max = find(tumor(:, 3) == max(tumor(:, 3)));
    z_min = find(tumor(:, 3) == min(tumor(:, 3)));
    x = tumor(z_max(1), 3);
    y = tumor(z_min(1), 3);
%     x1 = [x(1, 1) y(1, 1)];
%     y1 = [x(1, 2) y(1, 2)];
%     z1 = [x(1, 3) y(1, 3)];
%     line(x1, y1, z1);
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
    radiusZ = (sqrt(sum((x - y) .^ 2)))/2;

    mean_radius = (radiusZ + radiusX + radiusY)/3;
end

