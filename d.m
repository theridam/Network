%% Demand function (road)

function [ g ] = d( f,sigma,rho )

    g =  f(rho)*(rho<= sigma)+f(sigma)*(rho>sigma);

end

