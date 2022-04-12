for M=[3,5,8,10]
    data_num=100;
    dataset_num=100;
    r = 1.2;
    Data = zeros(data_num,M,dataset_num);
    HVC = zeros(data_num,dataset_num);
    P=zeros(1,dataset_num);
    % generate solution set and HVC
    tic;
    for i=1:dataset_num
        %p = rand*1.5+0.5;
        p=2^(rand*2-1);
        %[Data(:,:,i),data_num] = UniformVector(data_num, Global.M);
        if i<=dataset_num/2
            temp = abs(UniformSphere_ExponentioalPowerDistribution(data_num,ones(1,M)*p,1));
        else
            temp = abs(UniformSphere_ExponentioalPowerDistribution(data_num,ones(1,M)*p,1));
            temp = temp*(-1)+1;
        end
        Data(:,:,i) = temp;
        HVC(:,i) = CalHVC(Data(:,:,i),r,data_num);  
        P(i)=p;
    end
    Time = toc;
    save(sprintf("Data/Training/dataSet_M%d.mat",M),"Data","HVC", "P","Time");
end

