%

function [road] = initial_data_shock(road,grid)

e = 1;

for xi = 1:length(road.xV{e})
    if (road.xV{e}(xi) <= 0)
        road.rho{e}(xi,1) = 0.5;
    else
        road.rho{e}(xi,1) = 0.75;
    end
end




end