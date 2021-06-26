function [Lam,m2,m4,m2_fit,m4_fit]=Fit_Ising(Data)

% Data is a T (time) x N (regions) matrix
sz=size(Data);
T=sz(1);
N=sz(2);


%% Binarizing the data and compute synchrony

Data_Bin=Isingify2(T,N,Data);
s=sum(Data_Bin,2)/N;


%% Fitting the Ising model
%This finds the unique value of lambda that best fits the sufficient statistic, mean(s^2)
% Currently will only work for an EVEN number of regions.  Can be adapted.

%N=25;  %set N_eff

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
options = optimset('TolX',1*10^-10);
lam=fzero(f3,.00001,options);                       %ML estimation
     
Lamc=1/(2*N);
Lam=(lam-Lamc)/Lamc;

%extra outputs to assess accuracy of fit in lam_accuracy.m
%m2 also useful in making errorbars for diet/bolus data
m4=var(s.^2);
vvvv=vv.^2;

m2_fit = f1(lam)/f2(lam);
f4=@(lambda) sum(vvvv.*nck.*exp(lambda.*vv*N^2)); 
m4_fit = f4(lam)/f2(lam) - m2_fit^2;
