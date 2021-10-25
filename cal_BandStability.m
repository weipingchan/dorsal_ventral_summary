function sidesAllBandStability=cal_BandStability(fore_hind_grids_dorsal)
%Derive the most variant region
wingPartLoc=[1,4];
sidesAllBandStability=cell(0,2);    
for wingID=1:2 %fore hind wing
%     disp(['wingID: ',num2str(wingID)]);
    allBandStability=cell(0,10);    
    for bandID=1:10
%         disp(['bandID: ',num2str(bandID)]);
        detDat=fore_hind_grids_dorsal{1}{wingPartLoc(wingID)}{bandID};
        if size(detDat,3)==1
            for matID=1:length(fore_hind_grids_dorsal)
%                 disp(['matID: ',num2str(matID)]);
                meanRefDat=fore_hind_grids_dorsal{matID}{wingPartLoc(wingID)}{bandID};
                    if matID==1
                        bandDatAll=meanRefDat;
                    else
                        bandDatAll=cat(3,bandDatAll,meanRefDat);
                    end
            end
            bandStability=std(bandDatAll,[],3,'omitnan');
        else
           for matID=1:length(fore_hind_grids_dorsal)
                meanRefDat=fore_hind_grids_dorsal{matID}{wingPartLoc(wingID)}{bandID};
                if matID==1
                    bandDatAllR=meanRefDat(:,:,1);
                    bandDatAllG=meanRefDat(:,:,2);
                    bandDatAllB=meanRefDat(:,:,3);
                else
                    bandDatAllR=cat(3,bandDatAllR,meanRefDat(:,:,1));
                    bandDatAllG=cat(3,bandDatAllR,meanRefDat(:,:,2));
                    bandDatAllB=cat(3,bandDatAllR,meanRefDat(:,:,3));
                end
           end
           bandStability=cat(3,std(bandDatAllR,[],3,'omitnan'),std(bandDatAllG,[],3,'omitnan'),std(bandDatAllB,[],3,'omitnan'));
        end
        allBandStability{bandID}=bandStability;
    end
    sidesAllBandStability{wingID}=allBandStability;
end

%Data structure generate by the loop above:
%{1}=fore wing
%{2}= hind wing
    %{}{n}=the variance/ stability of bandID (the order is the same as the matrix read in)
end