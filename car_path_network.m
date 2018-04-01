% Compute Car Path choosing in every step the edge which is part of the
% fastest path according to current information

function [x_path,t_path,e_path,e_p] = car_path_network(e0,x0,t0,P0,vt,G,E,T,algo,path,road,junction,grid,eps)

% Source and target node of the edge on which the car is located at time t0  
[vs1,vt1] = findedge(G,e0);

% Variable to terminate the algorithm
% k = 0;

% Find time index 
tmp2 = find(grid.t + eps >= t0);
tn = tmp2(1);

% Start Car Path Algo at (x0,t0) on road e0
if (algo == 'com')
    [ x,t,tn ] = car_path_tn( e0,x0,tn,T,road,grid,eps );
elseif (algo == 'sim')
    [ x,t,tn ] = car_path_simple_tn( e0,x0,tn,T,road,grid );
end

% Termination condition if final time T is reached and the car is in the
% middle of a road
% if (x(end) < road.x{e0}(end))
%     k = 1;
% end


% Initialization 
e_p    = e0;                    % Path consisting of edges
e_path = e0*ones(length(x),1);  % Edge vector (at time tn)
x_path = x;                     % Position vector (at time tn)
t_path = t;                     % Time steps
vs     = vt1;                   % Subsequent node


if ( path == 'short' )
    % Calculate shortest path P (P consists of node indices) 
    P = shortestpath(G,vs,vt);
elseif ( path == 'presc' )
    % Use prescribed path P0
    P = P0;
else
    P = [vs1; vt1]; 
end

 

% As long as the final time T and the target node are not reached
while ( tn < grid.NT && vs ~= vt ) %( k ~= 1 && vs ~= vt ) 
    
    % If the subsequent node vs has only one outgoing road, the car will
    % pass on this road
    if (junction.outdegree{vs} == 1)
        e = junction.outgoing{vs};
        
    % If the car reaches a 1:2 junction, the next edge is computed
    else
        % according to the given path P
        if ( strcmp(path,'short') || strcmp(path,'presc') )
            e = findedge(G,vs,P(find(P==vs)+1)); 
            
        % according to densities (fastest path)
        else
            %tn-1 logischer?
            e = find_edge_weights(e_p,tn,P,E,G,vs,vt,road,junction,grid);
        end
    end
    
    % Function to determine the waiting time wt and the time t at which the
    % car leaves the node
    [x_path,t_path,e_path,tn] = car_path_node_ip( x_path,t_path,e_path,tn,vs,e_p(end),e,road,junction,grid );
   
    % If the final time T is not reached, the car path on the next edge is
    % computed
    if ( tn < grid.NT ) %( k ~= 1 )
    
        % Find next node which is the target node of the current edge e
        [~,vs] = findedge(G,e);
        
        % Include the new edge and the new node in the path
        e_p = [ e_p; e ];
        
        if ( strcmp(path,'short')== 0 && strcmp(path,'presc')==0 )
            P   = [P; vs];
        end
        
        % Car Trajectory on new road e
        if (algo == 'com')
            [ x,t,tn ] = car_path_tn( e,x_path(end),tn,T,road,grid,eps );
        elseif (algo == 'sim')
            [ x,t,tn ] = car_path_simple_tn( e,x_path(end),tn,T,road,grid );
        end
        
        % Termination condition if final time T is reached
%         if (x(end) < road.x{e}(end))
%             k = 1;
%         end

        % Update the solution vectors but leave the first entry of x since 
        % it is equal to the last one in x_path (avoid double entry)
        x_path = [ x_path; x(2:end) ];
        t_path = [ t_path; t(2:end) ];
        e_path = [ e_path; e*ones(length(x(2:end)),1)];

    end
    
end

end
    
    


