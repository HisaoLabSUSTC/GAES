function V = GetVectorSet(WVMethod,M,seed)
    if ismember(WVMethod, ["Inclusion"])
        V=load(sprintf("VectorSet/Inclusion/%s_M%d_%d",WVMethod,M,seed)).vectorSet;
    else
        V=load(sprintf("VectorSet/%s_M%d",WVMethod,M)).W;
        V=squeeze(V(:,:,seed));
    end
end
