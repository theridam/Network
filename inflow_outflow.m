%% Inflow and outflow

function [ road,junction ] = inflow_outflow( v,tn,tau,road,junction,f,sigma,fin,s,d,sB,dB,d1,sB2,dB2,eps,outflowType )
    
    % In- and outdegree of node v
    ideg = junction.indegree{v};
    odeg = junction.outdegree{v};
    
    % Incoming and outgoing roads of node v
    in  = junction.incoming{v};
    out = junction.outgoing{v};
    
    
    % Inflow of the network
    if (ideg == 0 && odeg == 1)
        
        road.inflow{out(1)}(1,tn)  = min( d1(v,tn,tau,junction,fin) , s(f,sigma,road.rho{out(1)}(1,tn)) );
        junction.outflow{v}(1,tn)  = road.inflow{out(1)}(1,tn);
        
        junction.inflow{v}(1,tn) = fin(v,(tn-1)*tau);
        
        
    % Outflow of the network
    elseif (ideg == 1 && odeg == 0)
        
        NNP = road.NP{in(1)};
        
        if (outflowType == 'd')
            road.outflow{in(1)}(1,tn) = d(f,sigma,road.rho{in(1)}(NNP,tn));
        elseif (outflowType == 'f')
            road.outflow{in(1)}(1,tn) = f(road.rho{in(1)}(NNP,tn));
        end
        
        junction.inflow{v}(1,tn)  = road.outflow{in(1)}(1,tn);
        
        junction.outflow{v}(1,tn) = junction.inflow{v}(1,tn);
      
        
    % One-to-one junction
    elseif (ideg == 1 && odeg == 1)
        
        NNP = road.NP{in(1)}; %eps?
        
        road.outflow{in(1)}(1,tn) = min( sB(v,tn,road.rho{out(1)}(1,tn),junction,f,sigma,s,eps) ,  d(f,sigma,road.rho{in(1)}(NNP,tn)) );
        junction.inflow{v}(1,tn)     = road.outflow{in(1)}(1,tn);
        
        road.inflow{out(1)}(1,tn)  = min ( dB(v,tn,road.rho{in(1)}(NNP,tn),junction,f,sigma,d) , s(f,sigma,road.rho{out(1)}(1,tn)) );
        junction.outflow{v}(1,tn)     = road.inflow{out(1)}(1,tn);
        
        
    % One-to-two junction
    elseif (ideg == 1 && odeg == 2)
        
        NNP = road.NP{in(1)};
        
        road.inflow{out(1)}(1,tn) = min( junction.alpha{v}(1)*dB(v,tn,road.rho{in(1)}(NNP,tn),junction,f,sigma,d) , s(f,sigma,road.rho{out(1)}(1,tn)) );
        road.inflow{out(2)}(1,tn) = min( junction.alpha{v}(2)*dB(v,tn,road.rho{in(1)}(NNP,tn),junction,f,sigma,d) , s(f,sigma,road.rho{out(2)}(1,tn)) );
        junction.outflow{v}(1,tn) = road.inflow{out(1)}(1,tn) + road.inflow{out(2)}(1,tn);
        
        road.outflow{in(1)}(1,tn) = min( sB2(v,tn,road.rho{out(1)}(1,tn),road.rho{out(2)}(1,tn),junction,f,sigma,s,eps) , d(f,sigma,road.rho{in(1)}(NNP,tn)) );
        junction.inflow{v}(1,tn)  = road.outflow{in(1)}(1,tn);
     
        
    % Two-to-one junction
    elseif (ideg == 2 && odeg == 1)
        
        NNP1 = road.NP{in(1)};
        NNP2 = road.NP{in(2)};

        road.inflow{out(1)}(1,tn) = min( dB2(v,tn,road.rho{in(1)}(NNP1,tn),road.rho{in(2)}(NNP2,tn),junction,f,sigma,d) , s(f,sigma,road.rho{out(1)}(1,tn)) );
        junction.outflow{v}(1,tn) = road.inflow{out(1)}(1,tn);
        
        
        road.outflow{in(1)}(1,tn) = min( junction.c{v}(1)*sB(v,tn,road.rho{out(1)},junction,f,sigma,s,eps) , d(f,sigma,road.rho{in(1)}(NNP1,tn)) );
        road.outflow{in(2)}(1,tn) = min( junction.c{v}(2)*sB(v,tn,road.rho{out(1)},junction,f,sigma,s,eps) , d(f,sigma,road.rho{in(2)}(NNP2,tn)) );
        junction.inflow{v}(1,tn)  = road.outflow{in(1)}(1,tn) + road.outflow{in(2)}(1,tn);
        
    end
   
end