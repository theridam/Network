% Compute Car Trajectory according to simple Algorithm

function [ x,t ] = car_path_simple( x0,t0,T,road,grid )

% Initialization
x = x0;
t = t0;
e = 1; % später ändern

% Determine time index 
tmp2 = find(grid.t >= t0);
tn = tmp2(1);


% while: final time T and the end of the road are not reached
while ( t(end) < T && x(end) < road.x{e}(end) )

    % Determine index of the cell containing x^n
%     tmp1 = find(road.xV{e} > x(end) );
%     m = tmp1(1);
tmp1 = find( road.x{e} > x(end) );
m = tmp1(1) - 1;
    
    
    % Calculate next time step
    x_next = x(end) + grid.tau * ( 1 - road.rho{e}(m,tn) );
    
    % Update variables
    x = [x x_next];
    t = [t t(end)+grid.tau];
    tn = tn + 1;

end

end