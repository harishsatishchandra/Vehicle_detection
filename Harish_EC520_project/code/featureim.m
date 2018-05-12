%% construct feature vector
function fd=featureim(k)
    
    fd=[];
  
    xax=[1:size(k,1)]'*ones(1,size(k,2)); % x coordinate of pixel
    yax=([1:size(k,2)]'*ones(1,size(k,1)) )'; 
    sobel=[[1 0 -1];[2 0 -2];[1 0 -1]];  
    lap2=[[1 1 1];[1 -8 1];[1 1 1]];

    fd(:,:,end)=xax; % x coordinate of pixel
    fd(:,:,end+1)=yax; % y coordinate of pixel
    
    fd(:,:,end+1)=k;   
    fd(:,:,end+1)=conv2(k,sobel,'same'); % first order derivative 
                                         % of intensity along 
                                         %horizontal direction
                                         
    fd(:,:,end+1)=conv2(k,sobel','same'); % first order derivative 
                                         % of intensity along 
                                         %vertical direction
    
    fd(:,:,end+1)=conv2(k,lap2,'same'); % second order derivative 
                                         % of intensity
    
end
