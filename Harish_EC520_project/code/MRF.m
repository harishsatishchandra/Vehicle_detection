function [ U ] = MRF( U,T, type , order)
        energy= zeros(1,256);
        for iter = 1:5
            for j = 2:129
                for i = 2:129
                    for k = 1:256
                        energy(k) = energy_cal( U,i,j,type,order,k);
                    end
                    P = (exp(-1*energy./T));
                    U(i,j) = randany(P);
                end
            end
        end
    %end


    function [ E ] = energy_cal( img,i,j,type,order,k) 
        if type == 1
            if order == 2
                 E = 5*(((k-1)==img(j-1,i)) + ((k-1)==img(j+1,i)) +...
                            ((k-1)==img(j,i-1)) + ((k-1)==img(j,i+1)) + ...
                            ((k-1)==img(j-1,i-1)) + ((k-1)==img(j+1,i+1))+...
                            ((k-1)==img(j+1,i-1)) + ((k-1)==img(j-1,i+1)));
            else
                 E = 5*(((k-1)==img(j-1,i)) + ((k-1)==img(j+1,i)) +...
                            ((k-1)==img(j,i-1)) + ((k-1)==img(j,i+1)));
            end
        else
            if order == 2
                E = (abs((k-1) - img(j-1,i)) + abs((k-1) - img(j+1,i)) +...
                            abs((k-1) - img(j,i+1)) + abs((k-1) - img(j,i+1))...
                            + abs((k-1) - img(j-1,i-1)) + abs((k-1)-img(j+1,i+1))+...
                            abs((k-1)-img(j+1,i-1)) + abs((k-1)-img(j-1,i+1)));
            else
                E = (abs((k-1) - img(j-1,i)) + abs((k-1) - img(j+1,i)) +...
                            abs((k-1) - img(j,i-1)) + abs((k-1) - img(j,i+1)));
            end
        end
    end

    function index = randany(prob)
        cum_prob = cumsum(prob);
        if cum_prob(256) > 0
            cum_prob = cum_prob/cum_prob(256);
        end

        index = min(find(cum_prob >= rand(1)));
        if index > 0
            index = index - 1;
        else
            index = 0;
        end
    end
end