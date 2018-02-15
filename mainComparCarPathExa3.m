%% Comparison (Example 3) - Rarefaction

%% Initialization

% Graph: One Road
nodelist1 = 1;   % graph: start and end node of edges
nodelist2 = 2;

% Roads
L     = 1;       % vector with length of each road
a     = 0;       % vecotr with starting point of each road
b     = 1;       % vector with end point of each road
N     = 100*L;   % vector with total number of space dicretizaton points    

% Junctions
mu    = [0.25, 0.25];        
rMax  = [Inf, Inf];        
r0    = [0, 0];            
alpha = [0 0; 0 0];
c     = [0 0; 0 0];

% Parameters
T     = 5;         % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'


% % Exa 3: (Interaction with rarefaction traveling to the left: car  
x0 = 0;
t0 = 0.000001;
p0 = 0.8;
fin   = @(v,tn) f(0.8);
oType = 'd'; 

%% Calculate Network solution
[ E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType );


%% Calculate car trajectory    

% Car Path Algo
[x,t] = car_path( x0,t0,Tx,road,grid );

% Simple Algo
[xs,ts] = car_path_simple( x0,t0,Tx,road,grid );

% Ode-solver Matlab (exact derivative x'=... is needed)
[tm,xm] = ode45(@(t,x) 0.2*(x<1-0.6*t) + (0.5+((x-1)/(2*t)))*(-0.6*t<=x-1)*(x-1<=0) + 0.5*(x>1), ts, x0);

% Ode-solver Matlab (exact derivative x'=... is needed)
[tm2,xm2] = ode23(@(t,x) 0.2*(x<1-0.6*t) + (0.5+((x-1)/(2*t)))*(-0.6*t<=x-1)*(x-1<=0) + 0.5*(x>1), ts, x0);

% Exact solution (analytical)
xexact = @(t) 0.2*t*(t<=1.25) + (1+t-sqrt(t)*(2/sqrt(1.25)))*(t>1.25);
xe = arrayfun(xexact,t);


%% Plot
plot(x,t,x,(-5/3)*x+(5/3),x,5*x,xs,ts,xm,tm,xm2,tm2,xe,t)
legend('car trajectory','start of rarefaction','car trajectory if no rarefaction','simple car trajectory','car ODE45','car ODE23','car exact')

