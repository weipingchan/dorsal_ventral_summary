%%
%Basic required information
grid_mat_directory='...\tribal_level_dorsal-ventral_wing_parameters';
group_list_name='specimen_groups_group_barcode_list.json';
preference_list_name='morphology_analysis_spp_preference_table.csv';
Code_directory='...';
Result_directory='...';

%%
%Run all listed groups
addpath(genpath(Code_directory)) %Add the library to the path
dorsal_ventral_summary(grid_mat_directory, Code_directory, Result_directory, group_list_name, preference_list_name)

%%
%To run a specific group by its group number
fieldID = 6;
%%%%%%%Provide the group name that is listed in the json group file%%%%%%%
%Create result folders
subFolderList={'summary_visualization','summary_matrices'};
for fold=1:length(subFolderList)
    if ~exist(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}), 'dir')
        mkdir(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}));
    end
    disp(['corresponding folder ', subFolderList{fold}, ' is created / found.']);
end

labelfile=readtable(fullfile(Code_directory,preference_list_name));
disp('The file with preference information is found.');

group_list=loadjson(fullfile(Code_directory,group_list_name));
group_list_field=fieldnames(group_list);

group_barcodes=remove_duplicate_strings(group_list.(group_list_field{fieldID})); %Removing duplicates
groupName=strrep(group_list_field{fieldID},'0x2D_','');
    try
        grid_summary2(grid_mat_directory, Result_directory, subFolderList, groupName, group_barcodes, labelfile);
    catch
        disp(['[ ',groupName,' ] did NOT process successfully.']);
    end

%%
%To run a specific group by its group name
groupName='NymPap';
%%%%%%%Provide the group name that is listed in the json group file%%%%%%%
%Create result folders
subFolderList={'summary_visualization','summary_matrices'};
for fold=1:length(subFolderList)
    if ~exist(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}), 'dir')
        mkdir(fullfile(Result_directory,'dorsal_ventral_map',subFolderList{fold}));
    end
    disp(['corresponding folder ', subFolderList{fold}, ' is created / found.']);
end

labelfile=readtable(fullfile(Code_directory,preference_list_name));
disp('The file with preference information is found.');

group_list=loadjson(fullfile(Code_directory,group_list_name));
group_list_field=fieldnames(group_list);

fieldID=find(strcmp(group_list_field,groupName));
group_barcodes=remove_duplicate_strings(group_list.(group_list_field{fieldID})); %Removing duplicates
groupName=strrep(group_list_field{fieldID},'0x2D_','');
grid_summary2(grid_mat_directory, Result_directory, subFolderList, groupName, group_barcodes, labelfile);

