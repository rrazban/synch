function lam_onediet(which,num_regions)
%% Variant of Fig5b, instead of difference between glc and ket, shows 
%individual lambda values per subject

%which: 'ket', 'std'    %'std' corresponds to glycolytic diet
%num_regions: 1 to 498



if which=='ket' | which=='std'
    [Lam,m_data,T,~]=readin_diet(which,num_regions);
elseif which=='glc' | which=='bhb'  %method is not necessary here
    [Lam,m_data,Sub_Ages,T,~]=readin_bolus(which,num_regions);
end

vdata=m_data(1,:);
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
                                                    


%% Plot the figure
plot_diet(difLam, difErr, TOTAL, 1, which)   %pval does not make sense here so set arbitrarily to 1