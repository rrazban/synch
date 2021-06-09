function lam_diet(method,num_regions)
%% Lambda differences for individual subjects under ketogenic or glycolytic
%diet (Figure 5b)
%methods: 'regular', 'gs', 'acompcor15','new_wmcsf'
%num_regions: 1 to 498


[Lamglu,m_glu,T,~]=readin_diet(method,'std',num_regions);
[Lamket,m_ket,T,~]=readin_diet(method,'ket',num_regions);

vglu=m_glu(1,:);
vket=m_ket(1,:);

%[Lamglu,m_glu,~,~,~]=readin_bolus('glc',num_regions);
%[Lamket,vket,Sub_Ages,T,~]=readin_bolus('bhb',num_regions);

%thresh=50;
%Lamglu = Lamglu(Sub_Ages<thresh);
%vglu = vglu(Sub_Ages<thresh);

%Lamket = Lamket(Sub_Ages<thresh);
%vket = vket(Sub_Ages<thresh);

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
                                                    
%% statistical Test
[pdiet,~,stats]=signrank(Lamglu,Lamket,'tail','left');       %Wilcoxon Sign-rank for diets
magnitude = strcat('W = ', string(stats.signedrank));
pvalue = strcat('p = ', sprintf('%.3f',pdiet));
sprintf(strcat(magnitude, '\n', pvalue))

%% Plot the figure
plot_diet(difLam, difErr, TOTAL, pdiet)
