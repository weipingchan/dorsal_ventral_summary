function antennaC=generateCirclePlot(rr, rad, radint)
%     rr=antennaC/2;
    antennaC=[];
%     radint=0.001;
    radID=0;
     while radID<rad
        antennaC = [antennaC; [rr*cos(radID), rr*sin(radID)]] ;
        radID= radID + radint;
     end
end