% Script: Figure_S2
% 
% Purpose: This script plots Supplementary Figure S2, which shows two
% measures of late performance (total production of sexuals and queen 
% lifespan) as a function of early performance ('initialluck', which is the
% sum of the workforce size measured over the first 10 events in a colony 
% life cycle). The script accesses the output from the script 'luck_matters', 
% called 'luck_matters.mat'.

clear;
load('/home/roman/Desktop/Matlab/Romants-I/JEB/mat files/luck_matters_20250703_03.mat')

% Fit linear models to log-transformed data
lmS = fitlm(initialluck, log(S + 1));
lmL = fitlm(initialluck, log(L));

% Extract coefficients for exponential curve
cS = flip(lmS.Coefficients.Estimate'); % [slope, intercept] for polyval
cL = flip(lmL.Coefficients.Estimate');

I = 0:55;

yS = exp(polyval(cS, I)) - 1;
yL = exp(polyval(cL, I));

% Plotting
fig = figure(1); clf;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

tiledlayout(1, 2);

% Function to annotate p and R²
annotate = @(lm) sprintf('p = %.3g\nR² = %.2f', ...
    lm.Coefficients.pValue(2), ...
    lm.Rsquared.Ordinary);

% First subplot: S
nexttile;
plot(initialluck, S, '.', I, yS, 'LineWidth', 1.5);
xlabel('Initial workforce development', 'FontSize', 14);
ylabel('Total production of sexuals', 'FontSize', 14);
text(0.05, 0.95, annotate(lmS), 'Units', 'normalized', 'FontSize', 12);

nexttile;
plot(initialluck, L, '.', I, yL, 'LineWidth', 1.5);
xlabel('Initial workforce development', 'FontSize', 14);
ylabel('Queen lifespan', 'FontSize', 14);
text(0.05, 0.95, annotate(lmL), 'Units', 'normalized', 'FontSize', 12);
