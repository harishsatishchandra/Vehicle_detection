function dist_car1=calc_dist(obj_cov)
    %car
    load('db1.mat');
    %truck
    load('db2.mat');
    %junk
    load('db3.mat');
    
    %% for car database comparision
    %avg_car
    db_car = [];
    dist_car1 = [];
    db_car = zeros(6,6);
    nn = 1;
    
    for i =1:size(db1.cov,3)
        db_car(:,nn) =  sqrt(log(eig(obj_cov,db1.cov(:,:,i))).^2);
        nn = nn+1;
    end
    dist_car = zeros(1,6);
    nnn = 1;
    temp = 0;
    while nnn <=6
        for i = 1:size(db_car,1)
            temp = temp + db_car(i,nnn);
        end
        dist_car(1,nnn) = temp;
        nnn = nnn+1;
        temp = 0;
    end
    dist_car1(1) = min(dist_car);
    
    %% for truck database comparision
    
    %avg_car
    db_car = [];
   % dist_car1 = [];
    db_car = zeros(6,6);
    nn = 1;
    for i =1:size(db2.cov,3)
        db_car(:,nn) =  sqrt(log(eig(obj_cov,db2.cov(:,:,i))).^2);       
        nn = nn+1;
    end
    dist_car = zeros(1,6);
    nnn = 1;
    temp = 0;
    while nnn <=6
        for i = 1:size(db_car,1)
            temp = temp + db_car(i,nnn);
        end
        dist_car(1,nnn) = temp;
        nnn = nnn+1;
        temp = 0;
    end
    dist_car1(2) = min(dist_car);    
end

    