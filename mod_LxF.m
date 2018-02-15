%% Modified LxF

function [ road ] = mod_LxF( e,tn,tau,h,road,f )

    road.rho{e}(1,tn+1) = 0.25*(3*road.rho{e}(1,tn)+road.rho{e}(2,tn))-(tau/(2*h(e)))*(f(road.rho{e}(2,tn))+f(road.rho{e}(1,tn))-2*road.inflow{e}(tn));
    for xi=2:road.NP{e}-1
        road.rho{e}(xi, tn+1) = 0.25*(road.rho{e}(xi+1,tn)+2*road.rho{e}(xi,tn)+road.rho{e}(xi-1,tn))-(tau/(2*h(e)))*(f(road.rho{e}(xi+1,tn))-f(road.rho{e}(xi-1,tn)));
    end
    NNP = road.NP{e};
    road.rho{e}(NNP,tn+1) = 0.25*(3*road.rho{e}(NNP,tn)+road.rho{e}(NNP-1,tn))-(tau/(2*h(e)))*(2*road.outflow{e}(tn)-f(road.rho{e}(NNP,tn))-f(road.rho{e}(NNP-1,tn)));    

end