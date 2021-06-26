function [Errtop,Errbot]=errorbars(N,T,TOTAL,Lam,vdata)
%% Find Errorbars for Each Lambda fit


%x=.0006:.00001:.0016;                           % Our uniform prior distribution,  other lambda values are unphysical
x=6/(2*N*10):1/(2*N*1000):1.6/(2*N);    %need to sometimes make lower bound smaller for _gs results

% Requires the lowercase lambda values to be compatible with the likelihood
% function

lamcrit=1/(2*N);
lam=Lam*lamcrit+lamcrit;


%Calculating the log-likelihood ratio of the ML fit from the data for each
%subject to all of the lambda values in x

LLr=zeros(TOTAL,length(x));

k=0:1:N;
v=(2*k-N)/N;
vv=v.^2;
nck=zeros(1,N+1);
for n=1:N+1
    nck(n)=nchoosek(N,k(n));
end

f2=@(lambda) sum(nck.*exp(lambda.*vv*N^2)); 


for i=1:TOTAL
    for j=1:length(x)
        LLr(i,j)=T*((x(j)-lam(i))*vdata(i)*N^2-(log(f2(x(j)))-log(f2(lam(i)))));
    end
end

%Calculating the actual errorbars

Errtop=zeros(1,TOTAL);
Errbot=zeros(1,TOTAL);

thr=log(.01);      %LL ratio is .01, that means that the ends of our confidence interval are predicted 
                          %to be 100-fold less likely than the ML estimate.
                          
                     
                          
                
%for each subject, finds the index (for the top and the bottom) of x, and corresponding values of lambda
%where the likelihood ratio is .01.  This is done by looping through x and
%stopping at the lowest and highest values in x that satify LL(x(i))>.01
                          
 
for i=1:TOTAL
    xx=x-lam(i);
    qp=find(xx>0);
    qm=find(xx<0);
    ind=0;
    ird=1;
    while ind==0
        if LLr(i,qp(ird))<=thr
            Errtop(i)=x(qp(ird));
            ind=1;
        elseif ird>length(qp)
            ind=1;
        else
            ird=ird+1;
        end
    end
    ind=0;
    ird=1;
    while ind==0
        if LLr(i,qm(length(qm)-ird+1))<=thr
            Errbot(i)=x(qm(length(qm)-ird+1));
            ind=1;
        elseif ird>length(qm)
            ind=1;  
        else
            ird=ird+1;
        end
    end
end

