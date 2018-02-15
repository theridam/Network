function [] = plotFlux_LastTimeStep(E,road,tt,f)

    figure
   
    % Use LaTex font
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    
    % 
    s = zeros(E,1);
    for e = 1:E
        s(e) = subplot(1,E,e);  
    end
  
   
        
        for e=1:E
            plot(s(e),road.xV{e},arrayfun(f,road.rho{e}(:,end)))
            axis(s(e),[road.x{e}(1) road.x{e}(end) 0 0.3])
            xlabel(s(e),'x','Interpreter','latex')
            ylabel(s(e),['flux ',num2str(e)],'Interpreter','latex')
        end


end