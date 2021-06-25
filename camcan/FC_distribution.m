function FC_distribution(method)
%% plot average functional connectivity across all camcan (Figure S2)
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'

num_regions=498;
[~,~,ages,T,Age_Data]=readin_camcan(method,num_regions);

TOTAL_SUBS = size(ages,1);

mean_R = zeros(num_regions);
for s=1:TOTAL_SUBS
    %calculate FC on binarized data
    Xnew= Isingify2(T,num_regions,Age_Data{s});
    R = corrcoef(Xnew);

    %calculate FC on unaltered data
    %R = corrcoef(Age_Data{s});

    mean_R = mean_R+R;        
end

mean_R = mean_R/TOTAL_SUBS;
mean_R_region = mean(mean_R,1);

histogram(mean_R_region)
ylabel('Frequency');
xlabel('Average FC per region');



            
