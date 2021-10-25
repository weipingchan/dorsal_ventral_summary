function save_multi_band_grid_img(inMat, visoutname, colorcode, mat_res,xbands_name,y_label,boldLineList, calculationType, matix_basic_resolution, imgformat, imgresolution)
if strcmp(calculationType,'grid') 
    ff=figure('visible', 'off');
    plot_multi_band_grid_img(inMat,mat_res,xbands_name,y_label,boldLineList);
elseif strcmp(calculationType,'project')
    ff=figure('visible', 'off');
    plot_multi_band_grid_proj_img(inMat, matix_basic_resolution,xbands_name,y_label,boldLineList);
end
    colormap(ff,colorcode);
    export_fig(ff,visoutname, ['-',imgformat],['-r',num2str(imgresolution)]);
    close(ff);
end