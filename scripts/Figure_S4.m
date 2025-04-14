% Script: Figure_S4
% 
% This script plots Supplementary Figure S4, which shows the masking index
% (mean of the correlations across all 16 subplots in Figure 5) as a
% function of the queen-to-worker lifespan ratio mu_W/mu_Q0. A high masking
% index means that unmasking is very difficult. The script accesses the 
% output from the script 'categorize', called 'categories.mat'.

clear;
load categories.mat;

fig = figure(1); clf;

% Some exploration of when to expect negative correlations
roughscore = (mean(TEcorr', 'omitnan') + mean(TScorr', 'omitnan') + mean(REcorr','omitnan') + mean(RScorr','omitnan')) / 4;
semilogx(P(:,5) ./ P(:,4), roughscore, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
set(gca, 'FontSize', 12);
xlabel('Queen-to-worker lifespan ratio, \mu_W/\mu_{Q0}', 'Interpreter', 'tex', 'FontSize', 14);
ylabel('Masking index', 'FontSize', 14);
