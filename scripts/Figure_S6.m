% Script: Figure_S6
% 
% Purpose: This script plots Supplementary Figure S6, which shows queen 
% fitness as a function of x, with age dependence, which means that production 
% of sexual eggs does not start above sexual threshold y, 
% (there is no such threshold in this model version), but rather after 
% a given time point called 't_sexual'. The figure has 1x2 subplots. The
% left subplot shows the production of sexual eggs for 1 simulation run, 
% the right subplot shows the mean of 'num_simulations' simulation runs.

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

% Store all simulation runs
TS_all = zeros(num_simulations, length(x));

for k = 1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew_with_age_dependence(params, x(:), t_sexual);
    TS_all(k, :) = total_sexuals'; % Store results from each run
end

TSmean = mean(TS_all, 1);

% Spline fitting
p = 0.99; % Smoothing parameter (default: 0.99)
spline_fit = csaps(x, TSmean, p);

xx = linspace(min(x), max(x), 500); % Fine-grained x for smooth curve
y_fit = fnval(spline_fit, xx); % Evaluate the spline at new points

% Find maximum value and its x value
[y_max, idx_max] = max(y_fit);
x_max = xx(idx_max);

% If x_max exceeds 1, set it to 1 and recompute the corresponding y
if x_max > 1
    x_max = 1;
    y_max = fnval(spline_fit, x_max);  % Recalculate y at x = 1
end

% Calculate upper limit of y axis
y_max_single_run = max(TS_all(1, :));
y_buffer = 0.1 * y_max_single_run; % include 10% buffer
y_limit = y_max_single_run + y_buffer;

% Plotting
fig = figure(1); clf;
figureWidth = 1000;
figureHeight = 500;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

subplot(1, 2, 1);
pos = get(gca, 'Position');  % Get current position
set(gca, 'Position', [pos(1), pos(2) - 0.01, pos(3), pos(4)]);  % Move it down
plot(x, TS_all(1, :), 'bo', 'LineWidth', 1.5);
ylabel('Sexual eggs', 'FontSize', 14);
title('1 simulation run', 'FontSize', 14, 'FontWeight', 'normal');
ylim([0, y_limit]);
text(-0.18, 1.07, '(a)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Adjust position of the first subplot
pos1 = get(gca, 'Position');
pos1(1) = 0.09;
pos1(3) = 0.38; 
pos1(4) = 0.76;
set(gca, 'Position', pos1);

subplot(1, 2, 2);
pos = get(gca, 'Position');  % Get current position
set(gca, 'Position', [pos(1), pos(2) - 0.01, pos(3), pos(4)]);  % Move it down
plot(x, TSmean, 'b-', 'LineWidth', 2);
hold on;
plot(xx, y_fit, 'k-', 'LineWidth', 1);
plot(x_max, y_max, 'ro', 'MarkerFaceColor', 'r'); % Plot the maximum point
title(sprintf('%d simulation runs', num_simulations), 'FontSize', 14, 'FontWeight', 'normal');
ylim([0, y_limit]); % set the same y axis upper bound as in the left subplot
ylabel('');
text(-0.18, 1.07, '(b)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Adjust position of the second subplot
pos2 = get(gca, 'Position');
pos2(1) = 0.57;
pos2(3) = 0.38;
pos2(4) = 0.76;
set(gca, 'Position', pos2);

% Common title
sgtitle('Lifetime production of sexual eggs', 'FontWeight', 'bold', 'FontSize', 14);

% Common x-axis label
han = axes(fig, 'visible', 'off'); 
han.XLabel.Visible='on';
xlabel(han,'Allocation to reproduction,{\it x}', 'FontSize', 14);
set(han, 'Position', [0.018, 0.1, 1, 1]);
