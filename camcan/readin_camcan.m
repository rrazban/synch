function [Lamage,moments,Sub_Ages,correct_Tage,Age_Data]=readin_camcan(method,num_regions)

data_dir = strcat('/fmri_data/camcan/time_series_498_',method);

info_file = 'CAMCAN_participant_data.tsv';
info = tdfread(info_file);
ages = info.age;
subs = cellstr(info.Observations);


keySet = {'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'};
valueSet = [261 241 260 260 257];   %hard-coded
T_dict = containers.Map(keySet,valueSet);
correct_Tage = T_dict(method);


[Lamage,moments,Sub_Ages,Age_Data]=readin(data_dir,num_regions,subs,correct_Tage,ages,'N/A');