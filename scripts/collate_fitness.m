% Script: collate_fitness
% 
% Purpose: This script uses the output from 'runtask' called 'task.mat' 
% (i.e., the output from 'matthew' run on 50 different parameter sets) to 
% compute a fitness matrix W (fitness measure: mean number of total sexuals) 
% for those different parameter sets. The matrix W stores mean fitness 
% for each {x, y} pair for each parameter combination. Output is saved as
% 'collated.mat', which is accessed by the script 'categorize'. 
% 'collate_fitness' is an auxiliary script to plot Figure 5.

clear;
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load task.mat

W = nan([length(xvalues) length(yvalues) nof_combos]);
bestW = nan([1 nof_combos]);

for c = 1:nof_combos
    c
    for i = 1:length(xvalues)
        for j = 1:length(yvalues)
            f = find(~isnan(L) & combo == c & abs(x - xvalues(i)) < 0.01 & abs(y - yvalues(j)) < 0.5);
            if ~isempty(f)
                W(i, j, c) = mean(TS(f));
                bestW(c) = max([W(i, j, c), bestW(c)]);
            end
        end
    end
    W(:, :, c) = W(:, :, c) / bestW(c); % best value will be 1 after this normalization
    
end
save collated.mat
