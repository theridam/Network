%% Test Car path on one road

%% Initialization

% Graph: One Road
nodelist1 = 1;   % graph: start and end node of edges
nodelist2 = 2;

% Road
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


% % Exa 1: (No interaction, car with speed v(0.4) )
% x0  = 0.2;
% t0  = 0;
% p0  = 0.4; 
% fin = @(v,tn) f(0.2);

% % Exa 2: (Interaction with shock traveling to the right: car starts with  
% % a higher speed and after the interaction, it is slower)
% % Comparison to analytical solution in mainComparCarPath
x0 = 0;
t0 = 0.25;
p0    = 0.4;
fin   = @(v,tn) f(0.2);

% % Exa 3: (Interaction with rarefaction traveling to the left: car  
% x0 = 0;
% t0 = 0;
% p0 = 0.8;
% fin   = @(v,tn) f(0.8);
% oType = 'd'; 

% % Exa 4: (No interaction with rarefaction traveling to the right)
% x0 = 0.2;
% t0 = 0;
% p0 = 0.1;
% fin   = @(v,tn) f(0.5);
% oType = 'f'; 

% % Exa 5: (Starting in rarefaction traveling to the right, final 
% % intersection would be in x=2.8)
% x0 = 0;
% t0 = 0.125;
% p0 = 0.1;
% fin   = @(v,tn) f(0.5);
% oType = 'f'; 


%% Calculate Network solution
[ E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType );

% plotDensities(E,road,grid.t)
% plotFlux(E,road,grid.t,@f)


%% Calculate car trajectory  

% Complex Algo
[x,t] = car_path( x0,t0,Tx,road,grid );

% Simple Algo
[xs,ts] = car_path_simple( x0,t0,Tx,road,grid );


%% Plot

% % Ex 1
% plot(x,t, x,2.5*x, xs,ts)
% legend('car trajectory', 'shock front', 'simple car trajectory')

% % Ex 2
plot(x,t,x,2.5*x,x,1.25*x+0.25,xs,ts)
legend('car trajectory','shock front','car trajectory if no shock','simple car trajectory')

% % Ex 3
% plot(x,t,x,(-5/3)*x+(5/3),x,5*x,xs,ts);
% legend('car trajectory','start of rarefaction','car trajectory if no rarefaction','simple car trajectory')

% % Ex 4 und 5
% plot(x,t,x,1.25*x,xs,ts)
% legend('car trajectory','end of rarefaction','simple car trajectory')


