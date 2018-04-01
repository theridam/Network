function [] = plotBuffers(V,junction,tt)

    figure
    
    hold on 
   
    % Use LaTex font
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    
    s = zeros(V,1);
    
    for v=1:V

    s(v)=plot(tt,junction.r{v});
    axis([0 tt(end) 0 1])
    xlabel('time','Interpreter','latex')
    ylabel('buffer','Interpreter','latex')
    
    legendInfo{v} = ['Junction ' num2str(v)];
    box on
    end
    legend(legendInfo)
   

end