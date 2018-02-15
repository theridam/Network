%% Demand function (buffer) 

function [ g ] = dB( v,tn,rho,junction,f,sigma,d )

    if (junction.r{v}(1,tn) > 0 )
        g = junction.mu{v};
    elseif (junction.r{v}(1,tn) <= 0)
        g = min( d(f,sigma,rho) , junction.mu{v} );
    end
    
end