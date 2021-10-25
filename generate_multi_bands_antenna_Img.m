function [ant_final_ref_d, ant_final_ref_v, ant_info, antFlag_d, antFlag_v, ant_d_filter, ant_v_filter]=generate_multi_bands_antenna_Img(ant_ref_d, ant_ref_v, ant_info_d, ant_info_v)
    %Create filter
    ant_info_all=[ant_info_d ; ant_info_v];
if ~isempty(ant_info_all)
    len_filter=ant_info_all(:,1)<=2 | ant_info_all(:,4)<1; %Exclude those antenna less than 2mm or curvature <1
    nullDat=zeros(nnz(len_filter),4);
    nullDat(nullDat==0)=NaN;
    ant_info_all(len_filter,:)=nullDat;

    outlier_filter=isoutlier(ant_info_all(:,1),'quartiles');
    nan_filter=isnan(ant_info_all(:,1));

    net_filter=(outlier_filter+nan_filter)>0;
    ant_d_filter=net_filter(1:size(ant_info_d,1));
    ant_v_filter=net_filter(size(ant_info_d,1)+1:size(ant_info_d,1)+size(ant_info_d,1));

    %Use the filter to filt reflectance matrice
    ant_ref_d2=ant_ref_d;
    ant_ref_v2=ant_ref_v;
    ant_ref_d2(:,:,ant_d_filter)=[];
    ant_ref_v2(:,:,ant_v_filter)=[];

    %calculate the mean and standard deviation of reflectance and parameters
    ant_ref_d_mean=nanmean(ant_ref_d2,3);
    ant_ref_v_mean=nanmean(ant_ref_v2,3);
    ant_ref_d_std=nanstd(ant_ref_d2,0,3);
    ant_ref_v_std=nanstd(ant_ref_v2,0,3);
    if isnan(mean(ant_ref_d_mean,'all'))
        antFlag_d=1;
    else
        antFlag_d=0;
    end
    if isnan(mean(ant_ref_v_mean,'all'))
        antFlag_v=1;
    else
        antFlag_v=0;
    end

    ant_info_all_f=ant_info_all;
    ant_info_all_f(net_filter,:)=[];
    ant_info_mean=nanmean(ant_info_all_f,1);
    ant_info_std=nanstd(ant_info_all_f, [], 1);

    ant_final_ref_d={ant_ref_d_mean, ant_ref_d_std};
    ant_final_ref_v={ant_ref_v_mean, ant_ref_v_std};
    ant_info={ant_info_mean, ant_info_std};
else
    ant_final_ref_d=[];
    ant_final_ref_v=[];
    ant_info=[];
    antFlag_d= 1;
    antFlag_v= 1;
    ant_d_filter=[];
    ant_v_filter=[];
end
end