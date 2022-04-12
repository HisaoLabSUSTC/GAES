for N = [100]
for M = [3,5,8,10]
    if N==100
        TOT=100;
        data=zeros(N,M,100);
        hvc=zeros(N,100);
    else
        TOT=1;
        data=zeros(N,M, 1);
    end
    for problem = ["linear_triangular","linear_invertedtriangular",...
            "concave_triangular","concave_invertedtriangular", ...
            "convex_triangular","convex_invertedtriangular"]
    for T = 1:TOT
        if contains(problem, "linear")
            u=1;
        elseif contains(problem, "concave")
            u=2;
        elseif contains(problem, "convex")
            u=0.5;
        end
        if contains(problem, "invertedtriangular")
            u = 1/u;
        end
        res = UniformSphere_ExponentioalPowerDistribution(N-M, ones(1,M)*u, 1);
        if contains(problem, "invertedtriangular")
            res = res*(-1)+1;
            for i=1:M
                p = ones(1,M); p(i)=0;
                res = [res;p];
            end
        else
            for i=1:M
                p = zeros(1,M); p(i)=1;
                res = [res;p];
            end
        end
        data(:,:,T)=res;
        if TOT==100
            tmp = CalHVC(res,1.2, size(res, 1));
            hvc(:,T)=tmp';
        end
        %problem
        %plot3(res(:,1),res(:,2),res(:,3),'b.')   
    end
    if TOT==100
        save(sprintf("Data/Test/%s_M%d", problem, M), "data", "hvc")
    else
        save(sprintf("Data/Test/%s_M%d", problem, M), "data")
    end
    end
end
end
