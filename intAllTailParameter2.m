function [having_tail_f, firstColLastRow_L_all, firstColLastRow_C_all, firstColLastRow_L_all_cm] = intAllTailParameter2(all_tail_L,all_scale_L, scaling_factor_listH_L, mat_res, sampleN)
    firstColLastRow_L_all=zeros(mat_res,2); %First column is the first column in grid; second column is the last row in grid
    firstColLastRow_L_all_cm=zeros(mat_res,2); %First column is the first column in grid; second column is the last row in grid
    firstColLastRow_C_all=zeros(mat_res,2); %First column is the first column in grid; second column is the last row in grid
    having_tail=zeros(length(all_tail_L),2);

    tailValID=1;
    for spID=1:sampleN
        tailPart0=all_tail_L{spID};
        scale=all_scale_L{spID};
        scaling_factor0=scaling_factor_listH_L(spID,:);
        for sideID=1:2
            tailPart=tailPart0{sideID};
            scaling_factor=scaling_factor0(sideID);
            if ~isempty(tailPart)
                %disp(num2str(tID));
                if nnz(cellfun(@iscell, tailPart))==0
                    tailN=1;
                else
                    tailN=nnz(cellfun(@iscell, tailPart));
                end
                for tID2=1:tailN
                    %disp(num2str(tID2));
                    tailTail=tailPart{tID2};
                    tailTailBase=tailTail{1};
                    tailTailChar=tailTail{2};
                    tailTailL=tailTailChar(2); % in cm
                    tailTailC=tailTailChar(5);
                    [bin_L, A_L]=tailSummary2(tailTailBase,tailTailL,0, mat_res); %Derive the distribution of value 
                    [bin_C, A_C0]=tailSummary2(tailTailBase,tailTailC-1,0, mat_res);
                    A_C=A_C0+1;
                    if ~isempty(bin_L) && ~isempty(bin_C)
                        firstColLastRow_L_cm=allocateTailVal2bin(bin_L, A_L, mat_res); % in cm
                        firstColLastRow_C=allocateTailVal2bin(bin_C, A_C, mat_res);

                        firstColLastRow_L_scaled=firstColLastRow_L_cm*scale*scaling_factor; % in scaled px

                        if tailValID==1
                            firstColLastRow_L_all_cm=firstColLastRow_L_cm;
                            firstColLastRow_L_all=firstColLastRow_L_scaled;
                            firstColLastRow_C_all=firstColLastRow_C;
                        else
                            firstColLastRow_L_all=cat(3,firstColLastRow_L_all,firstColLastRow_L_scaled);
                            firstColLastRow_L_all_cm=cat(3,firstColLastRow_L_all_cm,firstColLastRow_L_cm);
                            firstColLastRow_C_all=cat(3,firstColLastRow_C_all,firstColLastRow_C);
                        end
                        tailValID=tailValID+1;
                        if ~isempty(tailTailL)
                            having_tail(spID,sideID)=1;
                        end
                    end
                end
            end
        end
    end

%     having_tail_f=having_tail(:,1).*having_tail(:,2);
    having_tail_f=max(having_tail,[],2);
end