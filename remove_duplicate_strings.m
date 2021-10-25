function out_string_List=remove_duplicate_strings(in_string_list)
    [~,Xin,Zin] = unique(in_string_list,'stable');
    Yin = histc(Zin,1:numel(Xin))<2;
    out_string_List=in_string_list(Xin(Yin));
end