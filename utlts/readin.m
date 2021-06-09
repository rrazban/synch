function [Lam,moments,Sub_Ages,Data]=readin(data_dir,num_regions,subs,correct_T,ages,diet)

DIR = 'synchrony/'; %path to the repo from pwd, *set this appropriately*
%disp(['repository path from present working directory is currently: ', DIR])

ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/age45,64.mat'));%diet.mat
rois = ranked_regions.indi(1:num_regions);%num_regions chooses the top ranked regions
%rois = randsample(1:498,num_regions);


TOTAL_SUBS = length(subs);
Lam = ones(1,TOTAL_SUBS);    
moments = ones(4, TOTAL_SUBS); %m2 data, m4 data, m2 fit, m4 fit %note that m2 data = m2 fit by constructions
Sub_Ages = ones(1,TOTAL_SUBS);  %needed for readin_camcan and readin_bolus (does not apply to diet data)
Data = {};

remove_sub = [];

for s=1:TOTAL_SUBS  %have this read in from a utilits fxn (readin.m), pass an empty list for diet for ages%also allows you to set DIR once!
    sub = subs{s};
    if diet=='ket' | diet=='std'
        filename = strcat(DIR,data_dir,'/sub-',sub,'_ses-',diet,'.csv');%diet=ket,std
    elseif diet=='glc' | diet=='bhb'
        filename = strcat(DIR,data_dir,'/sub-',sub,'_ses-',diet,'_task-rest_run-2.csv');%diet=bhb,glc
    else
        filename = strcat(DIR,data_dir,'/sub-',sub,'.csv'); %camcan data
    end
    
    if isfile(filename)
        raw_data=readmatrix(filename);
        if num_regions~=498       %important to keep original region numbering for identify_age/diet
            raw_data=raw_data(:,rois);
        end

        Tage=size(raw_data,1);
        if Tage==correct_T  %make sure time always the same       
            [Lam(s),moments(1,s),moments(2,s),moments(3,s),moments(4,s)] = Fit_Ising(raw_data);            
            Data{1,end+1}=raw_data;
            
            %uncomment below to check out distributions individually
            %Fit_and_plot_Ising(Lam(s),raw_data,ages(s));%or diet 
                    
            if ~strcmp(ages,'none')            
                Sub_Ages(s)=ages(s);
            end
        else
            disp(strcat(sub,' has incorrect time series length'))
            remove_sub(end+1) = s;
        end
    else
        disp(strcat(sub,' is not present'))
        remove_sub(end+1) = s;
    end    
end

%delete subjects from outputs that are not present or have incorrect time series length
Lam(remove_sub) = [];
Sub_Ages(remove_sub) = [];
moments(:,remove_sub)=[];
