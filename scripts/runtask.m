% Script: runtask
%
% Purpose: This script accesses 'task.mat', runs the function 'matthew' on 
% the 50 different parameter sets saved in 'task.mat', and saves the result 
% as 'task.mat', which is accessed by the script 'collate_fitness'. 
% 'runtask' is an auxiliary script to plot Figures 5, S2, and S3.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load task.mat;

fprintf('Progress: %.2f%% remaining\n', mean(isnan(L)) * 100);

[lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew(params, x, y);

L = lifespan;
TE = total_eggs;
TS = total_sexuals;
RE = rate_eggs;
RS = rate_sexuals;

all_done = 1;
save task.mat;