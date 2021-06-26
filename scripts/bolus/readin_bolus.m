function [Lamdiet,vdiet,Sub_Ages,correct_T,Data]=readin_bolus(diet,num_regions)


data_dir = '/fmri_data/bolus/parcelled_498';

info_file = 'info_bolus.txt';
info = tdfread(info_file);
ages = info.age;
full_subs = cellstr(info.Subject);
subs = cellfun(@(S) strcat('0',S(end-1:end)), full_subs, 'Uniform', 0);%need to concatenate 0 since some in info file are not three digits


%subs = {'006', '010', '011', '012', '013', '015', '016', '019', '020', '021',... 
    %'023', '025', '027', '028', '029', '034', '035', '037', '041', '042', '044',... 
    %'045', '046', '047', '048', '049', '051', '052', '053', '054', '056', '057',... 
    %'058', '059', '060', '061', '062', '063', '064', '066', '067', '068', '070',... 
    %'071', '072', '075', '076', '079', '080', '082', '084', '085', '090', '091',... 
    %'092', '093', '094', '095', '098', '099'};

correct_T=720;
[Lamdiet,vdiet,Sub_Ages,Data]=readin(data_dir,num_regions,subs,correct_T,ages,diet);
