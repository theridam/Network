% Find next edge which is part of the fastest path according to current 
% traffic densities and buffer loads 

function [e_next] = find_edge_weights(e_p,tn,P,E,G,vs,vt,road,junction,grid)

% Initialization
w  = zeros(E,1);  % Weights of edge e
G_algo = G;       % Graph for shortestpath algo (edges already in the path are removed)
    
% Compute travelling time for each edge that is not already in the path e_p
for e = 1 : E
    if ( isempty(find(e_p==e,1)) ~= 0 )
        
        % Find source node of edge e
        [v1,~] = findedge(G,e);
        e
        
        % Weights for shortestpath algo is the sum of waiting and 
        % travelling time 
        r = junction.r{v1}(tn)
        p = grid.h(e) * sum( 1 ./(1 - road.rho{e}(:,tn)) )
        w(e) = r + p
        
    end
end

% Assign new weights to edges
G_algo.Edges.Weight = w; 

% Remove edges already in the path e_p
for P_idx = 1 : length(P)-1
    G_algo = rmedge(G_algo,P(P_idx),P(P_idx+1));
    G_algo.Edges
end

% Shortest path with source node vs and target node vt
P =  shortestpath(G_algo,vs,vt);

% Next edge
e_next = findedge(G,P(1),P(2));



end
