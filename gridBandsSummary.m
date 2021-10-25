function [forewingGridsSpMean, forewingGridsSpAbsDiff] = gridBandsSummary(forewingGrids)
        if size(forewingGrids,3)<=2 %BW band
            forewingGridsSpMean=mean(forewingGrids,3,'omitnan');
            forewingGridsSpAbsDiff=abs(forewingGrids(:,:,1)-forewingGrids(:,:,2));
            forewingGridsSpAbsDiff(isnan(forewingGrids(:,:,1)) | isnan(forewingGrids(:,:,2)))=-9999;
        else %RGB band
            forewingGridsSpMeanR=mean(cat(3,forewingGrids(:,:,1),forewingGrids(:,:,4)),3,'omitnan');
            forewingGridsSpMeanG=mean(cat(3,forewingGrids(:,:,2),forewingGrids(:,:,5)),3,'omitnan');
            forewingGridsSpMeanB=mean(cat(3,forewingGrids(:,:,3),forewingGrids(:,:,6)),3,'omitnan');
            forewingGridsSpAbsDiffR=abs(forewingGrids(:,:,1)-forewingGrids(:,:,4));
            forewingGridsSpAbsDiffR(isnan(forewingGrids(:,:,1)) | isnan(forewingGrids(:,:,4)))=-9999;
            forewingGridsSpAbsDiffG=abs(forewingGrids(:,:,2)-forewingGrids(:,:,5));
            forewingGridsSpAbsDiffG(isnan(forewingGrids(:,:,2)) | isnan(forewingGrids(:,:,5)))=-9999;
            forewingGridsSpAbsDiffB=abs(forewingGrids(:,:,3)-forewingGrids(:,:,6));
            forewingGridsSpAbsDiffB(isnan(forewingGrids(:,:,3)) | isnan(forewingGrids(:,:,6)))=-9999;

            forewingGridsSpMean=cat(3,forewingGridsSpMeanR,forewingGridsSpMeanG,forewingGridsSpMeanB);
            forewingGridsSpAbsDiff=cat(3,forewingGridsSpAbsDiffR,forewingGridsSpAbsDiffG,forewingGridsSpAbsDiffB);
        end
end