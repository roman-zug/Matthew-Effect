% Script: Figure_3
%
% Purpose: This script plots Figure 3, which shows queen lifespan and
% different measures of queen fecundity on the x-y plane. (a) Lifespan, 
% (b) production of total eggs per lifespan, (c) production of total eggs 
% as a rate, and (d) production of sexual eggs as a rate.

clear;
addpath('../functions'); % Add the "functions" folder to the search path

% Define parameters
a1 = 1; % Parameter adjusting how important help by workers is to keep the queen alive
a2 = 1; % Parameter adjusting how many workers are needed to create a significant shift towards a longer-lived queen
a3 = 1; % Parameter describing the strength of the positive effect of a large workforce on queen productivity
mu_q0 = 0.005; % queen baseline mortality
mu_w = 0.1; % worker mortality
params = [a1, a2, a3, mu_q0, mu_w];

x = 0.01:0.01:0.99; % allocation into reproduction
y = 1:50; % sexual threshold
[x, y] = meshgrid(x, y);

params = ones(size(x(:))) * params;

num_simulations = 2;

for k = 1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew(params, x(:), y(:));
    L(:,:,k) = reshape(lifespan, size(x));
    TE(:,:,k) = reshape(total_eggs, size(x));
    TS(:,:,k) = reshape(total_sexuals, size(x));
    RE(:,:,k) = reshape(rate_eggs, size(x));
    RS(:,:,k) = reshape(rate_sexuals, size(x));
end

Lmean = mean(L, 3);
TEmean = mean(TE, 3);
TSmean = mean(TS, 3);
REmean = mean(RE, 3);
RSmean = mean(RS, 3);

fig = figure(1);
figureWidth = 1000;
figureHeight = 850;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

subplot(2, 2, 1);
s2a = surf(x, y, log(Lmean + 1));
view([0 90]);
cb1 = colorbar;
cb1.Position = [0.443, 0.576, 0.0225, 0.3412];
cb1.FontSize = 11;
set(gca, 'XTickLabel', []);
set(gca, 'YTick', 0:10:50, 'FontSize', 11);
yticks_1 = get(gca, 'YTick');
title({'Queen'; 'lifespan'}, 'FontSize', 14);
s2a.EdgeColor = 'none';
text(-0.03, 1.172, '(a)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Colorbar showing the original (non-log-transformed) values
cb1_ticks = cb1.Ticks;
cb1_tick_labels = exp(cb1_ticks) - 1;
cb1.TickLabels = arrayfun(@(x) sprintf('%.2f', x), cb1_tick_labels, 'UniformOutput', false);

% Adjust position of the colorbar
cb1.Position = cb1.Position - [0.01 0 0 0];  % Shift it left a bit

% Adjust position of the whole figure
pos1 = get(gca, 'Position'); % Position: left bottom width height
pos1(1) = 0.08;
pos1(2) = 0.577;
pos1(3) = 0.34;
pos1(4) = 0.34;
set(gca, 'Position', pos1);

subplot(2, 2, 2);
s2b=surf(x, y, log(TEmean + 1));
view([0 90]);
cb2 = colorbar;
cb2.Position = [0.924, 0.576, 0.0225, 0.3412];
cb2.FontSize = 11;
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'YTick', yticks_1);
title({'Lifetime production'; 'of total eggs'}, 'FontSize', 14);
s2b.EdgeColor = 'none';
text(-0.03, 1.172, '(b)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Colorbar showing the original (non-log-transformed) values
cb2_ticks = cb2.Ticks;
cb2_tick_labels = exp(cb2_ticks) - 1;
cb2.TickLabels = arrayfun(@(x) sprintf('%.2f', x), cb2_tick_labels, 'UniformOutput', false);

% Adjust position of the colorbar
cb2.Position = cb2.Position - [0.01 0 0 0];  % Shift it left a bit

% Adjust position of the whole figure
pos2 = get(gca, 'Position'); % Position: left bottom width height
pos2(1) = 0.56;
pos2(2) = 0.577;
pos2(3) = 0.34;
pos2(4) = 0.34;
set(gca, 'Position', pos2);

subplot(2, 2, 3);
s2c=surf(x, y, log(REmean + 1));
view([0 90]);
cb3 = colorbar;
cb3.Position = [0.443, 0.13, 0.0225, 0.3412];
cb3.FontSize = 11;
set(gca, 'YTick', 0:10:50, 'FontSize', 11);
yticks_3 = get(gca, 'YTick');
title({'Production of total eggs'; 'as a rate'}, 'FontSize', 14);
s2c.EdgeColor = 'none';
text(-0.03, 1.172, '(c)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Colorbar showing the original (non-log-transformed) values
cb3_ticks = cb3.Ticks;
cb3_tick_labels = exp(cb3_ticks) - 1;
cb3.TickLabels = arrayfun(@(x) sprintf('%.2f', x), cb3_tick_labels, 'UniformOutput', false);

% Adjust position of the colorbar
cb3.Position = cb3.Position - [0.01 0 0 0];  % Shift it left a bit

% Adjust position of the whole figure
pos3 = get(gca, 'Position'); % Position: left bottom width height
pos3(1) = 0.08;
pos3(2) = 0.13;
pos3(3) = 0.34;
pos3(4) = 0.34;
set(gca, 'Position', pos3);

subplot(2, 2, 4);
s2d=surf(x, y, log(RSmean + 1));
view([0 90]);
cb4 = colorbar;
cb4.Position = [0.924, 0.13, 0.0225, 0.3412];
cb4.FontSize = 11;
set(gca, 'FontSize', 11);
set(gca, 'YTickLabel', []);
set(gca, 'YTick', yticks_3);
title({'Production of sexual eggs'; 'as a rate'}, 'FontSize', 14);
s2d.EdgeColor = 'none';
text(-0.03, 1.172, '(d)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Colorbar showing the original (non-log-transformed) values
cb4_ticks = cb4.Ticks;
cb4_tick_labels = exp(cb4_ticks) - 1;
cb4.TickLabels = arrayfun(@(x) sprintf('%.2f', x), cb4_tick_labels, 'UniformOutput', false);

% Adjust position of the colorbar
cb4.Position = cb4.Position - [0.01 0 0 0];  % Shift it left a bit

% Adjust position of the whole figure
pos4 = get(gca, 'Position'); % Position: left bottom width height
pos4(1) = 0.56;
pos4(2) = 0.13;
pos4(3) = 0.34;
pos4(4) = 0.34;
set(gca, 'Position', pos4);

% Add common x-axis label
han_x = axes(fig, 'visible', 'off'); 
han_x.XLabel.Visible='on';
xlabel(han_x,'Allocation to reproduction, {\it x}', 'FontSize', 14);
set(han_x, 'Position', [0.018, 0.12, 1, 1]);

% Add common y-axis label
han_y = axes(fig, 'visible', 'off'); 
han_y.YLabel.Visible='on';
ylabel(han_y,'Sexual threshold, {\it y}', 'FontSize', 14);
set(han_y, 'Position', [0.07, 0.03, 1, 1]);
