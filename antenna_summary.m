function [spp_antMat_dorsal, spp_antMat_ventral, spp_antInfo_dorsal, spp_antInfo_ventral] = antenna_summary(antenna, antenna_info, dorsal_preference_list, ventral_preference_list)
    antRef_rescale_L=antenna{1}{1};
    antRef_rescale_R=antenna{1}{2};
    ant_info_L=antenna_info{2};
    ant_info_R=antenna_info{3};

    %Prepare nan matrix for replacement
    nanAnt=zeros(size(antRef_rescale_L,1), size(antRef_rescale_L,2))-9999;
    nanAnt(nanAnt==-9999)=NaN;
    nanAntInfo=zeros(1,size(ant_info_L,2))-9999;

    if dorsal_preference_list.L_antennae_d==0
        antRef_rescale_L(:,:,1)=nanAnt;
        ant_info_L(1,:)=nanAntInfo;
    end
    if dorsal_preference_list.R_antennae_d==0
        antRef_rescale_R(:,:,1)=nanAnt;
        ant_info_R(1,:)=nanAntInfo;
    end
    if ventral_preference_list.L_antennae_d==0
        antRef_rescale_L(:,:,2)=nanAnt;
        ant_info_L(2,:)=nanAntInfo;
    end
    if ventral_preference_list.R_antennae_d==0
        antRef_rescale_R(:,:,2)=nanAnt;
        ant_info_R(2,:)=nanAntInfo;
    end

    spp_antMat_dorsal=cat(3,antRef_rescale_L(:,2:end,1), antRef_rescale_R(:,2:end,1));
    spp_antMat_ventral=cat(3,antRef_rescale_L(:,2:end,2), antRef_rescale_R(:,2:end,2));

    spp_antInfo_dorsal=[ant_info_L(1,:) ; ant_info_R(1,:)];
    spp_antInfo_ventral=[ant_info_L(2,:) ; ant_info_R(2,:)];
    spp_antInfo_dorsal(spp_antInfo_dorsal==-9999)=NaN;
    spp_antInfo_ventral(spp_antInfo_ventral==-9999)=NaN;
end