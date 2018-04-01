% Line network with only two roads and a buffer in between

% Initialization

% Graph
nodelist1 = [1, 2];   % graph: start and end node of edges
nodelist2 = [2, 3];

% Roads
L     = [1, 1];       % vector with length of each road
a     = [0, 1];       % vecotr with starting point of each road
b     = [1, 2];       % vector with end point of each road
N     = 100*L;        % vector with total number of space dicretizaton points
p0    = [0.4 0.7];     

% Junctions
mu    = [0.25, 0.2, 0.25];        
rMax  = [Inf, 0.3, Inf];        
r0    = [0, 0, 0];            
alpha = [0 0 0; 0 0 0];
c     = [0 0 0; 0 0 0];

% Parameters
T     = 5;         % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
fin   = @(v,tn) f(0.4);
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType ='not';      % use the fixed coefficients c_1 and c_2

[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType );

plotDensities(E,road,grid.t)
plotFlux(E,road,grid.t,@f)