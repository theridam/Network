%% 

function [x_ct,x_diff,err_ct,err_max,time] = error_certainTime( nodelist1,nodelist2,L,a,b,T,eps,mu,rMax,r0,p0,CFL,alpha,c,f,sigma,fin,s,d,sB,dB,sB2,dB2,d1,method,oType,cType,e0,x0,t0,ct,n1,n2,tspan,exact_value,xexact ) 

    m = n2-n1+1;
    
    x_ct    = zeros(m,5);
    x_diff  = zeros(m,5);
    err_ct  = zeros(m-1,5);
    err_max = zeros(m,5);
    time    = zeros(m,5);
    
    
    for n = n1:n2
        
        % Spacial step size h = 1/N
        N = 10*2^n*L;
        
        % %  Calculate Network solution
        [ ~,~,~,road,~,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,f,sigma,fin,s,d,sB,dB,sB2,dB2,d1,method,oType,cType );
        
        % % Calculate car trajectory
        
        % Complex Algo
        tic
        [x,t]   = car_path( e0,x0,t0,tspan(end),road,grid,eps );
        time(n-n1+1,1) = toc;
        x_e   = arrayfun(xexact,t);
        
        
        % Naive Algo
        tic
        [xs,ts] = car_path_simple( e0,x0,t0,tspan(end),road,grid,eps );
        time(n-n1+1,2) = toc;
        xs_e    = arrayfun(xexact,ts);
        
        % Matlab Solver ode45, ode23, ode23s
        [TT,XX] = meshgrid(grid.t,road.xV{1});
        VV      = road.rho{1};
        opts    = odeset('RelTol',1e-6,'AbsTol',1e-6);
        
        % ode45
        tic
        [t45,x45] = ode45(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
        time(n-n1+1,3) = toc;
        x45_e    = arrayfun(xexact,t45);
% t45 =0;
% x45=0;
% x45_e=0;
%         
        % ode23
        tic
        [t23,x23] = ode23(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
        time(n-n1+1,4) = toc;
        x23_e     = arrayfun(xexact,t23);
        
        % ode23s
        %if (n < 2)
        tic
        [t23s,x23s] = ode23s(@(t,x) myOde(t,x,XX,TT,VV,road,grid), tspan, x0, opts);
        time(n-n1+1,5) = toc;
        x23s_e      = arrayfun(xexact,t23s);
        %else
        %    time(n-n1+1,5) = 0;
        %    x23s_e      = 0;
        %    t23s = 0;
        %    x23s = 0;
        %end
        
        % Find index such that t(t_index)=ct
        [~, t_index ]    = min(abs(t-ct));
        [~, ts_index ]   = min(abs(ts-ct));
        [~, t45_index ]  = min(abs(t45-ct));
        [~, t23_index ]  = min(abs(t23-ct));
        [~, t23s_index ] = min(abs(t23s-ct));
        
        %[grid.t(t45_index) grid.t(t23_index) grid.t(t23s_index)]
        %[x45(t45_index) x23(t23_index) x23s(t23s_index)]
        
        % x(ct)
        x_ct(n-n1+1,1)  = x(t_index);
        x_ct(n-n1+1,2) = xs(ts_index);
        x_ct(n-n1+1,3) = x45(t45_index);
        x_ct(n-n1+1,4) = x23(t23_index);
        x_ct(n-n1+1,5) = x23s(t23s_index);
        
        % x(ct) - exact
        x_diff(n-n1+1,1) = abs( exact_value - x_ct(n-n1+1,1) );
        x_diff(n-n1+1,2) = abs( exact_value - x_ct(n-n1+1,2) );
        x_diff(n-n1+1,3) = abs( exact_value - x_ct(n-n1+1,3) );
        x_diff(n-n1+1,4) = abs( exact_value - x_ct(n-n1+1,4) );
        x_diff(n-n1+1,5) = abs( exact_value - x_ct(n-n1+1,5) );
        
        % Trunc. error
        err_max(n-n1+1,1) = max ( abs(x - x_e) );
        err_max(n-n1+1,2) = max ( abs(xs - xs_e) );
        err_max(n-n1+1,3) = max ( abs(x45 - x45_e) );
        err_max(n-n1+1,4) = max ( abs(x23 - x23_e) );
        err_max(n-n1+1,5) = max ( abs(x23s - x23s_e) );

        % Error per step
        if (n > n1)
            err_ct(n-n1,1) = abs( x_ct(n-n1,1) - x_ct(n-n1+1,1) );
            err_ct(n-n1,2) = abs( x_ct(n-n1,2) - x_ct(n-n1+1,2) );
            err_ct(n-n1,3) = abs( x_ct(n-n1,3) - x_ct(n-n1+1,3) );
            err_ct(n-n1,4) = abs( x_ct(n-n1,4) - x_ct(n-n1+1,4) );
            err_ct(n-n1,5) = abs( x_ct(n-n1,5) - x_ct(n-n1+1,5) );
        end
        
    end
    
   
end