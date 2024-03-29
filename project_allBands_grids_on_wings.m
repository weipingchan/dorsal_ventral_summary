function sidesAllBandsProj=project_allBands_grids_on_wings(fore_wing_mask,hind_wing_mask,fore_wing_grids,hind_wing_grids,sidesAllBanddata)
foreW=size(fore_wing_mask,2);
hindW=size(hind_wing_mask,2);

sidesAllBandsProj=cell(0,2);
for partID=1:2
    if partID==1
        wingMask=fore_wing_mask;
        wingGrids=fore_wing_grids;
    else
        wingMask=hind_wing_mask;
        wingGrids=hind_wing_grids;
    end
    part_std_d=sidesAllBanddata{partID};
    allBandsProj=cell(0,length(part_std_d));
        for bandID=1:length(part_std_d)
            part_std_band_d=part_std_d{bandID};
            if size(part_std_band_d,3)==1
                gridProjF=project_grids_on_wings(part_std_band_d,wingMask,wingGrids);
            else
                gridProjR=project_grids_on_wings(part_std_band_d(:,:,1),wingMask,wingGrids);
                gridProjG=project_grids_on_wings(part_std_band_d(:,:,2),wingMask,wingGrids);
                gridProjB=project_grids_on_wings(part_std_band_d(:,:,3),wingMask,wingGrids);
                gridProjF=cat(3,gridProjR,gridProjG,gridProjB);
            end
            gridProjFreSize=imresize(gridProjF, [NaN max([foreW, hindW])]);
            allBandsProj{bandID}=gridProjFreSize;
        end
        sidesAllBandsProj{partID}=allBandsProj;
end

%Data structure generated by the loop above:
%{1}=forewing
%{2}= hindwing
    %{}{n}=the variance/ stability of bandID (the order is the same as the matrix read in)
end