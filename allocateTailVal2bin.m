function firstColLastRow_L=allocateTailVal2bin(bin_L, A_L, mat_res)
A_L(isnan(A_L))=0;
firstColLastRow_L=zeros(mat_res,2); %First column is the first column in grid; second column is the last row in grid
    for binID=1:length(bin_L)-1
        loc_raw=bin_L(binID,:);
        if round(loc_raw(1),4)==mat_res+1
            locx=round(loc_raw(2),2);
            locy=2;        
        elseif round(loc_raw(2),4)==1
            locx=round(loc_raw(1),2);
            locy=1;
        else %if the tail is at unusual position, it should be a bias, so simply neglect it
            continue
        end
        firstColLastRow_L(locx,locy)=A_L(binID);    
    end
end