%% Compute grid variables

function [ grid ] = grid_variables( L,N,T,CFL )

    grid.h      = L./(N);                       % step size in space
    grid.tau    = min( CFL * grid.h );          % step size in time, satisfying the CFL condition
    grid.lambda = min( grid.tau ./ grid.h );    % grid constant
    grid.NT     = floor( ( T / grid.tau )+ 1 ); % total number of time steps 
    grid.t      = 0:grid.tau:T;                 % time grid

end