%% Inflow

function [ q ] = inflow( e,tn,road,f,sigma,fin,s,d,dB,d1 )

    if (e==1)
        q = min( d1(fin(tn),road.r{e}(tn),road.mu{e}), s(f,sigma,road.rho{e}(1,tn)) );
    else 
        NNP = road.NP{e-1}; 
        q = min( dB(road.rho{e-1}(NNP,tn),road.r{e}(tn),road.mu{e},f,sigma,d), s(f,sigma,road.rho{e}(1,tn)) ); 
    end
   
end