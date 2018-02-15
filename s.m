%% Supply function (road)

function [ e ] = s( f,sigma,rho )

    e = f(sigma)*(rho<= sigma)+f(rho)*(rho>sigma);

end

