%%

function [err_max] = error_max(nodelist1,nodelist2,L,a,b,T,eps,mu,rMax,r0,p0,CFL,alpha,c,f,sigma,fin,s,d,sB,dB,sB2,dB2,d1,method,oType,cType,e0,x0,t0,n1,n2,xexact,tspan)

m       = n2-n1+1;
err_max = zeros(m,5);



for n=n1:n2
    
    N = 10*2^n*L; %valid for only one road
    
    % %  Calculate Network solution
    [ ~,~,~,road,~,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,f,sigma,fin,s,d,sB,dB,sB2,dB2,d1,method,oType,cType );
    
    % % Calculate car trajectory
    
    % Complex
    [x,t] = car_path( e0,x0,t0,tspan(end),road,grid,eps );
    x_e   = arrayfun(xexact,t);
      
    % Naive
    [xs,ts] = car_path_simple( e0,x0,t0,tspan(end),road,grid,eps );
    xs_e    = arrayfun(xexact,ts);
    
    % Matlab Solver ode45, ode23, ode23s
    [TT,XX] = meshgrid(grid.t,road.xV{1});
    VV      = road.rho{1};
    opts    = odeset('RelTol',1e-6,'AbsTol',1e-6);
    
    % ode45
    [t45,x45] = ode45(@(t,x) myOde(t,x,XX,TT,VV), tspan, x0, opts);
    x45_e    = arrayfun(xexact,t45);
    
    %ode23
    [t23,x23] = ode23(@(t,x) myOde(t,x,XX,TT,VV), tspan, x0, opts);
    x23_e     = arrayfun(xexact,t23);
    
    %ode23s
    [t23s,x23s] = ode23s(@(t,x) myOde(t,x,XX,TT,VV), tspan, x0, opts);
    x23s_e      = arrayfun(xexact,t23s);
    
    % % Calculate error
    err_max(n-n1+1,1) = max ( abs(x - x_e) );
    err_max(n-n1+1,2) = max ( abs(xs - xs_e) );
    err_max(n-n1+1,3) = max ( abs(x45 - x45_e) );
    err_max(n-n1+1,4) = max ( abs(x23 - x23_e) );
    err_max(n-n1+1,5) = max ( abs(x23s - x23s_e) );
    
end

end