% Network given by Herty et al
% Parameter Setting similar to Figure 8-10

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
rMax  = [Inf, Inf, Inf, Inf, Inf, Inf];        
r0    = [0, 0, 0, 0, 0, 0];            
alpha = [0 0.4 0.4 0 0 0; 0 0.6 0.6 0 0 0];
c     = [0 0 0 0.5 0.5 0; 0 0 0 0.5 0.5 0];
%c = [0 0 0 0.6 0.5 0; 0 0 0 0.4 0.5 0];

% Parameters
T     = 15;        % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'


% % Setting 1 (Figure 8b)
p0  = [0 0 0 0 0 0 0]; 
mu  = 0.25*ones(1,6);
fin = @(v,tn) f(0.45);

% Setting 1.1 (Alternative): Puffer bleiben leer, Verdünnung von links
% nach rechts bis Gleichgewicht erreicht
% T   = 15;
% p0  = [0 0 0 0 0 0 0]; 
% mu  = 0.25*ones(1,6);
% fin = @(v,tn) f(0.2);

% % Setting 1.2 (sin-Inflow)
% T   = 15;
% p0  = [0 0 0 0 0 0 0]; 
% mu  = 0.25*ones(1,6);
% tau = min(1./N)*CFL;
% fin_c = @(t) 0.06*sin(((2*pi)/3.75)*t)+0.08;
% fin   = @(v,tn) (1/tau)*integral(fin_c,tn,tn+tau) ; 


% % Setting 2 (Figure 9b)
% p0 = [0 0.9 0.9 0 0 0 0];  
% mu = [0.25 0.21 0.01 0.5 0.5 0.5]; % Ergb. Paper
% %mu = [0.25 0.25 0.01 0.5 0.5 0.25]; %laut Paper
% fin   = @(v,tn) f(0.7);

% % % Setting 3 (Figure 10b with different sin function)
% p0 = [0 0.9 0.9 0 0 0 0];
% mu = [0.25 0.25 0.01 0.5 0.5 0.25]; %laut Paper
% fin   = @(v,tn) 0.125*sin(((2*pi)/3.75)*tn)+0.125 ; 


[ E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType );

% plotDensities(E,road,grid.t)
% plotDensities_LastTimeStep(E,road,grid.t)

% plotFlux(E,road,grid.t,@f)
% plotFlux_LastTimeStep(E,road,grid.t,@f)

plotInflowOutflow(V,junction,grid.t)

