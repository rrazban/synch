function Fig5b(method,num_regions)
%% Lambda differences for individual subjects under ketogenic or glycolytic
%diet (Figure 5b)
%methods: 'regular', 'gs', 'acompcor15','new_wmcsf'
%num_regions: 1 to 498


[Lamglu,vglu,T,~]=readin_diet(method,'std',num_regions);
[Lamket,vket,T,~]=readin_diet(method,'ket',num_regions);

%[Lamglu,vglu,N,T]=readin_bolus('glc');
%[Lamket,vket,N,T]=readin_bolus('bhb');

TOTAL = size(Lamglu,2);


%% Find Errorbars for Each Lambda fit
[Errtopg,Errbotg]=errorbars(num_regions,T,TOTAL,Lamglu,vglu);
[Errtopk,Errbotk]=errorbars(num_regions,T,TOTAL,Lamket,vket);


%% Calculate the error bars for the rescaled Lambda
    
difLam=Lamket-Lamglu;

%Next we have to propagate the error bars (from our posterior distribution) 
%to find the error bars of difLam for each subject
    
% For simplicity we just approximate the error as being symmetric.
  
Errg=(Errtopg-Errbotg)/2;
Errk=(Errtopk-Errbotk)/2;

lamcrit=1/(2*num_regions);
difErr=sqrt(Errg.^2+Errk.^2)/(lamcrit);  %standard error propagation for differences
                                         %rescaling was because of rescaling lambda->Lambda
                                                    


%% Plot the figure

[a,b]=sort(difLam,'descend'); %subjects are ordered by difLam

h=figure;
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
xlabel('Subjects')
ylabel('\Lambda_{Ket}-\Lambda_{Glu}')
%ylabel('\Lambda_{bhb}-\Lambda_{glc}')
hAxis.TickLength=[.04 .04];
hAxis.XMinorTick='off';
hAxis.YMinorTick='off';
hAxis.LineWidth=1;
xticks([1:1:TOTAL])
xticklabels({});
h.Color=[1 1 1];
title(strcat(method,', ', string(num_regions), ' regions'))


% statistical Test

[pdiet,~,stats]=signrank(Lamglu,Lamket,'tail','left');       %Wilcoxon Sign-rank for diets
magnitude = strcat('W = ', string(stats.signedrank));
pvalue = strcat('p = ', sprintf('%.3f',pdiet));
str = sprintf(strcat(magnitude, '\n', pvalue));

xL=xlim;
yL=ylim;
text(0.99*xL(2),0.99*yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')

hold off