

% Initialization

% Graph
nodelist1 = [1, 2, 2];   % graph: start and end node of edges
nodelist2 = [2, 3, 4];

% Roads
L     = [1, 1, 1];       % vector with length of each road
a     = [0, 1, 1];       % vecotr with starting point of each road
b     = [1, 2, 2];       % vector with end point of each road
N     = 100*L;                       % vector with total number of space dicretizaton points

% Junctions                      
alpha = [0 0.4 0 0; 0 0.6 0 0];
c     = [0 0 0 0; 0 0 0 0];

% Parameters
T     = 5;        % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType ='max'; 

% Setting
rMax  = [Inf, 0.3, Inf, Inf]; 
p0  = [0.5 1 0.9]; 
r0  = [0, 0, 0, 0]; 
mu  = [0.25 0.25 0.25 0.25];
fin = @(v,tn) f(0.5);


%% Calculate numerical solution 

[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType );


%% Plot 

% plotDensities(E,road,grid.t)
% plotDensities_LastTimeStep(E,road,grid.t)

% plotFlux(E,road,grid.t,@f)
% plotFlux_LastTimeStep(E,road,grid.t,@f)

 % plotInflowOutflow(V,junction,grid.t)
 % plotBuffers(V,junction,grid.t)

 %%
 figure
   
    % Use LaTex font
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
  
    plot(grid.t,road.outflow{1},'-',grid.t,road.inflow{2},grid.t,road.inflow{3},grid.t,junction.r{2})
    axis([0 grid.t(end) 0 0.5])
    xlabel('time','Interpreter','latex')
    ylabel('flux','Interpreter','latex')
    legend('inflow to buffer','inflow on road 2','inflow on road 3','buffer')
 
 
%% Write to .csv files

% header = {'t','inflowBuffer','inflowRoad2','inflowRoad3','buffer'};
% data_blockedRoad = [grid.t',junction.inflow{2}',road.inflow{2}',road.inflow{3}',junction.r{2}'];
% csvwrite_with_headers('dataBlockedRoad.csv',data_blockedRoad,header);

