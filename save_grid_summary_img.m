function save_grid_summary_img(bandsImgVarRescale, bandsImgVarRescaleProj, bandsImgRefRescale, bandsImgRefRescaleProj, bandsImgSERefRescale, bandsImgSERefRescaleProj, groupName, mat_res, sampleN, xbands_name, y_label, boldLineList, Result_directory, subFolderList, imgformat, imgresolution)
%mat_res=32;
% sampleN=length(in_grid);

%stability accross specimens
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgVarRescale, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_std_original','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_img(bandsImgVarOriginal,mat_res,xbands_name,y_label,boldLineList);
% colormap(ff,jet);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_std_original','_Grids.png]']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgVarRescaleProj, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgVarRescaleProj,2)/12, imgformat, imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale-proj','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_std_original-proj','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_proj_img(bandsImgVarOriginalProj,size(bandsImgVarOriginalProj,2)/12,xbands_name,y_label,boldLineList);
% colormap(ff,jet);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_std_original-proj','_Grids.png]']);

%mean reflectance
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgRefRescale, visoutname, bone, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_avg_original','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_img(bandsImgRefOriginal,mat_res,xbands_name,y_label,boldLineList);
% colormap(ff,bone);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_avg_original','_Grids.png]']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgRefRescaleProj, visoutname, bone, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgRefRescaleProj,2)/12, imgformat, imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale-proj','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_avg_original-proj','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_proj_img(bandsImgRefOriginalProj,size(bandsImgRefOriginalProj,2)/12,xbands_name,y_label,boldLineList);
% colormap(ff,bone);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_avg_original-proj','_Grids.png]']);

%mean SE of reflectance
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgSERefRescale, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_SEavg_original','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_img(bandsImgSERefOriginal,mat_res,xbands_name,y_label,boldLineList);
% colormap(ff,jet);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_SEavg_original','_Grids.png]']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgSERefRescaleProj, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgRefRescaleProj,2)/12, 'png', imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale-proj','_Grids.',imgformat,']']);

% visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},['bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_SEavg_original-proj','_Grids.png']);
% ff=figure('visible', 'off');
% plot_multi_band_grid_proj_img(bandsImgSERefOriginalProj,size(bandsImgRefOriginalProj,2)/12,xbands_name,y_label,boldLineList);
% colormap(ff,jet);
% export_fig(ff,visoutname, '-png','-r200');
% close(ff);
% disp(['saving [bothSidesAllBand_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(length(all_grid_name)),'_SEavg_original-proj','_Grids.png]']);
disp('all grid summary imgs are saved');
end