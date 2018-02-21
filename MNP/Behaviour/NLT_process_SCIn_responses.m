clear all
dbstop if error % optional instruction to stop at a breakpoint if there is an error - useful for debugging

%% 1. ADD FUNCTIONS/TOOLBOXES TO MATLAB PATH
paths = {'C:\Data\Matlab\Matlab_files\MNP'};
subpaths = [1]; % add subdirectories too?

for p = 1:length(paths)
    if subpaths(p)
        addpath(genpath(paths{p}));
    else
        addpath(paths{p});
    end
end

%% 2. FOLDER AND FILENAME DEFINITIONS

% FILE NAMING
% Name the input files as <study name>_<participant ID>_<sessions name_<block name>_<condition name>
% For example: EEGstudy_P1_S1_B1_C1.mat
% Any of the elements can be left out. But all must be separated by underscores.
clear S
S.rawpath = 'C:\Data\MNP\Pilots\NLT\raw'; % unprocessed data in original format
S.anapath = 'C:\Data\MNP\Pilots\NLT\processed'; % folder to save processed .set data
S.fnameparts = {'subject','block','',''}; % parts of the input filename separated by underscores, e.g.: {'study','subject','session','block','cond'};
S.subjects = {}; % either a single subject, or leave blank to process all subjects in folder
S.sessions = {};
S.blocks = {'Sequence_NLT_OptionNLT_classical_adaptive'}; % blocks to load (each a separate file) - empty means all of them, or not defined
S.conds = {}; % conditions to load (each a separate file) - empty means all of them, or not defined
S.datfile = 'C:\Data\MNP\Pilots\NLT\Participant_Data.xlsx'; % .xlsx file to group participants; contains columns named 'Subject', 'Group', and any covariates of interest
save(fullfile(S.anapath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 3. DATA IMPORT, REFORMAT

% SETTINGS
S.loadext = 'mat'; 
S.loadprefixes = {'Output','Sequence'};
S.saveprefix = ''; % prefix to add to output file, if needed
S.savesuffix = ''; % suffix to add to output file, if needed
% RUN
[S,D]=SCIn_data_import(S);
save(fullfile(S.anapath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable
save(fullfile(S.anapath,'D'),'D'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 4. PROCESSING
% SET PROCESSING OPTIONS
S.accuracy.on = 1;
S.accuracy.buttons = {'LeftArrow','RightArrow'};
S.accuracy.signal = [1 2];
S.RT = 1;
% RUN
[S,D]=SCIn_data_process(S,D);
save(fullfile(S.anapath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable
save(fullfile(S.anapath,'D'),'D'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%5. PLOT
close all
for d = 1:length(D)
    figure
    bar(D(d).Processed.condcorrectfract)
    ylabel('fraction correct')
    xlabel('condition')
    labels = {'adaptive: low','adaptive: high','low prob: low','low prob: high','equal prob: low','equal prob: high','high prob: low','high prob: high',};
    set(gca,'xticklabel', labels) 
    title(D(d).subname)
    hold on
    plot(xlim,[0.5 0.5], 'k--')
end