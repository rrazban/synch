function identify_age(method)
%% rank regions according to mean correlation difference between young and old
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'

num_regions=498;
[~,~,ages,T,Age_Data]=readin_camcan(method,num_regions);

TOTAL_SUBS = size(ages,1);

mean_R_old = zeros(1,498);
mean_R_young = zeros(1,498);
num_old = 0;
num_young = 0;

for s=1:TOTAL_SUBS
    if ages(s)>64
        %R = corrcoef(Age_Data{s});
        Xnew= Isingify2(T,num_regions,Age_Data{s});
        FC_per_region = sum(Xnew,1);
        mean_R_old = mean_R_old+FC_per_region;
        num_old = num_old+1;
    
    elseif ages(s)<45
        %R = corrcoef(Age_Data{s});
        Xnew= Isingify2(T,num_regions,Age_Data{s});
        FC_per_region = sum(Xnew,1);
        mean_R_young = mean_R_young+FC_per_region;
        num_young = num_young+1;
    end        
end

mean_R_old = mean_R_old/num_old;
mean_R_young = mean_R_young/num_young;

difference_per_region=mean_R_young-mean_R_old


ylabel('frequency');
xlabel('difference of mean correlation per region');
histogram(difference_per_region)



            
