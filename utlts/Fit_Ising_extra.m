function [Lam,m2,m4,m2_fit,m4_fit]=Fit_Ising_extra(Data)

% Currently will only work for an EVEN number of regions.  Can be adapted.
%seems to be related to how v is defined

% Data is a T (time) x N (regions) matrix


sz=size(Data);
T=sz(1);
N=sz(2);


%remove this below, flipping is no longer used
Flip=ones(1,N);                                 %1 if we don't flip, -1 if we flip.  See Methods and XYZ.m
%load('Flip_Ind.mat');   %does not seem to matter
%for i=1:15              %not sure why only look at first 15
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
m4=var(s.^2);

k=0:1:N;
v=(2*k-N)/N;
vv=v.^2;
vvvv=vv.^2;

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

m2_fit = f1(lam)/f2(lam);
f4=@(lambda) sum(vvvv.*nck.*exp(lambda.*vv*N^2)); 
m4_fit = f4(lam)/f2(lam) - m2_fit^2;

