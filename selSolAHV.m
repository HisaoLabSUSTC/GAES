function [selVal,index] = selSolAHV(objVal,selNum,r, seed, method)
            tic
            [solNum,M] = size(objVal);  
            if M==3
                num_vec = 91;
            elseif M==5
                num_vec = 105;
            elseif M==8
                num_vec = 120;
            elseif M==10
                num_vec = 110;
            end
            W=GetVectorSet(method,M, seed);
            tensor = zeros(solNum,num_vec);
            r = r*max(objVal,[],1);
            for i=1:solNum
                s = objVal(i,:);
                temp1 = min(abs(s-r)./W,[],2)';        
                tensor(i,:) = temp1;     
            end
            mintensor = tensor;
                                    
            selVal = zeros(selNum,M);
            index = zeros(1,selNum);
            for num = 1:selNum
                mintensor = min(mintensor, tensor);
                r2hvc = sum(mintensor.^M,2);
                [~,bestindex] = max(r2hvc);
                
                for i=1:solNum
                    s = objVal(i,:);
                    temp1 = max((objVal(bestindex,:)-s)./W,[],2)';        
                    tensor(i,:) = temp1;
                end  
                
                %selVal = [selVal;objVal(bestindex,:)];
                selVal(num,:) = objVal(bestindex,:);
                index(num) = bestindex;
            end    
end