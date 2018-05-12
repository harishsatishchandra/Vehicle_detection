
%% generate covariance feature descriptor

function c=gencov(img)
figure(1)
imagesc(img);
[y,x]=ginput(2);
x=round(x);
y=round(y);
fi=featureim(img(x(1):x(2),y(1):y(2)));
c=cov(reshape(fi,size(fi,1)*size(fi,2),size(fi,3)));
end