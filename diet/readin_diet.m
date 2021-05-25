function [Lamdiet,vdiet,correct_T]=readin_diet(method,diet,num_regions)

DIR = 'synchrony/'; %path to the repo from pwd, *set this appropriately*

prep_method = strcat(DIR,'/fmri_data/diet/time_series_498_',method);

subs = {'001','002','005','019','022','027','028','031','032','034','036','038'};
%subs = {'034'};%the outlier
TOTAL_SUBS = size(subs,2);

Lamdiet = ones(1,TOTAL_SUBS);
vdiet = ones(TOTAL_SUBS,1);

keySet = {'regular','gs','acompcor15','new_wmcsf'};
valueSet = [740 740 730 730];
T_dict = containers.Map(keySet,valueSet);
correct_T = T_dict(method);


ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/age45,64.mat'));
%ranked_regions = load(strcat(DIR,'utlts/ranked_regions/mean_correlation/diet.mat'));
rois = ranked_regions.indi(1:num_regions);%num_regions chooses the top ranked regions


for s=1:TOTAL_SUBS
    sub = subs{s};

    filename = strcat(prep_method,'/sub-',sub,'_ses-',diet,'.csv');%diet=ket,std

    if isfile(filename)
        raw_data=readmatrix(filename);
        raw_data=raw_data(:,rois);
        
        Tage=size(raw_data,1); 
        if Tage==correct_T     %make sure time always the same       
            [Lamdiet(s),vdiet(s)] = Fit_Ising(raw_data);
            
        else
            disp(strcat(sub,' has incorrect time series length'))
        end
    else
        disp(strcat(sub,' is not present'))
    end    
end

%delete subjects not present or have incorrect time series length
Lamdiet(Lamdiet == 1) = [];
vdiet(vdiet == 1) = [];