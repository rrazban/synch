function FC(method)
%% rank regions according to ?
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'

num_regions = 498;
[~,~,ages,T,Age_Data]=readin_camcan(method,num_regions);

TOTAL_SUBS = size(ages,1);


for s=1:TOTAL_SUBS
    Xnew= Isingify2(T,num_regions,Age_Data{s});
    FC_per_region = sum(Xnew,1);
    
    [val,indi] = maxk(FC_per_region, 498);
    sort(indi(1:10))'
    histogram(FC_per_region);
    %scatter(1:num_regions,sort(FC_per_region));
    pause
end




            
