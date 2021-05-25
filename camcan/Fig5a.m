function Fig5a(method,num_regions)
%% Lambda as a function of age (Figure 5a)
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'
%num_regions: 1 to 498


[Lamage,vage,Sub_Ages,Tage,~]=readin_camcan(method,num_regions);



%% Calculating the means and error bars for each age bin (Camcan only).

Edges=[18,32,46,60,74,88];  %The plotted age groups (5 total) are the midpoints between these edges 

Q25e=zeros(1,5);
Q75e=zeros(1,5);
Qmed=zeros(1,5);

for i=1:5
    q=find(Sub_Ages>Edges(i)&Sub_Ages<Edges(i+1));          %calculates the medians and quartiles (error bars) of each age group 
                                                            
    sss=Lamage(q);
    Qmed(i)=median(sss);
    Q25e(i)=Qmed(i)-quantile(sss,.25);
    Q75e(i)=quantile(sss,.75)-Qmed(i);
end

%% Plot the figure

h=figure;
hold on
hl=errorbar(1:5,Qmed,Q25e,Q75e);
hl.Marker='o';
hl.MarkerEdgeColor= [.2 .2 .2];
hl.MarkerFaceColor=[.7 .7 .7];
hl.MarkerSize=6;  
hl.LineWidth=1;
hl.Color='k';
hAxis=gca;
h.Color=[1 1 1];
xlim([0.5 5.5])
xticks([1 2 3 4 5])
xticklabels({'25' '39' '53' '67' '81'})
title(strcat(method,', ', string(num_regions), ' regions'))
ylabel('\Lambda')
xlabel('Ages')
hAxis.TickLength=[.04 .04];
hAxis.XMinorTick='off';
hAxis.YMinorTick='on';
hAxis.LineWidth=1;

% Statistical Test
[ro,page]=corr(Sub_Ages,Lamage','Type','Spearman');
magnitude = strcat('ρ = ', sprintf('%.3f',ro));
pvalue = strcat('p-val = ', sprintf('%.2d',page));
str = sprintf(strcat(magnitude, '\n', pvalue));

xL=xlim;
yL=ylim;
text(0.99*xL(2),0.99*yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')

hold off

