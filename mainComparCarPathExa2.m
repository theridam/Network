%% Comparison (Example 2) - Shock

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


% % Exa 2: (Interaction with shock traveling to the right: car starts with  
% % a higher speed and after the interaction, it is slower)
x0 = 0;
t0 = 0.25;
p0    = 0.4;
fin   = @(v,tn) f(0.2);

%% Calculate Network solution
[ E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType );


%% Calculate car trajectory    

% Complex Algo
[x,t] = car_path( x0,t0,Tx,road,grid );

% Simple Algo
[xs,ts] = car_path_simple( x0,t0,Tx,road,grid );

% Ode-solver Matlab (exact derivative x'=... is needed)
[tm,xm] = ode45(@(t,x) 0.8*(x<0.4*t)+0.6*(x>0.4*t), ts, x0);

% Ode-solver Matlab (exact derivative x'=... is needed)
[tm2,xm2] = ode23(@(t,x) 0.8*(x<0.4*t)+0.6*(x>0.4*t), ts, x0);

% Exact solution (analytical)
xexact = @(t) (-0.2+0.8*t)*(t<=0.5) + (0.2+0.6*(t-0.5))*(t>0.5);
xe = arrayfun(xexact,t);


%% Plot
plot(x,t,x,2.5*x,x,1.25*x+0.25,xs,ts,xm,tm,xm2,tm2,xe,t)
legend('car trajectory','shock front','car trajectory if no shock','simple car trajectory','car ODE45','car ODE23','car exact')

