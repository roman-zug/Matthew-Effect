% Script: Figure_4
%
% Purpose: This script plots Figure 4, which shows the correlation between
% queen lifespan and fecundity, for different measures of queen fecundity
% (rows) and different (x, y) combinations used queens (columns).

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

num_simulations = 2;

for k=1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew(params, x(:), y(:));
    TS(:,:,k) = reshape(total_sexuals, size(x));
end

TSmean = mean(TS, 3);

% Optimization
[xopt, yopt, max_value, iopt, jopt] = find_optimum(TSmean, x, y);

% Plotting
fig = figure(1); clf;
grid on;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

% Array to hold axes handles for each row
top_row_axes = [];
second_row_axes = [];
third_row_axes = [];
fourth_row_axes = [];

% 1st column: every queen uses the optimum
x1 = xopt * ones([1 250]);
y1 = yopt * ones([1 250]);

% Adjust the call to matthew to match the initial call structure
params1 = ones(size(x1(:))) * [a1 a2 a3 mu_q0 mu_w];

[L1, TE1, TS1, RE1, RS1] = matthew(params1, x1(:), y1(:));

ax1 = subplot(4, 4, 1);
plot(L1, TE1, 'b.');
ylabel({'Total eggs'; 'over lifetime'}, 'FontSize', 11);
title({'Optimal{\it x}*,'; 'optimal{\it y}*'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax1];
ax1.YAxis.Exponent = 3;
ax1.YTick = [0, 2000, 4000];
ax1.YAxis.FontSize = 11;
rho1 = corr(L1, TE1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho1), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(a)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax5 = subplot(4, 4, 5);
plot(L1,TS1,'b.');
ylabel({'Sexual eggs'; 'over lifetime'}, 'FontSize', 11);
second_row_axes = [second_row_axes, ax5];
ax5.YAxis.Exponent = 3;
ax5.YTick = [0, 1000, 2000];
ax5.YAxis.FontSize = 11;
rho5 = corr(L1, TS1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho5), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(e)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax9 = subplot(4, 4, 9);
plot(L1,RE1,'b.');
ylabel({'Total eggs'; 'as a rate'}, 'FontSize', 11);
third_row_axes = [third_row_axes, ax9];
ax9.YTick = [0, 2, 4];
ax9.YAxis.FontSize = 11;
rho9 = corr(L1, RE1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho9), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(i)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax13 = subplot(4, 4, 13);
plot(L1,RS1,'b.');
ylabel({'Sexual eggs'; 'as a rate'}, 'FontSize', 11);
fourth_row_axes = [fourth_row_axes, ax13];
ax13.YTick = [0, 1, 2];
ax13.XAxis.FontSize = 11;
ax13.YAxis.FontSize = 11;
rho13 = corr(L1, RS1, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho13), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(m)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% 2nd column: queens vary in sexual threshold (within reason)
x2 = xopt * ones([1 250]);
y2 = y(ddists(TSmean(:, jopt), 250), 1)';

params2 = ones(size(x2(:))) * [a1 a2 a3 mu_q0 mu_w];

[L2, TE2, TS2, RE2, RS2] = matthew(params2, x2(:) ,y2(:));

ax2 = subplot(4, 4, 2);
plot(L2, TE2, 'b.');
title({'Optimal{\it x}*,'; 'variable{\it y}'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax2];
set(gca, 'YTickLabel', []);
rho2 = corr(L2, TE2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho2), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(b)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax6 = subplot(4, 4, 6);
plot(L2, TS2, 'b.'); %hold on
second_row_axes = [second_row_axes, ax6];
set(gca, 'YTickLabel', []);
rho6 = corr(L2, TS2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho6), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(f)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax10 = subplot(4, 4, 10);
plot(L2, RE2, 'b.');
third_row_axes = [third_row_axes, ax10];
set(gca, 'YTickLabel', []);
rho10 = corr(L2, RE2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho10), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(j)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax14 = subplot(4, 4, 14);
plot(L2, RS2, 'b.');
fourth_row_axes = [fourth_row_axes, ax14];
set(gca, 'YTickLabel', []);
ax14.XAxis.FontSize = 11;
rho14 = corr(L2, RS2, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho14), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(n)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% 3nd column: queens vary in allocation to reproduction (within reason)
x3 = x(1, ddists(TSmean(iopt, :), 250));
y3 = yopt * ones([1 250]);

params3 = ones(size(x3(:))) * [a1 a2 a3 mu_q0 mu_w];

[L3, TE3, TS3, RE3, RS3] = matthew(params3, x3(:), y3(:));

ax3 = subplot(4, 4, 3);
plot(L3, TE3, 'b.');
title({'Variable{\it x},'; 'optimal{\it y}*'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax3];
set(gca, 'YTickLabel', []);
rho3 = corr(L3, TE3, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho3), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(c)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax7 = subplot(4, 4, 7);
plot(L3, TS3, 'b.');
second_row_axes = [second_row_axes, ax7];
set(gca, 'YTickLabel', []);
rho7 = corr(L3, TS3, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho7), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(g)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax11 = subplot(4, 4, 11);
plot(L3, RE3, 'b.');
third_row_axes = [third_row_axes, ax11];
set(gca, 'YTickLabel', []);
rho11 = corr(L3, RE3, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho11), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(k)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax15 = subplot(4, 4, 15);
plot(L3, RS3, 'b.');
fourth_row_axes = [fourth_row_axes, ax15];
set(gca, 'YTickLabel', []);
ax15.XAxis.FontSize = 11;
rho15 = corr(L3, RS3, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho15), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(o)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% 4th column: queens vary in everything (within reason)
xall = x(:);
yall = y(:);
sample = ddists(TSmean(:), 250);
x4 = xall(sample)';
y4 = yall(sample)';

params4 = ones(size(x4(:))) * [a1 a2 a3 mu_q0 mu_w];

[L4, TE4, TS4, RE4, RS4] = matthew(params4, x4(:), y4(:));

ax4 = subplot(4, 4, 4);
plot(L4, TE4, 'b.');
title({'Variable{\it x},'; 'variable{\it y}'}, 'FontSize', 11, 'FontWeight', 'normal');
top_row_axes = [top_row_axes, ax4];
set(gca, 'YTickLabel', []);
rho4 = corr(L4, TE4, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho4), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(d)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax8 = subplot(4, 4, 8);
plot(L4, TS4, 'b.');
second_row_axes = [second_row_axes, ax8];
set(gca, 'YTickLabel', []);
rho8 = corr(L4, TS4, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho8), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(h)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax12 = subplot(4, 4, 12);
plot(L4, RE4, 'b.');
third_row_axes = [third_row_axes, ax12];
set(gca, 'YTickLabel', []);
rho12 = corr(L4, RE4, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho12), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(l)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

ax16 = subplot(4, 4, 16);
plot(L4, RS4, 'b.');
fourth_row_axes = [fourth_row_axes, ax16];
set(gca, 'YTickLabel', []);
ax16.XAxis.FontSize = 11;
rho16 = corr(L4, RS4, 'Type', 'Spearman');
text(0.95, 0.95, sprintf('ρ = %.2f', rho16), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
text(0.05, 0.95, '(p)', 'Units', 'normalized', 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 11);

% Link y-axis for each row
linkaxes(top_row_axes, 'y');
linkaxes(second_row_axes, 'y');
linkaxes(third_row_axes, 'y');
linkaxes(fourth_row_axes, 'y');

% Make x-axis tick labels of upper three rows invisible
set(top_row_axes, 'XTickLabel', []);
set(second_row_axes, 'XTickLabel', []);
set(third_row_axes, 'XTickLabel', []);

% Set y-axis limits
set(top_row_axes, 'YLim', [0 4000]);
set(second_row_axes, 'YLim', [0 2000]);
set(third_row_axes, 'YLim', [0 4]);
set(fourth_row_axes, 'YLim', [0 2]);

% Add common x-axis label
han = axes(fig, 'visible', 'off'); 
han.XLabel.Visible='on';
xlabel(han,'Queen lifespan', 'FontSize', 14);
set(han, 'Position', [0.018, 0.1, 1, 1]);

% Add common y-axis label on the left
han_left = axes(fig, 'visible', 'off');
han_left.YLabel.Visible = 'on';
ylabel(han_left,'What measure of queen fecundity do researchers use?', 'FontSize', 14);
set(han_left, 'Position', [0.1, -0.01, 1, 1]);

% Add a common title for the entire figure
sgtitle('       What values of \it{x} \rm{and} \it{y} \rm{do queens use?}', 'FontSize', 14);

