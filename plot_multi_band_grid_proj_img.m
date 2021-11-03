function plot_multi_band_grid_proj_img(bandsImg,matix_basic_resolution,xbands_name,y_label,boldLineList)
imagesc_rmNaN(bandsImg);hold on;
axis on
set(gca, 'Color', [0, 0, 0]);
daspect([1 1 1]);
for ncol=1:size(bandsImg,2)/matix_basic_resolution-1
    linecor=[[ncol*matix_basic_resolution+0.5, 0] ; [ncol*matix_basic_resolution+0.5, size(bandsImg,1)]];
    if ismember(ncol,boldLineList)
        plot(linecor(:,1),linecor(:,2),'r','lineWidth',2);
    else
        plot(linecor(:,1),linecor(:,2),'k','lineWidth',1);
    end
end
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
xlabel(xbands_name); 
ylabel(y_label);
set(gcf,'units','points','position',[0,0,1080,500]);

function hout = imagesc_rmNaN(img_data)
% a wrapper for imagesc, with some formatting going on for nans
    % plotting data. Removing and scaling axes (this is for image plotting)
    hout = imagesc(img_data);

    % setting alpha values
    if ndims( img_data ) == 2
      set(hout, 'AlphaData', ~isnan(img_data))
    elseif ndims( img_data ) == 3
      set(hout, 'AlphaData', ~isnan(img_data(:, :, 1)))
    end

    if nargout < 1
      clear hout
    end
end
end