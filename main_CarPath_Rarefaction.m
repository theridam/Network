%% Comparison Car Path on a Single Road - Shock

%% Initialization

% Graph: One Road
nodelist1 = 1;   % graph: start and end node of edges
nodelist2 = 2;

% Roads
L     = 6;       % vector with length of each road
a     = -3;       % vecotr with starting point of each road
b     = 3;       % vector with end point of each road
N     = L*200;   % vector with total number of space dicretizaton points    

% Junctions
mu    = [0.25, 0.25];        
rMax  = [Inf, Inf];        
r0    = [0, 0];            
alpha = [0 0; 0 0];
c     = [0 0; 0 0];

% Parameters
T     = 15;         % time horizon
eps   = 1.e-10;    % accuracy
sigma = 0.5;       % f^max = f(sigma)
CFL   = 0.5;       % coefficient of CFL condition
oType = 'f';       % outflow type, choose 'd' for maximal flux at an outgoing node and otherwise 'f'
cType = 'not';     % use fixed coefficients c_1 and c_2


% % Interaction with shock traveling to the right: car starts with  
% % a higher speed and after the interaction, it is slower)
e0 = 1;
x0 = -2;
t0 = 0;
p0    = 0.4;
fin   = @(v,tn) f(0.5);
tspan = [0 10];

% Analytical solution
xexact = @(t) (-2+0.25*t)*(t<=(8/3)) + (t-sqrt(t)*sqrt(6))*(t>(8/3))*(t<6) + (0.5*(t-6))*(t>6);


%% PART I

%% Calculate Network solution
[ G,E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType );


%% Calculate car trajectory    

% % % Complex Algo
%  [x,t] = car_path( e0,x0,t0,T,road,grid,eps );
% 
% % % Naive Algo
%  [xs,ts] = car_path_simple( e0,x0,t0,T,road,grid,eps );
% 
% % % Matlab Solver ode45, ode23, ode23s
% [TT,XX] = meshgrid(grid.t,road.xV{1});
% VV      = road.rho{1};
% tspan   = [0 11];
% opts    = odeset('RelTol',1e-6,'AbsTol',1e-6);
% [t45,x45] = ode45(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
% [t23,x23] = ode23(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
% [t23s,x23s] = ode23s(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
% 
% % % Exact solution (analytical)
% xexact = @(t) (-2+0.25*t)*(t<=(8/3)) + (t-sqrt(t)*sqrt(6))*(t>(8/3))*(t<6) + (0.5*(t-6))*(t>6);
% xe = arrayfun(xexact,t);
% 
% 
% %% Plot all solutions
% %plot(x,t,xs,ts,xe,t,x45,t45,x23,t23,x23s,t23s)
% %legend('Complex','Naive','Exact','ode45','ode23','ode23s') 
% %plotDensitiesAndCar(E,road,grid,x,t,ones(length(x),1),eps)
% 
% %% Plot only the exact solution together with the shock front
% plot(xe,t,-0.5*t,t,'--',[0 0],[0 12],'--')
% axis([-2 2 0 12])
% legend('car trajectory','rarefaction bounds')
% xlabel('x')
% ylabel('t')

%% PART II

%% Error Calculation at time t = 12 for h = 0.1*2^(-n), n = n1,...,n2
ct = 10;
exact_value= 2;
n1 = 0;
n2 = 3;
[x_ct,x_diff,err_ct,err_max,time] = error_certainTime(  nodelist1,nodelist2,L,a,b,T,eps,mu,rMax,r0,p0,CFL,alpha,c,@f,sigma,fin,@s,@d,@sB,@dB,@sB2,@dB2,@d1,'Godunov',oType,cType,e0,x0,t0,ct,n1,n2,tspan,exact_value,xexact ) ;

%% Write to csv file
header = {'n','Complex','Naive','ode45','ode23','ode23s'};

n = n1:n2;
data_xct    = [n', x_ct];
data_xdiff  = [n', x_diff];
data_errct  = [n(1:end-1)', err_ct];
data_errmax = [n', err_max];
data_time   = [n', time];

csvwrite_with_headers('data_xct_rar.csv',data_xct,header);
csvwrite_with_headers('data_xdiff_rar.csv',data_xdiff,header);
csvwrite_with_headers('data_errct_rar.csv',data_errct,header);
csvwrite_with_headers('data_errmax_rar.csv',data_errmax,header);
csvwrite_with_headers('data_time_rar.csv',data_time,header);


% %% Plot
% n = n1:n2;
% N = 10*2.^n;
% 
% figure
% 
% plot(N,err_max(:,1),N,err_max(:,2),N,err_max(:,3),N,err_max(:,4),N,err_max(:,5))
% xlabel('N')
% ylabel('err_{max}')
% legend('Complex','Naive','ode45','ode23','ode23s')
% 
% 
% 
% figure
% 
% subplot(1,2,1)
% plot(N,x_ct(:,1),N,x_ct(:,2),N,x_ct(:,3),N,x_ct(:,4),N,x_ct(:,5),N,2*ones(length(N),1))
% xlabel('N')
% ylabel('x(10)')
% legend('Complex','Naive','ode45','ode23','ode23s','exact')
% 
% subplot(1,2,2)
% n = n1:n2-1;
% N = 10*2.^n;
% plot(N,err_ct(:,1),N,err_ct(:,2),N,err_ct(:,3),N,err_ct(:,4),N,err_ct(:,5))
% xlabel('N')
% ylabel('|x_h(10)-x_{h/2}(10)|')
% legend('Complex','Naive','ode45','ode23','ode23s')
% 
