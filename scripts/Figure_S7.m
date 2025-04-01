% Script: Figure_S7
%
% Purpose: This script plots Supplementary Figure S7, which shows the 
% correlation between queen lifespan and fecundity, for different measures 
% of queen fecundity (rows) and optimal vs. variable x values used by queens 
% (columns), with seasonality, which means that production of sexual eggs 
% does not start above sexual threshold y, (there is no such threshold in 
% the model version with seasonality), but rather after a given time point 
% called 't_sexual'.

clear;
addpath('../functions'); % Add the "functions" folder to the search path

% Define parameters
a1 = 1; % Parameter adjusting how important help by workers is to keep the queen alive
a2 = 1; % Parameter adjusting how many workers are needed to create a significant shift towards a longer-lived queen
a3 = 1; % Parameter describing the strength of the positive effect of a large workforce on queen productivity
mu_q0 = 0.005; % queen baseline mortality
mu_w = 0.1; % worker mortality
params = [a1, a2, a3, mu_q0, mu_w];

x = 0.01:0.01:0.99; % allocation to reproduction
t_sexual = 200; % time point at which the production of sexual eggs begins

num_simulations = 100;

% Store simulation runs for total sexuals (measure of queen fitness)
TS_all = zeros(num_simulations, length(x));

for k = 1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew_with_seasonality(params, x(:), t_sexual);
    % Store results from each run
    TS_all(k, :) = total_sexuals';
end

% Compute mean across simulations
TSmean = mean(TS_all, 1);

% Optimization (used for first column)
[xopt, max_value, iopt] = find_optimum_with_seasonality(TSmean, x);

% Normalize TSmean to get a probability distribution (used for second column)
prob_dist = TSmean / sum(TSmean);

% Plotting
fig = figure(1); clf;
grid on;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

% Array to hold axes handles for each row (4 July 2024)
top_row_axes = [];
second_row_axes = [];
third_row_axes = [];
fourth_row_axes = [];

% 1st column: every queen uses the optimum
x1 = xopt * ones([1 250]);

% Adjust the call to matthew_with_seasonality to match the initial call structure
params1 = ones(size(x1(:))) * [a1 a2 a3 mu_q0 mu_w];

[L1, TE1, TS1, RE1, RS1] = matthew_with_seasonality(params1, x1(:), t_sexual);

ax1 = subplot(4, 2, 1);
plot(L1, TE1, 'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
ylabel({'Total eggs'; 'over lifetime'}, 'FontSize', 11);
title({'Optimal{\it x}*'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax1];
ax1.YAxis.Exponent = 3;
ax1.YTick = [0, 500, 1000, 1500];
ax1.YAxis.FontSize = 11;
x_ticks = get(ax1, 'XTick');
set(ax1, 'XTick', x_ticks);
y_ticks_1 = get(ax1, 'YTick');
set(ax1, 'YTick', y_ticks_1);
rho1 = corr(L1, TE1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho1), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(a)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax3 = subplot(4, 2, 3);
plot(L1,TS1,'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
ylabel({'Sexual eggs'; 'over lifetime'}, 'FontSize', 11);
second_row_axes = [second_row_axes, ax3];
ax3.YAxis.Exponent = 2;
ax3.YTick = [0, 250, 500];
ax3.YAxis.FontSize = 11;
set(ax3, 'XTick', x_ticks);
y_ticks_2 = get(ax3, 'YTick');
set(ax3, 'YTick', y_ticks_2);
rho3 = corr(L1, TS1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho3), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(c)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax5 = subplot(4, 2, 5);
plot(L1,RE1,'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
ylabel({'Total eggs'; 'as a rate'}, 'FontSize', 11);
third_row_axes = [third_row_axes, ax5];
ax5.YTick = [0, 2.5, 5];
ax5.YAxis.FontSize = 11;
set(ax5, 'XTick', x_ticks);
y_ticks_3 = get(ax5, 'YTick');
set(ax5, 'YTick', y_ticks_3);
rho5 = corr(L1, RE1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho5), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(e)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax7 = subplot(4, 2, 7);
plot(L1,RS1,'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
ylabel({'Sexual eggs'; 'as a rate'}, 'FontSize', 11);
fourth_row_axes = [fourth_row_axes, ax7];
ax7.YTick = [0, 0.4, 0.8];
ax7.XAxis.FontSize = 11;
ax7.YAxis.FontSize = 11;
set(ax7, 'XTick', x_ticks);
y_ticks_4 = get(ax7, 'YTick');
set(ax7, 'YTick', y_ticks_4);
rho7 = corr(L1, RS1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho7), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(g)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% 2nd column: queens vary in allocation to reproduction (within reason)
x2 = x(ddists(prob_dist, 250));

% Adjust the call to matthew_with_seasonality to match the initial call structure
params2 = ones(size(x2(:))) * [a1 a2 a3 mu_q0 mu_w];

[L2, TE2, TS2, RE2, RS2] = matthew_with_seasonality(params2, x2(:), t_sexual);

ax2 = subplot(4, 2, 2);
plot(L2, TE2, 'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
title({'Variable{\it x}'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax2];
set(ax2, 'XLim', [min(L2), max(L2)]);
set(gca, 'YTickLabel', []);
x_ticks_2 = get(ax2, 'XTick');
set(ax2, 'XTick', x_ticks_2);
set(ax2, 'YTick', y_ticks_1);
rho2 = corr(L2, TE2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho2), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(b)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax4 = subplot(4, 2, 4);
plot(L2, TS2, 'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
second_row_axes = [second_row_axes, ax4];
set(ax4, 'XLim', [min(L2), max(L2)]);
set(gca, 'YTickLabel', []);
set(ax4, 'XTick', x_ticks_2);
set(ax4, 'YTick', y_ticks_2);
rho4 = corr(L2, TS2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho4), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(d)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax6 = subplot(4, 2, 6);
plot(L2, RE2, 'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
third_row_axes = [third_row_axes, ax6];
set(ax6, 'XLim', [min(L2), max(L2)]);
set(gca, 'YTickLabel', []);
set(ax6, 'XTick', x_ticks_2);
set(ax6, 'YTick', y_ticks_3);
rho6 = corr(L2, RE2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho6), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(f)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax8 = subplot(4, 2, 8);
plot(L2, RS2, 'b.');
xline(t_sexual, 'k:', 'LineWidth', 1.5);
fourth_row_axes = [fourth_row_axes, ax8];
set(ax8, 'XLim', [min(L2), max(L2)]);
set(gca, 'YTickLabel', []);
ax8.XAxis.FontSize = 11;
set(ax8, 'XTick', x_ticks_2);
set(ax8, 'YTick', y_ticks_4);
rho8 = corr(L2, RS2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho8), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(h)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% Link y-axis for each row
linkaxes(top_row_axes, 'y');
linkaxes(second_row_axes, 'y');
linkaxes(third_row_axes, 'y');
linkaxes(fourth_row_axes, 'y');

% Hide x-axis labels for upper three rows
set([ax1, ax2, ax3, ax4, ax5, ax6], 'XTickLabel', []);
set([ax7, ax8], 'XTickLabelMode', 'auto');

% Set y-axis limits
set(top_row_axes, 'YLim', [0 1500]);
set(second_row_axes, 'YLim', [0 500]);
set(third_row_axes, 'YLim', [0 5]);
set(fourth_row_axes, 'YLim', [0 0.8]);

% Add common x-axis label
han = axes(fig, 'visible', 'off'); 
han.XLabel.Visible='on';
xlabel(han,'Queen lifespan', 'FontSize', 14);
set(han, 'Position', [0.018, 0.1, 1, 1]);

% Add common y-axis label on the left
han_left = axes(fig, 'visible', 'off');
han_left.YLabel.Visible = 'on';
ylabel(han_left,'What measure of queen fecundity do researchers use?', 'FontSize', 14);
set(han_left, 'Position', [0.08, -0.01, 1, 1]);

% Add a common title for the entire figure
sgtitle('       What values of \it{x} \rm{do queens use?}', 'FontSize', 14);
