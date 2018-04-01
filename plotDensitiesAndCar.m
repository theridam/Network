function [] = plotDensitiesAndCar(E,road,grid,x_path,t_path,e_path,eps)

    figure
   
    % Use LaTex font
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    
    % Subplot for each road
    s = zeros(E,1);
    for e = 1:E
        s(e) = subplot(1,E,e);  
    end
    
    % Find starting time index
    tmp = find(grid.t + eps >= t_path(1));
    t_in = tmp(1);
    
    stepsize = 4;
  
    
    for tn = 1 : stepsize : length(t_path)
        
        e_car = e_path(tn);
        
        for e = 1: E
            
            if ( e == e_car )
                plot(s(e),road.xV{e},road.rho{e}(:,t_in),x_path(tn),0.05,'.','MarkerSize',20)
                axis(s(e),[road.x{e}(1) road.x{e}(end) 0 1])
                xlabel(s(e),'x','Interpreter','latex')
                ylabel(s(e),['density ',num2str(e)],'Interpreter','latex')
            else
                plot(s(e),road.xV{e},road.rho{e}(:,t_in))
                axis(s(e),[road.x{e}(1) road.x{e}(end) 0 1])
                xlabel(s(e),'x','Interpreter','latex')
                ylabel(s(e),['density ',num2str(e)],'Interpreter','latex')
            end
            
        end
        
        drawnow()
        t_in = t_in + stepsize;
        
    end
                
%             %hold(s(1),'on')
%             e=1;
%             plot(s(e),road.xV{e},road.rho{e}(:,tn),x(tn),0.05,'.','MarkerSize',20)
%             axis(s(e),[road.x{e}(1) road.x{e}(end) 0 1])
%             xlabel(s(e),'x','Interpreter','latex')
%             ylabel(s(e),['density ',num2str(e)],'Interpreter','latex')
% 
%         
% %         if (t(k) >= tt(tn))
% %         plot(s(1),x(k),0.05,'.','MarkerSize',20)
% %         k = k+1;
% %         end
%         %box(s4,'on')
%         %axis(s4,[0,T,0,road.rMax{2}]);
%         %xlabel(s4,'t','Interpreter','latex')
%         %ylabel(s4,'buffer $r_2$','Interpreter','latex')
%          
%         drawnow()
%         %hold(s(1),'off')
        
        
   % end
   %hold(s(1),'off')

end