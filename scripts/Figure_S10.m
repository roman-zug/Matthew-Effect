% Script: Figure_S10
% 
% Purpose: This script plots Supplementary Figure S10, which shows the Spearman 
% correlation coefficients (for the correlation between queen lifespan and 
% fecundity) of 50 hypothetical species (corresponding to Figure 5) as a 
% function of the optimal sexual threshold values, y*, for these 50 species, 
% to see if there is any correlation between these two sets of values. The script 
% accesses the output from the script 'categorize', called 'categories.mat'.

clear;
load categories.mat

% first dataset: optimal y values (identical for all 16 subplots)
original_set1 = opt_y_values; %opt_values(:, 2);

% collection of all 4 second datasets, containing all Spearman correlation
% coefficents for Figure 5
corr_coeff_sets = {TEcorr, TScorr, REcorr, RScorr};
corr_coeff_set_names = {'TEcorr', 'TScorr', 'REcorr', 'RScorr'};

% check for NaN values in the datasets
if any(isnan(original_set1))
    warning('NaN values found in optimal y values. These will be removed during processing.');
end
for i = 1:length(corr_coeff_sets)
    if any(isnan(corr_coeff_sets{i}), 'all')
        warning('NaN values found in %s. These will be removed during processing.', corr_coeff_set_names{i});
    end
end

% Plotting
fig = figure(1); clf;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

for row = 1:4
    for col = 1:4
        % reset set1 for each subplot
        set1 = original_set1;
        % extract the current corr coeff set
        set2 = corr_coeff_sets{row}(:, col);
        
        % Remove NaNs from both sets)
        valid_idx = ~isnan(set1) & ~isnan(set2);
        set1 = set1(valid_idx);
        set2 = set2(valid_idx);
        
        % Calculate Pearson correlation and p-value
        [rho_pearson, p_value] = corr(set1, set2, 'Type', 'Pearson');
        
        % Calculate Spearman correlation
        rho_spearman = corr(set1, set2, 'Type', 'Spearman');

        % Plot in the current subplot
        subplot(4, 4, (row-1)*4 + col);

        % Separate positive and negative values
        positive_idx = set2 >= 0;
        negative_idx = set2 < 0;

        % Plot positive points in blue
        scatter(set1(positive_idx), set2(positive_idx), 'blue', 'filled');
        hold on;

        % Plot negative points in red
        scatter(set1(negative_idx), set2(negative_idx), 'red', 'filled');

        % x label only in the fourth row
        if row == 4
            xlabel('Optimal y values');
        end

        % y label only in the first column
        if col == 1
            ylabel(sprintf('%s', corr_coeff_set_names{row}));
        end

        % Set y-axis range from -1 to 1
        ylim([-1, 1]);

        grid on;

        % Determine colors for the titles
        title_color_spearman = [0, 0, 1]; % Blue for positive Spearman correlation
        if rho_spearman < 0
            title_color_spearman = [1, 0.5, 0]; % Orange for negative correlation
        end
        
        % Add the colored title to the subplot
        %title(sprintf('\\color[rgb]{%f,%f,%f}Spearman: %.2f', ...
        %              title_color_spearman(1), title_color_spearman(2), title_color_spearman(3), rho_spearman), ...
        %      'FontSize', 8, 'Interpreter', 'tex');

        % Add Spearman correlation coefficient to each subplot
        xL = xlim;
        yL = ylim;
        text(xL(2) * 0.95, yL(1) + (yL(2) - yL(1)) * 0.05, sprintf('%.2f', rho_spearman), ...
            'HorizontalAlignment','right','VerticalAlignment','bottom', 'FontWeight', 'bold')

        % Add titles only for the first row
        if row == 1
            switch col
                case 1
                    t = title({'Optimal{\it x}*,'; 'optimal{\it y}*'});
                case 2
                    t = title({'Optimal{\it x}*,'; 'variable{\it y}'});
                case 3
                    t = title({'Variable{\it x},'; 'optimal{\it y}*'});
                case 4
                    t = title({'Variable{\it x},'; 'variable{\it y}'});
            end
            set(t, 'FontWeight', 'normal');
        end
    end
end
