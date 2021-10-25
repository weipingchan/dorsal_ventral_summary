function save_antenna_summary_img(antImgSize, avgBarWidth, bandGatherList, antScaling_factor, barColor, barColorSD, bolbColor, ant_final_ref_d, ant_final_ref_v, ant_d_filter, ant_v_filter, antFlag_d, antFlag_v, ant_info, groupName, sampleN, Result_directory, subFolderList, imgformat, imgresolution)
% antImgSize=[500,300];
% avgBarWidth=10;
% bandGatherList={3,[6,7,8],1,2,[15,16,17],[18,19,20]};
antRes=0;
if ~isempty(ant_final_ref_d)
    antImg_d_mean=antennaImg2(ant_final_ref_d{1}, bandGatherList, antImgSize, avgBarWidth);
    antImg_d_std=antennaImg2(ant_final_ref_d{2}, bandGatherList, antImgSize, avgBarWidth);
    antRes=size(ant_final_ref_d{1},1);
else
    antImg_d_mean=zeros(antImgSize);
    antImg_d_std=zeros(antImgSize);
end
if ~isempty(ant_final_ref_v)
    antImg_v_mean=antennaImg2(ant_final_ref_v{1}, bandGatherList, antImgSize, avgBarWidth);
    antImg_v_std=antennaImg2(ant_final_ref_v{2}, bandGatherList, antImgSize, avgBarWidth);
    antRes=size(ant_final_ref_v{1},1);
else
    antImg_v_mean=zeros(antImgSize);
    antImg_v_std=zeros(antImgSize);
end
antImg_mean=cat(1,flip(antImg_d_mean), antImg_v_mean); %Dorsal side at top, Ventral side at bottom, tip in the middle
antImg_std=cat(1,flip(antImg_d_std), antImg_v_std); %Dorsal side at top, Ventral side at bottom, tip in the middle

if ~isempty(ant_info)
    if sum(isnan(ant_info{1}))+sum(isnan(ant_info{2}))<8
        antFlag=0;
    else
        antFlag=1;
    end
else
    antFlag=1;
end

if antFlag==0 
    %Plot antenna shape
    disp('Start to plot antenna summary');
    % antScaling_factor=100;
    ant_info_mean=ant_info{1};
    ant_info_std=ant_info{2};

    % barColor=[123,209,255]/255;
    % barColorSD=[200,200,200]/255;
    % bolbColor=[35, 105, 255]/255;

    %The plot is approaching real scale
    axis_interval_ratio1=0.03;
    unitAntL1=ant_info_mean(1)*10;  %Maximum antennae length
    axis_interval1=ceil(unitAntL1*axis_interval_ratio1);
    antW1=ant_info_mean(2)/unitAntL1*antScaling_factor;
    antThickness1=antW1/(1/72*2.54); %convert antennae width to linewidth (1/72 inch = 1pt)
    antW_addSD1=(ant_info_mean(2)+ant_info_std(2))/unitAntL1*antScaling_factor;
    antThickness_addSD1=antW_addSD1/(1/72*2.54); %convert antennae width to linewidth (1/72 inch = 1pt)
    scaleBarAntL=1/unitAntL1*antScaling_factor;

     [antennaC, antennaC_addSD, ~, bolbC, bolbC_addSD, ~, antTip] = generateAntennaPlotData(ant_info_mean, ant_info_std, unitAntL1, antScaling_factor);
     allAntPts0=[antennaC; antennaC_addSD; bolbC_addSD];
     scaleBarAnt=[[ceil(min( allAntPts0(:,1))/axis_interval1)*axis_interval1+2, 0.5]; [ceil(min( allAntPts0(:,1))/axis_interval1)*axis_interval1+2+scaleBarAntL, 0.5]]; %The position of scale bar
     allAntPts=[antennaC; antennaC_addSD; bolbC; bolbC_addSD; scaleBarAnt];
    antvisoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_antenna_morph_spn-',num2str(sampleN),'_n-',num2str(nnz([ant_d_filter,ant_v_filter]==0)),'_summary.',imgformat]);
    figinsp=figure('visible', 'off');
    plot (antennaC(:,1), antennaC(:,2), 'Color',barColorSD, 'LineWidth', antThickness_addSD1);
    hold on;
    plot (antennaC(:,1), antennaC(:,2), 'Color',barColor, 'LineWidth', antThickness1);
    plot (antennaC_addSD(:,1), antennaC_addSD(:,2),'Color',barColor, 'LineStyle', '-', 'LineWidth',0.5);
    plot (bolbC(:,1), bolbC(:,2));
    fill(bolbC(:,1), bolbC(:,2),bolbColor, 'LineStyle','none')
    plot (bolbC_addSD(:,1), bolbC_addSD(:,2),'Color',bolbColor, 'LineStyle', '-', 'LineWidth',0.5);
    plot (scaleBarAnt(:,1), scaleBarAnt(:,2),'Color','k', 'LineStyle', '-', 'LineWidth',1);
    axis equal;
    axis([floor(min( allAntPts(:,1))/axis_interval1)*axis_interval1, ceil(max(allAntPts(:,1))/axis_interval1)*axis_interval1, 0, ceil(max( allAntPts(:,2))/axis_interval1)*axis_interval1]);             % Set Axis Limits
    set(gca,'XColor','none','YColor','none','TickDir','out')
    export_fig(figinsp,antvisoutname, ['-',imgformat],['-r',num2str(imgresolution)],'-transparent');
    close(figinsp);
    disp(['saving [', groupName,'_antenna_morph_spn-',num2str(sampleN),'_n-',num2str(nnz([ant_d_filter,ant_v_filter]==0)),'_summary.',imgformat,']']);

    %The plot is rescaled; in order to amplify the curveture
    axis_interval_ratio=0.03;
    unitAntL=ant_info_mean(1);  %Maximum antennae length
    axis_interval=ceil(unitAntL*axis_interval_ratio);
    antW=ant_info_mean(2)/unitAntL*antScaling_factor;
    antThickness2=antW/(1/72*2.54); %convert antennae width to linewidth (1/72 inch = 1pt)
    antW_addSD2=(ant_info_mean(2)+ant_info_std(2))/unitAntL*antScaling_factor;
    antThickness_addSD2=antW_addSD2/(1/72*2.54); %convert antennae width to linewidth (1/72 inch = 1pt)
    scaleBarAntL2=1/unitAntL*antScaling_factor;

     [antennaC2, antennaC_addSD2, antennaC_minusSD2, bolbC2, bolbC_addSD2, bolbC_minusSD2, antTip2] = generateAntennaPlotData(ant_info_mean, ant_info_std, unitAntL, antScaling_factor);
     scaleBarAnt2=[[round(antScaling_factor-axis_interval-antW_addSD2-10), 0.5]; [round(antScaling_factor-axis_interval-antW_addSD2-10)+scaleBarAntL2, 0.5]]; %The position of scale bar

    allAntPts2=[antennaC2; antennaC_addSD2; antennaC_minusSD2; bolbC2; bolbC_addSD2;  scaleBarAnt2];
    antvisoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName, '_antenna_morph_spn-',num2str(sampleN),'_n-',num2str(nnz([ant_d_filter,ant_v_filter]==0)),'_summary-rescale.',imgformat]);
    figinsp=figure('visible', 'off');
    plot (antennaC2(:,1), antennaC2(:,2), 'Color',barColorSD, 'LineWidth', antThickness_addSD2*0.15);
    hold on;
    plot (antennaC2(:,1), antennaC2(:,2), 'Color',barColor, 'LineWidth', antThickness2*0.15);
    plot (antennaC_addSD2(:,1), antennaC_addSD2(:,2),'Color',bolbColor, 'LineStyle', '- -', 'LineWidth',0.5);
    plot (antennaC_minusSD2(:,1), antennaC_minusSD2(:,2),'Color',bolbColor, 'LineStyle', '- -', 'LineWidth',0.5);
    plot (antennaC2(:,1), antennaC2(:,2), 'Color', bolbColor, 'LineWidth', 0.5);
    plot (bolbC_addSD2(:,1), bolbC_addSD2(:,2),'Color',bolbColor, 'LineStyle', '-', 'LineWidth',0.5);
    plot (bolbC2(:,1), bolbC2(:,2));
    fill(bolbC2(:,1), bolbC2(:,2),bolbColor, 'LineStyle','none')
    plot (scaleBarAnt2(:,1), scaleBarAnt2(:,2),'Color','k', 'LineStyle', '-', 'LineWidth',1);
    axis equal;
    axis([0, ceil(max(allAntPts2(:,1))/axis_interval)*axis_interval+10, floor(min(allAntPts2(:,2))/axis_interval)*axis_interval, ceil(max(allAntPts2(:,2))/axis_interval)*axis_interval+10]);             % Set Axis Limits
    set(gca,'XColor','none','YColor','none','TickDir','out')
    export_fig(figinsp,antvisoutname, ['-',imgformat],['-r',num2str(imgresolution)],'-transparent');
    close(figinsp);
    disp(['saving [', groupName,'_antenna_morph_spn-',num2str(sampleN),'_n-',num2str(nnz([ant_d_filter,ant_v_filter]==0)),'_summary-rescale.',imgformat,']']);
end
%Save antenna mean
antvisoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName,'_antenna_AllSideBand_res-',num2str(antRes),'_spn-',num2str(sampleN),'_antDn-',num2str(nnz(ant_d_filter==0)),'_antVn-',num2str(nnz(ant_v_filter==0)),'_avg_rescale.',imgformat]);
figinsp=figure('visible', 'off');
imshow(antImg_mean);hold on;
plot([0, antImgSize(2)],[0+3*avgBarWidth, 0+3*avgBarWidth],'black', 'LineWidth',2);
plot([0, antImgSize(2)],[2*antImgSize(1)+3*avgBarWidth, 2*antImgSize(1)+3*avgBarWidth],'black', 'LineWidth',2);
if antFlag_d==1
    plot([0, antImgSize(2)],[0+avgBarWidth,antImgSize(1)+avgBarWidth],'white');
end
if antFlag_v==1
    plot([0, antImgSize(2)],[antImgSize(1)+avgBarWidth, 2*antImgSize(1)+avgBarWidth ],'white');
end
export_fig(figinsp,antvisoutname, ['-',imgformat],['-r',num2str(imgresolution)],'-transparent');
close(figinsp);
disp(['saving [', groupName,'_antenna_AllSideBand_res-',num2str(antRes),'_spn-',num2str(sampleN),'_antDn-',num2str(nnz(ant_d_filter==0)),'_antVn-',num2str(nnz(ant_v_filter==0)),'_avg_rescale.',imgformat,']']);

%Save antenna std
antvisoutname=fullfile(Result_directory,'dorsal_ventral_map',subFolderList{1},[groupName,'_antenna_AllSideBand_res-',num2str(antRes),'_spn-',num2str(sampleN),'_antDn-',num2str(nnz(ant_d_filter==0)),'_antVn-',num2str(nnz(ant_v_filter==0)),'_std_rescale.',imgformat]);
figinsp=figure('visible', 'off');
imshow(antImg_std);hold on;
plot([0, antImgSize(2)],[0+3*avgBarWidth, 0+3*avgBarWidth],'black', 'LineWidth',2);
plot([0, antImgSize(2)],[2*antImgSize(1)+3*avgBarWidth, 2*antImgSize(1)+3*avgBarWidth],'black', 'LineWidth',2);
if antFlag_d==1
    plot([0, antImgSize(2)],[0+avgBarWidth,antImgSize(1)+avgBarWidth ],'white');
end
if antFlag_v==1
    plot([0, antImgSize(2)],[antImgSize(1)+avgBarWidth, 2*antImgSize(1)+avgBarWidth ],'white');
end
export_fig(figinsp,antvisoutname, ['-',imgformat],['-r',num2str(imgresolution)],'-transparent');
close(figinsp);
disp(['saving [', groupName,'_antenna_AllSideBand_res-',num2str(antRes),'_spn-',num2str(sampleN),'_antDn-',num2str(nnz(ant_d_filter==0)),'_antVn-',num2str(nnz(ant_v_filter==0)),'_std_rescale.',imgformat,']']);

disp('all antenna summary imgs are saved');
end