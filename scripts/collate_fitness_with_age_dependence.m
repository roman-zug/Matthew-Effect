% Script: collate_fitness_with_age_dependence
% 
% Purpose: This script uses the output from 'runtask_with_age_dependence' 
% called 'task_with_age_dependence.mat' (i.e., the output from 
% 'matthew_with_age_dependence' run on 50 different parameter sets) to compute 
% a fitness matrix W (fitness measure: mean number of total sexuals) for 
% those different parameter sets, with age dependence, which means that 
% production of sexual eggs does not start above sexual threshold y (there 
% is no such threshold in the model version with age dependence), but rather 
% after a given time point called 't_sexual'. The matrix W stores mean 
% fitness for each x value for each parameter combination. Output is saved 
% as 'collated_with_age_dependence.mat', which is accessed by the script 
% 'categorize_with_age_dependence'. 'collate_fitness_with_age_dependence' is an 
% auxiliary script to plot Supplementary Figure S9.

clear;
load task_with_age_dependence.mat;

W = nan([length(xvalues) nof_combos]); 
bestW = nan([1 nof_combos]);

for c = 1:nof_combos
    for i = 1:length(xvalues)
        f = find(~isnan(L) & combo == c & abs(x - xvalues(i)) < 0.01);
        if ~isempty(f)
            W(i, c) = mean(TS(f));
            bestW(c) = max([W(i, c), bestW(c)]);
        end
    end

    % Normalization: best value will be 1 hereafter
    if ~isnan(bestW(c)) && bestW(c) ~= 0 % Normalize only if bestW(c) is valid
        W(:, c) = W(:, c) / bestW(c); 
    else
        fprintf('Warning: bestW(%d) is NaN or zero, skipping normalization.\n', c);
    end
end

% Final check for any fully NaN layers
fully_NaN_layers = find(all(isnan(W), 1));
if ~isempty(fully_NaN_layers)
    fprintf('Final check: Layers entirely NaN: %s\n', num2str(fully_NaN_layers));
else
    fprintf('Final check: No layers are entirely NaN.\n');
end

save collated_with_age_dependence.mat
