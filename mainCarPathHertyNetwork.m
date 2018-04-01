% Graph
nodelist1 = [1, 2, 2, 3, 3, 4, 5];   % graph: start and end node of edges
nodelist2 = [2, 3, 4, 4, 5, 5, 6];

% Roads
L     = [1, 1, 1, 1, 1, 1, 1];       % vector with length of each road
a     = [0, 1, 1, 2, 2, 2, 3];       % vecotr with starting point of each road
b     = [1, 2, 2, 3, 3, 3, 4];       % vector with end point of each road
N     = 200*L;                       % vector with total number of space dicretizaton points

% Junctions       
rMax  = [Inf, Inf, Inf, Inf, Inf, Inf];        
r0    = [0, 0, 0, 0, 0, 0];            
alpha = [0 0.4 0.4 0 0 0; 0 0.6 0.6 0 0 0];
c     = [0 0 0 0.5 0.5 0; 0 0 0 0.5 0.5 0];

% Parameters
T     = 15;        % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType ='max';      % c_1 and c_2 are chosen such that the flux is maximized

%% Setting 1 (Network) 
p0  = [0 0 0 0 0 0 0]; 
mu  = 0.25*ones(1,6);
fin = @(v,tn) f(0.45);

% Setting (Car) 

% % Speed 1 since the car starts at x0=0.2 and the network is still empty 
% e0 = 1;        % edge on which the car is located at time t0
% x0 = 0.2;      % position of the car at time t0
% t0 = 0;        % starting time of the car
% vt = 6;        % target vertex of the car path
% algo = 'com';  % 'com' for complex Algo and 'sim' for simple Algo
% path = 'fastt';
% P0 = [];

% Speed on each road constant - compare different paths
T  = 35;
e0 = 1;        % edge on which the car is located at time t0
x0 = 0.2;      % position of the car at time t0
t0 = 5;       % starting time of the car
vt = 6;        % target vertex of the car path
algo = 'com';  % 'com' for complex Algo and 'sim' for simple Algo
P0 = [];       % prescribed path

% Shortest Path = [2 3 5 6]
% path = 'short'; % use Dijkstra to determine shortest path

% Alternative 1: Densities are higher on road 3 and 6
%   path = 'presc';
%   P0 = [2 4 5 6];

% Alternative 2: Path is longer and higher density on road 6
% path = 'presc';
% P0 = [2 3 4 5 6];

% Fastest path
 path = 'fastt';

%% Setting 2 (Network) by mainBufferIncrease

% T = 30;
% rMax  = [Inf, 0.3, 0.3, 0.3, 0.3, Inf]; 
% p0  = [0 0.8 0.6 0.4 0 0 0]; 
% mu  = [0.25 0.25 0.25 0.25 0.25 0.25];
% fin = @(v,tn) f(0.3);
% 
% % Setting Car
% e0 = 1;        % edge on which the car is located at time t0
% x0 = 0.2;      % position of the car at time t0
% t0 = 6;%2; %5;  %10     % starting time of the car
% vt = 6;        % target vertex of the car path
% path = 'presc';
% P0 = [2 4 5 6];

%% Setting 3

% T = 20;
% r0    = [0, 0, 0.3, 0, 0, 0];  
% rMax  = [Inf, 0.3, 0.3, 0.3, 0.3, Inf]; 
% alpha = [0 0.5 0.7 0 0 0; 0 0.5 0.6 0 0 0];
% c     = [0 0 0 0.5 0.4 0; 0 0 0 0.5 0.6 0];
% p0  = [0.5 0.3 0.4 0 0.8 0 0.4]; 
% mu  = [0.25 0.25 0.25 0.25 0.25 0.25];
% fin = @(v,tn) f(0.5);
% cType ='not'; 
% 
% e0 = 1;        % edge on which the car is located at time t0
% x0 = 0.9;      % position of the car at time t0
% t0 =0; %5;  %10     % starting time of the car
% vt = 6;        % target vertex of the car path
% algo = 'com';  % 'com' for complex Algo and 'sim' for simple Algo
% path = 'short';
% P0 = [];




%% Calculate Network solution
[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType );

% plotDensities(E,road,grid.t)
% plotDensities_LastTimeStep(E,road,grid.t)

%% Calculate car trajectory  

algo = 'com';  % 'com' for complex Algo and 'sim' for simple Algo
[x_path1,t_path1,e_path1,e_p1] = car_path_network(e0,x0,t0,P0,vt,G,E,T,algo,path,road,junction,grid,eps);

algo = 'sim';  % 'com' for complex Algo and 'sim' for simple Algo
[x_path2,t_path2,e_path2,e_p2] = car_path_network(e0,x0,t0,P0,vt,G,E,T,algo,path,road,junction,grid,eps);


%plotDensitiesAndCar(E,road,grid,x_path1,t_path1,e_path1,eps)


