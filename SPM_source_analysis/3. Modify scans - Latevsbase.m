load job.mat
P = matlabbatch{1,1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans;
Q = {
'H:\PET study\EEG session\mspm_P1__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P1__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P1__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P1__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P2__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P2__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P2__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P2__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P5__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P5__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P5__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P5__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P6__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P6__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P6__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P6__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P7__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P7__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P7__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P7__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P8__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P8__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P8__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P8__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P15__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P15__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P15__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P15__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_P16__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_P16__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_P16__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_P16__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S1__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S1__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S1__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S1__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S2__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S2__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S2__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S2__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S3__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S3__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S3__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S3__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S5__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S5__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S5__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S5__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S6__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S6__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S6__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S6__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S8__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S8__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S8__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S8__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S9__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S9__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S9__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S9__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S10__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S10__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S10__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S10__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S11__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S11__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S11__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S11__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S18__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S18__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S18__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S18__LEP_7_2.nii'
'H:\PET study\EEG session\mspm_S20__LEP_3_1.nii'
'H:\PET study\EEG session\mspm_S20__LEP_3_2.nii'
'H:\PET study\EEG session\mspm_S20__LEP_6_1.nii'
'H:\PET study\EEG session\mspm_S20__LEP_7_2.nii'
};
matlabbatch{1,1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans = Q;
save job.mat matlabbatch