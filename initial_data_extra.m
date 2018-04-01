% Given initial data based on Bretti and Piccoli

function [road] = initial_data_extra(road,grid)

e = 1;

for xi = 1:length(road.xV{e})
    if (road.xV{e}(xi) <= 0.2)
        road.rho{e}(xi,1) = 0.3;
    elseif (road.xV{e}(xi) > 0.2 && road.xV{e}(xi) <= 0.5)
        road.rho{e}(xi,1) = 0.1;
    else
        road.rho{e}(xi,1) = 0.8;
    end
end

% for xi = 1:length(road.xV{e})
%     if (road.xV{e}(xi) <= 0.2+0.5*grid.h(e))
%         road.rho{e}(xi,1) = 0.3;
%     elseif (road.xV{e}(xi) > 0.2+0.5*grid.h(e) && road.xV{e}(xi) <= 0.5+0.5*grid.h(e))
%         road.rho{e}(xi,1) = 0.1;
%     else
%         road.rho{e}(xi,1) = 0.8;
%     end
% end

% for xi = 1:length(road.xV{e})
%     if (road.xV{e}(xi) <= 0.5)
%         road.rho{e}(xi,1) = 0.45;
%     elseif (road.xV{e}(xi) > 0.5 && road.xV{e}(xi) <= 1.5)
%         road.rho{e}(xi,1) = 0.1;
%     else
%         road.rho{e}(xi,1) = 0.8;
%     end
% end



end