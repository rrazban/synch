function Fig4c(method,num_regions)
%% Find Int and Seg and find their ratios vs Lambda (Figure 4c)
%methods: 'wmcsf','gs','wmcsfextra','wmcsfextra2','anar'
%num_regions: 1 to 498


[lamage,vage,Sub_Ages,T,Age_Data]=readin_camcan(method,num_regions);
N=num_regions;
TOTAL = size(lamage,2);

All_Age_data=zeros((T-1)*TOTAL,N);
BAge=zeros(T-1,TOTAL);
Flip=ones(1,N);                                 %1 if we don't flip, -1 if we flip.  See Methods and XYZ.m
%for i=1:15
 %   Flip(Flip_Ind(i))=-1;
%end


for i=1:TOTAL
    yy=Age_Data{i};
    yyn=Isingify2(length(yy(:,1)),N,yy);
    All_Age_data((T-1)*(i-1)+1:(T-1)*(i-1)+T-1,:)=Flip.*yyn;
	BAge(:,i)=sum(Flip.*yyn,2)/N;
end

BAge_reshaped=reshape(BAge,[(T-1)*TOTAL,1]);

%Find Int and Seg and normalize them
Ind_Seg=All_Age_data((abs(BAge_reshaped)==0),:);
Seg=corrcoef(Ind_Seg);
Seg=Seg-eye(N,N);
Seg=Seg/sqrt(sum(sum(Seg.^2)));  
Ind_Int=All_Age_data((abs(BAge_reshaped)>=1/2),:);
Int=corrcoef(Ind_Int);
Int=Int-eye(N,N);
Int=Int/sqrt(sum(sum(Int.^2)));

%Find P_Seg and P_Int for each subject

pseg=zeros(1,TOTAL);
pint=zeros(1,TOTAL);

cov_Seg_Int=sum(sum(Seg.*Int));
for i=1:TOTAL
    yy=Age_Data{i};
    yyn=Flip.*Isingify2(length(yy(:,1)),N,yy);
    Ma=cov(yyn);
    Ma=Ma-diag(diag(Ma));
    Ma=Ma/sqrt((sum(sum(Ma.^2))));
    pinti=sum(sum(Ma.*Int));
    psegi=sum(sum(Ma.*Seg));
    pint(i)=(pinti-psegi*cov_Seg_Int)/(1-cov_Seg_Int^2);
    pseg(i)=(psegi-pinti*cov_Seg_Int)/(1-cov_Seg_Int^2);
end


pint=pint./(pint+pseg);
pseg=1-pint;


figure

title(strcat(method,', ', string(num_regions), ' regions'))
xlabel('\Lambda')
hold on
yyaxis left
ylim([0 1])
scatter(lamage,pseg)
ylabel('P_{seg}')

yyaxis right 
ylim([0 1])
scatter(lamage,pint)
ylabel('P_{int}')

hold off