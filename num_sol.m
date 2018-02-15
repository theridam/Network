%% Numerical Solution

function [ E,V,road,junction,grid ] = num_sol( nodelist1,nodelist2,L,a,b,N,T,eps,mu,rMax,r0,p0,CFL,alpha,c,f,sigma,fin,s,d,sB,dB,sB2,dB2,d1,method,outflowType )

    % Compute grid variables
    [ grid ] = grid_variables( L,N,T,CFL );
    
    % Generate the graph of the network
    [ G,E,V,indeg,outdeg ] = generate_graph( nodelist1,nodelist2 );
    
    % Initialization of roads and junctions
    [ road,junction,E,V ] = initialization( G,E,V,indeg,outdeg,grid,L,N,a,b,mu,rMax,p0,r0,alpha,c );
    
    for tn = 1:grid.NT-1
        
        for v = 1:V
            % Inflow and Outflow
            [ road,junction ] = inflow_outflow( v,tn,grid.tau,road,junction,f,sigma,fin,s,d,sB,dB,d1,sB2,dB2,eps,outflowType );
        
            % Explicit Euler Method: Solving ODE for buffer r
            [ junction ] = exp_Euler( v,tn,grid.tau,junction,eps );
        end
        
        
        for e = 1:E
            
            % Solving the PDE according to the required method
            if (method == "LxF")
                [ road ] = LxF( e,tn,grid.tau,grid.h,road,f );
            elseif (method == "mod_LxF")
                [ road ] = mod_LxF( e,tn,grid.tau,grid.h,road,f );
            elseif (method == "Godunov")
                [ road ] = godunov( e,tn,grid.tau,grid.h,road,f,sigma,s,d );
            end
        end

         
        
    end
    
    
    
end

