%% Godunov

function [ road ] = godunov( e,tn,tau,h,road,f,sigma,s,d )

    road.rho{e}(1,tn+1) = road.rho{e}(1,tn) - (tau/h(e)) * (min(d(f,sigma,road.rho{e}(1,tn)),s(f,sigma,road.rho{e}(2,tn)))-road.inflow{e}(tn));
    for xi=2:road.NP{e}-1
               road.rho{e}(xi, tn+1) = road.rho{e}(xi,tn) - (tau/h(e)) * (min(d(f,sigma,road.rho{e}(xi,tn)),s(f,sigma,road.rho{e}(xi+1,tn))) - min(d(f,sigma,road.rho{e}(xi-1,tn)),s(f,sigma,road.rho{e}(xi,tn))));
    end
    NNP = road.NP{e};
    road.rho{e}(NNP,tn+1) = road.rho{e}(NNP,tn) - (tau/h(e)) * (road.outflow{e}(tn) - min(d(f,sigma,road.rho{e}(NNP-1,tn)),s(f,sigma,road.rho{e}(NNP,tn))));

end