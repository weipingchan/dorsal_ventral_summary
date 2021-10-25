function [newSeg4Pts,newWingGrids,new_mask,refOriF]=rmBlankRegionGrids(seg4Pts,wingGrids,wingMask_mean,bufferWidth)
    [new_mask,refOriF]=rmBlankRegion(int8(wingMask_mean),bufferWidth);
     newSeg4Pts=zeros(size(seg4Pts,1),size(seg4Pts,2));
    for ptID=1:size(seg4Pts)
        newSeg4Pts(ptID,:)=[seg4Pts(ptID,1)-refOriF(1),seg4Pts(ptID,2)-refOriF(2)];
    end
     newWingGrids=cat(3,wingGrids(:,:,1)-refOriF(1),wingGrids(:,:,2)-refOriF(2));

    new_mask=logical(new_mask);
end