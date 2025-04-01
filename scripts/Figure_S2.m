% Script: Figure_S2
% 
% This script plots Supplementary Figure S2, which shows the number of
% negative correlations a species managed to produce as a function of
% different parameters (a1, a2, a3, mu_Q0, mu_W) that together describe the
% rules of life of that species. A negatvie correlation means that the
% trade-off has been unmasked.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load categories.mat;

fig = figure(1); clf;
figureWidth = 800;
figureHeight = 1000;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

% Some exploration of when to expect negative correlations
negscore = sum(TEcorr' < 0) + sum(TScorr' < 0) + sum(REcorr' < 0) + sum(RScorr' < 0);

subplot(5, 1, 1);
plot(P(:, 1), negscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel({'Parameter adjusting how important help by workers is'; 'to keep the queen alive,{\it a}_1'});
xticks([0 1 2 3 4 5]);
set(gca, 'FontSize', 12);

subplot(5, 1, 2);
plot(P(:, 2), negscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel({'Parameter adjusting how many workers are needed'; 'to create a significant shift towards a longer-lived queen,{\it a}_2'});
xticks([0 1 2 3 4]);
set(gca, 'FontSize', 12);

subplot(5, 1, 3);
plot(P(:, 3), negscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel({'Parameter describing the strength of the positive effect'; 'of a large workforce on queen productivity,{\it a}_3'});
xticks([0 1 2 3]);
set(gca, 'FontSize', 12);

subplot(5, 1, 4);
plot(P(:, 4), negscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel('Queen baseline mortality, \mu_{Q0}', 'Interpreter', 'tex');
set(gca, 'FontSize', 12);

subplot(5, 1, 5);
plot(P(:, 5), negscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel('Worker mortality, \mu_W', 'Interpreter', 'tex');
xticks([0 0.1 0.2 0.3 0.4 0.5]);
set(gca, 'FontSize', 12);

% Add common y-axis label on the left
han_left = axes(fig, 'visible', 'off');
han_left.YLabel.Visible = 'on';
ylabel(han_left,'Number of negative correlations');
%set(han_left, 'Position', [0.1, -0.01, 1, 1]);
set(gca, 'FontSize', 12);
