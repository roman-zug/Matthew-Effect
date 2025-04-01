% Script: Figure_S6
% 
% Purpose: This script plots Supplementary Figure S6, which shows queen lifespan and
% different measures of queen fecundity as a function of x, with seasonality, 
% which means that production of sexual eggs does not start above sexual 
% threshold y (there is no such threshold in the model version with 
% seasonality), but rather after a given time point called 't_sexual'. 
% (a) Lifespan, (b) production of total eggs per lifespan, (c) production 
% of total eggs as a rate, and (d) production of sexual eggs as a rate.

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

num_simulations = 500;

% Store all simulation runs
L_all = zeros(num_simulations, length(x));
TE_all = zeros(num_simulations, length(x));
RE_all = zeros(num_simulations, length(x));
RS_all = zeros(num_simulations, length(x));

for k = 1:num_simulations
    k
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew_with_seasonality(params, x(:), t_sexual);
    % Store results from each run
    L_all(k, :) = lifespan';
    TE_all(k, :) = total_eggs';
    RE_all(k, :) = rate_eggs';
    RS_all(k, :) = rate_sexuals';
end

% Compute mean across simulations
Lmean = mean(L_all, 1);
TEmean = mean(TE_all, 1);
REmean = mean(RE_all, 1);
RSmean = mean(RS_all, 1);

% Plotting
fig = figure(1); clf;
figureWidth = 1000;
figureHeight = 850;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

subplot(2, 2, 1);
plot(x, Lmean, 'b-', 'LineWidth', 2);
set(gca, 'XTickLabel', []);
ylabel('Queen lifespan', 'FontSize', 14);
text(-0.25, 1.05, '(a)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

subplot(2, 2, 2);
plot(x, TEmean, 'b-', 'LineWidth', 2);
set(gca, 'XTickLabel', []);
ylabel('Lifetime production of total eggs', 'FontSize', 14);
text(-0.25, 1.05, '(b)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

subplot(2, 2, 3);
plot(x, REmean, 'b-', 'LineWidth', 2);
ylabel('Production of total eggs as a rate', 'FontSize', 14);
text(-0.25, 1.05, '(c)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

subplot(2, 2, 4);
plot(x, RSmean, 'b-', 'LineWidth', 2);
ylabel('Production of sexual eggs as a rate', 'FontSize', 14);
text(-0.25, 1.05, '(d)', 'Units', 'normalized', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

% Add common x-axis label
han_x = axes(fig, 'visible', 'off'); 
han_x.XLabel.Visible='on';
xlabel(han_x,'Allocation to reproduction, {\it x}', 'FontSize', 14);
set(han_x, 'Position', [0.018, 0.11, 1, 1]);

% Common title
sgtitle('Queen lifespan and various measures of queen fecundity', ...
    'FontWeight', 'bold', 'FontSize', 14);
