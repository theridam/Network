%% Supply function (buffer) in case of a one-to-two junction

function [ g ] = sB2( v,tn,rho1,rho2,junction,f,sigma,s,eps )

    if (junction.r{v}(1,tn) < junction.rMax{v}-eps)
        g = junction.mu{v};
    elseif (junction.r{v}(1,tn) >= junction.rMax{v}-eps)
        g = min( s(f,sigma,rho1) , junction.alpha{v}(1)*junction.mu{v} ) + min( s(f,sigma,rho2) , junction.alpha{v}(2)*junction.mu{v} );
    end

end