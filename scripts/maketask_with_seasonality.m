% Script: maketask_with_seasonality
% 
% Purpose: This script generates a dataset called 'task_with_seasonality.mat' 
% that contains 50 sets of random parameter combinations (a1, a2, a3, mu_q0,
% mu_w), corresponsing to 50 hypothetical species, with seasonality, which 
% means that production of sexual eggs does not start above sexual threshold y, 
% (there is no such threshold in the model version with seasonality), but 
% rather after a given time point called 't_sexual'. 'task_with_seasonality.mat' 
% is accessed by the script 'runtask_with_seasonality'. 'maketask_with_seasonality' 
% is an auxiliary script to plot Supplementary Figure S8.

clear;
% Define x values
xvalues = linspace(0.001, 0.999, 51); essential_x = 1:10:51;

nof_combos = 50; % Number of different parameter sets

% Random model parameters, drawn from an exponential distribution
a1 = exprnd(1, nof_combos, 1);
a2 = exprnd(1, nof_combos, 1);
a3 = exprnd(1, nof_combos, 1);
mu_q0 = exprnd(0.005, nof_combos, 1);
mu_w = exprnd(0.1, nof_combos, 1);

ind = 1;
rounds = 5;
cases = nof_combos * rounds * length(xvalues);
combo = zeros([cases 1]);
params = zeros([cases 5]);
essential = zeros([cases 1]);
x = zeros([cases 1]);
round = zeros([cases 1]);

for i = 1:nof_combos
    for j = 1:length(xvalues)
        for l = 1:rounds
            combo(ind) = i;
            params(ind, :) = [a1(i) a2(i) a3(i) mu_q0(i) mu_w(i)];
            essential(ind) = any(j == essential_x);
            x(ind) = xvalues(j);
            round(ind) = l;
            ind = ind + 1;
        end
    end
end

ind = ind - 1;

L = nan([ind 1]);
TE = L;
TS = L;
RE = L;
RS = L;

all_done = 0;

save task_with_seasonality.mat


