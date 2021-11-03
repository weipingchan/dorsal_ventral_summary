function all_tail_info_spp=summarize_specimen_Tail(all_tail_spp, all_scale_dorsal, all_scale_ventral, scaling_factor_listH2, in_grid_barcode, mat_res, length_threshold)
fprintf('Summarize tails of specimen: ');
all_tail_info_spp=cell(0,length(all_tail_spp));
for sppID=1:length(in_grid_barcode)
    spp_tail=all_tail_spp{sppID};
    spp_tail_dat_L={spp_tail{1},spp_tail{2}};
    spp_tail_dat_R={spp_tail{3},spp_tail{4}};
    scaling_factor_spp=scaling_factor_listH2(sppID,:);
    scale_L_spp=all_scale_dorsal{sppID}; %scale_L should be corrected as scale_dorsal
    scale_R_spp=all_scale_ventral{sppID}; %scale_R should be corrected as scale_ventral
    [having_tail, firstColLastRow_probability_spp, firstColLastRow_Len_summary_mean_spp, firstColLastRow_Cur_summary_mean_spp, firstColLastRow_Len_summary_rng_spp, firstColLastRow_Cur_summary_rng_spp, firstColLastRow_allLen_cm_spp]=summarizeTailInfo_spp(spp_tail_dat_L, spp_tail_dat_R, scale_L_spp, scale_R_spp, scaling_factor_spp, mat_res, length_threshold);
    all_tail_info_spp{sppID}={in_grid_barcode{sppID},having_tail, firstColLastRow_probability_spp, firstColLastRow_Len_summary_mean_spp, firstColLastRow_Cur_summary_mean_spp, firstColLastRow_Len_summary_rng_spp, firstColLastRow_Cur_summary_rng_spp, firstColLastRow_allLen_cm_spp};
    if sppID<length(in_grid_barcode) fprintf([num2str(sppID),'-']);, else fprintf([num2str(sppID),'#']);, end;
    if mod(sppID,50)==0
        fprintf('\n');
    end
end
fprintf('\n');
end