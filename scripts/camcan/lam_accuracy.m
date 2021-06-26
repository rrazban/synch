function lam_accuracy(method,num_regions,which)
%% mean(s^2) or var(s^2) as function of Lambda
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'
%num_regions: 1 to 498
%which= 'var' or 'mean' of s^2


[Lam_fit,moments,~,~,~]=readin_camcan(method,num_regions);

m2_data = moments(1,:);
m4_data = moments(2,:);
m2_fit = moments(3,:);
m4_fit = moments(4,:);


%% Plot the figure
if strcmp(which, 'var')
    scatter(Lam_fit, m4_data, 100)
    hold on
    scatter(Lam_fit, m4_fit,'filled')
    ylabel('Var (s^2)')

else
    scatter(Lam_fit, m2_data, 100)
    hold on
    scatter(Lam_fit, m2_fit,'filled')
    ylabel('Mean (s^2)')
end

legend('data', 'theory')
xlabel('\Lambda')
title(strcat(method,', ', string(num_regions), ' regions'))
%hold off

