cd /home/Harish/Pictures/ec520

%% read images into cell

imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    

for ii=1:nfiles   
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   currentimage = rgb2gray(currentimage);
   currentimage = imcrop(currentimage,[1 221 640 244]);
   currentimage = double(currentimage);
   images{ii} = currentimage;
   images2{ii} = currentimage;
end

%% Image Detection

for jj = 1:nfiles   
   if jj == 1
       sum = images{jj};
   else
       sum = sum + images{jj};
   end
end
N = 1./length(images);
B = N.*sum;
nnn = 1;
for kk = 1:nfiles
    images{kk} = images{kk} - B;  % subtract background from each frame
    images{kk} = medfilt2(images{kk},[5 5]);    % use median filter to  
                                                % eliminate noise
    images{kk} = images{kk}+20; % decrese intensity to delete high 
                                % intensity noise 
    thresh = images{kk};
    [row,col] = size(thresh);
    for i=1:row
        for j = 1:col
            if thresh(i,j) < 0
                thresh(i,j) = 255;
            else
                thresh(i,j) = 0;
            end
        end
    end    
    images1{kk} = thresh;
    images1{kk} = imbinarize(images1{kk},1);
    
%% image segmentation

    images1{kk} = imcrop(images1{kk},[1 34 481 149]);% crop image to remove 
                                                     % unwanted detections 
    cov_mat = [];
    cov_mat(:,:,end) = zeros(6,6);
    se = strel('disk',10);
    images1{kk}= imclose(images1{kk},se); % morphological closing
    dd = bwconncomp(double(images1{kk})); % create bounding box
    labeled = labelmatrix(dd);
    k = regionprops(dd,'BoundingBox');
    q = regionprops(dd,'FilledArea');

    for i = 1:length(k)
        if q(i).FilledArea >= 1000 % if filled area of bounding box 
                                   % greater than threshold, then  
                                   %vehicle detected 

            kk1 = k(i).BoundingBox;
            xmin = round(kk1(1));
            xmax = round(kk1(1)+kk1(3));
            ymin = round(kk1(2));
            ymax = round(kk1(2)+kk1(4));
            images2{kk} = uint8(images2{kk});
            images2{kk} = insertShape(images2{kk},'rectangle',...
            [kk1(1) kk1(2) kk1(3) kk1(4)],'Color','red','LineWidth',2);
            % draw bounding box
            
%% vehicle classification:

            a = imcrop(images1{kk},[kk1(1) kk1(2) kk1(3) kk1(4)]);
            % crop out ROI from image
            feat_vec = featureim(a); %create feature vector
            cov_mat(:,:,end+1) = gencov(a); %Calculate covariance matrix
            dist = zeros(size(cov_mat,3)-1,2);
            
            for ii = 2:size(cov_mat,3)
                dist(ii-1,:) = calc_dist(cov_mat(:,:,ii));
            end

            for iii = 1:size(dist,1)
                [r c] = min(dist(iii,:));

                for no=1:size(c,2)
                    
                    if c(1,no) == 1
                        images2{kk} = insertText(images2{kk},...
                        [xmax ymin],'car','FontSize',18,'BoxColor','w',...
                        'TextColor','r');
                    else                        
                        images2{kk} = insertText(images2{kk},...
                        [xmax ymin],'truck','FontSize',18,'BoxColor',...
                        'w','TextColor','r');

                
                    end
                end
                
            end
            
%% write frames to disk
%                 someFolder = '/home/khurshid-admin/Pictures/ec520/final3';
%                 filename=strcat(num2str(kk),'.jpg');
%                 %figure;
            imshow(images2{kk});
%                 fullFileName = fullfile(someFolder, filename);
%                 imwrite(images2{kk}, fullFileName);
%                 nnn = nnn+1;
%                 t = text(xmax,ymin,clas,'color','red','FontSize',12);
        end
    end
end



