function  sideresult=multi_band_grid_summary(sideDat, side_preference_list)
    band_forewing_Mean=cell(0,10);
    band_forewing_Diff=cell(0,10);
    band_hindwing_Mean=cell(0,10);
    band_hindwing_Diff=cell(0,10);
    band_forewing_SE_Mean=cell(0,10);
    band_hindwing_SE_Mean=cell(0,10);
    for bandID=1:10
        bandDat=sideDat{bandID};
        for wingID=1:4
            wingDat=bandDat{wingID};
            if wingID==1
                meanRef=wingDat{1};
                meanRef(meanRef==-9999) = NaN;

                seRef=wingDat{2};
                seRef(seRef==-9999) = NaN;

                if side_preference_list.LF_wing_d==1
                    forewingGrids=meanRef;
                    forewingGridsSE=seRef;
                else
                    nanMat=zeros(size(meanRef,1), size(meanRef,2), size(meanRef,3))-9999;
                    nanMat(nanMat==-9999)=NaN;
                    forewingGrids=nanMat;
                    forewingGridsSE=nanMat;
                end
            elseif wingID==2
                meanRef=flip(wingDat{1},2);
                meanRef(meanRef==-9999) = NaN;

                seRef=flip(wingDat{2},2);
                seRef(seRef==-9999) = NaN;

                if side_preference_list.RF_wing_d==1
                    forewingGrids=cat(3,forewingGrids,meanRef);
                    forewingGridsSE=cat(3,forewingGridsSE,seRef);
                else
                    nanMat=zeros(size(meanRef,1), size(meanRef,2), size(meanRef,3))-9999;
                    nanMat(nanMat==-9999)=NaN;
                    forewingGrids=cat(3,forewingGrids, nanMat);
                    forewingGridsSE=cat(3,forewingGridsSE, nanMat);
                end
            elseif wingID==3
                meanRef=wingDat{1};
                meanRef(meanRef==-9999) = NaN;

                seRef=wingDat{2};
                seRef(seRef==-9999) = NaN;

                if side_preference_list.LH_wing_d==1
                    hindwingGrids=meanRef;
                    hindwingGridsSE=seRef;
                else
                    nanMat=zeros(size(meanRef,1), size(meanRef,2), size(meanRef,3))-9999;
                    nanMat(nanMat==-9999)=NaN;
                    hindwingGrids=nanMat;
                    hindwingGridsSE=nanMat;
                end
            elseif  wingID==4
                meanRef=flip(wingDat{1},2);
                meanRef(meanRef==-9999) = NaN;

                seRef=flip(wingDat{2},2);
                seRef(seRef==-9999) = NaN;

                 if side_preference_list.RH_wing_d==1
                    hindwingGrids=cat(3,hindwingGrids,meanRef);
                    hindwingGridsSE=cat(3,hindwingGridsSE,seRef);
                 else
                    nanMat=zeros(size(meanRef,1), size(meanRef,2), size(meanRef,3))-9999;
                    nanMat(nanMat==-9999)=NaN;
                    hindwingGrids=cat(3,hindwingGrids, nanMat);
                    hindwingGridsSE=cat(3,hindwingGridsSE, nanMat);
                 end
            end
        end

        [forewingGridsSpMean, forewingGridsSpAbsDiff] = gridBandsSummary(forewingGrids);
        [hindwingGridsSpMean, hindwingGridsSpAbsDiff] = gridBandsSummary(hindwingGrids);
        [forewingGridsSESpMean, ~] = gridBandsSummary(forewingGridsSE);
        [hindwingGridsSESpMean, ~] = gridBandsSummary(hindwingGridsSE);

        band_forewing_Mean{bandID}=forewingGridsSpMean; %mean reflectance for left-right wings
        band_forewing_Diff{bandID}=forewingGridsSpAbsDiff; %difference of reflectance for left-right wings
        band_forewing_SE_Mean{bandID}=forewingGridsSESpMean; %mean SE of reflectance for left-right wings
        band_hindwing_Mean{bandID}=hindwingGridsSpMean; %mean reflectance for left-right wings
        band_hindwing_Diff{bandID}=hindwingGridsSpAbsDiff; %difference of reflectance for left-right wings
        band_hindwing_SE_Mean{bandID}=hindwingGridsSESpMean; %mean SE of reflectance for left-right wings
    end
    sideresult={band_forewing_Mean, band_forewing_Diff, band_forewing_SE_Mean, band_hindwing_Mean, band_hindwing_Diff, band_hindwing_SE_Mean};
end