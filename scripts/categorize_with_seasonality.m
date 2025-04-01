% Script: categorize_with_seasonality
% 
% Purpose: This script uses the output from 'collate_fitness_with_seasonality' 
% called 'collated_with_seasonality.mat' to get the fitness matrix W, and 
% the output from 'optimization_with_seasonality' called 'optimal_values_with_seasonality'
% to get 50 different optimal x* values. Fecundity measures (TE, TS, RE, RS) 
% are then computed for two different ways ("categories") that a queen can
% make use of x: optimal vs variable x values, with seasonality, which means that 
% production of sexual eggs does not start above sexual threshold y, (there 
% is no such threshold in the model version with seasonality), but rather 
% after a given time point called 't_sexual'. Finally, Spearman correlation 
% coefficients are computed between lifespan (L) and fecundity measures 
% (TE, TS, RE, RS). Output is saved as 'categories_with_seasonality.mat', 
% which is accessed by the script 'Figure_5_with_seasonality'. 
% 'categorize_with_seasonality' is an auxiliary script to plot Supplementary 
% Figure S8.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load collated_with_seasonality.mat
load optimal_values_with_seasonality.mat

opt_x_values = optimal_x_all;

P = nan([nof_combos 5]); % more concise parameters
for c = 1:nof_combos
    f = find(combo == c);
    P(c, :) = params(f(1), :); 
end

for c = 1:nof_combos
    c
    [iopt] = max(W(:, c)); % W: 2D

    % 1st column: queens use optimal x values
    x1 = opt_x_values(c) .* ones([250 1]);
    [L1(:, c), TE1(:, c), TS1(:, c), RE1(:, c), RS1(:, c)] = matthew_with_seasonality(P(c, :), x1, t_sexual);

    % 2nd column: queens vary in x
    x2 = xvalues(ddists(W(:, c), 250))';
    [L2(:, c), TE2(:, c), TS2(:, c), RE2(:, c), RS2(:, c)] = matthew_with_seasonality(P(c, :), x2, t_sexual);

    % How would a researcher report the correlations in a sample of 250 colonies?
    TEcorr(c, :) = [corr(L1(:, c), TE1(:, c), 'Type', 'Spearman'), corr(L2(:, c), TE2(:, c), 'Type', 'Spearman')];
    TScorr(c, :) = [corr(L1(:, c), TS1(:, c), 'Type', 'Spearman'), corr(L2(:, c), TS2(:, c), 'Type', 'Spearman')];
    REcorr(c, :) = [corr(L1(:, c), RE1(:, c), 'Type', 'Spearman'), corr(L2(:, c), RE2(:, c), 'Type', 'Spearman')];
    RScorr(c, :) = [corr(L1(:, c), RS1(:, c), 'Type', 'Spearman'), corr(L2(:, c), RS2(:, c), 'Type', 'Spearman')];

    save categories_with_seasonality.mat
end
