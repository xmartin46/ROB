function [x_mean, y_mean] = nearest_to(LM_x, LM_y, data_x, data_y, n, thr)
    steps = length(data_x);
    p1 = [LM_x LM_y];
    for i=1:steps
        p2 = [data_x(i) data_y(i)];
        distances(i, 1) = sqrt(sum((p1 - p2).^2));
        distances(i, 2) = i;
    end
    distances = distances(distances(:, 1)<=thr, :);
    
    distances = sortrows(distances, 1);
    [rows cols] = size(distances);
    n = min(n, rows);
    ids = distances(1:n, 2);
    
    x_mean = mean(data_x(ids(:)));
    y_mean = mean(data_y(ids(:)));
end

