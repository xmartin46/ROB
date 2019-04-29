%This function computes the mean radius for a given set of points. It also
%computes the values for radius X, radius Y and radius Z.
function [mean_radius, radiusX, radiusY, radiusZ] = compute_radius(tumor)
    % X
    x_max = find(tumor(:, 1) == max(tumor(:, 1)));
    x_min = find(tumor(:, 1) == min(tumor(:, 1)));
    x = tumor(x_max(1), 1);
    y = tumor(x_min(1), 1);
    radiusX = (sqrt(sum((x - y) .^ 2)))/2;

    % Y
    y_max = find(tumor(:, 2) == max(tumor(:, 2)));
    y_min = find(tumor(:, 2) == min(tumor(:, 2)));
    x = tumor(y_max(1), 2);
    y = tumor(y_min(1), 2);
    radiusY = (sqrt(sum((x - y) .^ 2)))/2;

    % Z
    z_max = find(tumor(:, 3) == max(tumor(:, 3)));
    z_min = find(tumor(:, 3) == min(tumor(:, 3)));
    x = tumor(z_max(1), 3);
    y = tumor(z_min(1), 3);
    radiusZ = (sqrt(sum((x - y) .^ 2)))/2;

    mean_radius = (radiusZ + radiusX + radiusY)/3;
end

