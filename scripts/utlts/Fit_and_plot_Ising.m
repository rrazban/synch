function [Lam,m2]=Fit_and_plot_Ising(Lam,Data,label)

%recreate some of the stuff needed from Fit_Ising.m
sz=size(Data);
T=sz(1);
N=sz(2);

Lamc=1/(2*N);
lam=Lamc*(Lam+1);

k=0:1:N;
v=(2*k-N)/N;
vv=v.^2;
nck=zeros(1,N+1);
warning('off','all'); %choosek gives a warning
for n=1:N+1
    nck(n)=nchoosek(N,k(n));
end


%start making the distribution plots
Data_Bin=Isingify2(T,N,Data);
s=sum(Data_Bin,2)/N;

pfit=nck.*exp(lam*vv*N^2);


control='compare_abs'; %compare_bins, _absolute

if strcmp(control, 'compare_bins')
    countsp=round(pfit);
    [countsd,Edges]=histcounts(s,'BinLimits',[-1,1]);
    countspnew=zeros(1,length(Edges)-1);

    for i=1:length(countspnew)
        k=ceil(Edges(i)*N);
        if mod(k,2)==1
            k=k+1;
        end
        while k<= floor(Edges(i+1)*N)
            countspnew(i)=countspnew(i)+countsp((k+N+2)/2); %not sure why N+2   %related to how nck is N+1
            k=k+2;
        end
    end
    histogram('BinEdges',Edges,'BinCounts',countspnew,'normalization','probability','DisplayStyle','stairs');
    hold on
    normalize = 'probability';
    
else
    F = griddedInterpolant(v,pfit);
    fun = @(t) F(t);
    Z = integral(fun, v(1), v(end));    %normalization to be able to directly compare P(s) with histogram

    plot(v,pfit/Z);  %plot wrt s^2, the variable whose mean we are fitting
    hold on
    normalize = 'pdf';
end


histogram(s,'BinLimits',[-1,1],'normalization',normalize,'DisplayStyle','stairs')

%id = strcat('age: ',string(label),', \Lambda= ',sprintf('%.3f',Lam));
id = strcat(string(label),', \Lambda= ',sprintf('%.3f',Lam));

title(id)
legend('data', 'theory')
xlabel('s');
ylabel('P(s)');
pause
hold off


%save('bhb.mat','s','Edges','countspnew')   %for readin to make FigS4






