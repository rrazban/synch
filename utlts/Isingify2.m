function Xnew= Isingify2(t,n,X)

Xnew=zeros(t-1,n);
kend= @(x1,x2) 1.*(x2-x1>0)-1.*(x2-x1<0);
for i=1:t-1
    for j=1:n
        Xnew(i,j)=kend(X(i,j),X(i+1,j));
    end
end