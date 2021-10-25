function moved_shp=register_two_shapes(raw_shp, mean_shp)
    shift_x=round(max(abs(raw_shp(:,1)))*1.2);
    shpRF2=raw_shp+[shift_x, 0];

    wingMask_raw=poly2mask(shpRF2(:,1),shpRF2(:,2),round(max(shpRF2(:,2))*1.2),round(max(shpRF2(:,1))*1.2));
    wingMask_mean = poly2mask(mean_shp(:,1),mean_shp(:,2),round(max(mean_shp(:,2))*1.2),round(max(mean_shp(:,1))*1.2));

    raw_prop=regionprops(wingMask_raw,'centroid');
    mean_prop=regionprops(wingMask_mean,'centroid');

    cen_diff=mean_prop.Centroid-(raw_prop.Centroid-[shift_x, 0]);

    moved_shp=raw_shp+cen_diff;
end
