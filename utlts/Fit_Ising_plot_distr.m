function [Lam,m2]=Fit_Ising_plot_distr(Data,age)

% Currently will only work for an EVEN number of regions.  Can be adapted.
%seems to be related to how v is defined

% Data is a T (time) x N (regions) matrix
% Flip_Ind is dependent on Willard Atlas.  Perhaps we can ignore this step
% later

sz=size(Data);
T=sz(1);
N=sz(2);


Flip=ones(1,N);     %1 if we don't flip, -1 if we flip.  See Methods and XYZ.m
%load('Flip_Ind.mat');   
%for i=1:15              
%    Flip(Flip_Ind(i))=-1;
%end


%% Binarizing the data and computing synchrony

Data_Bin=zeros(T-1,N);

kend= @(x1,x2) 1.*(x2-x1>0)-1.*(x2-x1<0);
for t=1:T-1
    for n=1:N
        Data_Bin(t,n)=kend(Data(t,n),Data(t+1,n));
    end
end
s=sum(Flip.*Data_Bin,2)/N;


%% Fitting the Ising model


%This finds the unique value of lambda that best fits the sufficient statistic, mean(s^2)
% Currently will only work for an EVEN number of regions.  Can be adapted.


m2=mean(s.^2);


k=0:1:N;
v=(2*k-N)/N;
vv=v.^2;
nck=zeros(1,N+1);
warning('off','all'); %choosek gives a warning
for n=1:N+1
    nck(n)=nchoosek(N,k(n));
end

f1=@(lambda) sum((vv).*nck.*exp(lambda.*vv*N^2));   %mean s^2 (variance of s)
f2=@(lambda) sum(nck.*exp(lambda.*vv*N^2));         %normalization         
f3=@(lambda) f1(lambda)./f2(lambda)-m2;
options = optimset('TolX',1*10^-10);                %ML estimation

lam=fzero(f3,.00001,options);  

Lamc=1/(2*N);
Lam=(lam-Lamc)/Lamc;

%everything above is the exact same as Fit_Ising
%below is where the actual plotting happens to visualize fit

P=nck.*exp(lam*vv*N^2);
F = griddedInterpolant(v,P);
fun = @(t) F(t);
Z = integral(fun, v(1), v(end));    %normalization to be able to directly compare P(s) with histogram

%plot(vv,P/Z);  %plot wrt s^2, the variable whose mean we are fitting
%hold on
%histogram(s.^2,10,'Normalization','probability');
%xlabel('s^2');

id = strcat('age: ',string(age),', \Lambda= ',sprintf('%.3f',Lam));

plot(v,P/Z);
hold on;
histogram(s,10,'Normalization','pdf');
xlabel('s');
title(id)
ylabel('P(s)');
pause
hold off






