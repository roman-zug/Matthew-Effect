% Script: Figure_S1
%
% Purpose: This script plots Supplementary Figure S1, which shows a
% comparison of the colony life cycle with a lucky (a, c) and an unlucky (b, d) 
% queen. Shown are the temporal dynamics of queen productivity (a, b) and
% workforce size (c, d).

clear;
addpath('../figures'); % Add the "figures" folder to the search path

% Open the original figures
fig1 = openfig('Figure_Temporal_Dynamics_Lucky_Queen.fig', 'invisible');
fig2 = openfig('Figure_Temporal_Dynamics_Unlucky_Queen.fig', 'invisible');

% Create a new figure for merging
mergedFig = figure;

% Set the size of the merged figure
set(mergedFig, 'Position', [400, 200, 800, 600]); % [left, bottom, width, height]

% Create a 2x2 layout for the merged figure (keeping the original orientation)
axNew1 = subplot(2,2,1); % Top-left
axNew2 = subplot(2,2,2); % Top-right
axNew3 = subplot(2,2,3); % Bottom-left
axNew4 = subplot(2,2,4); % Bottom-right

% Get axes handles from figures
ax1 = findobj(fig1, 'Type', 'Axes');
ax2 = findobj(fig2, 'Type', 'Axes');

% Sort axes to maintain order
ax1 = flipud(ax1);
ax2 = flipud(ax2);

% Copy objects from the original subplots into the new subplot positions
copyobj(allchild(ax1(1)), axNew1); % Top-left
copyobj(allchild(ax2(1)), axNew2); % Top-right
copyobj(allchild(ax1(2)), axNew3); % Bottom-left
copyobj(allchild(ax2(2)), axNew4); % Bottom-right

% Copy axis labels
axNew1.YLabel.String = ax1(1).YLabel.String; % 1. subplot: y axis label
axNew3.XLabel.String = ax2(2).XLabel.String; % 3. subplot: x axis label
axNew3.YLabel.String = ax2(2).YLabel.String; % 3. subplot: y axis label
axNew4.XLabel.String = ax1(2).XLabel.String; % 4. subplot: x axis label

% Copy the legend from the second original figure
lg2 = findobj(fig2, 'Type', 'Legend');
legend(axNew2, lg2.String); % Place legend from fig2 in the top-right subplot

% Adjust limits to match original figures
xlim(axNew1, xlim(ax1(1)));
ylim(axNew1, ylim(ax1(1)));
xlim(axNew2, xlim(ax2(1)));
ylim(axNew2, ylim(ax2(1)));

xlim(axNew3, xlim(ax2(2)));
ylim(axNew3, ylim(ax2(2)));
xlim(axNew4, xlim(ax1(2)));
ylim(axNew4, ylim(ax1(2)));

% Add grid to each subplot
grid(axNew1, 'on');  % Top-left subplot
grid(axNew2, 'on');  % Top-right subplot
grid(axNew3, 'on');  % Bottom-left subplot
grid(axNew4, 'on');  % Bottom-right subplot

% Add column headings
annotation(mergedFig, 'textbox', [0.05, 0.96, 0.5, 0.05], 'String', 'Lucky Queen', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
annotation(mergedFig, 'textbox', [0.49, 0.96, 0.5, 0.05], 'String', 'Unlucky Queen', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% Add letters (a-d) to each subplot
annotation(mergedFig, 'textbox', [0.02, 0.88, 0.1, 0.1], ...
    'String', '(a)', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
annotation(mergedFig, 'textbox', [0.47, 0.88, 0.1, 0.1], ...
    'String', '(b)', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
annotation(mergedFig, 'textbox', [0.02, 0.4, 0.1, 0.1], ...
    'String', '(c)', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
annotation(mergedFig, 'textbox', [0.47, 0.4, 0.1, 0.1], ...
    'String', '(d)', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');

% Save as FIG
savefig(mergedFig, 'Suppl_Figure_S1.fig');

% Save as JPG
saveas(mergedFig, 'Suppl_Figure_S1.jpg');

% Close figures
close(fig1);
close(fig2);
