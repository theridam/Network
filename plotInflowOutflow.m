function [] = plotInflowOutflow(V,junction,tt)

    figure
   
    % Use LaTex font
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    
    % 
    %s(1) = subplot(1,2,1);  
    %s(2) = subplot(1,2,2); 
  
    plot(tt,junction.inflow{1},'-',tt,junction.inflow{V})
    axis([0 tt(end) 0 0.3])
    xlabel('time','Interpreter','latex')
    ylabel('flux','Interpreter','latex')
    legend('inflow','outflow')
    
%     plot(s(2),tt,junction.inflow{V})
%     axis(s(2),[0 tt(end) 0 0.3])
%     xlabel(s(2),'time','Interpreter','latex')
%     ylabel(s(2),'outflow','Interpreter','latex')
   

end