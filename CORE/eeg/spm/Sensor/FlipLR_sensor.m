clear all

restoredefaultpath
run('C:\Data\Matlab\Matlab_files\CORE\CORE_addpaths')
%% SPECIFY DATA
filepath = 'C:\Data\CORE\EEG\ana\spm\SPMdata\sensorimages'; 

% prefix, middle part, or suffix of files to load (or leave empty) to select a subset of folders
%fpref = 't-200_899_b-200_0_mspm12';
%fpref = 't-200_899_b-200_0_mspm12_fnums';
fpref = 't-200_299_b-200_0_mspm12_fnums';
fmid = '';
%fsuff = '_4_cleaned_tm';
%fsuff = '_2_merged_cleaned';
fsuff = '_4_merged_cleaned'; % fnum

% conditions to flip (right stim only):
%fcond = [5:8 13:16 21:24]; % part4
fcond = [5:8]; % part4 fnum
%fcond = [3 4 7 8 11 12]; % part2

%% RUN
fname=[fpref '*' fmid  '*' fsuff];
fname=strrep(fname,'**','*');
files = dir(fullfile(filepath,fname));

for f = 1:length(files)
    fname = files(f).name;
 
    % re-orient the images
    for nf = fcond
        inputname = fullfile(filepath,files(f).name,['scondition_' num2str(nf) '.nii']);
        nii=load_nii(inputname);
        
        %flip LR
        M = diag(nii.hdr.dime.pixdim(2:5));
        M(1:3,4) = -M(1:3,1:3)*(nii.hdr.hist.originator(1:3)-1)';
        M(1,:) = -1*M(1,:);
        nii.hdr.hist.sform_code = 1;
        nii.hdr.hist.srow_x = M(1,:);
        nii.hdr.hist.srow_y = M(2,:);
        nii.hdr.hist.srow_z = M(3,:);
        
        sname=fullfile(filepath,files(f).name,['scondition_' num2str(nf) '_flip.nii']);
        save_nii(nii,sname); 
        spm_imcalc_ui({inputname;sname},sname,'(i1+i2)-i1'); %re-orients image for SPM analysis
        
    end
end
