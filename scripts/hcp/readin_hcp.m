function [Lamage,moments,Sub_Ages,correct_Tage,Age_Data]=readin_hcp(num_regions)

data_dir = '/fmri_data/hcp/';

info_file = 'info_hcp.txt';
info = tdfread(info_file);
ages = info.age;
subs = cellstr(info.src_subject_id);

correct_Tage = 1912;


[Lamage,moments,Sub_Ages,Age_Data]=readin(data_dir,num_regions,subs,correct_Tage,ages,'N/A');