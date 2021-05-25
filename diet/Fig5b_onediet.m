function Fig5b_onediet(method,which,num_regions)
%% Variant of Fig5b, instead of difference between glc and ket, shows 
%individual lambda values per subject

%methods: 'regular', 'gs', 'acompcor15','new_wmcsf'
%which: 'ket', 'std'    %'std' corresponds to glycolytic diet
%num_regions: 1 to 498



if which=='ket' | which=='std'
    [Lam,vdata,T,~]=readin_diet(method,which,num_regions);
elseif which=='glc' | which=='bhb'
    [Lam,vdata,T,~]=readin_bolus(which);
end


TOTAL = size(Lam,2);

%% Find Errorbars for Each Lambda fit
[Errtop,Errbot]=errorbars(num_regions,T,TOTAL,Lam,vdata);


%% Calculate the error bars for the rescaled Lambda

difLam=Lam;

%Next we have to propagate the error bars (from our posterior
%distribution to find the error bars of difLam for each subject
    
% For simplicity we just approximate the error as being symmetric.
  
Err=(Errtop-Errbot)/2;

lamcrit=1/(2*num_regions);
difErr=Err/(lamcrit); %rescaling was because of rescaling lambda->Lambda
                                                    


%% This code will plot the plain figures with the default matlab settings

[a,b]=sort(difLam,'descend');

h=figure;
hold on
hAxis=gca;
%bar(difLam(b));
%h1=errorbar(1:TOTAL,difLam(b),difErr(b));
bar(difLam);
h1=errorbar(1:TOTAL,difLam,difErr);
h1.Marker='.';
h1.MarkerEdgeColor= [.2 .2 .2];
h1.MarkerFaceColor=[.7 .7 .7];
h1.LineStyle='None';
h1.Color='k';
h1.LineWidth=1;
title(strcat(method,', ', string(num_regions), ' regions'))
xlabel('Subjects')
ylabel(strcat('\Lambda_{',which,'}'))
hAxis.TickLength=[.04 .04];
hAxis.XMinorTick='off';
hAxis.YMinorTick='on';
hAxis.LineWidth=1;
xticks([1:1:TOTAL])
xticklabels({});
h.Color=[1 1 1];

hold off