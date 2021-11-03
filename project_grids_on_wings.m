function gridProj=project_grids_on_wings(grid_data,wingMask,wingGrids)
     gridProj=double(wingMask);
     gridProj(gridProj==0)=NaN;
        for i=1:size(wingGrids,1)-1
            for j=1:size(wingGrids,2)-1
                cornerData=reshape([wingGrids(i,j,:) ; wingGrids(i,j+1,:) ; wingGrids(i+1,j,:) ; wingGrids(i+1,j+1,:)],[],2);
                [x2,y2]=orderPtsPoly(cornerData(:,1), cornerData(:,2));
                cropGrid = roipoly(gridProj,x2,y2);
                if nnz(cropGrid)>0
                    gridProj(cropGrid==1)=grid_data(i,j);
                else
                    gridProj(cropGrid==1)=NaN;
                end
            end
        end
end