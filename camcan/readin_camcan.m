function [Lamage,vage,Sub_Ages,correct_Tage,Age_Data]=readin_camcan(method,num_regions)

DIR = 'synchrony/'; %path to the repo from pwd, *set this appropriately*

prep_method = strcat(DIR,'/fmri_data/camcan/time_series_498_',method);


ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/age45,64.mat'));
%ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/diet.mat'));
rois = ranked_regions.indi(1:num_regions);%num_regions chooses the top ranked regions


info_file = 'CAMCAN_participant_data.tsv';
info = tdfread(info_file);
ages = info.age;
subs = cellstr(info.Observations);
TOTAL_SUBS = size(subs,1);

Lamage = ones(1,TOTAL_SUBS);    %why is this a row vector?
vage = ones(TOTAL_SUBS,1);
Sub_Ages = ones(TOTAL_SUBS,1);
Age_Data = {};


keySet = {'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'};
valueSet = [261 241 260 260 257];   %hard-coded
T_dict = containers.Map(keySet,valueSet);
correct_Tage = T_dict(method);


for s=1:TOTAL_SUBS
    sub = subs{s};
    filename = strcat(prep_method,'/sub-',sub,'.csv');
    
    if isfile(filename)
        raw_data=readmatrix(filename);
        if num_regions~=498       %important to keep original region numbering for indentify_age
            raw_data=raw_data(:,rois);
        end
        
        Tage=size(raw_data,1);
        if Tage==correct_Tage     %make sure time always the same       
            [Lamage(s),vage(s)] = Fit_Ising(raw_data);

            Sub_Ages(s)=ages(s);
            Age_Data{1,end+1}=raw_data; %needed for Fig 4c
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