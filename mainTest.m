% Test Network smaller than in Herty et al

% Initialization

% Graph
nodelist1 = [1, 2, 2, 3, 4];   % graph: start and end node of edges
nodelist2 = [2, 3, 4, 4, 5];

% Roads
L     = [1, 1, 2, 1, 1];       % vector with length of each road
a     = [0, 1, 1, 2, 3];       % vecotr with starting point of each road
b     = [1, 2, 3, 3, 4];       % vector with end point of each road
N     = 100*L;                 % vector with total number of space dicretizaton points
p0    = [0.4 0.2 0.2 0.2 0.4]; %[0.4, 0.7, 0.7, 0.4, 0.4];        

% Junctions
mu    = [0.25, 0.25, 0.25, 0.25, 0.25];        
rMax  = [Inf, 0.3, 0.3, 0.3, Inf];        
r0    = [0, 0, 0, 0, 0];            
alpha = [0 0.5 0 0 0; 0 0.5 0 0 0];
c     = [0 0 0 0.5 0; 0 0 0 0.5 0];

% Parameters
T     = 5;         % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
fin   = @(v,tn) f(0.4);
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType ='not';      % c_1 and c_2 are fixed

[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'LxF',oType,cType );

plotDensities(E,road,grid.t)
plotFlux(E,road,grid.t,@f)
