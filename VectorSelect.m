function [vectorSet, distance] = VectorSelect(M,seed)
    ref=1.2;
    distance=[];
    rng(seed);
    tic;
    % generate U via UNV
    mu = zeros(1,M);
    sigma = eye(M,M);
    sizeU=10000;
    R = mvnrnd(mu,sigma,sizeU);
    U = abs(R./repmat(sqrt(sum(R.^2,2)),1,M));
    % load training data
    load(sprintf("Data/Training/dataSet_M%d.mat",M), "Data", "HVC");
    [sizeX,sizeT]=size(HVC);
    r2hvc=zeros(sizeX,sizeU,sizeT);
    for t=1:sizeT
        for i=1:sizeX
            tmp=Data(:,:,t);
            s=tmp(i,:);
            tmp(i,:)=[];
            r2hvc(i,:,t)=calR2val(tmp, U, s, ref);
        end
    end
    if M==3
        N = 91;
    elseif M==5
        N = 105;
    elseif M==8
        N = 120;
    elseif M==10
        N = 110;
    end
     % greedy inclusion
     candidate=1:sizeU;
     select=[];
     currentVal=zeros(sizeX,sizeT);
    [~,rankA]=sort(HVC,1);
    [~,rankA]=sort(rankA,1);
     for i=1:N
        y=[];
        for x=candidate
            y=[y, fitness(currentVal+squeeze(r2hvc(:,x,:)),rankA)];
        end
        [f,I]=min(y);
        distance=[distance,f];
        select=[select, candidate(I)];
        currentVal=currentVal+squeeze(r2hvc(:,candidate(I),:));
        candidate(I)=[];
     end
     vectorSet=U(select,:);
     time=toc;
     save(sprintf("VectorSet/Inclusion/Inclusion_M%d_%d.mat",M,seed),"vectorSet", "time", "U","distance");
end
function y=fitness(r2hvc, rankA)
    [sizeX,sizeT]=size(r2hvc);
    [~,rankB]=sort(r2hvc,1);
    [~,rankB]=sort(rankB,1);
    y=sum(abs(rankA-rankB),'all')/sizeT;
end
function R2val = calR2val(data,W,s,ref)
%R2 for hvc approximation    
    [row, dim] = size(W);
    R2val = zeros(1,row);
    temp1 = min(abs(s-ref)./W,[],2);
    for j=1:row
        temp = (data-s)./W(j,:);
        [x,~] = min(max(temp,[],2));
        R2val(j)=min(x,temp1(j))^dim;
    end
end
