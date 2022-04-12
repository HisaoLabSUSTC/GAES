for M=[3,5,8,10]
for type=["UNV","JAS","DAS","MSS-U","MSS-D", "KMEANS-U"]
    if M==3
        num_vec = 91;
    elseif M==5
        num_vec = 105;
    elseif M==8
        num_vec = 120;
    elseif M==10
        num_vec = 110;
    end
    if ismember(type,["DAS", "MSS-D"])
        runs=1;
    else
        runs=21;
    end
    W=zeros(num_vec,M,runs);
    parfor run=1:runs
        W(:,:,run)=UniformVector2(num_vec,M,run,type);
    end
    save(sprintf("VectorSet/%s_M%d.mat",type,M),"W");
end
end