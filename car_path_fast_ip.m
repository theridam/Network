% Compute Car Path choosing in every step the edge which is part of the
% fastest path according to current information

function [x_path,t_path,e_path,e_p] = car_path_fast_ip(e0,x0,t0,vt,G,E,V,T,algo,road,junction,grid,eps)

% Source and target node of the edge on which the car is located at time t0  
[vs1,vt1] = findedge(G,e0);

% Variable to terminate the algorithm
k = 0;

% Find time index 
tmp2 = find(grid.t + eps >= t0);
tn = tmp2(1);

% Start Car Path Algo at (x0,t0) on road e0
if (algo == 'com')
    [ x,t,tn,k ] = car_path_tn( e0,x0,tn,T,road,grid,eps );
elseif (algo == 'sim')
    [ x,t ] = car_path_simple( e0,x0,t0,T,road,grid,eps ); %%
end

% Termination condition if final time T is reached and the car is in the
% middle of a road
if (x(end) < road.x{e0}(end))
    k = 1;
end

% Initialization
e_p    = e0;                    % Path consisting of edges
P      = [vs1; vt1];            % Path consisting of nodes
e_path = e0*ones(length(x),1);  % Edge vector (at time tn)
x_path = x;                     % Position vector (at time tn)
t_path = t;                     % Time steps
vs = vt1;                       % Subsequent node


% As long as the final time T and the target node are not reached
while ( k ~= 1 && vs ~= vt ) 
    
    % If the subsequent node vs has only one outgoing road, the car will
    % pass on this road
    if (junction.outdegree{vs} == 1)
        e = junction.outgoing{vs};
        
    % If the car reaches a 1:2 junction, the next edge is computed
    % according to current densities and buffer loads
    else
        e = find_edge_weights(e_p,tn,P,E,G,vs,vt,road,junction,grid);
    end
    
    % Function to determine the waiting time wt and the time t at which the
    % car leaves the node
    [x_path,t_path,e_path,tn,k] = car_path_node_ip( x_path,t_path,e_path,tn,vs,e_p(end),e,road,junction,grid );
   
    % If the final time T is not reached, the car path on the next edge is
    % computed
    if ( k ~= 1 )
    
        % Find next node which is the target node of the current edge e
        [~,vs] = findedge(G,e);
        
        % Include the new edge and the new node in the path
        e_p = [ e_p; e ];
        P   = [P; vs];
        
        % Car Trajectory on new road e
        if (algo == 'com')
            [ x,t,tn,k ] = car_path_tn( e,x_path(end),tn,T,road,grid,eps );
        elseif (algo == 'sim')
            [ x,t ] = car_path_simple( e,x_path(end),t_path(end),T,road,grid,eps );
        end
        
        % Termination condition if final time T is reached
        if (x(end) < road.x{e}(end))
            k = 1;
        end

        % Update the solution vectors but leave the first entry of x since 
        % it is equal to the last one in x_path (avoid double entry)
        x_path = [ x_path; x(2:end) ];
        t_path = [ t_path; t(2:end) ];
        e_path = [ e_path; e*ones(length(x(2:end)),1)];

    end
    
end

end
    
    


