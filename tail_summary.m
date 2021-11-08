function [tail_dat_spp, tail_dat_L, tail_dat_R]=tail_summary(sppmat, spp_tail_preference_list)
    tail_dat_spp=cell(0,1);
    tail_dat_L=cell(0,1);
    tail_dat_R=cell(0,1);
    taildatIDL=1;
    taildatIDR=1;
    for tailID=1:4
        tailFlag=0;
        tailDat=sppmat{5}{tailID};
        tailDat=tailDat(~cellfun('isempty',tailDat));
        if ~isempty(tailDat) && spp_tail_preference_list(tailID)==1 %if the hindwing is accepted in the preference list
            if iscell(tailDat{1})
                tmp_tail_dat=cell(0,1);
                for tailPartID=1:length(tailDat)
                    tailBase=tailDat{tailPartID}{3};
                    tailTailChar=tailDat{tailPartID}{4};
                    tmp_tail_dat{tailPartID}={tailBase,tailTailChar};
                end
                if tailID<=2
                    tail_dat_L{taildatIDL}=tmp_tail_dat;
                    taildatIDL=taildatIDL+1;
                else
                    tail_dat_R{taildatIDR}=tmp_tail_dat;
                    taildatIDR=taildatIDR+1;
                end
                tail_dat_spp{tailID}=tmp_tail_dat;
            else
                tailFlag=1;
            end
        else
            tailFlag=1;
        end
        
        if tailFlag==1
            if tailID<=2
                tail_dat_L{taildatIDL}={};
                taildatIDL=taildatIDL+1;
            else
                tail_dat_R{taildatIDR}={};
                taildatIDR=taildatIDR+1;
            end
            tail_dat_spp{tailID}={};
        end
    end
end