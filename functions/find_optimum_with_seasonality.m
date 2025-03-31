% Function: find_optimum_with_seasonality
%
% Purpose: This function finds the optimal x value using cubic smoothing
% spline (csaps) with seasonality, which means that production of sexual eggs 
% does not start above sexual threshold y, (there is no such threshold in 
% the model version with seasonality), but rather after a given time point 
% called 't_sexual'. 'find_optimum_with_seasonality' is used in the script
% 'Figure_S7'.
%
% Inputs:
%   TSmean - 1D array of fitness values (mean of total sexuals)
%   x - 1D array defining the parameter space; x: allocation to reproduction
%
% Outputs:
%   xopt - Optimal x value
%   max_value - Corresponding maximum fitness value
%   iopt - Index of the optimal x value

function [xopt, max_value, iopt] = find_optimum_with_seasonality(TSmean, x)
    
    % Spline fitting
    smoothing_param = 0.99; % Smoothing parameter (default: 0.99)
    sf = csaps(x, TSmean, smoothing_param);
    
    % Generate a finer grid for better resolution
    x_fit = linspace(min(x), max(x), 100);
    
    % Evaluate the fitted function
    Z_fit = fnval(sf, x_fit);
    
    % Find the maximum value and corresponding index
    [max_value, max_idx] = max(Z_fit);
    xopt = x_fit(max_idx);
    
    % Find closest index in the original x grid
    [~, iopt] = min(abs(x - xopt));
end
