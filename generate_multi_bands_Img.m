function bandsImg=generate_multi_bands_Img(sidesAllBand_dorsal, sidesAllBand_ventral, target_band_list, reScaleOrNot, avgBarWidth)
     bandsImg0=[];
    barImg=[];
    for bandID2=1:length(target_band_list)
        bandID=target_band_list(bandID2);
        fd=sidesAllBand_dorsal{1}{bandID};
        fv=sidesAllBand_ventral{1}{bandID};
        hd=sidesAllBand_dorsal{2}{bandID};
        hv=sidesAllBand_ventral{2}{bandID};

        bandImg=cat(1,fd,fv,hd,hv);

        if reScaleOrNot==1
            if size(bandImg,3)>1
                bandsRGB=cat(2,imadjust(bandImg(:,:,3)),imadjust(bandImg(:,:,2)),imadjust(bandImg(:,:,1)));
                bandsRGBnan=cat(2,bandImg(:,:,3),bandImg(:,:,2),bandImg(:,:,1));
                bandsRGB(isnan(bandsRGBnan))=NaN;
                avgBarR=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,1), 'all');
                avgBarG=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,2), 'all');
                avgBarB=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,3), 'all');
                avgBar=cat(2, avgBarB, avgBarG, avgBarR);
                bandsImg0=cat(2,bandsImg0, bandsRGB);
                barImg=cat(2, barImg, avgBar);
            else
                bandsGray=imadjust(bandImg);
                bandsGraynan=bandImg;
                bandsGray(isnan(bandsGraynan))=NaN;
                avgBar=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg, 'all');
                bandsImg0=cat(2,bandsImg0, bandsGray);
                barImg=cat(2, barImg, avgBar);
            end
        else
            if size(bandImg,3)>1
                avgBarR=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,1), 'all');
                avgBarG=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,2), 'all');
                avgBarB=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg(:,:,3), 'all');
                avgBar=cat(2, avgBarB, avgBarG, avgBarR);
                bandsImg0=cat(2,bandsImg0, bandImg(:,:,3),bandImg(:,:,2),bandImg(:,:,1));
                barImg=cat(2, barImg, avgBar);
            else
                avgBar=zeros(avgBarWidth,size(bandImg,2))+nanmean(bandImg, 'all');
                bandsImg0=cat(2,bandsImg0, bandImg);
                barImg=cat(2, barImg, avgBar);
            end
        end
    end
    
    if reScaleOrNot==1
        bandsImg=cat(1, bandsImg0, imadjust(barImg));
    else
        bandsImg=cat(1, bandsImg0, barImg);
    end
end