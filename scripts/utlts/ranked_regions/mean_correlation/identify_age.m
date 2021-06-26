function identify_age_ori(method)
%% rank regions according to mean correlation difference between young and old
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'

[~,~,ages,~,Age_Data]=readin_camcan(method,498);

TOTAL_SUBS = size(ages,1);

mean_R_old = zeros(498);
mean_R_young = zeros(498);
num_old = 0;
num_young = 0;

for s=1:TOTAL_SUBS
    if ages(s)>64
        R = corrcoef(Age_Data{s});
        mean_R_old = mean_R_old+R;
        num_old = num_old+1;
    
    elseif ages(s)<45
        R = corrcoef(Age_Data{s});
        mean_R_young = mean_R_young+R;
        num_young = num_young+1;
    end        
end

mean_R_old = mean_R_old/num_old;
mean_R_young = mean_R_young/num_young;

difference_per_region=mean(mean_R_young-mean_R_old,1);%order of mean (before or after difference taken) does not seem to matter

[val,indi] = maxk(difference_per_region, 498);
%sort(indi(1:10))' %show the top ten
%save('age45,64.mat','indi');  %save the ranking so that it can be used by readin


histogram(difference_per_region)
ylabel('frequency');
xlabel('difference of mean correlation per region');



            
