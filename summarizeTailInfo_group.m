function [having_tail_spp, firstColLastRow_probability, firstColLastRow_Len_summary_median, firstColLastRow_Cur_summary_median, firstColLastRow_Len_summary_IQR, firstColLastRow_Cur_summary_IQR, firstColLastRow_allLen_cm]=summarizeTailInfo_group(all_tail_L, all_tail_R, all_scale_L, all_scale_R, scaling_factor_listH2, mat_res, length_threshold, frequencyThreshold, sampleN)
%summarize tail information
%length_threshold=5; %5 px (~0.1mm) the threshold to define a tail

scaling_factor_listH_L=[scaling_factor_listH2(:,1),scaling_factor_listH2(:,3)]; %dorsal and ventral of left hind wing
scaling_factor_listH_R=[scaling_factor_listH2(:,1),scaling_factor_listH2(:,3)]; %dorsal and ventral of right hind wing

%Flipping the right-hind wing to left-hand side
all_tail_R_flip=cell(0,length(all_tail_R));
for spID=1:sampleN
    %disp(num2str(spID));
    tailPart0=all_tail_R{spID};
    side_tail=cell(0,2);
    for sideID=1:2
        %disp(num2str(sideID));
        tailPart=tailPart0{sideID};
        tailPart_flip=cell(0,length(tailPart));
        if ~isempty(tailPart)
            for tID2=1:length(tailPart)
                %disp(num2str(tID2));
                tailTail=tailPart{tID2};
                tailTailBase=tailTail{1};
                tailTailBase_flip=[tailTailBase(:,1), mat_res+2-tailTailBase(:,2)];
                tailTail_flip={tailTailBase_flip,tailTail{2}};
                tailPart_flip{tID2}=tailTail_flip;
            end
        else
            tailPart_flip={};
        end
        side_tail{sideID}=tailPart_flip;
    end
    all_tail_R_flip{spID}=side_tail;
end

[having_tail_L, firstColLastRow_L_allLen, firstColLastRow_L_allCur, firstColLastRow_L_allLen_cm] = intAllTailParameter2(all_tail_L, all_scale_L, scaling_factor_listH_L, mat_res, sampleN);
[having_tail_R, firstColLastRow_R_allLen, firstColLastRow_R_allCur, firstColLastRow_R_allLen_cm] = intAllTailParameter2(all_tail_R_flip, all_scale_R, scaling_factor_listH_R, mat_res, sampleN);

having_tail_spp=(having_tail_L+having_tail_R)>0; %List specimen having extended wing regions

firstColLastRow_allLen=cat(3,firstColLastRow_L_allLen,firstColLastRow_R_allLen);
firstColLastRow_allLen_cm=cat(3,firstColLastRow_L_allLen_cm,firstColLastRow_R_allLen_cm);
firstColLastRow_allCur=cat(3,firstColLastRow_L_allCur,firstColLastRow_R_allCur);

firstColLastRow_allLen2=firstColLastRow_allLen; %Preserve dataset for further calculation

firstColLastRow_allLen(round(firstColLastRow_allLen,1)<length_threshold)=NaN; %replace small value by NaN, and neglect those length less than 5 px (~0.1mm)
firstColLastRow_allCur(round(firstColLastRow_allCur,2)==0)=NaN; %replace 0 by NaN

firstColLastRow_Len_summary_median=nanmedian(firstColLastRow_allLen,3);
firstColLastRow_Cur_summary_median=nanmedian(firstColLastRow_allCur,3);
firstColLastRow_Len_summary_IQR=iqr(firstColLastRow_allLen,3);
firstColLastRow_Cur_summary_IQR=iqr(firstColLastRow_allCur,3);
firstColLastRow_Len_summary_median(isnan(firstColLastRow_Len_summary_median))=0; %replace NaN by 0
firstColLastRow_Cur_summary_median(isnan(firstColLastRow_Cur_summary_median))=0; %replace NaN by 0
firstColLastRow_Len_summary_IQR(isnan(firstColLastRow_Len_summary_IQR))=0; %replace NaN by 0
firstColLastRow_Cur_summary_IQR(isnan(firstColLastRow_Cur_summary_IQR))=0; %replace NaN by 0

%tail frequency
firstColLastRow_allLen2(round(firstColLastRow_allLen2,1)<length_threshold)=NaN; %replace small value by NaN, and neglect those length less than 5 px (~0.1mm)
firstColLastRow_allLen2(~isnan(firstColLastRow_allLen2))=1; %replace large value by 1
firstColLastRow_frequency=nansum(round(firstColLastRow_allLen2),3);
firstColLastRow_frequency(firstColLastRow_frequency<=frequencyThreshold)=0; %remove outliers
% firstColLastRow_probability=firstColLastRow_frequency/size(firstColLastRow_allLen2,3);
firstColLastRow_probability=firstColLastRow_frequency/sum(sum(nansum(firstColLastRow_allLen2))>0); %modified Set 27, 2020
end