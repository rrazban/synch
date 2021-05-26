function [Lamage,vage,Sub_Ages,Data]=readin(data_dir,num_regions,subs,correct_T,ages,diet)

DIR = 'synchrony/'; %path to the repo from pwd, *set this appropriately*
disp(['repository path from present working directory is currently: ', DIR])


ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/age45,64.mat'));
%ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/diet.mat'));
rois = ranked_regions.indi(1:num_regions);%num_regions chooses the top ranked regions
%rois = randsample(1:498,num_regions)

TOTAL_SUBS = length(subs);
Lamage = ones(1,TOTAL_SUBS);    %why is this a row vector? dunno, other code seems to depend on it
vage = ones(TOTAL_SUBS,1);
Sub_Ages = ones(TOTAL_SUBS,1);
Data = {};                      %this becomes a row vector too

for s=1:TOTAL_SUBS  %have this read in from a utilits fxn (readin.m), pass an empty list for diet for ages%also allows you to set DIR once!
    sub = subs{s};
    if ~strcmp(diet,'N/A')
        filename = strcat(DIR,data_dir,'/sub-',sub,'_ses-',diet,'.csv');%diet=ket,std
    else
        filename = strcat(DIR,data_dir,'/sub-',sub,'.csv'); %camcan data
    end
    
    if isfile(filename)
        raw_data=readmatrix(filename);
        if num_regions~=498       %important to keep original region numbering for identify_age/diet
            raw_data=raw_data(:,rois);
        end
        
        Tage=size(raw_data,1);
        if Tage==correct_T     %make sure time always the same       
            [Lamage(s),vage(s)] = Fit_Ising(raw_data);
            %[Lamage(s),vage(s)] = Fit_Ising_plot_distr(raw_data,ages(s));

            Data{1,end+1}=raw_data;
            if strcmp(diet,'N/A')            
                Sub_Ages(s)=ages(s);
            end
        else
            disp(strcat(sub,' has incorrect time series length'))
        end
    else
        disp(strcat(sub,' is not present'))
    end    
end


%delete subjects not present or have incorrect time series length
Lamage(Lamage == 1) = [];
Sub_Ages(Sub_Ages == 1) = [];
vage(vage == 1) = [];
