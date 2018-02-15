%% Outflow

function [ q ] = outflow( e,tn,E,road,f,sigma,s,d,sB )

    NNP = road.NP{e};
    if (e == E)
        q = f(road.rho{e}(NNP,tn)); %d(f,sigma,road.rho{e}(NNP,tn)); 
        % set "q = f(road.rho{e}(NNP,tn));" when max flux constraint is not
        % required e.g. Comparison exact - approx. solution
    else
        q = min(sB(road.rho{e+1}(1,tn),road.r{e+1}(tn),road.mu{e+1},road.rMax{e+1},f,sigma,s),d(f,sigma,road.rho{e}(NNP,tn))); 
    end
   
end