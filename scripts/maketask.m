% Script: maketask
% 
% Purpose: This script generates a data set called 'task.mat' that 
% contains 50 sets of random parameter combinations (a1, a2, a3, mu_q0, mu_w), 
% corresponsing to 50 hypothetical species. 'task.mat' is accessed by the 
% script 'runtask'. 'maketask' is an auxiliary script to plot Figure 5.

clear;

% Define x and y values
xvalues = linspace(0.001, 0.999, 51); essential_x = 1:10:51;
yvalues = [1:50 60:10:100 150:50:500]; essential_y = 3:10:63;

nof_combos = 50; % Number of different parameter sets

% Random model parameters, drawn from an exponential distribution
a1 = exprnd(1, nof_combos, 1);
a2 = exprnd(1, nof_combos, 1);
a3 = exprnd(1, nof_combos, 1);
mu_q0 = exprnd(0.005, nof_combos, 1);
mu_w = exprnd(0.1, nof_combos, 1);

ind = 1;
rounds = 5;
cases = nof_combos * rounds * length(xvalues) * length(yvalues);
combo = zeros([cases 1]);
params = zeros([cases 5]);
essential = zeros([cases 1]);
x = zeros([cases 1]);
y = zeros([cases 1]);
round = zeros([cases 1]);

for i = 1:nof_combos
    for j = 1:length(xvalues)
        for k = 1:length(yvalues)
            for l = 1:rounds
                combo(ind) = i;
                params(ind, :) = [a1(i) a2(i) a3(i) mu_q0(i) mu_w(i)];
                essential(ind) = all([any(j == essential_x) any(k == essential_y)]);
                x(ind) = xvalues(j);
                y(ind) = yvalues(k);
                round(l) = l;
                ind = ind + 1;
            end
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

save task.mat;