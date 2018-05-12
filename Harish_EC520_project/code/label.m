% code for class creation

img = imread('/home/khurshid-admin/Pictures/ec520/extra/thumb0751.jpg');
img_gray = rgb2gray(img);
figure;
imshow(img_gray);
img_crop = imcrop(img_gray);
%car
load('db1.mat');
%truck
load('db2.mat');
%junk
load('db3.mat');
% car.cov(:,:,end) = [];
% truck.cov(:,:,end) = [];
cova = gencov(img_crop);
if isempty(db2.cov)
    db2.cov(:,:,end) = cova;
else
    db2.cov(:,:,end+1) = cova;
end

save('db1.mat', 'db1')
save('db2.mat', 'db2')
save('db3.mat', 'db3')