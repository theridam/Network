% Compute the waiting time, the time at which the car leaves the buffer and
% indicate if the final time T is reached

function [wt,t,k] = car_path_node( v,junction,grid,t,eps )

% Initialization 
k = 0;

% Find time index 
tmp2 = find(grid.t + eps >= t);
tn = tmp2(1);

% Time index at which the car reaches the buffer/end of the ard
tn1 = tn;

% Buffer load when car reaches the buffer
r = junction.r{v}(tn);

% Outflow at this time (assuming cars are able do leave the buffer 
% immediately)
outflow = junction.outflow{v}(tn);

% As long as the sum of the outflow is smaller than the buffer load at
% time tn1 and the final time is not reached
while ( r >= outflow && tn < length(grid.t) )
    tn = tn + 1;
    outflow = outflow + junction.outflow{v}(tn);
end

% Time at which the car leaves the buffer
t = grid.t(tn);

% Waiting time is the difference between the time when the car reaches
% the buffer and when it leaves
wt = (tn - tn1)*grid.tau;

% If the final time T is reached
if ( tn >= length(grid.t) )
    k = 1;
end

end


    
    