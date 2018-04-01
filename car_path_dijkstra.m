function [x_path,t_path,e_path,e_p] = car_path_dijkstra(e0,x0,t0,P0,path,vt,G,T,algo,road,junction,grid,eps)

% Source node for shortest path
[~,vs] = findedge(G,e0);

% Variable to terminate the algorithm
k = 0;

if ( path == 'short' )
    % Calculate shortest path P (P consists of node indices) 
    P = shortestpath(G,vs,vt);
else
    % Use prescribed path P0
    P = P0;
end


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
% % If the car passed the exact end of the road
% elseif (x(end) > road.x{e0}(end))
%     x(end) = road.x{e0}(end);
% end

% Initialization
v_it   = 1;
e_p    = e0;
e_path = e0*ones(length(x),1);
x_path = x;
t_path = t;


% while the finale time T and the end of the Dijkstra path is not reached
while ( k ~= 1 && P(v_it) ~= vt ) 

    % Find next edge 
    e = findedge( G,P(v_it),P(v_it+1) );
    
    % Function to determine the waiting time wt and the time t at which the
    % car leaves the node
    [wt,t,k] = car_path_node( P(v_it),junction,grid,t_path(end),eps );
    
    % Avoid double entry if wt=0
    if ( wt < eps )
        x_tmp = x_path(end);
        x_path(end) = road.x{e}(1) + ( x_tmp - road.x{e_p(end)}(end));%road.x{e}(1);
        e_path(end) = e;
    elseif ( wt >= eps )
        x_path(end) = road.x{e_p(end)}(end);
        % Final time is not reached
        if ( k ~= 1 )
            e_path = [ e_path; e ];
            x_path = [ x_path; road.x{e}(1) ];
            t_path = [ t_path; t ];
        % Final time is reached and car is still at the junction
        elseif ( k == 1)
            e_path = [ e_path; e_path(end) ];
            x_path = [ x_path; road.x{e_p(end)}(end) ];
            t_path = [ t_path; t ];
        end
    end
    
    if ( k ~= 1 )
        e_p = [ e_p; e ];
        
        % Car Trajectory on road
        if (algo == 'com')
            [ x,t ] = car_path( e,x_path(end),t_path(end),T,road,grid,eps );
        elseif (algo == 'sim')
            [ x,t ] = car_path_simple( e,x_path(end),t_path(end),T,road,grid,eps );
        end
        
        % Termination condition if final time T is reached
        if (x(end) < road.x{e}(end))
            k = 1;
        end
        %     % If the car passed the exact end of the road
        %     elseif (x(end) > road.x{e}(end))
        %         x(end) = road.x{e}(end);
        %     end
        
        x_path = [ x_path; x(2:end) ];
        t_path = [ t_path; t(2:end) ];
        e_path = [ e_path; e*ones(length(x(2:end)),1)];
        
        v_it = v_it + 1;
    end
    
end
    
    


