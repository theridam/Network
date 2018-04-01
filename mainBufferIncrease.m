% Network given by Herty et al
% Parameter Setting such that buffer 4 increases up to r^max and decreases

% Initialization

% Graph
nodelist1 = [1, 2, 2, 3, 3, 4, 5];   % graph: start and end node of edges
nodelist2 = [2, 3, 4, 4, 5, 5, 6];

% Roads
L     = [1, 1, 1, 1, 1, 1, 1];       % vector with length of each road
a     = [0, 1, 1, 2, 2, 2, 3];       % vecotr with starting point of each road
b     = [1, 2, 2, 3, 3, 3, 4];       % vector with end point of each road
N     = 100*L;                       % vector with total number of space dicretizaton points

% Junctions       
       
r0    = [0, 0, 0, 0, 0, 0];            
alpha = [0 0.4 0.4 0 0 0; 0 0.6 0.6 0 0 0];
c     = [0 0 0 0.5 0.5 0; 0 0 0 0.5 0.5 0];

% Parameters
T     = 50;        % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType ='max'; 

% Setting
rMax  = [Inf, 0.3, 0.3, 0.3, 0.3, Inf]; 
p0  = [0 0.8 0.6 0.4 0 0 0]; 
mu  = [0.25 0.25 0.25 0.25 0.25 0.25];
fin = @(v,tn) f(0.3);


%% Calculate numerical solution 

[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType );


%% Plot 

% plotDensities(E,road,grid.t)
% plotDensities_LastTimeStep(E,road,grid.t)

% plotFlux(E,road,grid.t,@f)
% plotFlux_LastTimeStep(E,road,grid.t,@f)

 plotInflowOutflow(V,junction,grid.t)
 plotBuffers(V,junction,grid.t)

 
%% Write to .csv files

% header = {'t','inflow','outflow','buffer 1','buffer2','buffer3','buffer4','buffer5','buffer6'};
% data_bufferIncrease = [grid.t',junction.inflow{1}',junction.outflow{6}',junction.r{1}',junction.r{2}',junction.r{3}',junction.r{4}',junction.r{5}',junction.r{6}'];
% csvwrite_with_headers('dataBufferIncrease.csv',data_bufferIncrease,header);

