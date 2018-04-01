% Compute Car Trajectory according to complex Algorithm
% Difference between car_path_tn and car_path:
% Input index tn s.t. grid.t(tn)=t0 instead of t0

function [ x,t,tn ] = car_path_tn( e0,x0,tn,T,road,grid,eps )

% Initialization
%k = 0;
x = x0;
e = e0; 
t = grid.t(tn);

% Determine index of the cell containing x^n
tmp1 = find(road.xV{e} > x);
m = tmp1(1);


% while: final time T and the end of the road are not reached
while ( t(end) < T && x(end) < road.x{e}(end) )
    
    % Check, if x^n is in the first half of the cell
    if ( x(end) < road.x{e}(m) )
        
        % Function evaluation
        x_m = road.x{e}(m);
        rho_1 = road.rho{e}(m-1,tn);
        
        % Check if x^n is not in the last part of the road
        if (x(end) < road.x{e}(end-1))
            rho_2 = road.rho{e}(m,tn);
        else
            rho_2 = rho_1;
        end
        
    else
        
        % Function evaluation
        x_m = road.x{e}(m+1);
        rho_1 = road.rho{e}(m,tn);
        
        % Check if x^n is not in the last part of the road
        if (x(end) < road.x{e}(end-1))
            rho_2 = road.rho{e}(m+1,tn);
        else
            rho_2 = rho_1;
        end
        
    end
    
    
    % No wave
    if ( abs(rho_1 - rho_2) < eps ) 
        x_next = x(end) + grid.tau * (1-rho_1);
        
    % Shock
    elseif ( rho_1 - rho_2 < -eps ) %%( rho_1 < rho_2 )
        
        % Wave speed
        % s = 1 - rho_1 - rho_2;
        
        % First interaction point
        tau_b = (x_m - x(end)) / rho_2;
        x_b = x(end) + tau_b * (1-rho_1);
        
        % No interaction in [t_n,t_{n+1}]
        if ( tau_b >= grid.tau)
            x_next = x(end) + grid.tau * (1-rho_1);
            
        % Interaction in [t_n,t_{n+1}]
        elseif (tau_b < grid.tau)
            x_next = x_b + (grid.tau-tau_b) * (1-rho_2);
        end
        
        
    % Rarefaction
    elseif ( rho_1 - rho_2 > eps ) %%( rho_1 > rho_2) 
        
        %[rho_1 rho_2 x_m x(end)]
        
        % First interaction point
        tau_b = (x_m - x(end)) / rho_1;
        x_b = x(end) + tau_b * (1-rho_1);
        
        % No interaction in [t_n,t_{n+1}]
        if ( tau_b >= grid.tau )
            x_next = x(end) + grid.tau * (1-rho_1);
            
        % First interaction in [t_n,t_{n+1}]
        elseif ( tau_b < grid.tau )
            
            % Check, if there is no final interaction
            if ( rho_2 < eps ) % 1-f'(rho_2) = 0 then car cannot leave the rarefaction
                x_next = x_m + grid.tau - sqrt(grid.tau) *(tau_b + x_m - x_b) / (sqrt(tau_b));
            
            % If there is a finial interaction
            else
                % Solution to non-linear equation) in (x_bb,t_n+tau_bb)
                tau_bb = ( ( tau_b + x_m - x_b ) / ( sqrt(tau_b) * 2 * rho_2 ) )^2;
                x_bb = x_m + (1-2*rho_2) * tau_bb; %%
                
                % No final interaction in [t_n,t_{n+1}]
                if ( tau_bb >= grid.tau || tau_bb <= tau_b ) 
                    x_next = x_m + grid.tau - sqrt(grid.tau) *(tau_b + x_m - x_b) / (sqrt(tau_b));
                    
                % Final interaction
                elseif ( tau_bb < grid.tau && tau_bb > tau_b )
                    x_next = x_bb + (grid.tau-tau_bb) * (1-rho_2);
                end
                
            end
            
        end
        
    end
    
    if ( x_next >= road.x{e}(m)+0.5*grid.h(e) )
        m = m+1;
    end
    
    x = [x; x_next];
    tn = tn + 1;
    t = [t; grid.t(tn)];
end


end
            
  
   
        
     