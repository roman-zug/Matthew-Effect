% Function: matthew
%
% Purpose: This function runs the main algorithm. 

function [lifespan, total_eggs, total_sexuals, rate_eggs, rate_sexuals, t_series, eggs_series, sexuals_series, workforce_series] = matthew(params, x, y)

% x: allocation into reproduction
% y: sexual threshold (workforce size)

nofcolonies = max(length(x),length(y)); % number of colonies
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

% 8 July 2024: newly included to plot temporal dynamics (also included in line 1)
t_series = []; % Time series
eggs_series = []; % Series for total eggs
sexuals_series = []; % Series for sexual eggs
workforce_series = []; % Series for workforce

while any(qr)
    % [t; qr; workforce]'
    mu_q = mu_q0 .* (1 + a1 .* exp(-a2 .* soma_allocation .* workforce)); % one possible shape; here the queen is much safer in larger colonies
    time2nextegg = 1 ./ log(1 + a3 .* repr_allocation .* (1 + workforce)); % one possible shape (productivity is always the inverse of this)
    egg_develops_as_worker = double(workforce < y); % this takes the value 1 if egg is destined to increase workforce, 0 if instead it counts towards sexuals
    onemort = 1 - exp(-mu_w .* time2nextegg); % what is the mortality of workers during this time
    delta_workforce = egg_develops_as_worker - binornd(workforce, onemort);
    
    f = find(qr); % restrict attention to queenright colonies
    t(f) = t(f) + time2nextegg(f);
    total_eggs(f) = total_eggs(f)+1;
    total_sexuals(f) = total_sexuals(f) + (1 - egg_develops_as_worker(f));
    workforce(f) = workforce(f) + delta_workforce(f);

    % store the time series for t, total eggs, sexual eggs, and workforce
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
