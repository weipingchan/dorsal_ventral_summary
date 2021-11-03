function spp_mean_shapes=calculate_spp_mean_shp(fore_shapes0, shp_pref_listF, spp_barcodeList, sppnHarmonic)
spp_mean_shapes=cell(0,1);
for sppID=1:length(spp_barcodeList)
    spp_fore_shapes0=fore_shapes0(sppID,:);
    spp_fore_preference=shp_pref_listF(sppID,:);
    spp_fore_shapes=spp_fore_shapes0(logical(spp_fore_preference));
    if ~isempty(spp_fore_shapes)
        [mean_spp_shp_fore,~,~, ~]=cal_mean_shp2(spp_fore_shapes',sppnHarmonic,50); %transpose spp_fore_shapes
    else
        mean_spp_shp_fore=[-9999, -9999];
    end
    spp_mean_shapes{sppID}={spp_barcodeList{sppID}, mean_spp_shp_fore};
    if sppID<length(spp_barcodeList) fprintf([num2str(sppID),'-']);, else fprintf([num2str(sppID),'#']);, end;
    if mod(sppID,50)==0
        fprintf('\n');
    end
end
fprintf('\n');
end