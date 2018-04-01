% Compute Car Path choosing in every step the edge which is part of the
% fastest path according to current information

function [x_path,t_path,e_path,e_p] = car_path_fast(e0,x0,t0,vt,G,E,V,T,algo,road,junction,grid,eps)

% Source and target node of the edge on which the car is located at time t0  
[vs1,vt1] = findedge(G,e0);

% Variable to terminate the algorithm
k = 0;

% Start Car Path Algo at (x0,t0) on road e0
if (algo == 'com')
    [ x,t ] = car_path( e0,x0,t0,T,road,grid,eps );
elseif (algo == 'sim')
    [ x,t ] = car_path_simple( e0,x0,t0,T,road,grid,eps );
end

% Termination condition if finial time T is reached and the car is in the
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
        e = find_edge(t_path(end),e_p,P,V,E,G,vs,vt,road,junction,grid);
    end
    
    % Function to determine the waiting time wt and the time t at which the
    % car leaves the node
    [wt,t,k] = car_path_node( vs,junction,grid,t_path(end),eps );
    
    % If the waiting time is zero, the car immediately drives on the next
    % road by constant speed
    if ( wt < eps )
        x_tmp       = x_path(end);
        x_path(end) = road.x{e}(1) + ( x_tmp - road.x{e_p(end)}(end));
        e_path(end) = e;
        
    % If the waiting time is non-zero
    elseif ( wt >= eps )
        
        % The car does not drive on the next road but stops exactly at the
        % junction
        x_path(end) = road.x{e_p(end)}(end);
        
        % If the final time is not reached
        if ( k ~= 1 )
            % At time t, the car leaves the buffer and is located at the
            % beginning of the new road e
            e_path = [ e_path; e ];
            x_path = [ x_path; road.x{e}(1) ];
            t_path = [ t_path; t ];
            
        % If the final time is reached and car is still at the junction
        elseif ( k == 1)
            % At time t, the car has not passed the buffer but is still at
            % the end of the 'old' road
            e_path = [ e_path; e_path(end) ];
            x_path = [ x_path; road.x{e_p(end)}(end) ];
            t_path = [ t_path; t ];
        end
    end
    
    % Find next node which is the target node of the current edge e
    [~,vs] = findedge(G,e);
    
    % If the final time T is not reached, the car path on the next edge is
    % computed
    if ( k ~= 1 )
        
        % Include the new edge and the new node in the path
        e_p = [ e_p; e ];
        P   = [P; vs];
        
        % Car Trajectory on new road e
        if (algo == 'com')
            [ x,t ] = car_path( e,x_path(end),t_path(end),T,road,grid,eps );
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
    
    


