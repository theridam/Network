%% Demand function (road 1)

function [ g ] = d1( v,tn,junction,fin )

    if (junction.r{v}(1,tn) > 0)
        g = junction.mu{v};
    elseif (junction.r{v} <= 0)
        g = min( fin(v,tn) , junction.mu{v} ) ; 
    end

end