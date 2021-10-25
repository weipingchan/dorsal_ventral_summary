function plot_multi_band_grid_img(bandsImg,matix_basic_resolution,xbands_name,y_label,boldLineList)
%mat_res=32;
% xbands_name='UV ; B ; G ; R ; NIR ; fNIR ; fluor_B ; fluor_G ; fluor_R ; polDiff_B ; polDiff_G ; polDiff_R';
% yleft_label='Hind wing ; Fore wing';
% yright_label='Ventral ; Dorsal ; Ventral ; Dorsal';
% boldLineList=[1,4,5,6,9];
%ff=figure;
imagesc(bandsImg);hold on;
daspect([1 1 1]);
for ncol=1:size(bandsImg,2)/matix_basic_resolution-1
    linecor=[[ncol*matix_basic_resolution+0.5, 0] ; [ncol*matix_basic_resolution+0.5, size(bandsImg,1)]];
    if ismember(ncol,boldLineList)
        plot(linecor(:,1),linecor(:,2),'r','lineWidth',2);
    else
        plot(linecor(:,1),linecor(:,2),'k','lineWidth',1);
    end
end
for nrow=1:size(bandsImg,1)/matix_basic_resolution-1
    linecor=[[0, nrow*matix_basic_resolution+0.5] ; [size(bandsImg,2), nrow*matix_basic_resolution+0.5, ]];
    if nrow==2
        plot(linecor(:,1),linecor(:,2),'k','lineWidth',3);
    else
        plot(linecor(:,1),linecor(:,2),'k','lineWidth',2);
    end
end
%colormap(ff,jet);
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
xlabel(xbands_name); 
ylabel(y_label);
% yyaxis right
% set(gca,'ytick',[],'yticklabel',[]);
% ylabel(yright_label);
set(gcf,'units','points','position',[0,0,1080,500]);
end