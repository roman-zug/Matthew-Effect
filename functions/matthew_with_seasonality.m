% Function: matthew_with_seasonality
% 
% Purpose: This function runs the main algorithm with seasonality, which 
% means that production of sexual eggs does not start above sexual threshold y, 
% (there is no such threshold in the model version with seasonality), but 
% rather after a given time point called 't_sexual'.
% 
% Inputs:
%   params - parameters a1, a2, a3, mu_q0, mu_w
%   x - allocation to reproduction
%   t_sexual - time point at which production of sexual eggs begins
%
% Outputs:
%   lifespan - queen lifespan
%   total_eggs - number of total eggs produced over queen lifetime
%   total_sexuals - number of sexual eggs produced over queen lifetime
%   rate_eggs - number of total eggs produced per time interval
%   rate_sexuals - number of sexual eggs produced per time interval
%   t_series - time series array for time
%   eggs_series - time series array for total eggs
%   sexuals_series - time series array for sexual eggs
%   workforce_series - time series array for workforce size

function [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals, t_series, eggs_series, sexuals_series, workforce_series] = matthew_with_seasonality(params, x, t_sexual)

nofcolonies = length(x);
a1 = params(:, 1); % parameter adjusting how important help by workers is to keep the queen alive
a2 = params(:, 2); % parameter adjusting how many workers are needed to create a significant shift towards a longer-lived queen
a3 = params(:, 3); % parameter describing the strength of the positive effect of a large workforce on queen productivity
mu_q0 = params(:, 4); % queen baseline mortality
mu_w = params(:, 5); % worker mortality
repr_allocation = x; % allocation into reproduction
soma_allocation = 1 - x; % allocation into soma

t = zeros([nofcolonies 1]); % time
qr = ones([nofcolonies 1]); % qr stands for queenright
workforce = zeros([nofcolonies 1]); % number of workers
total_eggs = zeros([nofcolonies 1]); % number of total eggs
total_sexuals = zeros([nofcolonies 1]); % number of sexual eggs

% Store time series data
t_series = []; % array for time
eggs_series = []; % array for total eggs
sexuals_series = []; % array for sexual eggs
workforce_series = []; % array for workforce size

while any(qr)
    mu_q = mu_q0 .* (1 + a1 .* exp(-a2 .* soma_allocation .* workforce)); % one possible shape; here the queen is much safer in larger colonies.
    time2nextegg = 1 ./ log(1 + a3 .* repr_allocation .* (1 + workforce)); % one possible shape (productivity is always the inverse of this)
    egg_develops_as_worker = double(t < t_sexual); % switches to 0 after t_sexual
    onemort = 1 - exp(-mu_w .* time2nextegg); % what is the mortality of workers during this time
    delta_workforce = egg_develops_as_worker - binornd(workforce, onemort);
    
    f = find(qr); % restrict attention to queenright colonies
    t(f) = t(f) + time2nextegg(f);
    total_eggs(f) = total_eggs(f) + 1;
    total_sexuals(f) = total_sexuals(f) + (1 - egg_develops_as_worker(f));
    workforce(f) = workforce(f) + delta_workforce(f);

    % Store the time series
    t_series = [t_series; t(f)];
    eggs_series = [eggs_series; total_eggs(f)];
    sexuals_series = [sexuals_series; total_sexuals(f)];
    workforce_series = [workforce_series; workforce(f)];

    % newly dead queens
    qr(rand(nofcolonies, 1) > exp(-mu_q .* time2nextegg)) = 0;
end

lifespan = t;
rate_eggs = total_eggs ./ (lifespan + eps);
rate_sexuals = total_sexuals ./ (lifespan + eps);
