% Script: optimization_with_seasonality
% 
% This script accesses the output from 'collate_fitness_with_seasonality' 
% called 'collated_with_seasonality.mat' to find the optimal x* values for 
% the 50 different parameter sets, using spline fitting, with seasonality, 
% which means that production of sexual eggs does not start above sexual 
% threshold y (there is no such threshold in the model version with 
% seasonality), but rather after a given time point called 't_sexual'. 
% Output is saved as 'optimal_values_with_seasonality.mat', which is 
% accessed by the script 'categorize_with_seasonality'. 
% 'optimization_with_seasonality' is an auxiliary script to plot 
% Supplementary Figure S8.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load collated_with_seasonality.mat; 

% Extract x values
x_values = xvalues;

% Set up a vector to store optimal x values for each layer
optimal_x_all = NaN(50, 1);

% Loop through each layer of W (total 50 layers)
for z_layer = 1:50

    % Extract the current z-layer
    z_values_layer = W(:, z_layer); % 1D vector

    % Spline fitting
    smooth_param = 0.99; % Smoothness parameter (default: 0.99)
    z_pred = csaps(x_values, z_values_layer, smooth_param, x_values); % 1D

    % Ensure z_pred is valid
    if all(isnan(z_pred)) || isempty(z_pred)
        warning('Skipping layer %d due to invalid spline fit.', z_layer);
        continue;
    end

    % Find optimal point
    [max_val, max_index] = max(z_pred);

    % Ensure max_index is valid
    if isempty(max_index) || max_index < 1 || max_index > numel(x_values)
        warning('Invalid max index for layer %d. Skipping.', z_layer);
        continue;
    end

    optimal_x = x_values(max_index); % Extract corresponding x value

    % Store the result for the current layer
    optimal_x_all(z_layer) = optimal_x;
end

% Save the results to a .mat file
save('optimal_values_with_seasonality.mat', 'optimal_x_all');

% Optionally, display the results
fprintf('\nOptimal x values for all layers:\n');
disp(table((1:50)', optimal_x_all, 'VariableNames', {'Layer', 'Optimal_x'}));
