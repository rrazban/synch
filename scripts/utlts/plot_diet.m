function plot_diet(difLam, difErr, TOTAL, pdiet, which, ages)
    
[a,b]=sort(difLam,'descend'); %subjects are ordered by difLam
%[a,b]=sort(ages,'ascend');


%h=figure;
h=subplot(1,3,[2 3]);
hold on
hAxis=gca;

bar(difLam(b));
h1=errorbar(1:TOTAL,difLam(b),difErr(b));
h1.Marker='.';
h1.MarkerEdgeColor= [.2 .2 .2];
h1.MarkerFaceColor=[.7 .7 .7];
h1.LineStyle='None';
h1.Color='k';
h1.LineWidth=1;
hAxis.TickLength=[.04 .04];
hAxis.XMinorTick='off';
hAxis.YMinorTick='off';
hAxis.LineWidth=1;    

xticks([1:1:TOTAL])
xticklabels({});
xlabel('Subjects')
h.Color=[1 1 1];
%title(strcat(method,', ', string(num_regions), ' regions'))

if pdiet==1
    ylabel(strcat('\Lambda_{',which,'}'))
else
    str = strcat('{\it p} {= }', sprintf('%.1d',pdiet));
    xL=xlim;
    yL=ylim;
    text(0.99*xL(2),0.99*yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')
    ylabel('\Lambda_{Ket}-\Lambda_{Glu}')
end

pos = get(gca, 'Position');
pos(1) = pos(1) + 0.05; %necessary to ensure ylabel of Fig5b does not bleed into Fig5a
set(gca, 'Position', pos)
set(gcf,'units','inches','position',[2,2,8,4])
hold off