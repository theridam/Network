%% Initialization of roads and junctions
   
function [ road,junction,E,V ] = initialization( G,E,V,indeg,outdeg,grid,L,N,a,b,mu,rMax,p0,r0,alpha,c )
    
    for e=1:E
        road.L{e}        = L(e);                  % length of the road e
        road.NP{e}       = N(e);                  % total number of space discret. points of road e
        road.x{e}        = a(e):grid.h(e):b(e);   % spacial grid 
        road.xV{e}       = a(e)+0.5*grid.h(e):grid.h(e):b(e)-0.5*grid.h(e); % spacial grid used for finite volume methods
        
        road.rho{e}      = zeros(N(e),grid.NT);   % density of road e at all discret. points
        road.rho{e}(:,1) = p0(e)*ones(N(e),1);    % inital density
        
        road.inflow{e}   = zeros(1,grid.NT);      % inflow q^(in)_e for all tn   
        road.outflow{e}  = zeros(1,grid.NT);      % outflow q^(out)_e for all tn
     end   
        
     for v=1:V   
        junction.r{v}        = zeros(1,grid.NT); % buffer in front of road e at all time steps
        junction.r{v}(1,1)   = r0(v);            % initial buffer load
        junction.rMax{v}     = rMax(v);          % max capacity of buffer
        junction.mu{v}       = mu(v);            % buffer rate
        
        junction.alpha{v} = alpha(:,v);          % distribution rates
        junction.c{v} = c(:,v);                  % right-of-way parameter
        
        junction.inflow{v}  = zeros(1,grid.NT);  % total inflow in junction/buffer v
        junction.outflow{v} = zeros(1,grid.NT);  % total outflow in junction/buffer v
        
        junction.indegree{v}  = indeg(v);        % number of incoming roads at junction v
        junction.outdegree{v} = outdeg(v);       % number of outgoing roads at junction v
        
        junction.incoming{v} = findedge(G,predecessors(G,v),v);  % all incoming roads of junction v
        junction.outgoing{v} = findedge(G,v,successors(G,v));    % all outgoing roads of function v
     
        junction.change{v} = zeros(1,grid.NT); % change in buffer load
     end
    
end