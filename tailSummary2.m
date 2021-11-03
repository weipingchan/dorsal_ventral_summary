function [tarXbin, binA]=tailSummary2(tailBase0,keyPar,baseVal, mat_res)
    tailBase1=tailBase0(tailBase0(:,2)<=1 | tailBase0(:,1)>=mat_res+1,:); %filter tails in wired region
    tailFlag=0;
    if size(tailBase1,1)==1
        if tailBase1(1)==mat_res+1
            tailBase=[[tailBase1(1), mat_res+1-0.001] ; [tailBase1(1), (tailBase1(2)+mat_res+1)/2] ; tailBase1];
        else
            tailBase=[[1.001, tailBase1(2)] ; [(tailBase1(1)+1)/2, tailBase1(2)] ; tailBase1];
        end
    elseif size(tailBase1,1)==2
        if round(tailBase1(1,1),4)==round(tailBase1(2,1),4) || round(tailBase1(1,2),4)==round(tailBase1(2,2),4)
            fakeMid=mean(tailBase1);
        else
            cornerPt=[mat_res+1,1];
            tailBase2=sortrows(tailBase1);
            dist=sqrt((tailBase2(:,1)-cornerPt(1)).^2 + (tailBase2(:,2)-cornerPt(2)).^2);
            if mean(dist)<dist(1)
                fakeMid=tailBase2(1,:) + [mean(dist), 0];
            else
                fakeMid=tailBase2(2,:) + [0, -mean(dist)];
            end
        end
        tailBase=[tailBase1 ; fakeMid ];
    elseif size(tailBase1,1)==3
        tailBase=tailBase1;
    else
        tailFlag=1;
    end
    
    if tailFlag<1
        if round(std(tailBase(:,1)),4) ==0 %At the bottom
            vx=sort(tailBase(:,2));
            vy=[baseVal; keyPar; baseVal];
            [tarXbin0,binA]=binAvg(vx,vy);
            tarXbin=[zeros(1,length(tarXbin0))+tailBase(1,1);tarXbin0]';
        elseif round(std(tailBase(:,2)),4) ==0  %At the side
            vx=sort(tailBase(:,1));
            vy=[baseVal; keyPar; baseVal];
            [tarXbin0,binA]=binAvg(vx,vy);
            tarXbin=[tarXbin0; zeros(1,length(tarXbin0))+tailBase(1,2)]';
        else %Cross the corner
            vx0=sortrows(tailBase,1);
            if round(vx0(1,2),4)==round(vx0(2,2),4) %2 pt in the same column
                vx=[vx0(1:2,1);[vx0(3,1)+vx0(3,2)-1]];
                vy=[baseVal; keyPar; baseVal];
                [tarXbin0,binA]=binAvg(vx,vy);
                tarXbin1=[tarXbin0; zeros(1,length(tarXbin0))+vx0(1,2)]';

                tarXbin=zeros(length(tarXbin1),2);
                for tarbinID=1:length(tarXbin1)
                    if tarXbin1(tarbinID,1)>vx0(3,1)
                        tarXbin(tarbinID,:)=[vx0(3,1),tarXbin1(tarbinID,1)-vx0(3,1)+1];
                    else
                        tarXbin(tarbinID,:)=tarXbin1(tarbinID,:);
                    end
                end
            else %2 pts in the same row
                vx=[[1-(vx0(2,1)-vx0(1,1))] ; vx0(2:3,2)];
                vy=[baseVal; keyPar; baseVal];
                [tarXbin0,binA]=binAvg(vx,vy);
                tarXbin1=[zeros(1,length(tarXbin0))+vx0(3,1) ; tarXbin0]';

                tarXbin=zeros(length(tarXbin1),2);
                for tarbinID=1:length(tarXbin1)
                    if tarXbin1(tarbinID,2)<1
                        tarXbin(tarbinID,:)=[vx0(2,1)-(1-tarXbin1(tarbinID,2)),vx0(1,2)];
                    else
                        tarXbin(tarbinID,:)=tarXbin1(tarbinID,:);
                    end
                end
            end
        end
    else
        tarXbin=[];
        binA=[];
    end
end