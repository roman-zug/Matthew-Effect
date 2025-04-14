% Script: Figure_S2
% 
% Purpose: This script plots Supplementary Figure S2, which shows two
% measures of late performance (total production of sexuals and queen 
% lifespan) as a function of early performance ('initialluck', which is the
% sum of the workforce size measured over the first 10 events in a colony 
% life cycle). The script accesses the output from the script 'luck_matters', 
% called 'luck_matters.mat'.

clear;
load luck_matters.mat

cS = polyfit(initialluck, log(S + 1), 1);
cL = polyfit(initialluck, log(L), 1);

I = 0:55;

yS = exp(polyval(cS, I)) - 1;
yL = exp(polyval(cL, I));

% Plotting
fig = figure(1); clf;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

tiledlayout(1, 2);

nexttile;
plot(initialluck, S, 'o', I, yS);
xlabel('Initial workforce development', 'FontSize', 14);
ylabel('Total production of sexuals', 'FontSize', 14);

nexttile;
plot(initialluck, L, 'o', I, yL);
xlabel('Initial workforce development', 'FontSize', 14);
ylabel('Queen lifespan', 'FontSize', 14);
