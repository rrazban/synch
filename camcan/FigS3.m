function FigS3(method,num_regions)
%% mean(s^2) or var(s^2) as function of Lambda (Figure S3)
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'
%num_regions: 1 to 498


[~,~,~,~,Data]=readin_camcan(method,num_regions);

TOTAL_SUBS = size(Data,2);

Lam_fit = ones(TOTAL_SUBS,1);
m2_data = ones(TOTAL_SUBS,1);
m4_data = ones(TOTAL_SUBS,1);
m2_fit = ones(TOTAL_SUBS,1);
m4_fit = ones(TOTAL_SUBS,1);

for s=1:TOTAL_SUBS
    [Lam_fit(s),m2_data(s),m4_data(s),m2_fit(s),m4_fit(s)] = Fit_Ising_extra(Data{s});
 
end


%if strcmp(which, 'mean')%be able to toggle from presenting mean and
%variance

scatter(Lam_fit, m4_data, 100)
hold on
scatter(Lam_fit, m4_fit,'filled')
    
%ylabel('Mean (s^2)')
legend('data', 'theory')
xlabel('\Lambda')
ylabel('Var (s^2)')
title(strcat(method,', ', string(num_regions), ' regions'))
hold off

