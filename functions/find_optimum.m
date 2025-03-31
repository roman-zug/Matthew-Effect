% Function: find_optimum
%
% Purpose: This function finds the optimal (x, y) combination using cubic 
% smoothing spline (csaps). It is used in the script 'Figure_4'.
%
% Inputs:
%   TSmean - 2D matrix of fitness values (mean of total sexuals)
%   x, y - Meshgrid matrices defining the parameter space; x: allocation to 
%          reproduction; y: sexual threshold
%
% Outputs:
%   xopt, yopt - Optimal (x, y) combination
%   max_value - Corresponding maximum fitness value
%   iopt, jopt - Indices of the optimal (x, y) combination

function [xopt, yopt, max_value, iopt, jopt] = find_optimum(TSmean, x, y)
    
    % Extract x and y values (assuming both are meshgrids)
    x_values = x(1, :);
    y_values = y(:, 1);

    % Spline fitting
    smoothing_param = 0.99; % Smoothing parameter (default: 0.99)
    sf = csaps({x_values, y_values}, TSmean', smoothing_param);
    
    % Generate a finer grid for better resolution
    [X_fit, Y_fit] = meshgrid(linspace(min(x(:)), max(x(:)), 100), ...
                              linspace(min(y(:)), max(y(:)), 100));
    
    % Evaluate the fitted function
    Z_fit = fnval(sf, [X_fit(:), Y_fit(:)]');
    Z_fit = reshape(Z_fit, size(X_fit));
    
    % Find the maximum value and corresponding indices
    [max_value, max_idx] = max(Z_fit(:));
    [imax_fit, jmax_fit] = ind2sub(size(Z_fit), max_idx);
    
    % Get corresponding (x, y) values
    xopt = X_fit(imax_fit, jmax_fit);
    yopt = Y_fit(imax_fit, jmax_fit);
    
    % Find closest indices in the original x, y grid
    [~, iopt] = min(abs(y(:,1) - yopt));
    [~, jopt] = min(abs(x(1,:) - xopt));
end