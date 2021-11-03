function [reconstructPts,shpIDr, scaling_factor_list,specimens_included]=cal_mean_shp2(in_shapes,nHarmonic,ConfIntervalKeep)
refID=find(cell2mat(cellfun(@(x)size(x,1)>2, in_shapes, 'UniformOutput', false)),1); %Reference img used for registration (find the first non NaN cell)

fft_coefficient_matrix=zeros(4,nHarmonic,1);
scaling_factor_list=zeros(size(in_shapes,1),1); 
specimens_included=zeros(size(in_shapes,1),1)+1; 
refImgPt=in_shapes{refID};
if min(refImgPt(:,1))<0 %prevent the reference image is right wing
    refImgPt=[refImgPt(:,1)-floor(min(refImgPt(:,1))/30)*30+50, refImgPt(:,2)];
end

if ~iscell(in_shapes)
    shpN=1;
else
    shpN=length(in_shapes);
end

fftdatID=1;
for shpID=1:shpN
    movEdgePt=in_shapes{shpID};
%     figure,plot(movEdgePt(:,1),movEdgePt(:,2),'rx'); daspect([1 1 1]);
%     figure,plot(movEdgePt(1:5,1),movEdgePt(1:5,2),'rx'); daspect([1 1 1]);
    if ~isnan(movEdgePt)
        [degreeIndex,Z, transform] = procrustes(refImgPt,movEdgePt,'reflection',false);

        T = transform.T;
        b = transform.b;
        c = repelem(transform.c(1,:),length(movEdgePt),1);
        

        if T(1,1)<0.71 %Constrain the rotating angle between -45d and 45d
            T=[[1,0];[0,1]]; %Don't rotate
            disp(['shpID: ',num2str(shpID),'rotating angle over the threshold, so it is not rotated']);
        end

        newMovEdgePtReScale=double(b*movEdgePt*T + c);
        
        nWingMaskReScale = poly2mask(newMovEdgePtReScale(:,1),newMovEdgePtReScale(:,2),round(max(refImgPt(:,2))*1.2),round(max(refImgPt(:,1))*1.2));
        %figure,imshow(nWingMaskReScale);
        scaling_factor_list(shpID)=b; 

        try
            wingreduce=nWingMaskReScale;
            %make a fully closed shape
            chain = mk_chain(flip(wingreduce)); %Flip the mask to counter the flipping effect in the following process

            [chainCode] = chaincode(chain); %Derive the chain code of the shape
            maskChainCode=transpose(chainCode.code);

              for i = 1 : nHarmonic
                    harmonic_coeff = calc_harmonic_coefficients(maskChainCode, i);
                    ca(i) = harmonic_coeff(1, 1);
                    cb(i) = harmonic_coeff(1, 2);
                    cc(i) = harmonic_coeff(1, 3);
                    cd(i) = harmonic_coeff(1, 4);
              end
            fft_coeffcient=[ca ; cb ; cc ; cd];
            fft_coefficient_matrix(:,:,fftdatID)=fft_coeffcient;
            fftdatID=fftdatID+1;
        catch
            disp(['shpID: ',num2str(shpID),' went wrong, so it is neglected'])
            specimens_included(shpID)=0;
        end
    else
        disp(['shpID: ',num2str(shpID),' is not on the preference list, so it is neglected'])
        scaling_factor_list(shpID)=NaN;
    end
end

fft_coefficient_mean=trimmean(fft_coefficient_matrix,100-ConfIntervalKeep,3); %Exclude the outliers and keep only %80.
shpIDr=1;
while 1
    try
        reconstructPts = fourier_approx_by_coefficient(in_shapes{shpIDr}, fft_coefficient_mean,100);
        if size(reconstructPts,1)>50
            break
        end
    catch
        shpIDr=shpIDr+1;
    end
    if shpIDr>shpN
        try
            reconstructPts = fourier_approx_by_coefficient(refImgPt, fft_coefficient_mean,100);
            shpIDr=refID;
            break
        catch
            break
        end
    end
end
%     %Plot on the shape without ornament
%     figure, plot(reconstructPts(:,1), -reconstructPts(:,2), 'r','LineWidth',2);

end