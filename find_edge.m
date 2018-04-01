% Find next edge which is part of the fastest path according to current 
% traffic densities and buffer loads 

function [e_next] = find_edge(t,e_p,P,V,E,G,vs,vt,road,junction,grid)

% Initialization
wt = zeros(V,1);  % Waiting time at node v
tt = zeros(E,1);  % Travelling time on edge e
w  = zeros(E,1);  % Weights of edge e
G_algo = G;       % Graph for shortestpath algo (edges already in the path are removed)

% Find time index
tmp2 = find(grid.t + eps >= t);
tn = tmp2(1);

% Time index at which the car reaches the buffer/end of the ard
tn1 = tn;

% Compute waiting time at each node (assuming last node is leaving node)
for v = 1:V-1 
    
    % Buffer load when car reaches the buffer
    r = junction.r{v}(tn);
    
    % Outflow at this time (assuming cars are able do leave the buffer
    % immediately)
    outflow = junction.outflow{v}(tn);
    
    % As long as the sum of the outflow is smaller than the buffer load at
    % time tn1 and the final time is not reached
    while ( r >= outflow && tn < length(grid.t) )
        tn = tn + 1;
        outflow = outflow + junction.outflow{v}(tn);
    end
    
    % Waiting time is the difference between the time when the car reaches
    % the buffer and when it leaves
    wt(v) = (tn - tn1)*grid.tau;
    
    tn = tn1;
    
end
    
% Compute travelling time for each edge that is not already in the path e_p
for e = 1 : E
    if ( isempty(find(e_p==e,1)) ~= 0 )
        
        % Travelling times (forecast)
        tt(e) = grid.h(e) * sum( 1 ./(1 - road.rho{e}(:,tn)) );
        
        % Find source node of edge e
        [v1,~] = findedge(G,e);
        
        % Weights for shortestpath algo is the sum of waiting and 
        % travelling time 
        w(e) = wt(v1) + tt(e);
        
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
