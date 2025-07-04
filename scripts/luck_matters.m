% Script: luck_matters
% 
% Purpose: This script runs matthew.m for 1000 colonies, using the optimal
% {x*, y*} combination from Figure_4, to compute a measure of early 
% performance called 'initialluck', which is the sum of the workforce size
% measured over the first 10 events in a colony life cycle. If all events 
% are "a worker is added" then one has 1+2+3+4+5+6+7+8+9+10 = 55, which is 
% the luckiest start ever, while if some of the events involve deaths 
% then the initial luck is lower. Output is saved as 'luck_matters.mat',
% which is accessed by the script 'Figure_S2'. The script 'luck_matters' 
% is an auxiliary script to plot Figure S2.

clear;
addpath('../functions'); % Add the "functions" folder to the search path

% Define parameters
a1 = 1; % Parameter adjusting how important help by workers is to keep the queen alive
a2 = 1; % Parameter adjusting how many workers are needed to create a significant shift towards a longer-lived queen
a3 = 1; % Parameter describing the strength of the positive effect of a large workforce on queen productivity
mu_q0 = 0.005; % queen baseline mortality
mu_w = 0.1; % worker mortality
params = [a1, a2, a3, mu_q0, mu_w];

xopt = 0.7524; % same xopt value as in Figure_4.m
yopt = 9.9091; % same yopt value as in Figure_4.m

for i=1:1000
    i
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals, t_series, eggs_series, sexuals_series, workforce_series] = matthew(params, xopt, yopt);
    initialluck(i) = sum(workforce_series(1:min(10,length(workforce_series))));
    L(i) = lifespan;
    S(i) = total_sexuals;
end

save('luck_matters.mat', 'L', 'S', 'initialluck');
