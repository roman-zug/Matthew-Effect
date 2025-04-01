% Script: categorize
% 
% Purpose: This script uses the output from 'collate_fitness' called 
% 'collated.mat' to adjust the fitness matrix W so that the probabilities 
% of those fitness values are increased that correspond to multiple y
% values. It also uses the outpur from 'optimization' called
% 'optimal_values.mat' to get 50 different optimal (x*, y*) pairs.
% Fecundity measures (TE, TS, RE, RS) are then computed for 4 different
% ways ("categories") that a queen can make use of x and y: (1) queens use 
% optimal {x*, y*} values; (2) queens vary only in y; (3) queens vary only 
% in x; and (4) queens vary in both x and y. Finally, Spearman correlation 
% coefficients are computed between lifespan (L) and fecundity measures 
% (TE, TS, RE, RS). Output is saved as 'categories.mat', which is accessed 
% by the script 'Figure_5'. 'categorize' is an auxiliary script 
% to plot Figures 5, S2, and S3.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load collated.mat
load optimal_values.mat

[X, Y] = meshgrid(xvalues, yvalues);

opt_x_values = optimal_x_all;
opt_y_values = optimal_y_all;

P = nan([nof_combos 5]); % more concise parameters
for c = 1:nof_combos
    f = find(combo == c);
    P(c, :) = params(f(1), :); 
end

for c = 1:nof_combos
    c
    % Find the maximum value and its linear index
    [max_val, max_index] = max(W(:, :, c), [], 'all', 'linear');

    % Convert linear index to subscript indices (row, col)
    max_indices = cell(1, ndims(W(:, :, c)));
    [max_indices{:}] = ind2sub(size(W(:, :, c)), max_index);

    % Convert max_indices to numerical indices
    max_indices = cell2mat(max_indices);

    max_row = max_indices(1);
    max_col = max_indices(2);

    Wadjusted = W(:, :, c);
    Wadjusted(yvalues == 50) = Wadjusted(yvalues == 50) * 5;
    Wadjusted(yvalues > 50 & yvalues < 100) = Wadjusted(yvalues > 50 & yvalues < 100) * 10;
    Wadjusted(yvalues == 100) = Wadjusted(yvalues == 100) * (10 + 25);
    Wadjusted(yvalues > 100) = Wadjusted(yvalues > 100) * 50;

    % 1st column: queens use the optimum for both x and y
    x1 = opt_x_values(c) .* ones([250 1]);
    y1 = opt_y_values(c) .* ones([250 1]);
    [L1(:, c), TE1(:, c), TS1(:, c), RE1(:, c), RS1(:, c)] = matthew(P(c, :), x1, y1);

    % 2nd column: queens vary in y
    x2 = opt_x_values(c) .* ones([250 1]);
    y2 = yvalues(ddists(Wadjusted(max_row, :), 250));
    [L2(:, c), TE2(:, c), TS2(:, c), RE2(:, c), RS2(:, c)] = matthew(P(c, :), x2, y2);

    % 3rd column: queens vary in x
    x3 = xvalues(ddists(Wadjusted(:, max_col), 250))';
    y3 = opt_y_values(c) .* ones([250 1]);
    [L3(:, c), TE3(:, c), TS3(:, c), RE3(:, c), RS3(:, c)] = matthew(P(c, :), x3, y3);

    % 4th column: queens vary in both x and y
    xall = X(:);
    yall = Y(:);
    sample = ddists(Wadjusted(:), 250)';
    x4 = xall(sample);
    y4 = yall(sample);
    [L4(:, c), TE4(:, c), TS4(:, c), RE4(:, c), RS4(:, c)] = matthew(P(c, :), x4, y4);

    % How would a researcher report the correlations in a sample of 250 colonies?
    TEcorr(c, :) = [corr(L1(:, c), TE1(:, c), 'Type', 'Spearman'), corr(L2(:, c), TE2(:, c), 'Type', 'Spearman'), corr(L3(:, c), TE3(:, c), 'Type', 'Spearman'), corr(L4(:, c), TE4(:, c), 'Type', 'Spearman')];
    TScorr(c, :) = [corr(L1(:, c), TS1(:, c), 'Type', 'Spearman'), corr(L2(:, c), TS2(:, c), 'Type', 'Spearman'), corr(L3(:, c), TS3(:, c), 'Type', 'Spearman'), corr(L4(:, c), TS4(:, c), 'Type', 'Spearman')];
    REcorr(c, :) = [corr(L1(:, c), RE1(:, c), 'Type', 'Spearman'), corr(L2(:, c), RE2(:, c), 'Type', 'Spearman'), corr(L3(:, c), RE3(:, c), 'Type', 'Spearman'), corr(L4(:, c), RE4(:, c), 'Type', 'Spearman')];
    RScorr(c, :) = [corr(L1(:, c), RS1(:, c), 'Type', 'Spearman'), corr(L2(:, c), RS2(:, c), 'Type', 'Spearman'), corr(L3(:, c), RS3(:, c), 'Type', 'Spearman'), corr(L4(:, c), RS4(:, c), 'Type', 'Spearman')];

    save categories.mat
end
