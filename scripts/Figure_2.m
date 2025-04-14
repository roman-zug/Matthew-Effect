% Script: Figure_2
% 
% Purpose: This script plots Figure 2, which shows queen fitness on the 
% x-y plane. (a) Production of sexual eggs for 1 simulation run; 
% (b) production of sexual eggs for 'num_simulations' simulation runs.

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
y = 1:50; % sexual threshold
[x, y] = meshgrid(x, y);

params = ones(size(x(:))) * params;

num_simulations = 100;

for k = 1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew(params, x(:), y(:));
    L(:,:,k) = reshape(lifespan, size(x));
    TE(:,:,k) = reshape(total_eggs, size(x));
    TS(:,:,k) = reshape(total_sexuals, size(x));
    RE(:,:,k) = reshape(rate_eggs, size(x));
    RS(:,:,k) = reshape(rate_sexuals, size(x));
end

TSmean = mean(TS, 3);

% Plotting
fig = figure(1); clf;
figureWidth = 1000;
figureHeight = 490;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

% Calculate the overall color limits
min_c = min([log(TS(:, :, 1) + 1), log(TSmean + 1)], [], 'all');
max_c = max([log(TS(:, :, 1) + 1), log(TSmean + 1)], [], 'all');

subplot(1, 2, 1);
s1a = surf(x, y, log(TS(:, :, 1) + 1));
view([0 90]);
clim([min_c max_c]); % set the color axis limits
set(gca, 'YTick', 0:10:50, 'FontSize', 11);
ylabel('Sexual threshold,{\it y}', 'FontSize', 14);
title('1 simulation run', 'FontSize', 14, 'FontWeight', 'normal');
s1a.EdgeColor = 'none';
text(0.02, 1.07, '(a)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Adjust position of the first subplot
pos1 = get(gca, 'Position');
pos1(3) = 0.38; % Width of the first subplot
pos1(4) = 0.76;
set(gca, 'Position', pos1);

subplot(1, 2, 2);
s1b = surf(x, y, log(TSmean + 1));
view([0 90]);
clim([min_c max_c]);
set(gca, 'YTickLabel', [], 'YTick', []);
set(gca, 'FontSize', 11);
title('100 simulation runs', 'FontSize', 14, 'FontWeight', 'normal');
s1b.EdgeColor = 'none';
text(0.02, 1.07, '(b)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Adjust position of the second subplot
pos2 = get(gca, 'Position');
pos2(1) = 0.54; % Move the second subplot closer to the first subplot
pos2(3) = 0.38; % Width of the second subplot
pos2(4) = 0.76;
set(gca, 'Position', pos2);

h = colorbar;
h.Position = [0.93, 0.11, 0.02, 0.76];
h.FontSize = 11;

% Colorbar ticks
log_ticks = [0, log([10^0, 10^1, 10^2, 10^3] + 1)];
h.Ticks = log_ticks;
h.TickLabels = {'0', '1', '10', '100', '1000'};

% Add a common title for the entire figure
sgtitle('       Lifetime production of sexual eggs', 'FontWeight', 'bold', 'FontSize', 14);

% Add common x-axis label
han = axes(fig, 'visible', 'off'); 
han.XLabel.Visible='on';
xlabel(han,'Allocation to reproduction,{\it x}', 'FontSize', 14);
set(han, 'Position', [0.018, 0.1, 1, 1]);
