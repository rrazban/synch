function [Lamdiet,moments,correct_T,Data]=readin_diet(diet,num_regions)

%data_dir = strcat('/fmri_data/diet/time_series_498_',method);
data_dir = '/fmri_data/diet/';

subs = {'001','002','005','019','022','027','028','031','032','034','036','038'};

%keySet = {'regular','gs','acompcor15','new_wmcsf'};
%valueSet = [740 740 730 730];
%T_dict = containers.Map(keySet,valueSet);
%correct_T = T_dict(method);
correct_T = 740;

[Lamdiet,moments,~,Data]=readin(data_dir,num_regions,subs,correct_T,'none',diet);