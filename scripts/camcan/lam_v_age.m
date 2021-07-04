function lam_v_age(num_regions)
%% Lambda as a function of age (Figure 5a)
%num_regions: 1 to 498


[Lamage,~,Sub_Ages,~,~]=readin_camcan(num_regions);

%% Calculating the means and error bars for each age bin

Edges=[18,32,46,60,74,89];  %The plotted age groups (5 total) are the midpoints between these edges 
N = length(Edges)-1;

Q25e=zeros(1,N);
Q75e=zeros(1,N);
Qmed=zeros(1,N);

for i=1:N
    q=find(Sub_Ages>=Edges(i)&Sub_Ages<Edges(i+1));          %calculates the medians and quartiles (error bars) of each age group 
    sss=Lamage(q);
    Qmed(i)=median(sss);
    Q25e(i)=Qmed(i)-quantile(sss,.25);
    Q75e(i)=quantile(sss,.75)-Qmed(i);
end


%% Plot the figure
plot_figure_5a
%figure also used to make supplement figure for varying number of regions

    function plot_figure_5a
        %h=figure;
        h=subplot(1,3,1);
        hold on;

        l = plot(1:N,Qmed);
        l.LineWidth=5;
        l.Color = [0.8500 0.3250 0.0980]; %orange (default chosen as second color)
        hold on

        hl=errorbar(1:N,Qmed,Q25e,Q75e,'LineStyle', 'None');    %linestyle turns off line connection points (unable to make it wider without effecting error bar width
        hl.Marker='o';
        hl.MarkerEdgeColor= [.2 .2 .2];
        hl.MarkerFaceColor= [0.3010 0.7450 0.9330];%light blue (default) %dark blue  [0 0.4470 0.7410] (default chosen as first color)
        hl.MarkerSize=10;  
        hl.LineWidth=1;
        hl.Color='k';
        hold on

        hAxis=gca;
        h.Color=[1 1 1];
        xlim([0.5 5.5])
        xticks([1:N])
        xticklabels({'25' '39' '53' '67' '81'})
        
        %title(strcat(string(num_regions), ' regions'))
        ylabel('\Lambda')
        xlabel('Ages')
        hAxis.TickLength=[.04 .04];
        hAxis.XMinorTick='off';
        hAxis.YMinorTick='off';
        hAxis.LineWidth=1;

        % Statistical Test
        [ro,page]=corr(Sub_Ages',Lamage','Type','Spearman');
        magnitude = strcat('ρ = ', sprintf('%.3f',ro))
        pvalue = strcat('p = ', sprintf('%.2d',page));
        %str = sprintf(strcat(magnitude, '\n', pvalue));
        str = strcat('{\it p} {= }', sprintf('%.1d',page));
        xL=xlim;
        yL=ylim;
        text(0.99*xL(2),0.99*yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')

        set(gca,'box','off');   %remove axes on top and right
        set(gcf,'units','inches','position',[2,2,8,4])    %set figure size
        %hold off   
    end
end





