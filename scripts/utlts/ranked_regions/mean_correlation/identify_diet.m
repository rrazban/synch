function identify_diet(method)
%% rank regions according to mean correlation difference between young and old
%methods: 'regular', 'gs', 'acompcor15','new_wmcsf'

[~,~,~,Data_glu]=readin_diet(method,'std',498);
[~,~,~,Data_ket]=readin_diet(method,'ket',498);

TOTAL_SUBS = size(Data_glu,2);

mean_R_glu = zeros(498);
mean_R_ket = zeros(498);


for s=1:TOTAL_SUBS
    R = corrcoef(Data_glu{s});
    mean_R_glu = mean_R_glu+R;
    
    R = corrcoef(Data_ket{s});
    mean_R_ket = mean_R_ket+R;    
end

mean_R_glu = mean_R_glu/TOTAL_SUBS;
mean_R_ket = mean_R_ket/TOTAL_SUBS;

difference_per_region=mean(mean_R_ket-mean_R_glu,1);%order of mean (before or after difference taken) does not seem to matter

[val,indi] = maxk(difference_per_region, 498);
%sort(indi(1:10))' %show the top ten
%save('diet.mat','indi');  %save the ranking so that it can be used by readin

ylabel('frequency');
xlabel('difference of mean correlation per region');
histogram(difference_per_region)



            
