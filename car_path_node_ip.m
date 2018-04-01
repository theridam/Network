% Compute the waiting time, the time at which the car leaves the buffer and
% indicate if the final time T is reached

%function [wt,t,k] = car_path_node_ip( v,junction,grid,t,eps )
function [x,t,e,tn,k] = car_path_node_ip( x,t,e,tn1,v,e1,e2,road,junction,grid )

% Initialization 
k = 0;
x_tmp = [];
t_tmp = [];
e_tmp = [];

% Time at which the car is one step before the buffer
tn = tn1 - 1;

% Speed at which the car enter the buffer
speed = ( x(end) - x(end-1) ) / grid.tau;

% Time tn + tau_b at which the car enters the buffer, speed ~= 0 since x(end) ~= x(end-1)
tau_b = ( road.x{e1}(end) - x(end-1) ) / speed;

% Buffer load at time tn+tau_b (tn = tn1 - 1) 
r = junction.r{v}(tn) + tau_b * ( junction.inflow{v}(tn)-junction.outflow{v}(tn) );

% If buffer is empty
if ( r <= 0 )
    
    % Position of the car after leaving the buffer
    x(end) =  road.x{e2}(1) + (grid.tau-tau_b) * (1 - road.rho{e2}(1,tn));
    
    % After leaving the buffer, the car  is on road e2
    e(end) = e2;
    
    % Next time step
    tn = tn1;
    
else
    
    % Total outflow since the car has entered the buffer
    outflow = (grid.tau-tau_b)*junction.outflow{v}(tn);
   
    % As long as the sum of the outflow is smaller than the buffer load at
    % time tn+tau_b and the final time is not reached
    while ( r > outflow && tn < grid.NT )
        tn = tn + 1;
        outflow = outflow + grid.tau * junction.outflow{v}(tn);
        
        % Add x and t to vector
        x_tmp = [x_tmp; road.x{e1}(end)];
        t_tmp = [t_tmp; grid.t(tn)];
        e_tmp = [e_tmp; e1];
        
    end
    
    % Termination Criteria: If the car is still in the buffer at final time T
    if (tn >= grid.NT)
        
        k = 1;
    
        % The car is still at the end of the road e1 at final time T
        x = [x(1:end-1); x_tmp];
        e = [e(1:end-1); e_tmp];
    
        % Final time
        t = [t(1:end-1) t_tmp];
        

    % The car has left the buffer...
    else
        
        % in the first step
        if ( tn == tn1-1 )  
            tau_bb = ( r + tau_b * junction.outflow{v}(tn) ) / junction.outflow{v}(tn);
            
            % Position of the car after leaving the buffer
            x_next = road.x{e2}(1) + (grid.tau-tau_bb) * (1 - road.rho{e2}(1,tn)); 
            x(end) = x_next;
            e(end) = e2;
            tn = tn1;
        
        else
            % Time tn + tau_bb at which the car leaves the buffer (if it leaves)
            tau_bb = ( r - outflow + grid.tau * junction.outflow{v}(tn) ) / junction.outflow{v}(tn);
            
            % Position of the car after leaving the buffer
            x_next = road.x{e2}(1) + (grid.tau-tau_bb) * (1 - road.rho{e2}(1,tn));
            x = [x(1:end-1); x_tmp; x_next];
            e = [e(1:end-1); e_tmp; e2];
            
            % Time at which the car is on the next road
            tn = tn + 1;
            t  = [t(1:end-1); t_tmp; grid.t(tn)];
        end
    
    end

end

end
