function antennaC=generateCirclePlot(rr, rad, radint)
    antennaC=[];
    radID=0;
     while radID<rad
        antennaC = [antennaC; [rr*cos(radID), rr*sin(radID)]] ;
        radID= radID + radint;
     end
end