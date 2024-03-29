function grid_summary2(grid_mat_directory, Result_directory, subFolderList, groupName, group_barcodes, labelfile)
disp(['################################']);
disp(['Begin to analyze group [[ ', groupName,' ]]']);
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
if isempty(in_grid_barcode) disp('no corresponding matrix is found');, end;
group_preference_list= labelfile(ismember(labelfile.barcode,in_grid_barcode),:); %Extract the preference list only related to the barcodes in the group

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
    end
    fore_hind_shapes{1}{matinID}={v_d_shapes{1}{1:2},v_d_shapes{2}{1:2}}; %forewings
    fore_hind_shapes{2}{matinID}={v_d_shapes{1}{3:4},v_d_shapes{2}{3:4}}; %hindwings
    fore_hind_shapes{3}{matinID}={v_d_shapes{1}{5},v_d_shapes{2}{5}}; %Reg pts LF
    fore_hind_shapes{4}{matinID}={v_d_shapes{1}{6},v_d_shapes{2}{6}}; %Reg pts LH
    %The shape will be filtered after entire matrix is generated
    
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
    %Antennae data
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
        disp(['No gridded reflectacne data in No. ',num2str(matinID),' [',matinname,']']);
    end
 end

fore_hind_grids_dorsal=fore_hind_grids_dorsal(~cellfun('isempty',fore_hind_grids_dorsal));
fore_hind_grids_ventral=fore_hind_grids_ventral(~cellfun('isempty',fore_hind_grids_ventral));
 
 %%
sidesAllBandStability_dorsal=cal_BandStability2(fore_hind_grids_dorsal);
sidesAllBandStability_ventral=cal_BandStability2(fore_hind_grids_ventral);
%Data structure generated by the loop above:
%{1}=forewing
%{2}= hindwing
    %{}{n}=the variance/ stability of bandID (the order is the same as the matrix read in)
    
sidesAllBandRef_dorsal=cal_BandAvgRef2(fore_hind_grids_dorsal);
sidesAllBandRef_ventral=cal_BandAvgRef2(fore_hind_grids_ventral);
%Data structure generate by the loop above:
%{1}=forewing
%{2}= hindwing
    %{}{n}=the mean reflectance of bandID (the order is the same as the matrix read in)

sidesAllBandSERef_dorsal=cal_BandAvgRefSE2(fore_hind_grids_dorsal);
sidesAllBandSERef_ventral=cal_BandAvgRefSE2(fore_hind_grids_ventral); 

%%
%filter wing shapes parameter
%Calculate the mean shapes of forewing and hindwing of a specimen
group_dorsal_pref_list=group_preference_list(ismember(group_preference_list.side,'dorsal'),:);
group_ventral_pref_list=group_preference_list(ismember(group_preference_list.side,'ventral'),:);

shp_pref_listF=[group_dorsal_pref_list.LF_wing_d, group_dorsal_pref_list.RF_wing_d, group_ventral_pref_list.LF_wing_d, group_ventral_pref_list.RF_wing_d];
shp_pref_listH=[group_dorsal_pref_list.LH_wing_d, group_dorsal_pref_list.RH_wing_d, group_ventral_pref_list.LH_wing_d, group_ventral_pref_list.RH_wing_d];

disp('Start to calculate mean specimen shape');
fore_shapes0=vertcat(fore_hind_shapes{1}{:});
hind_shapes0=vertcat(fore_hind_shapes{2}{:});
%calculate mean wing shape for each species
sppnHarmonic=30;
spp_barcodeList=group_dorsal_pref_list.barcode;
fprintf('forewing: ');
spp_mean_shpF=calculate_spp_mean_shp(fore_shapes0, shp_pref_listF, spp_barcodeList, sppnHarmonic);
fprintf('hindwing: ');
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

%Calculate the mean shapes of forewing and hindwing
nHarmonic=20;
ConfIntervalKeepF=90;
ConfIntervalKeepH=90;
disp('Start to calculate mean group shape');
disp(['Variable [nHarmonic]: ',num2str(round(nHarmonic))]);
disp(['Variable [ConfIntervalKeepF]: ',num2str(round(ConfIntervalKeepF,2))]);
disp(['Variable [ConfIntervalKeepH]: ',num2str(round(ConfIntervalKeepH,2))]);
[mean_shp_fore, shpIDF,~, specimens_includedF]=cal_mean_shp2(fore_shapes,nHarmonic,ConfIntervalKeepF);
[mean_shp_hind, shpIDH, scaling_factor_listH, specimens_includedH]=cal_mean_shp2(hind_shapes,nHarmonic,ConfIntervalKeepH);
disp('Mean shapes of forewing and hindwings are done');

scaling_factor_listH2=reshape(scaling_factor_listH,4, [])';
%row: specimen order; col1: dorsal LH; col 2: dorsal RH; col 3: ventral LH; col 4: ventral RH;
%Here, the scaling factor is used for tails, so no matter the wing is
%accepted for the final mean shape or not, we need to know the scaling
%factor for the corresponding tails
%To derive the scaling factor corresponding to specimens that are included,
%futher calculation between scaling_factor and specimens_included is
%needed.

%     %Plot on the shape without ornament (for debugging purpose)
%     figure, plot(mean_shp_fore(:,1), -mean_shp_fore(:,2), 'r','LineWidth',1);
%     figure, plot(mean_shp_hind(:,1), -mean_shp_hind(:,2), 'r','LineWidth',1);

disp('Start to calculate grid for mean shapes');
fore_keys=reshape(vertcat(fore_hind_shapes{3}{:}),[],1);
hind_keys=reshape(vertcat(fore_hind_shapes{4}{:}),[],1);

fore_ref_shp0=fore_shapes{shpIDF}; %Run this first for accuracy
if mean(fore_ref_shp0(:,1))>0
    fore_ref_shp=fore_ref_shp0;
else
    fore_ref_shp=register_two_shapes(fore_ref_shp0, mean_shp_fore);
end
seg4PtsLF=[fore_ref_shp(1+2*mat_res,:) ; fore_ref_shp(1+mat_res,:) ; fore_ref_shp(1,:) ; fore_ref_shp(1+3*mat_res,:)]; %Run this first for accuracy

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
%remove blank regions; make sure the bounding box fits the wing mask
disp('Remove un-necessary blank regions');
bufferWidth=10;
[seg4PtsF2,wingGridsF2,wingMask_meanF2,~]=rmBlankRegionGrids(seg4PtsF,wingGridsF,wingMask_meanF,bufferWidth);
[seg4PtsH2,wingGridsH2,wingMask_meanH2,~]=rmBlankRegionGrids(seg4PtsH,wingGridsH,wingMask_meanH,bufferWidth);

%%
%Project summary value on mean shape grids
disp('Start to project multi-spectral reflectance on grids. It takes a while. Be patient.');
sidesAllBandsProj_std_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandStability_dorsal);
disp('std of dorsal side is done');
sidesAllBandsProj_std_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandStability_ventral);
disp('std of ventral side is done');
sidesAllBandsProj_ref_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandRef_dorsal);
disp('mean of dorsal side is done');
sidesAllBandsProj_ref_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandRef_ventral);
disp('mean of ventral side is done');
sidesAllBandsProj_SE_ref_dorsal=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandSERef_dorsal);
disp('mean of SE of dorsal side is done');
sidesAllBandsProj_SE_ref_ventral=project_allBands_grids_on_wings(wingMask_meanF2,wingMask_meanH2,wingGridsF2,wingGridsH2,sidesAllBandSERef_ventral);
disp('mean of SE of ventral side is done');
%%
disp('Start to plot multi-spectral reflectance on grids of mean shapes');
%Visualization
target_band_list=[3,6,1,2,9,10];
%Variance Img
bandsImgVarRescale=generate_multi_bands_Img(sidesAllBandStability_dorsal, sidesAllBandStability_ventral, target_band_list, 1, 2);
bandsImgVarRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_std_dorsal, sidesAllBandsProj_std_ventral, target_band_list, 1, 20);

%Reflectance Img
bandsImgRefRescale=generate_multi_bands_Img(sidesAllBandRef_dorsal, sidesAllBandRef_ventral, target_band_list, 1, 2);
bandsImgRefRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_ref_dorsal, sidesAllBandsProj_ref_ventral, target_band_list, 1, 20);

%SE of reflectance Img (where has more patterns)
bandsImgSERefRescale=generate_multi_bands_Img(sidesAllBandSERef_dorsal, sidesAllBandSERef_ventral, target_band_list, 1, 2);
bandsImgSERefRescaleProj=generate_multi_bands_Img(sidesAllBandsProj_SE_ref_dorsal, sidesAllBandsProj_SE_ref_ventral, target_band_list, 1, 20);

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

firstColLastRow_midPts_single_line=deriveTailPlotLoc(wingGridsH2, wingMask_meanH2); %Derive the key coordinations for plotting tail

%Plot tail summary
disp('Start to plot tail summary');
bufferW=50; %Buffer range from the tip of bar to the edge of image
rescaleOpacity=1; %rescale opacity to fit 10%-90% range or not
defaultOpacity=0.2; %the opacity when all probabilities are the same
color1=[[245,164,190];[250,37,98]]/255; %red gradient for probability; low to high
color2=[[37,299,250];[2,39,247]]/255; %blue gradient for curvature; low to high
color3=[[255,255,255];[130,130,130]]/255; %gray gradient for curvature iqr; low to high

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
antenna_all_info={};
   %% 
   disp('Start to save summary information');
sidesAllBandSummary={{sidesAllBandRef_dorsal, sidesAllBandRef_ventral},{sidesAllBandStability_dorsal, sidesAllBandStability_ventral, sidesAllBandSERef_dorsal, sidesAllBandSERef_ventral},{{wingMask_meanF2,seg4PtsF2,wingGridsF2},{wingMask_meanH2,seg4PtsH2,wingGridsH2}, spp_mean_shpF, spp_mean_shpH}, all_tail_info_spp, tail_all_info, antenna_all_info, {all_scale_dorsal, all_scale_ventral}, in_grid};
%Data structure of output matrix:
%{1}= average reflectance
    %{1}{1} = dorsal side
    %{1}{2} = ventral side
        %{1}{}{1}=forewing
        %{1}{}{2}= hindwing
            %{}{}{}{n}=the mean reflectance of bandID (the order is the same as the matrix read in)
%{2}= standard deviation of reflectance (inter species)
    %{2}{1}= standard deviation of reflectance (inter species) at dorsal side (high value indicates regions different from different individual)
    %{2}{2}= standard deviation of reflectance (inter species) at ventral side (high value indicates regions different from different individual)
    %{2}{3}= average spatial standard error of reflectance (inter species) at dorsal side (high value indicates high contrast region)
    %{2}{4}= average spatial standard error of reflectance (inter species) at ventral side (high value indicates high contrast region)
        %{2}{}{1}=forewing
        %{2}{}{2}= hindwing
            %{2}{}{}{n}=the reflectance of bandID (the order is the same as the matrix read in)
%{3}= mean shape
    %{}{1}=overall mean shape of forewing
    %{}{2}=overall mean shape of hindwing
        %{}{}{1}=mean shpe mask
        %{}{}{2}=mean shpe regPts
        %{}{}{3}=mean shpe grids
    %{}{3}=mean shape of forewing of each specimen
    %{}{4}=mean shape of hindwing of each specimen
%{4}= specimen level tail summary data
    %{4}{N}= No.N specimen
        %{4}{}{1}=specimen barcode
        %{4}{}{2}=with tail or not (1, 0)
        %{4}{}{3}=  the probability of having a tail in a postion under the condition that the specimen does have a tail
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
        %{4}{}{4}= the mean length of those tails at each position
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
        %{4}{}{5}= the mean curvature of those tails at each position
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curvature)
        %{4}{}{6}= the range of length of those tails at each position %See {4}{4}
        %{4}{}{7}= the range of curvature of those tails at each position  %See {4}{5}
        %{4}{}{8}= a matrix which integrated tail length data for both left and right hindwings
            %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: left or right wing)
            %{4}{}{8}(:,:,1) = left hindwing
            %{4}{}{8}(:,:,2) = right hindwing
%{5}= tail summary information (not normally distributed so use median and IQR)
    %{5}{1} = the probability of having a tail in a postion under the condition that the specimen does have a tail
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: probability)
    %{5}{2} = the median length of those tails at each position
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail length)
    %{5}{3} = the median curvature of those tails at each position
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tail curvature)
    %{5}{4} = the IQR of length of those tails at each position %See {5}{2}
    %{5}{5} = the IQR of curvature of those tails at each position  %See {5}{3}
    %{5}{6} = a 3d matrix which integrated all original tail length data
        %(x=1: First column in the grid; x=2: Last row in the grid; y: concessive grids; z: tails but not specimens)
%{6}= antenna summary information
    %{6}{1} = multispectral reflectance of dorsal side of antennae
    %{6}{2} = multispectral reflectance of ventral side of antennae
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
    %{6}{3} = antennae morphology measurements (normal distributed so use mean and sd)
        %{6}{3}{1} = mean
        %{6}{3}{2} = standard deviation
            %{6}{3}{}(1) = Antennae length (mm)
            %{6}{3}{}(2) = Antennae width (mm)
            %{6}{3}{}(3) = Bulb width (mm)
            %{6}{3}{}(4) = Curviness (unitless)
    %{6}{4} = filter indicating those dorsal-side antennae being included in the analysis; 0: excluded; 1: included
    %{6}{5} = filter indicating those dorsal-side antennae being included in the analysis; 0: excluded; 1: included
%{7} = scale length
    %{7}{1} = dorsal
    %{7}{2} = ventral
%{8} = The list of original file information

matoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{2},[groupName,'_res-',num2str(mat_res),'x',num2str(mat_res),'_n-',num2str(sampleN),'_summary.mat']);
save(matoutname,'sidesAllBandSummary'); %save the specimen matrix
disp('The summary matrix has been successfully saved.');

end