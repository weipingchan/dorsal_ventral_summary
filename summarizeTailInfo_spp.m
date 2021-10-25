function [having_tail, firstColLastRow_probability_spp, firstColLastRow_Len_summary_mean_spp, firstColLastRow_Cur_summary_mean_spp, firstColLastRow_Len_summary_rng_spp, firstColLastRow_Cur_summary_rng_spp, firstColLastRow_allLen_cm_spp]=summarizeTailInfo_spp(spp_tail_dat_L, spp_tail_dat_R, scale_L_spp, scale_R_spp, scaling_factor_spp, mat_res, length_threshold)
%summarize tail information
%length_threshold=5; %5 px (~0.1mm) the threshold to define a tail

scaling_factor_listH_L=[scaling_factor_spp(:,1),scaling_factor_spp(:,3)]; %dorsal and ventral of left hind wing
scaling_factor_listH_R=[scaling_factor_spp(:,1),scaling_factor_spp(:,3)]; %dorsal and ventral of right hind wing

%Flipping the right-hind wing to left-hand side
tailPart0=spp_tail_dat_R;
all_tail_R_flip=cell(0,2);
if ~isempty(tailPart0)
    for sideID=1:2
        %disp(num2str(sideID));
        tailPart=tailPart0{sideID};
        tailPart_flip=cell(0,length(tailPart));
        if ~isempty(tailPart)
            if nnz(cellfun(@iscell, tailPart))==0
                tailN=1;
            else
                tailN=nnz(cellfun(@iscell, tailPart));
            end
            for tID2=1:tailN
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
        all_tail_R_flip{sideID}=tailPart_flip;
    end
end

%Here scale_L should be corrected as scale_dorsal; scale_R should be
%corrected as scale_ventral
[having_tail_L, firstColLastRow_L_allLen, firstColLastRow_L_allCur, firstColLastRow_L_allLen_cm] = intAllTailParameter_spp(spp_tail_dat_L, scale_L_spp, scaling_factor_listH_L, mat_res);
[having_tail_R, firstColLastRow_R_allLen, firstColLastRow_R_allCur, firstColLastRow_R_allLen_cm] = intAllTailParameter_spp(all_tail_R_flip, scale_R_spp, scaling_factor_listH_R, mat_res);

having_tail=(having_tail_L+having_tail_R)>0; %List specimen having extended wing regions

firstColLastRow_allLen=cat(3,firstColLastRow_L_allLen,firstColLastRow_R_allLen);
firstColLastRow_allLen_cm_spp=cat(3,firstColLastRow_L_allLen_cm,firstColLastRow_R_allLen_cm);
firstColLastRow_allCur=cat(3,firstColLastRow_L_allCur,firstColLastRow_R_allCur);

firstColLastRow_allLen2=firstColLastRow_allLen; %Preserve dataset for further calculation

firstColLastRow_allLen(round(firstColLastRow_allLen,1)<length_threshold)=NaN; %replace small value by NaN, and neglect those length less than 5 px (~0.1mm)
firstColLastRow_allCur(round(firstColLastRow_allCur,2)==0)=NaN; %replace 0 by NaN

firstColLastRow_Len_summary_mean_spp=nanmean(firstColLastRow_allLen,3);
firstColLastRow_Cur_summary_mean_spp=nanmean(firstColLastRow_allCur,3);
firstColLastRow_Len_summary_rng_spp=max(firstColLastRow_allLen,[],3)-min(firstColLastRow_allLen,[],3);
firstColLastRow_Cur_summary_rng_spp=max(firstColLastRow_allCur,[],3)-min(firstColLastRow_allCur,[],3);
firstColLastRow_Len_summary_mean_spp(isnan(firstColLastRow_Len_summary_mean_spp))=0; %replace NaN by 0
firstColLastRow_Cur_summary_mean_spp(isnan(firstColLastRow_Cur_summary_mean_spp))=0; %replace NaN by 0
firstColLastRow_Len_summary_rng_spp(isnan(firstColLastRow_Len_summary_rng_spp))=0; %replace NaN by 0
firstColLastRow_Cur_summary_rng_spp(isnan(firstColLastRow_Cur_summary_rng_spp))=0; %replace NaN by 0

%tail frequency
firstColLastRow_allLen2(round(firstColLastRow_allLen2,1)<length_threshold)=NaN; %replace small value by NaN, and neglect those length less than 5 px (~0.1mm)
firstColLastRow_allLen2(~isnan(firstColLastRow_allLen2))=1; %replace large value by 1
firstColLastRow_frequency=nansum(round(firstColLastRow_allLen2),3);
% firstColLastRow_probability_spp=firstColLastRow_frequency/size(firstColLastRow_allLen2,3);
firstColLastRow_probability_spp=firstColLastRow_frequency/sum(sum(nansum(firstColLastRow_allLen2))>0); %modified Set 27, 2020
end