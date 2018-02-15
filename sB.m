%% Supply function (buffer) 

function [ g ] = sB( v,tn,rho,junction,f,sigma,s,eps )

    if (junction.r{v}(1,tn) < junction.rMax{v}) %-eps
        g = junction.mu{v};
    elseif (junction.r{v}(1,tn) >= junction.rMax{v}) %-eps
        g = min( s(f,sigma,rho) , junction.mu{v} );
    end

end