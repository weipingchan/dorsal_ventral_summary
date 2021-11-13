function save_grid_summary_img(bandsImgVarRescale, bandsImgVarRescaleProj, bandsImgRefRescale, bandsImgRefRescaleProj, bandsImgSERefRescale, bandsImgSERefRescaleProj, groupName, mat_res, sampleN, xbands_name, y_label, boldLineList, Result_directory, subFolderList, imgformat, imgresolution)
%stability across specimens
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgVarRescale, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale','_Grids.',imgformat,']']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgVarRescaleProj, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgVarRescaleProj,2)/12, imgformat, imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_std_rescale-proj','_Grids.',imgformat,']']);

%mean reflectance
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgRefRescale, visoutname, bone, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale','_Grids.',imgformat,']']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgRefRescaleProj, visoutname, bone, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgRefRescaleProj,2)/12, imgformat, imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_avg_rescale-proj','_Grids.',imgformat,']']);

%mean SE of reflectance
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgSERefRescale, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'grid', [], imgformat, imgresolution);
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale','_Grids.',imgformat,']']);

visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale-proj','_Grids.',imgformat]);
save_multi_band_grid_img(bandsImgSERefRescaleProj, visoutname, jet, mat_res, xbands_name, y_label, boldLineList, 'project', size(bandsImgRefRescaleProj,2)/12, 'png', imgresolution)
disp(['saving [', groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_SEavg_rescale-proj','_Grids.',imgformat,']']);

disp('all grid summary imgs are saved');
end