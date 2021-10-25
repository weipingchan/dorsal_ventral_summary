function [antennaC, antennaC_addSD, antennaC_minusSD, bolbC, bolbC_addSD, bolbC_minusSD, antTip] = generateAntennaPlotData(ant_info_mean, ant_info_std, unitAntL, antScaling_factor)
%Here the approach is try to scale the curveness as the length of radius
%rater than showing a curve haing exact the same curveness as the input
%cuveness because the second method will limit the curveness between
%[0 pi]; (value pi happens when the circle is half)
    antL=ant_info_mean(1)/unitAntL*antScaling_factor;
    antC=1/ant_info_mean(4)*antScaling_factor;
    rad=2*pi*antL/(antC*pi);

    %Equation of  a circle with centre (a,b) is (x-a)^2+ (y-b)^2 = r^2
    %Circle Centre (1,1), radius = 10
    radint=0.001;
    antennaC=generateCirclePlot(antC/2, rad, radint);
    antennaC=antennaC+[antScaling_factor-antC/2, 0];
    
    antTip=[antC/2*cos(rad), antC/2*sin(rad)]+[antScaling_factor-antC/2, 0];
    
    bolbW=ant_info_mean(3)/unitAntL*antScaling_factor;
    bolbC=generateCirclePlot(bolbW/2, 2*pi, radint);
    bolbC=bolbC+antTip;
    
    bolbW_addSD=(ant_info_mean(3)+ant_info_std(3))/unitAntL*antScaling_factor;
    bolbC_addSD=generateCirclePlot(bolbW_addSD/2, 2*pi, radint);
    bolbC_addSD=bolbC_addSD+antTip;
    
    bolbW_minusSD=(ant_info_mean(3)-ant_info_std(3))/unitAntL*antScaling_factor;
    bolbC_minusSD=generateCirclePlot(bolbW_minusSD/2, 2*pi, radint);
    bolbC_minusSD=bolbC_addSD+antTip;
    
    %prepare dataplot for lower and upper bound
    antL2=(ant_info_mean(1)+ant_info_std(1))/unitAntL*antScaling_factor;
    antC2=1/(ant_info_mean(4)+ant_info_std(4))*antScaling_factor;
    rad2=2*pi*antL2/(antC2*pi);
    antennaC_addSD=generateCirclePlot(antC2/2, rad2, radint);
    antennaC_addSD=antennaC_addSD+[antScaling_factor-antC2/2, 0];
    
    antL2=(ant_info_mean(1)-ant_info_std(1))/unitAntL*antScaling_factor;
    antC2=1/(ant_info_mean(4)-ant_info_std(4))*antScaling_factor;
    rad2=2*pi*antL2/(antC2*pi);
    antennaC_minusSD=generateCirclePlot(antC2/2, rad2, radint);
    if ~isempty(antennaC_minusSD) %mean-sd can result in zero radius
        antennaC_minusSD=antennaC_minusSD+[antScaling_factor-antC2/2, 0];
    else
        antennaC_minusSD=[antScaling_factor-antC2/2, 0];
    end
end