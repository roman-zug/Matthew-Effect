% Script: Figure_S4
% 
% Purpose: This script plots Supplementary Figure S4, which shows an example
% of the ltemporal dynamics of a colony life cycle with seasonality, which
% means that production of sexual eggs does not start above sexual threshold y, 
% (there is no such threshold in the model version with seasonality), but 
% rather after a given time point called 't_sexual'. (a) Queen productivity 
% (both total and sexual eggs) over time; (b) workforce size over time.

clear;
addpath('../functions'); % Add the "functions" folder to the search path

% Define parameters
a1 = 1; % Parameter adjusting how important help by workers is to keep the queen alive
a2 = 1; % Parameter adjusting how many workers are needed to create a significant shift towards a longer-lived queen
a3 = 1; % Parameter describing the strength of the positive effect of a large workforce on queen productivity
mu_q0 = 0.005; % queen baseline mortality
mu_w = 0.1; % worker mortality
params = [a1, a2, a3, mu_q0, mu_w];

% Define values for x and t_sexual
x = 0.5; % allocation to reproduction
t_sexual = 200; % time point at which the production of sexual eggs begins

% Call the matthew function
[lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals, t_series, eggs_series, sexuals_series, workforce_series] = matthew_with_seasonality(params, x, t_sexual);

% Plotting
figure;

subplot(2,1,1);
h1 = plot(t_series, eggs_series, 'r', 'LineWidth', 2);
hold on;
h2 = plot(t_series, sexuals_series, 'b', 'LineWidth', 2);
xline(t_sexual, 'k:', 'LineWidth', 1.5);
ylabel('Queen productivity');
legend([h1, h2], {'Total eggs', 'Sexual eggs'}, 'Location', 'northwest');
%xlim([0 800]);
%ylim([0 2000]);
grid on;
set(gca, 'XTickLabel', []);
text(-0.15, 1.17, '(a)', 'Units', 'normalized', 'FontSize', 12, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

subplot(2,1,2);
plot(t_series, workforce_series, 'g', 'LineWidth', 2);
hold on;
xline(t_sexual, 'k:', 'LineWidth', 1.5);
xlabel('Time, {\it t}');
ylabel('Workforce, {\it n}');
%xlim([0 800]);
grid on;
text(-0.15, 1.17, '(b)', 'Units', 'normalized', 'FontSize', 12, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
