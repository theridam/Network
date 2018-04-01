% Compute Car Trajectory according to simple Algorithm

function [ x,t,tn ] = car_path_simple_tn( e0,x0,tn,T,road,grid )

% Initialization
x = x0;
e = e0; 
t = grid.t(tn);


% while: final time T and the end of the road are not reached
while ( t(end) < T && x(end) < road.x{e}(end) ) 
    
    % Determine index of the cell containing x^n
    tmp1 = find( road.x{e} > x(end) );
    m = tmp1(1) - 1;
    
    % Calculate next time step
    x_next = x(end) + grid.tau * ( 1 - road.rho{e}(m,tn) );
    
    % Update variables
    x  = [x; x_next];
    tn = tn + 1;
    t  = [t; grid.t(tn)];

end

end