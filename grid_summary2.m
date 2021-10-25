function grid_summary2(grid_mat_directory, Result_directory, subFolderList, groupName, group_barcodes, labelfile)
disp(['################################']);
disp(['Begin to analysis group [[ ', groupName,' ]]']);
disp(['################################']);
fprintf('check specimen matrices: ');
in_grid=cell(0,1);
in_grid_barcode0=cell(0,1);
barID=1;
 for matinID0=1:length(group_barcodes)
    matindir=grid_mat_directory;
    barcodein=deblank(group_barcodes{matinID0});
    matin=dir(fullfile(matindir,[barcodein,'_*']));
    if ~isempty(matin)
%         matinname=matin.name;
        in_grid{barID}=matin;
        in_grid_barcode0{barID}=barcodein;
        barID=barID+1;
        if matinID0<length(group_barcodes) fprintf([num2str(matinID0),'-']);, else fprintf([num2str(matinID0),'#']);, end;
    end
    if mod(matinID0,50)==0
        fprintf('\n');
    end
 end
  fprintf('\n');
in_grid_barcode=remove_duplicate_strings(in_grid_barcode0);
if isempty(in_grid_barcode) disp('none corresponding matrix is found');, end;
group_preference_list= labelfile(ismember(labelfile.barcode,in_grid_barcode),:); %Extrcat the preference list only related to the barcodes in the group

sampleN=length(in_grid);
 
fore_hind_grids_dorsal=cell(0,sampleN);
fore_hind_grids_ventral=cell(0,sampleN);
fore_hind_shapes=cell(0,3);
all_tail_L=cell(0,3);
all_tail_R=cell(0,3);
all_tail_spp=cell(0,3);
all_scale_dorsal=cell(0,3);
all_scale_ventral=cell(0,3);
ant_ref_d=[];
ant_ref_v=[];
ant_info_d=[];
ant_info_v=[];
gridDatID=1;
 for matinID=1:sampleN
    matindir=in_grid{matinID}.folder;
    matinname=in_grid{matinID}.name;
    pathdirs=strsplit(matindir,filesep);
    lowestdir=pathdirs{end};
    matres0=strsplit(matinname,'res-');
    matres1=strsplit(matres0{2},'x');
    mat_res=str2num(matres1{1});
    matin=fullfile(matindir,matinname);
    sppmat0=load(matin);
    fieldName=cell2mat(fieldnames(sppmat0));
    sppmat=sppmat0.(fieldName);
    clear sppmat0;
    disp(['[',matinname,'] in {',lowestdir,'} has been read into memory']);

    spp_preference_list= group_preference_list(ismember(group_preference_list.barcode,in_grid_barcode{matinID}),:);
    dorsal_preference_list= spp_preference_list(ismember(spp_preference_list.side,'dorsal'),:);
    ventral_preference_list= spp_preference_list(ismember(spp_preference_list.side,'ventral'),:);
    %%
    v_d_shapes=cell(0,2);
    %Derive shape summary
    for sideID=1:2
        sideDat=sppmat{1}{sideID};
        grid=sideDat{1}{2};
        shpLF=[reshape(grid(1,:,:),[],2) ; reshape(grid(2:end,end,:),[],2) ; flip(reshape(grid(end,1:end-1,:),[],2)) ; flip(reshape(grid(1:end-1,1,:),[],2))];
        grid=sideDat{2}{2};
        shpRF0=[flip(reshape(grid(1,:,:),[],2)) ; reshape(grid(1:end-1,1,:),[],2) ; reshape(grid(end,1:end-1,:),[],2) ; flip(reshape(grid(1:end-1,end,:),[],2))];
        shpRF=[-shpRF0(:,1),shpRF0(:,2)];
        grid=sideDat{3}{2};
        shpLH=[reshape(grid(1,:,:),[],2) ; reshape(grid(2:end,end,:),[],2) ; flip(reshape(grid(end,1:end-1,:),[],2)) ; flip(reshape(grid(1:end-1,1,:),[],2))];
        grid=sideDat{4}{2};
        shpRH0=[flip(reshape(grid(1,:,:),[],2)) ; reshape(grid(1:end-1,1,:),[],2) ; reshape(grid(end,1:end-1,:),[],2) ; flip(reshape(grid(1:end-1,end,:),[],2))];
        shpRH=[-shpRH0(:,1),shpRH0(:,2)];
        regPtLF=sideDat{1}{1};
        regPtLH=sideDat{3}{1};
        v_d_shapes{sideID}={shpLF,shpRF,shpLH,shpRH,regPtLF,regPtLH};
        %figure,plot(shpRF(:,1),shpRF(:,2),'r');
    end
    fore_hind_shapes{1}{matinID}={v_d_shapes{1}{1:2},v_d_shapes{2}{1:2}}; %fore wings
    fore_hind_shapes{2}{matinID}={v_d_shapes{1}{3:4},v_d_shapes{2}{3:4}}; %hind wings
    fore_hind_shapes{3}{matinID}={v_d_shapes{1}{5},v_d_shapes{2}{5}}; %Reg pts LF
    fore_hind_shapes{4}{matinID}={v_d_shapes{1}{6},v_d_shapes{2}{6}}; %Reg pts LH
    %The shape will be filtered after entire matrix being generated
    
    %%
    spp_tail_preference_list=[dorsal_preference_list.LH_wing_d, ventral_preference_list.LH_wing_d, dorsal_preference_list.RH_wing_d, ventral_preference_list.RH_wing_d];
    
    %Derive tail summary
    [tail_dat_spp, tail_dat_L, tail_dat_R]=tail_summary(sppmat, spp_tail_preference_list);
    all_tail_L{matinID}=tail_dat_L;
    all_tail_R{matinID}=tail_dat_R;
    all_tail_spp{matinID}=tail_dat_spp;
    %%
    % derive scale
    all_scale_dorsal{matinID}=sppmat{3}(1);
    all_scale_ventral{matinID}=sppmat{3}(2);
    
    %%
    %Antanae data
    antenna=sppmat{7};
    antenna_info=sppmat{6};

    if length(antenna)>1
        [spp_antMat_dorsal, spp_antMat_ventral, spp_antInfo_dorsal, spp_antInfo_ventral] = antenna_summary(antenna, antenna_info, dorsal_preference_list, ventral_preference_list);
        ant_ref_d=cat(3,ant_ref_d,spp_antMat_dorsal);
        ant_ref_v=cat(3, ant_ref_v, spp_antMat_ventral);
        ant_info_d=cat(1, ant_info_d, spp_antInfo_dorsal);
        ant_info_v=cat(1, ant_info_v, spp_antInfo_ventral);
    end

    
    %%
    %Calculate grid summary
    if iscell(sppmat{2})
        for sideID=1:2
            sideDat=sppmat{2}{sideID};
            if sideID==1
                side_preference_list=dorsal_preference_list;
            else
                side_preference_list=ventral_preference_list;
            end
            sideresult=multi_band_grid_summary(sideDat, side_preference_list);
            if sideID==1
                fore_hind_grids_dorsal{gridDatID}=sideresult;
            else
                fore_hind_grids_ventral{gridDatID}=sideresult;
            end
        end
        gridDatID=gridDatID+1;
    else
        disp(['No grided reflectacne data in No. ',num2str(matinID),' [',matinname,']']);
    end
 end

fore_hind_grids_dorsal=fore_hind_grids_dorsal(~cellfun('isempty',fore_hind_grids_dorsal));
fore_hind_grids_ventral=fore_hind_grids_ventral(~cellfun('isempty',fore_hind_grids_ventral));
 
 %%
sidesAllBandStability_dorsal=cal_BandStability(fore_hind_grids_dorsal);
sidesAllBandStability_ventral=cal_BandStability(fore_hind_grids_ventral);
%Data structure generate by the loop above:
%{1}=fore wing
%{2}= hind wing
    %{}{n}=the variance/ stability of bandID (the order is the same as the matrix read in)
    
sidesAllBandRef_dorsal=cal_BandAvgRef(fore_hind_grids_dorsal);
sidesAllBandRef_ventral=cal_BandAvgRef(fore_hind_grids_ventral);
%Data structure generate by the loop above:
%{1}=fore wing
%{2}= hind wing
    %{}{n}=the mean reflectance of bandID (the order is the same as the matrix read in)

sidesAllBandSERef_dorsal=cal_BandAvgRefSE(fore_hind_grids_dorsal);
sidesAllBandSERef_ventral=cal_BandAvgRefSE(fore_hind_grids_ventral); 

%%
%filter wing shapes parameter
%Calculate the mean shapes of fore wing and hind wing of a specimen
group_dorsal_pref_list=group_preference_list(ismember(group_preference_list.side,'dorsal'),:);
group_ventral_pref_list=group_preference_list(ismember(group_preference_list.side,'ventral'),:);

shp_pref_listF=[group_dorsal_pref_list.LF_wing_d, group_dorsal_pref_list.RF_wing_d, group_ventral_pref_list.LF_wing_d, group_ventral_pref_list.RF_wing_d];
shp_pref_listH=[group_dorsal_pref_list.LH_wing_d, group_dorsal_pref_list.RH_wing_d, group_ventral_pref_list.LH_wing_d, group_ventral_pref_list.RH_wing_d];

disp('Start to calculate specimen mean shape');
fore_shapes0=vertcat(fore_hind_shapes{1}{:});
hind_shapes0=vertcat(fore_hind_shapes{2}{:});
%calculate mean wing shape for each species
sppnHarmonic=30;
spp_barcodeList=group_dorsal_pref_list.barcode;
fprintf('fore wing: ');
spp_mean_shpF=calculate_spp_mean_shp(fore_shapes0, shp_pref_listF, spp_barcodeList, sppnHarmonic);
fprintf('hind wing: ');
spp_mean_shpH=calculate_spp_mean_shp(hind_shapes0, shp_pref_listH, spp_barcodeList, sppnHarmonic);

%%
fore_shapes1=fore_shapes0;
[emptyIdxF_x, emptyIdxF_y]=find(shp_pref_listF==0);
if length(emptyIdxF_x)==sampleN*4 %If no perfect wing at all, we use the last one
    emptyIdxF_x=emptyIdxF_x(1:end-1);
    emptyIdxF_y=emptyIdxF_y(1:end-1);
end
for epyID=1:length(emptyIdxF_x)
    fore_shapes1(emptyIdxF_x(epyID), emptyIdxF_y(epyID)) = {NaN};
end
fore_shapes=reshape(fore_shapes1',[],1);

hind_shapes1=hind_shapes0;
[emptyIdxH_x, emptyIdxH_y]=find(shp_pref_listH==0);
if length(emptyIdxF_x)==sampleN*4 %If no perfect wing at all, we use the last one
    emptyIdxH_x=emptyIdxH_x(1:end-1);
    emptyIdxH_y=emptyIdxH_y(1:end-1);
end
for epyID=1:length(emptyIdxH_x)
    hind_shapes1(emptyIdxH_x(epyID), emptyIdxH_y(epyID)) = {NaN};
end
hind_shapes=reshape(hind_shapes1',[],1);

%Calculate the mean shapes of fore wing and hind wing
nHarmonic=20;
ConfIntervalKeepF=90;
ConfIntervalKeepH=90;
disp('Start to calculate group mean shape');
disp(['Variable [nHarmonic]: ',num2str(round(nHarmonic))]);
disp(['Variable [ConfIntervalKeepF]: ',num2str(round(ConfIntervalKeepF,2))]);
disp(['Variable [ConfIntervalKeepH]: ',num2str(round(ConfIntervalKeepH,2))]);
[mean_shp_fore, shpIDF,~, specimens_includedF]=cal_mean_shp2(fore_shapes,nHarmonic,ConfIntervalKeepF);
[mean_shp_hind, shpIDH, scaling_factor_listH, specimens_includedH]=cal_mean_shp2(hind_shapes,nHarmonic,ConfIntervalKeepH);
disp('Mean shapes of fore wing and hind wings are done');

scaling_factor_listH2=reshape(scaling_factor_listH,4, [])';
%row: specimen order; col1: dorsal LH; col 2: dorsal RH; col 3: ventral LH; col 4: ventral RH;
%Here, the scaling factor is used for tails, so no matter the wing is
%accepted for the final mean shape or not, we need to know the scaling
%factor for the corresponding tails
%To derive the scaling factor corresponding to specimens that are included,
%futher calculation between scaling_factor and specimens_included is
%needed.

%     %Plot on the shape without ornament
%     figure, plot(mean_shp_fore(:,1), -mean_shp_fore(:,2), 'r','LineWidth',1);
%     figure, plot(mean_shp_hind(:,1), -mean_shp_hind(:,2), 'r','LineWidth',1);

disp('Start to calculate grid for mean shapes');
fore_keys=reshape(vertcat(fore_hind_shapes{3}{:}),[],1);
hind_keys=reshape(vertcat(fore_hind_shapes{4}{:}),[],1);
%seg4PtsLF=fore_keys{ceil(shpIDF/2)};  %If the first-run result is wrong, then run this to debug
%manual define for deBug
% seg4PtsLF=manual_deBug_define_key_pts(mean_shp_fore, seg4PtsLF, 'F');
% %if the plot is out of range, run the same manual function twice can help
fore_ref_shp0=fore_shapes{shpIDF}; %Run this first for accuracy
if mean(fore_ref_shp0(:,1))>0
    fore_ref_shp=fore_ref_shp0;
else
    fore_ref_shp=register_two_shapes(fore_ref_shp0, mean_shp_fore);
end
seg4PtsLF=[fore_ref_shp(1+2*mat_res,:) ; fore_ref_shp(1+mat_res,:) ; fore_ref_shp(1,:) ; fore_ref_shp(1+3*mat_res,:)]; %Run this first for accuracy

% seg4PtsLH=hind_keys{ceil(shpIDH/2)};  %If the first-run result is wrong, then run this to debug
%manual define for deBug
% seg4PtsLH=manual_deBug_define_key_pts(mean_shp_hind, seg4PtsLH, 'H');
% %if the plot is out of range, run the same manual function twice can help
hind_ref_shp0=hind_shapes{shpIDH}; %Run this first for accuracy
if mean(hind_ref_shp0(:,1)) >0
    hind_ref_shp=hind_ref_shp0;
else
    hind_ref_shp=register_two_shapes(hind_ref_shp0, mean_shp_hind);
end
seg4PtsLH=[hind_ref_shp(1+mat_res,:) ; hind_ref_shp(1+2*mat_res,:) ; hind_ref_shp(1+3*mat_res,:) ; hind_ref_shp(1,:)]; %Run this first for accuracy

numberOfIntervalDegree=log2(mat_res);
 [seg4PtsF,wingGridsF,wingMask_meanF]=mena_shp_grids(mean_shp_fore, seg4PtsLF,'F',numberOfIntervalDegree);
 [seg4PtsH,wingGridsH,wingMask_meanH]=mena_shp_grids(mean_shp_hind, seg4PtsLH,'H',numberOfIntervalDegree);
disp('All grids are done');
%remove blank regions; make sure the bounding box fit the wing mask
disp('Remove un-necessary blank regions');
bufferWidth=10;
[seg4PtsF2,wingGridsF2,wingMask_meanF2,~]=rmBlankRegionGrids(seg4PtsF,wingGridsF,wingMask_meanF,bufferWidth);
[seg4PtsH2,wingGridsH2,wingMask_meanH2,~]=rmBlankRegionGrids(seg4PtsH,wingGridsH,wingMask_meanH,bufferWidth);
%  %plot all grids on Fore wings
% figure,imshow(logical(wingMask_meanF2));hold on;
% for i=2:size(wingGridsF2,1)-1
%     gridPlot=reshape(wingGridsF2(i,:,:),[],2);
%     plot(gridPlot(:,1),gridPlot(:,2),'r');
% end
% for j=2:size(wingGridsF2,2)-1
%     gridPlot=reshape(wingGridsF2(:,j,:),[],2);
%     plot(gridPlot(:,1),gridPlot(:,2),'r');
% end
% 
% figure,imshow(wingMask_meanH2);hold on;
% for i=2:size(wingGridsH2,1)-1
%     gridPlot=reshape(wingGridsH2(i,:,:),[],2);
%     plot(gridPlot(:,1),gridPlot(:,2),'r');
% end
% for j=2:size(wingGridsH2,2)-1
%     gridPlot=reshape(wingGridsH2(:,j,:),[],2);
%     plot(gridPlot(:,1),gridPlot(:,2),'r');
% end

%%
%Project sumarry value on mean shape grids
disp('Start to project multi-spectral reflectance on grids. It takes a while. Be patient.');
sidesAllBandsProj_std_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandStability_dorsal);
disp('std of drosal side is done');
sidesAllBandsProj_std_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandStability_ventral);
disp('std of ventral side is done');
sidesAllBandsProj_ref_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandRef_dorsal);
disp('mean of drosal side is done');
sidesAllBandsProj_ref_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandRef_ventral);
disp('mean of ventral side is done');
sidesAllBandsProj_SE_ref_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandSERef_dorsal);
disp('mean of SE of drosal side is done');
sidesAllBandsProj_SE_ref_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandSERef_ventral);
disp('mean of SE of ventral side is done');
%%
disp('Start to plot multi-spectral reflectance on grids of mean shapes');
%Visualization
target_band_list=[3,6,1,2,9,10];
%Variance Img
bandsImgVarRescale=generate_multi_bands_Img(sidesAllBandStability_dorsal, sidesAllBandStability_ventral, target_band_list, 1, 2);
% bandsImgVarOriginal=generate_multi_bands_Img(sidesAllBandStability_dorsal, sidesAllBandStability_ventral, target_band_list, 0, 2);
bandsImgVarRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_std_dorsal, sidesAllBandsProj_std_ventral, target_band_list, 1, 20);
% bandsImgVarOriginalProj=generate_multi_bands_Img(sidesAllBandsProj_std_dorsal, sidesAllBandsProj_std_ventral, target_band_list, 0, 20);

%Reflectance Img
bandsImgRefRescale=generate_multi_bands_Img(sidesAllBandRef_dorsal, sidesAllBandRef_ventral, target_band_list, 1, 2);
% bandsImgRefOriginal=generate_multi_bands_Img(sidesAllBandRef_dorsal, sidesAllBandRef_ventral, target_band_list, 0, 2);
bandsImgRefRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_ref_dorsal, sidesAllBandsProj_ref_ventral, target_band_list, 1, 20);
% bandsImgRefOriginalProj=generate_multi_bands_Img(sidesAllBandsProj_ref_dorsal, sidesAllBandsProj_ref_ventral, target_band_list, 0, 20);
%bandsImgRefRescaleProjRGB=generate_multi_bands_ImgRGB(sidesAllBandsProj_ref_dorsal, sidesAllBandsProj_ref_ventral, target_band_list, 1);

%SE of reflectance Img (where has more patterns)
bandsImgSERefRescale=generate_multi_bands_Img(sidesAllBandSERef_dorsal, sidesAllBandSERef_ventral, target_band_list, 1, 2);
% bandsImgSERefOriginal=generate_multi_bands_Img(sidesAllBandSERef_dorsal, sidesAllBandSERef_ventral, target_band_list, 0, 2);
bandsImgSERefRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_SE_ref_dorsal, sidesAllBandsProj_SE_ref_ventral, target_band_list, 1, 20);
% bandsImgSERefOriginalProj=generate_multi_bands_Img(sidesAllBandsProj_SE_ref_dorsal, sidesAllBandsProj_SE_ref_ventral, target_band_list, 0, 20);


%Save grid images
xbands_name='UV ; B ; G ; R ; NIR ; fNIR ; fluor_B ; fluor_G ; fluor_R ; polDiff_B ; polDiff_G ; polDiff_R';
y_label={'Hind wing ; Fore wing' ; '(Ventral ; Dorsal) ; (Ventral ; Dorsal)'};
boldLineList=[1,4,5,6,9];
imgformat='png';
imgresolution=200;
save_grid_summary_img(bandsImgVarRescale, bandsImgVarRescaleProj, bandsImgRefRescale, bandsImgRefRescaleProj, bandsImgSERefRescale, bandsImgSERefRescaleProj, groupName, mat_res, sampleN, xbands_name, y_label, boldLineList, Result_directory, subFolderList, imgformat, imgresolution);
%%
%Summarize specimen level tail information
disp('Start to summarize specimen tail information');
length_threshold=5; %5 px (~0.1mm) the threshold to define a tail
all_tail_info_spp=summarize_specimen_Tail(all_tail_spp, all_scale_dorsal, all_scale_ventral, scaling_factor_listH2, in_grid_barcode, mat_res, length_threshold);

%Summarize group tail information
disp('Start to summarize group tail information');
frequencyThreshold=6; % minimal sample size for each location; number of minimal required specimen *4+2
if sampleN<=2 frequencyThreshold=2;, end; %lower the threshold for small size of specimens
[~, firstColLastRow_probability, firstColLastRow_Len_summary_median, firstColLastRow_Cur_summary_median, firstColLastRow_Len_summary_IQR, firstColLastRow_Cur_summary_IQR, firstColLastRow_allLen_cm]=summarizeTailInfo_group(all_tail_L, all_tail_R, all_scale_dorsal, all_scale_ventral, scaling_factor_listH2, mat_res, length_threshold, frequencyThreshold, sampleN);
%Key variables for the following analysis: firstColLastRow_probability,
%firstColLastRow_Len_summary, firstColLastRow_Cur_summary
%Key canvas variables: wingGridsH2, wingMask_meanH2

firstColLastRow_midPts_single_line=deriveTailPlotLoc(wingGridsH2, wingMask_meanH2); %Derive the key coordinatinos for plotting tail

%Plot tail summary
disp('Start to plot tail summary');
bufferW=50; %Buffer range from the tip of bar to the edge of image
rescaleOpacity=1; %rescale opacity to fit 10%-90% range or not
defaultOpacity=0.2; %the opacity when all probility are the same
color1=[[245,164,190];[250,37,98]]/255; %red gradient for probability; low to high
% color1=[[250,37,98];[250,37,98]]/255; %red gradient for probability; low to high
color2=[[37,299,250];[2,39,247]]/255; %blue gradient for curvature; low to high
color3=[[255,255,255];[130,130,130]]/255; %grey gradient for curvature iqr; low to high

imgformat='png';
imgresolution=200;
outnameHeader=groupName;
visoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[outnameHeader,'_bothSides_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_tails_summary.png']);
fftail=figure('visible', 'off');
plotTails(wingMask_meanH2,firstColLastRow_Len_summary_median,firstColLastRow_probability,firstColLastRow_Cur_summary_median, firstColLastRow_Len_summary_IQR, firstColLastRow_Cur_summary_IQR, firstColLastRow_midPts_single_line, rescaleOpacity, defaultOpacity, bufferW,color1, color2, color3);
export_fig(fftail,visoutname, ['-',imgformat],['-r',num2str(imgresolution)]);
close(fftail);
disp(['saving [', groupName, '_res-',num2str(mat_res),'x',num2str(mat_res),'_spn-',num2str(sampleN),'_tails_summary.png]']);

tail_all_info={firstColLastRow_probability, firstColLastRow_Len_summary_median, firstColLastRow_Cur_summary_median, firstColLastRow_Len_summary_IQR, firstColLastRow_Cur_summary_IQR, firstColLastRow_allLen_cm};
%%
%summarize antenna reflectance and parameters
disp('Start to summarize antenna information');
imgformat='png';
imgresolution=200;
[ant_final_ref_d, ant_final_ref_v, ant_info, antFlag_d, antFlag_v, ant_d_filter, ant_v_filter]=generate_multi_bands_antenna_Img(ant_ref_d, ant_ref_v, ant_info_d, ant_info_v);

%Plot antenna reflectance
antImgSize=[500,300];
avgBarWidth=10;
bandGatherList={3,[6,7,8],1,2,[15,16,17],[18,19,20]};
antScaling_factor=100;
barColor=[123,209,255]/255;
barColorSD=[200,200,200]/255;
bolbColor=[35, 105, 255]/255;
save_antenna_summary_img(antImgSize, avgBarWidth, bandGatherList, antScaling_factor, barColor, barColorSD, bolbColor, ant_final_ref_d, ant_final_ref_v, ant_d_filter, ant_v_filter, antFlag_d, antFlag_v, ant_info, groupName, sampleN, Result_directory, subFolderList, imgformat, imgresolution);
antenna_all_info={ant_final_ref_d, ant_final_ref_v, ant_info, ant_d_filter, ant_v_filter};
   %% 
   disp('Start to save summary information');
sidesAllBandSummary={{sidesAllBandRef_dorsal, sidesAllBandRef_ventral},{sidesAllBandStability_dorsal, sidesAllBandStability_ventral, sidesAllBandSERef_dorsal, sidesAllBandSERef_ventral},{{wingMask_meanF2,seg4PtsF2,wingGridsF2},{wingMask_meanH2,seg4PtsH2,wingGridsH2}, spp_mean_shpF, spp_mean_shpH}, all_tail_info_spp, tail_all_info, antenna_all_info, {all_scale_dorsal, all_scale_ventral}, in_grid};
%Data structure of output matrix:
%{1}= average reflectance
    %{1}{1} = dorsal side
    %{1}{2} = ventral side
        %{1}{}{1}=fore wing
        %{1}{}{2}= hind wing
            %{}{}{}{n}=the mean reflectance of bandID (the order is the same as the matrix read in)
%{2}= standard deviation of reflectance (inter species)
    %{2}{1}= standard deviation of reflectance (inter species) at dorsal side (high value indicates regions different from different individual)
    %{2}{2}= standard deviation of reflectance (inter species) at ventral side (high value indicates regions different from different individual)
    %{2}{3}= average spatial standard error of reflectance (inter species) at dorsal side (high value indicates high contrast region)
    %{2}{4}= average spatial standard error of reflectance (inter species) at ventral side (high value indicates high contrast region)
        %{2}{}{1}=fore wing
        %{2}{}{2}= hind wing
            %{2}{}{}{n}=the reflectance of bandID (the order is the same as the matrix read in)
%{3}= mean shape
    %{}{1}=overall mean shape of fore wing
    %{}{2}=overall mean shape of hind wing
        %{}{}{1}=mean shpe mask
        %{}{}{2}=mean shpe regPts
        %{}{}{3}=mean shpe grids
    %{}{3}=mean shape of fore wing of each specimen
    %{}{4}=mean shape of hind wing of each specimen
%{4}= specimen level tail summary data
    %{4}{N}= No.N specimen
        %{4}{}{1}=specimen barcode
        %{4}{}{2}=haveing tail or not (1, 0)
        %{4}{}{3}=  the probability of having a tail in a postion under the condition that the specimen does have a tail
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
        %{4}{}{4}= the mean length of those tails at each position
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
        %{4}{}{5}= the mean curveture of those tails at each position
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curveture)
        %{4}{}{6}= the range of length of those tails at each position %See {4}{4}
        %{4}{}{7}= the range of curveture of those tails at each position  %See {4}{5}
        %{4}{}{8}= a matrix which integrated tail length data for both left and right hind wings
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: left or right wing)
            %{4}{}{8}(:,:,1) = left hind wing
            %{4}{}{8}(:,:,2) = right hind wing
%{5}= tail summary information (not normal distributed so use median and IQR)
    %{5}{1} = the probability of having a tail in a postion under the condition that the specimen does have a tail
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
    %{5}{2} = the median length of those tails at each position
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
    %{5}{3} = the median curveture of those tails at each position
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curveture)
    %{5}{4} = the IQR of length of those tails at each position %See {5}{2}
    %{5}{5} = the IQR of curveture of those tails at each position  %See {5}{3}
    %{5}{6} = a 3d matrix which integrated all original tail length data
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tails but not specimens)
%{6}= antenna summary information
    %{6}{1} = multispectral reflectance of dorsal side of antenna
    %{6}{2} = multispectral reflectance of ventral side of antenna
        %{6}{1 | 2}{1} = mean
        %{6}{1 | 2}{1} = standard deviation
            %{6}{1 | 2}{}(:,1) = 740
            %{6}{1 | 2}{}(:,2) = 940
            %{6}{1 | 2}{}(:,3) = UV
            %{6}{1 | 2}{}(:,4) = UVF
            %{6}{1 | 2}{}(:,5) = F
            %{6}{1 | 2}{}(:,6:8) = white (RGB)
            %{6}{1 | 2}{}(:,9:11) = whitePo1 (RGB)
            %{6}{1 | 2}{}(:,12:14) = whitePo2 (RGB)
            %{6}{1 | 2}{}(:,15:17) = FinRGB (RGB)
            %{6}{1 | 2}{}(:,18:20) = PolDiff (RGB)
    %{6}{3} = antenna morphology measurements (normal distributed so use mean and sd)
        %{6}{3}{1} = mean
        %{6}{3}{2} = standard deviation
            %{6}{3}{}(1) = Antennae length (mm)
            %{6}{3}{}(2) = Antennae width (mm)
            %{6}{3}{}(3) = Bolb width (mm)
            %{6}{3}{}(4) = Curveness (unitless)
    %{6}{4} = filter indicating those dorsal-side antennae beeing included in the analysis; 0: excluded; 1: included
    %{6}{5} = filter indicating those dorsal-side antennae beeing included in the analysis; 0: excluded; 1: included
%{7} = scale length
    %{7}{1} = dorsal
    %{7}{2} = ventral
%{8} = The list of original file information

matoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{2},[groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_summary.mat']);
save(matoutname,'sidesAllBandSummary'); %save the specimen matrix
disp('The summary matrix has been successfully saved.');

end