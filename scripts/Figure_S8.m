% Script: Figure_S8
% 
% This script plots Supplementary Figure S8, which shows the distribution 
% of correlations between queen lifespan and fecundity for different measures of queen 
% fecundity (rows) and optimal vs. variable x values used by queens (columns), with
% seasonality, which means that production of sexual eggs does not start 
% above sexual threshold y (there is no such threshold in the model version 
% with seasonality), but rather after a given time point called 't_sexual'.
% In each subplot, the x axis shows the Spearman correlation coefficient
% and the y axis shows the number of hypothetical species that show a given 
% correlation.

clear;
addpath('../functions'); % Add the "functions" folder to the search path
addpath('../mat-files'); % Add the "mat-files" folder to the search path
load categories_with_seasonality.mat

% Plotting
fig = figure(1); clf;
figureWidth = 1200;
figureHeight = 800;
set(fig, 'Position', [400, 100, figureWidth, figureHeight]);

x = -1.025:0.05:1.025; % Spearman correlation coefficient
xneg = x(x < 0);
xpos = x(x > 0);

yLimits = [0, 52];

% What values of x do queens use?
% Column 1: optimal x*
% Column 2: variable x
for column=1:2 
    % First row: total eggs over lifetime
    s1 = subplot(4, 2, 0 + column);
    nTE = hist(TEcorr(:, column), x);
    nTEneg = nTE(x < 0);
    nTEpos = nTE(x > 0);
    bar(xneg,nTEneg,'FaceColor', 'r','EdgeColor', 'r');
    hold on; 
    bar(xpos,nTEpos,'FaceColor', 'b','EdgeColor', 'b');
    xline(0, ':');
    hold off
    ylim(yLimits);
    if column == 1
        ylabel({'Total eggs'; 'over lifetime'}, 'FontSize', 11);
    end
    if column == 2
        set(gca, 'YAxisLocation', 'right', 'YTickMode', 'auto');
        set(gca, 'YTick', 0:25:50);
        set(gca, 'FontSize', 11);
    else
        set(gca, 'YTick', []);
    end
    switch column
        case 1, t = title('Optimal{\it x}*', 'FontSize', 11);
        case 2, t = title('Variable{\it x}', 'FontSize', 11);
    end
    set(t, 'FontWeight', 'normal');
    s1.XTickLabel={};

    % Second row: sexual eggs over lifetime
    s2 = subplot(4, 2, 2 + column);
    nTS = hist(TScorr(:, column), x);
    nTSneg = nTS(x < 0);
    nTSpos = nTS(x > 0);
    bar(xneg,nTSneg,'FaceColor', 'r','EdgeColor', 'r');
    hold on;
    bar(xpos,nTSpos,'FaceColor', 'b','EdgeColor', 'b'); 
    xline(0, ':');
    hold off
    ylim(yLimits);
    if column == 1
        ylabel({'Sexual eggs'; 'over lifetime'}, 'FontSize', 11);
    end
    if column == 2
        set(gca, 'YAxisLocation', 'right', 'YTickMode', 'auto');
        set(gca, 'YTick', 0:25:50);
        set(gca, 'FontSize', 11);
    else
        set(gca, 'YTick', []);
    end
    s2.XTickLabel={};

    % Third row: total eggs as a rate
    s3 = subplot(4, 2, 4 + column);
    nRE = hist(REcorr(:, column), x);
    nREneg = nRE(x < 0);
    nREpos = nRE(x > 0);
    bar(xneg, nREneg, 'FaceColor', 'r','EdgeColor', 'r');
    hold on;
    bar(xpos, nREpos, 'FaceColor', 'b','EdgeColor', 'b');
    xline(0, ':');
    hold off
    ylim(yLimits);
    if column == 1
        ylabel({'Total eggs'; 'as a rate'}, 'FontSize', 11);
    end
    if column == 2
        set(gca, 'YAxisLocation', 'right', 'YTickMode', 'auto');
        set(gca, 'YTick', 0:25:50);
        set(gca, 'FontSize', 11);
    else
        set(gca, 'YTick', []);
    end
    s3.XTickLabel={};
    
    % Fourth row: sexual eggs as a rate 
    s4 = subplot(4, 2, 6 + column);
    nRS = hist(RScorr(:, column), x);
    nRSneg = nRS(x < 0);
    nRSpos = nRS(x > 0);
    bar(xneg, nRSneg, 'FaceColor', 'r','EdgeColor', 'r');
    hold on;
    bar(xpos, nRSpos, 'FaceColor', 'b','EdgeColor', 'b');
    xline(0, ':');
    hold off
    ylim(yLimits);
    if column == 1
        ylabel({'Sexual eggs'; 'as a rate'}, 'FontSize', 11);
    end
    if column == 2
        set(gca, 'YAxisLocation', 'right', 'YTickMode', 'auto');
        set(gca, 'YTick', 0:25:50);
        set(gca, 'FontSize', 11);
    else
        set(gca, 'YTick', []);
    end
    set(gca, 'XTick', -1:1:1);
    set(gca, 'FontSize', 11);
end

% Add a letter to each subplot
letters = 'a':'h';

for column = 1:2
    for row = 1:4
        subplot_idx = (row - 1) * 2 + column;
        subplot(4, 2, subplot_idx);
        
        % Add the letter to the upper left corner of the subplot
        text(0.05, 0.95, ['(', letters(subplot_idx), ')'], ...
            'Units', 'normalized', ... % Use normalized units for positioning
            'HorizontalAlignment', 'left', ... % Align text to the left
            'VerticalAlignment', 'top', ... % Align text to the top
            'FontSize', 11, ...
            'FontWeight', 'bold');
    end
end

% Add common x-axis label
han = axes(fig, 'visible', 'off'); 
han.XLabel.Visible='on';
xlabel(han,'Correlation between queen lifespan and fecundity', 'FontSize', 14);
set(han, 'Position', [0.018, 0.09, 1, 1]);

% Add common y-axis label on the left
han_left = axes(fig, 'visible', 'off');
han_left.YLabel.Visible = 'on';
ylabel(han_left,'What measure of queen fecundity do researchers use?', 'FontSize', 14);
set(han_left, 'Position', [0.11, 0, 1, 1]);

% Add common y-axis label on the right
han_right = axes(fig, 'visible', 'off');
han_right.YLabel.Visible = 'on';
ylabel(han_right,'How many of the 50 hypothetical species show a given correlation?', 'FontSize', 14, 'Rotation', -90);
set(han_right, 'Position', [0.985, 0, 1, 1]);

% Add a common title for the entire figure
sgtitle('       What values of \it{x} \rm{do queens use?}', 'FontSize', 14);
