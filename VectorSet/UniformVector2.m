function [V,N] = UniformVector2(N,M,seed,WVMethod)
    switch WVMethod
        case 'UNV'
            mu = zeros(1,M);
            sigma = eye(M,M);
            rng(seed);
            R = mvnrnd(mu,sigma,N);
            V = abs(R./repmat(sqrt(sum(R.^2,2)),1,M));
        case 'DAS'
            H1 = 1;
            while nchoosek(H1+M,M-1) <= N
                H1 = H1 + 1;
            end
            V = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1;
            V = ([V,zeros(size(V,1),1)+H1]-[zeros(size(V,1),1),V])/H1;
            if H1 < M
                H2 = 0;
                while nchoosek(H1+M-1,M-1)+nchoosek(H2+M,M-1) <= N
                    H2 = H2 + 1;
                end
                if H2 > 0
                    V2 = nchoosek(1:H2+M-1,M-1) - repmat(0:M-2,nchoosek(H2+M-1,M-1),1) - 1;
                    V2 = ([V2,zeros(size(V2,1),1)+H2]-[zeros(size(V2,1),1),V2])/H2;
                    V  = [V;V2/2+1/(2*M)];
                end
            end
            V = max(V,1e-6);
            V = V./repmat(sqrt(sum(V.^2,2)),1,M);
            N = size(V,1);

        case 'JAS'
            V = zeros(N,M);
            rng(seed);
            V(:,1) = rand(N,1);
            V(:,1) = 1-(V(:,1).^(1/(M-1)));
            for obj = 2:M-1
                V(:,obj) = (1-sum(V(:,1:obj-1),2)).*(1-rand(N,1).^(1/(M-obj)));
            end
            V(:,M) = 1-sum(V,2);
            V = V./sqrt(sum(V.^2,2));
        case 'MSS-U'
            mu = zeros(1,M);
            sigma = eye(M,M);
            rng(seed);
            if M==3
                R = mvnrnd(mu,sigma,49770);
            elseif M==5
                R = mvnrnd(mu,sigma,46376); 
            elseif M==8
                R = mvnrnd(mu,sigma,31824); 
            elseif M==10
                R = mvnrnd(mu,sigma,48620); 
            end
            S = abs(R./sqrt(sum(R.^2,2)));
            V = zeros(N,M);
            V(1:M,:) = eye(M,M);
            for i = M+1:N
               distance = pdist2(V(1:i-1,:),S);
               distance = min(distance);
               [~,maxInd] = max(distance);
               V(i,:) = S(maxInd,:);
               S(maxInd,:) = [];
            end
        case 'MSS-D'
            H1 = 1;
            ZN = 0;
            if M==3
                ZN = 49770;
            elseif M==5
                ZN = 46376; 
            elseif M==8
                ZN = 31824;
            elseif M==10
                ZN = 48620;
            end
            
            while nchoosek(H1+M,M-1) <= ZN
                H1 = H1 + 1;
            end
            V = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1;
            V = ([V,zeros(size(V,1),1)+H1]-[zeros(size(V,1),1),V])/H1;
            if H1 < M
                H2 = 0;
                while nchoosek(H1+M-1,M-1)+nchoosek(H2+M,M-1) <= ZN
                    H2 = H2 + 1;
                end
                if H2 > 0
                    W2 = nchoosek(1:H2+M-1,M-1) - repmat(0:M-2,nchoosek(H2+M-1,M-1),1) - 1;
                    W2 = ([W2,zeros(size(W2,1),1)+H2]-[zeros(size(W2,1),1),W2])/H2;
                    V  = [V;W2/2+1/(2*M)];
                end
            end
            V = max(V,1e-6);
            S = V./sqrt(sum(V.^2,2));
            V = zeros(N,M);
            V(1:M,:) = eye(M,M);
            for i = M+1:N
               distance = pdist2(V(1:i-1,:),S);
               distance = min(distance);
               [~,maxInd] = max(distance);
               V(i,:) = S(maxInd,:);
               S(maxInd,:) = [];
            end
        case "KMEANS-U"
            mu = zeros(1,M);
            sigma = eye(M,M);
            rng(seed);
            if M==3
                R = mvnrnd(mu,sigma,49770);
            elseif M==5
                R = mvnrnd(mu,sigma,46376); 
            elseif M==8
                R = mvnrnd(mu,sigma,31824); 
            elseif M==10
                R = mvnrnd(mu,sigma,48620); 
            end
            S = abs(R./sqrt(sum(R.^2,2)));
            [V, ~] = K_means_S(S, N);
%             V = zeros(N,M);
%             V(1:M,:) = eye(M,M);
%             for i = M+1:N
%                distance = pdist2(V(1:i-1,:),S);
%                distance = min(distance);
%                [~,maxInd] = max(distance);
%                V(i,:) = S(maxInd,:);
%                S(maxInd,:) = [];
%             end
    end
end
