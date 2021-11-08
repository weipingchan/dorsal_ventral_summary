function [tarXbin,binA]=binAvg(vx,vy)
    vv=[vx,vy];
    tarXbin=[floor(min(vx)) :1: ceil(max(vx)) ];
    
    m1=(vv(2,2)-vv(1,2))/(vv(2,1)-vv(1,1));
    m2=(vv(3,2)-vv(2,2))/(vv(3,1)-vv(2,1));

    binA=zeros(0,length(tarXbin)-1);
    for binID=1:length(tarXbin)-1
        tarX1=tarXbin(binID);
        if tarX1<vx(1) tarX1=vx(1);, end;
        
        tarX2=tarXbin(binID+1);
        if tarX2>vx(3) tarX2=vx(3);, end;
        
        if tarX2<vx(2) %Both value less than the tip pt
            tarY1=m1*( tarX1-vv(1,1))+vv(1,2);
            tarY2=m1*( tarX2-vv(1,1))+vv(1,2);
            
            tarA=(tarY1+tarY2)*abs(tarX2-tarX1)/2;
        elseif tarX1>vx(2) %Both values greater than the tip pt
            tarY1=m2*( tarX1-vv(2,1))+vv(2,2);
            tarY2=m2*( tarX2-vv(2,1))+vv(2,2);
            
            tarA=(tarY1+tarY2)*abs(tarX2-tarX1)/2;
        else %Values on both sides of the tip pt
            tarY1=m1*( tarX1-vv(1,1))+vv(1,2);
            tarY2=m2*( tarX2-vv(2,1))+vv(2,2);
            
            if vy(2)>tarY1
                tarA=abs(tarX2-tarX1)*vy(2)-abs(vx(2)-tarX1)*abs(vy(2)-tarY1)/2-abs(tarX2-vx(2))*abs(vy(2)-tarY2)/2;
            else
                tarA=abs(tarX2-tarX1)*vy(2)+abs(vx(2)-tarX1)*abs(vy(2)-tarY1)/2+abs(tarX2-vx(2))*abs(vy(2)-tarY2)/2;
            end
        end
        binA(binID)=tarA;
    end
end