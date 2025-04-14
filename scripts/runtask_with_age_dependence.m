% Script: runtask_with_age_dependence
% 
% Purpose: This script accesses 'task_with_age_dependence.mat', runs the 
% function 'matthew_with_age_dependence' on the 50 different parameter sets 
% saved in 'task_with_age_dependence.mat', and saves the result as
% 'task_with_age_dependence.mat', which is accessed by the script
% 'collate_fitness_with_age_dependence', with age dependence, which means that 
% production of sexual eggs does not start above sexual threshold y 
% (there is no such threshold in the model version with age dependence), but 
% rather after a given time point called 't_sexual'. 'runtask_with_age_dependence' 
% is an auxiliary script to plot Supplementary Figure S9.

clear;
load task_with_age_dependence.mat;

t_sexual = 200;

% Initialize progress tracking
total_steps = 100; % Set to the total number of steps you want to track
current_step = 1;

% Update progress in a loop or after significant steps
fprintf('Progress: %.2f%% remaining\n', 100);

for step = 1:total_steps
    [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals] = matthew_with_age_dependence(params, x, t_sexual);

    L = lifespan;
    TE = total_eggs;
    TS = total_sexuals;
    RE = rate_eggs;
    RS = rate_sexuals;

    all_done = 1;

    % Save periodically or at the end
    if mod(step, 10) == 0  % Example: save every 10 steps
        save task_with_age_dependence.mat;
    end

    % Update progress in the command window
    fprintf('Progress: %.2f%% remaining\n', (current_step / total_steps) * 100);
    current_step = current_step + 1;
end

save task_with_age_dependence.mat;
