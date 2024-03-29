function sidesAllBandSERef=cal_BandAvgRefSE2(fore_hind_grids_dorsal)
%Derive the most variant region
wingPartLoc=[3,6];
sidesAllBandSERef=cell(0,2);    
for wingID=1:2
    allBandStability=cell(0,10);    
    for bandID=1:10
        for matID=1:length(fore_hind_grids_dorsal)
            detDat=fore_hind_grids_dorsal{matID}{wingPartLoc(wingID)}{bandID};
            if length(detDat)>4
                break
            end
        end
        if size(detDat,3)==1
            bandDatAll=[];
            for matID=1:length(fore_hind_grids_dorsal)
                meanRefDat=fore_hind_grids_dorsal{matID}{wingPartLoc(wingID)}{bandID};
                if length(meanRefDat)>4
                        bandDatAll=cat(3,bandDatAll,meanRefDat);
                end
            end
            bandStability=mean(bandDatAll,3,'omitnan');
        else
            bandDatAllR=[];
            bandDatAllG=[];
            bandDatAllB=[];
           for matID=1:length(fore_hind_grids_dorsal)
                meanRefDat=fore_hind_grids_dorsal{matID}{wingPartLoc(wingID)}{bandID};
                if length(meanRefDat)>4
                        bandDatAllR=cat(3,bandDatAllR,meanRefDat(:,:,1));
                        bandDatAllG=cat(3,bandDatAllG,meanRefDat(:,:,2));
                        bandDatAllB=cat(3,bandDatAllB,meanRefDat(:,:,3));
                end
           end
           bandStability=cat(3,mean(bandDatAllR,3,'omitnan'),mean(bandDatAllG,3,'omitnan'),mean(bandDatAllB,3,'omitnan'));
        end
        allBandStability{bandID}=bandStability;
    end
    sidesAllBandSERef{wingID}=allBandStability;
end

%Data structure generated by the loop above:
%{1}=forewing
%{2}= hindwing
    %{}{n}=the variance/ stability of bandID (the order is the same as the matrix read in)
end