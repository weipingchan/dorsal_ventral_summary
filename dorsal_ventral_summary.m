function dorsal_ventral_summary(grid_mat_directory, Code_directory, Result_directory, group_list_name, preference_list_name)
%Convert double quotes to single quotes for the Matlab version prior to 2017
if size(grid_mat_directory,2)==1 grid_mat_directory=grid_mat_directory{1};, end;
if size(Code_directory,2)==1 Code_directory=Code_directory{1};, end;
if size(Result_directory,2)==1 Result_directory=Result_directory{1};, end;
if size(group_list_name,2)==1 group_list_name=group_list_name{1};, end;
if size(preference_list_name,2)==1 preference_list_name=preference_list_name{1};, end;

% Turn off this warning "Warning: Image is too big to fit on screen; displaying at 33% "
% To set the warning state, you must first know the message identifier for the one warning you want to enable. 
    warning('off', 'Images:initSize:adjustingMag');
    addpath(genpath(Code_directory)) %Add the library to the path

    subFolderList={'summary_visualization','summary_matrices'};
    for fold=1:length(subFolderList)
        if ~exist(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}), 'dir')
            mkdir(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}));
        end
        disp(['corresponding folder ', subFolderList{fold}, ' is created / found.']);
    end

    labelfile=readtable(fullfile(Code_directory,preference_list_name));
    disp('The file including preference information is found.');

    group_list=loadjson(fullfile(Code_directory,group_list_name));
    disp(['The file including barcodes in each group  [', group_list_name,'] is found.']);
    group_list_field=fieldnames(group_list);
    for fieldID=1:length(group_list_field)
    group_barcodes=remove_duplicate_strings(group_list.(group_list_field{fieldID})); %Removing duplicates
    groupName=strrep(group_list_field{fieldID},'0x2D_','');
        try
            grid_summary2(grid_mat_directory, Result_directory, subFolderList, groupName, group_barcodes, labelfile);
        catch
            disp(['[ ',groupName,' ] did NOT process sucessfully.']);
        end
    end
end