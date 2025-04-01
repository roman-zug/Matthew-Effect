% Script: optimization
% 
% This script accesses the output from 'collate_fitness' called
% 'collated.mat' to find the optimal (x*, y*) pairs for the 50 different
% parameter sets, using spline fitting. Output is saved as 'optimal_values.mat', 
% which is accessed by the script 'categorize'. 'optimization' is an auxiliary
% script to plot Figures 5, S2 and S3.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load collated.mat;

% Extract variables
x_values = xvalues;
y_values = yvalues;

% Set up a matrix to store optimal x, y values for each layer
optimal_x_all = NaN(50, 1); % Pre-allocate array for optimal x values
optimal_y_all = NaN(50, 1); % Pre-allocate array for optimal y values
optimal_x_idx_all = NaN(50, 1); % Stores row indices
optimal_y_idx_all = NaN(50, 1); % Stores column indices

% Loop through each layer of z_values (total 50 layers)
for z_layer = 1:50

    % Extract the current z-layer
    z_values_layer = W(:, :, z_layer); % 2D layer

    % Spline fitting
    smooth_param = 0.99; % smoothness parameter (default: 0.99)
    z_pred_grid = csaps({x_values, y_values}, z_values_layer, smooth_param, {x_values, y_values});

     % Ensure z_pred is valid
    if all(isnan(z_pred_grid), 'all') || isempty(z_pred_grid)
        warning('Skipping layer %d due to invalid spline fit.', z_layer);
        continue;
    end

    % Find optimal points
    [max_val, max_index] = max(z_pred_grid(:));
    [max_row, max_col] = ind2sub(size(z_pred_grid), max_index);

    % Ensure max_index is valid
    if isempty(max_index) || max_row < 1 || max_row > size(z_pred_grid, 1) ...
       || max_col < 1 || max_col > size(z_pred_grid, 2)
        warning('Invalid max index for layer %d. Skipping.', z_layer);
        continue;
    end

    % Store optimal {x, y} coordinates
    optimal_x_all(z_layer) = x_values(max_row);
    optimal_y_all(z_layer) = y_values(max_col);

    % Store indices
    optimal_x_idx_all(z_layer) = max_row;
    optimal_y_idx_all(z_layer) = max_col;
end

% Save the results to a .mat file
save('optimal_values.mat', 'optimal_x_all', 'optimal_y_all');

% Optionally, display the results
fprintf('\nOptimal values and indices for all layers:\n');
disp(table((1:50)', optimal_x_all, optimal_y_all, 'VariableNames', {'Layer', 'Optimal_x', 'Optimal_y'}));
