%% Explicit Euler method

function [ junction ] = exp_Euler( v,tn,tau,junction,eps )

    junction.r{v}(1,tn+1) = junction.r{v}(1,tn) + tau * ( junction.inflow{v}(1,tn) - junction.outflow{v}(1,tn) );
    
    % Condition: 0 <= r(t) <= rMax
    if (junction.indegree{v}+junction.outdegree{v} > 1)
        if (junction.r{v}(1,tn+1) < eps)  
            junction.r{v}(1,tn+1) = 0.e00;
        end
        if ( (abs(junction.r{v}(1,tn+1) - junction.rMax{v}) < eps) || (junction.r{v}(1,tn+1) - junction.rMax{v} > eps) )
            junction.r{v}(1,tn+1) = junction.rMax{v};
        end
    end
    
    junction.change{v}(1,tn) = (junction.r{v}(1,tn+1) - junction.r{v}(1,tn))/tau;
    
end