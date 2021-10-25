function [seg4Pts,wingGrids,wingMask_mean]=mena_shp_grids(mean_shp,seg4PtsFH,fore_hind,numberOfIntervalDegree)
newSeg4Pts=zeros(size(seg4PtsFH,1),size(seg4PtsFH,2));
for ptID=1:size(seg4PtsFH)
    newSeg4Pts(ptID,:)=findCloestPt(mean_shp,seg4PtsFH(ptID,:));
end

wingMask_mean = poly2mask(mean_shp(:,1),mean_shp(:,2),round(max(mean_shp(:,2))*1.2),round(max(mean_shp(:,1))*1.2));

% figure,imshow(wingMask_mean); hold on;
% plot(newSeg4Pts(:,1),newSeg4Pts(:,2),'ro');
% plot(seg4PtsFH(:,1),seg4PtsFH(:,2),'go');

if fore_hind=='F'
    emu_keyL=zeros(10,2);
    emu_keyL(7,:)=newSeg4Pts(1,:);
    emu_keyL(2,:)=newSeg4Pts(2,:);
    emu_keyL(10,:)=newSeg4Pts(3,:);
    [seg4Pts,wingGrids]=foreWingGrids(wingMask_mean,emu_keyL,'L',numberOfIntervalDegree);
elseif fore_hind=='H'
    emu_keyL=zeros(10,2);
    emu_keyL(6,:)=newSeg4Pts(2,:);
    regPtLH=[newSeg4Pts(1,:); newSeg4Pts(3,:); newSeg4Pts(4,:)];
    [seg4Pts ,wingGrids ]=hindWingGrids(wingMask_mean,emu_keyL,regPtLH,'L',numberOfIntervalDegree);
end
end