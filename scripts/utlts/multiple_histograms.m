ages = {'39' '53' '67' '81'};
N=length(ages);

annotation('textarrow','Position',[.0675,0.085,0,.15],'String','   P(s)','HeadWidth',5,'HeadLength',5,'HorizontalAlignment','left','VerticalAlignment','cap','TextRotation',90,'Textmargin',10)
annotation('doublearrow','Position',[.0250,0.085,.075,0],'Head1Width',5,'Head2Width',5,'Head1Length',5,'Head2Length',5)
annotation('textbox',[.0475,0.045,0,.05],'String','s','FitBoxToText','on','EdgeColor','none')

for i=1:N
    filename=strcat('age',ages{i},'.mat');
    stuff=load(filename);
    if i>2
        splt = i+1;
    else
        splt=i;
    end
    subplot(2,3,splt)
    hold on;
    h=histogram('BinEdges',stuff.Edges,'BinCounts',stuff.countspnew,'normalization','probability','DisplayStyle','stairs');
    hi=histogram(stuff.s,'BinLimits',[-1,1],'normalization','probability','DisplayStyle','stairs');
    h.LineWidth=2;
    hi.LineWidth=2;
    id = strcat('Age{ }',ages{i});
    yticks([0.1 0.2])
    title(id)
end
hold off
legend('Model','Data')
diet={'Glucose', 'Ketone'};
bolus={'glc','bhb'};


for j=1:2
    filename=strcat(bolus{j},'.mat');
    stuff=load(filename);
    subplot(2,3,3*j)
    hold on;
    h=histogram('BinEdges',stuff.Edges,'BinCounts',stuff.countspnew,'normalization','probability','DisplayStyle','stairs');
    hi=histogram(stuff.s,'BinLimits',[-1,1],'normalization','probability','DisplayStyle','stairs');
    h.LineWidth=2;
    hi.LineWidth=2;
    id = diet{j};
    yticks([0.1 0.2])
    title(id)
end

ratio=2;%3.25, 1.75
set(gcf,'units','inches','position',[2,2,ratio*4,ratio*2])
%xlabel('s'); maybe have this labels spanning entire y and x axis
%ylabel('P(s)');