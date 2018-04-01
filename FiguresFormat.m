% Change Plots format and save as eps
fig = gcf;
fig.Position = [100, 100,500,450];
%fig.Position = [2300,350,500,300];
g   = gca;

% % Specify xaxis
% g.XLim = [-2 2];
% g.YLim = [0 14];


g.FontName = 'Helvetica';
g.FontSize = 20;
g.TickLabelInterpreter = 'latex';
g.XLabel.FontName = g.FontName;
g.XLabel.FontSize = g.FontSize;
g.XLabel.Interpreter = g.TickLabelInterpreter;
g.YLabel.FontName = g.FontName;
g.YLabel.FontSize = g.FontSize;
g.YLabel.Interpreter = g.TickLabelInterpreter;
g.ZLabel.FontName = g.FontName;
g.ZLabel.FontSize = g.FontSize;

if sum(size(legend))>0
    l = legend;
    l.Interpreter = g.TickLabelInterpreter;
    l.FontName = g.FontName;
    l.FontSize = g.FontSize;
end

%createMyColormap = @(n) [0.9*linspace(0,1,n+1)',0.4*ones(n+1,1),0.7*linspace(1,0,n+1)'];
createMyColormap = @(n) [linspace(150/255,89/255,n+1)',linspace(220/255,0/255,n+1)',linspace(255/255,179/255,n+1)'];
%createMyColormap = @(n) [linspace(0/255,204/255,n+1)',linspace(51/255,243/255,n+1)',linspace(153/255,255/255,n+1)'];
%colormap(createMyColormap(255));
colormap(gca, createMyColormap(255));

c = findall(groot,'Type','colorbar');
if sum(size(c))>0
    c.FontName = g.FontName;
    c.FontSize = g.FontSize;
    c.TickLabelInterpreter = g.TickLabelInterpreter;
    c.Label.FontName = g.FontName;
    c.Label.FontSize = g.FontSize;
    c.Label.Interpreter = g.TickLabelInterpreter;
end

leg = findall(groot,'Type','legend');
for i = 1:size(leg,1)
    leg(i).FontName = g.FontName;
    leg(i).FontSize = g.FontSize;
    leg(i).Interpreter = g.TickLabelInterpreter;
    leg(i).Location = 'northeast';
    %leg(i).Location = 'northwest';
    %leg(i).Location = 'southeast';
   %leg(i).Location ='northoutside'; %legend above the box
end


% % Style

% TYPE I: First line '-', then '--'; every line black
% used for main_CarPath_Shock, main_CarPath_Rarefaction,
% mainBufferIncrease
PersonalLineStyle = {'-','--','--'};
PersonalColor = {[0,0,0],[0,0,0],[0,0,0]};

% % TYPE II: First line '--', then '-'; every line black
% % used for mainRightOfWayParameter, mainBufferDemand, mainBufferIncrease
% PersonalLineStyle = {'--','-'};
% PersonalColor = {[0,0,0],[0,0,0]};



% TYPE II: 
%PersonalLineStyle = {'-','--','-.',':','-','--'};
%PersonalColor = {[0,0,0],[89,0,179]/255,[230, 46,0]/255,[0,0,0]/255};

PersonalMarker = {'.','s','d','*'};

lines = findobj('Type', 'line');
for i = 1:size(lines,1)
     lines(i).LineWidth = 1.5;%2.5;
     if ~(strcmp(lines(i).LineStyle,'none'))
         lines(i).LineStyle = PersonalLineStyle{size(lines,1)-i+1};
     end
%     lines(i).MarkerSize = 20;
%     if ~(strcmp(lines(i).Marker,'none'))
%         lines(i).Marker = PersonalMarker{size(lines,1)-i+1};
%     end
    lines(i).Color = PersonalColor{size(lines,1)-i+1};
end

%     lines(1).Color = [16,78,139]/255;
%     lines(1).LineStyle = '-';


set(fig, 'PaperPositionMode','auto')

% set(findall(gcf,'-property','FontSize'),'FontSize',g.FontSize)
% set(findall(gcf,'-property','FontName'),'FontName',g.FontName)

%fileadd = '4_ProductionLoadDependent_';
savefig([fig.FileName(1:end-4),'./Figures/_new.fig']);
print([fig.FileName(1:end-4),'./Figures/.eps'],'-depsc','-loose');
%close