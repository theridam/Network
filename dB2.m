%% Demand function (buffer) in case of a two-to-one junction

function [ g ] = dB2( v,tn,rho1,rho2,junction,f,sigma,d )

    if (junction.r{v}(1,tn) > 0)
        g = junction.mu{v};
    elseif (junction.r{v}(1,tn) <= 0)
        g = min( d(f,sigma,rho1) , junction.c{v}(1)*junction.mu{v} ) + min( d(f,sigma,rho2) , junction.c{v}(2)*junction.mu{v} );
        %g = min( d(f,sigma,rho1) + d(f,sigma,rho2) , junction.mu{v} );
    end
    
end