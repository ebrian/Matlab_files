% Searchlight analysis
% RECOMMEND TO USE WITH NO MORE THAN 2-FOLD CROSS-VALIDATION FOR SPEED
clear all
dbstop if error
Din = 'C:\Data\PET-LEP\PET\pronto\_Scan_Subject\PET_prt_gpc_noperm';
anatype = 'group'; % options: group, subject
Din_sub = ''; % subject folder; leave blank if group analysis
%opt.searchtype = 'spacetime'; opt.R = 5;
%opt.searchtype = 'time'; opt.R = [inf inf 10];
opt.searchtype = '3Dspace'; opt.R = 10;
opt.parallel = 1;
opt.i_model = 1; % Model index to use
opt.loadF = 1; % load all features
opt.savImg = 1;
opt.permStat = 10; % permutations

switch anatype
    case 'group'
        %% RUN
        prt_in = fullfile(Din,'PRT.mat');
        [SLres,Pout,XYZ,D] = crc_parSL(prt_in,opt);
        % Results structure for classification & regression
        %   Classification:
        % stats.con_mat: Confusion matrix (nClasses x nClasses matrix, pred x true)
        % stats.acc:     Accuracy (scalar)
        % stats.b_acc:   Balanced accuracy (nClasses x 1 vector)
        % stats.c_acc:   Accuracy by class (nClasses x 1 vector)
        % stats.c_pv:    Predictive value for each class (nClasses x 1 vector)
        % stats.acc_lb:  \_ Lower/upper 5% confidence interval bounds for a
        % stats.acc_ub:  /  binomial distribution using Wilson's 'score interval'
        %
        %   Regression:
        % stats.mse:     Mean square error between test and prediction
        % stats.corr:    Correlation between test and prediction
        % stats.r2:      Squared correlation
        
        %% PLOT
        figure
        switch opt.searchtype
            case 'time'
                if ~exist('XYZ','var')
                    XYZ=XYZmm;
                end
                acc = [SLres(:).acc];
                acc_lb = [SLres(:).acc_lb];
                acc_ub = [SLres(:).acc_ub];
                plot(XYZ(3,:),acc(1:size(XYZ,2)),'k');hold on
                plot(XYZ(3,:),acc_lb(1:size(XYZ,2)),'--');
                plot(XYZ(3,:),acc_ub(1:size(XYZ,2)),'--');hold off
                title(['Searchlight over time'])
                xlabel('Time (ms)')
                ylabel('Accuracy')
            case '3Dspace'
                % TO DO,
                % - when the p-value is available, save it as an image too!
                % - maybe add other stuff to image or leave options
                if opt.savImg
                    switch D.PRTw.model(D.i_model).input.type
                        case 'classification'
                            % save acc/bacc/cacc only,
                            Pout = save_classif_images(D.Vmsk,D.pth,D.PRTw,SLres,D.DIM,D.nVx,D.i_model,D.R,D.lVx);
                        case 'regression'
                            % save mse, corr, r2
                            Pout = save_regression_images(D.Vmsk,D.pth,D.PRTw,SLres,D.DIM,D.nVx,D.i_model,D.R,D.lVx);
                        otherwise
                            fprintf('\nUnknown model type!\n')
                            Pout{1} = [];
                    end
                end

                %if ploton
                %    acc = [SLres(:).acc];
                %    acc_lb = [SLres(:).acc_lb];
                %    acc_ub = [SLres(:).acc_ub];
                %    plot(XYZ(3,:),acc); hold on
                %    plot(XYZ(3,:),acc_lb,'--')
                %    plot(XYZ(3,:),acc_ub,'--')
                %    hold off
                %end
        end

    case 'subject'
        %% RUN
        subdir = dir(fullfile(Din,Din_sub));
        dirFlags = [subdir.isdir];
        subdir = subdir(dirFlags);
        for s = 1:length(subdir)
            Sub_in = fullfile(Din,subdir(s).name,'PRT.mat');
            [SLres{s},Pout{s},XYZ] = crc_parSL(Sub_in,opt);
        end

        %% Group info
        load(fullfile(Din,'sub_info.mat'))
        grp=[];
        for g = 1:length(SubInd)
            grp = [grp g*ones(1,length(SubInd{g}))];
        end

        %% PLOT
        figure
        hold on
        cols={'r','b'};
        for s = 1:length(SLres)
            acc(:,s) = [SLres{s}(:).acc];
            col=cols{grp(s)};
            plot(XYZ(3,:),acc(1:size(XYZ,2),s),col); 
            acc_lb(:,s) = [SLres{s}(:).acc_lb];
            acc_ub(:,s) = [SLres{s}(:).acc_ub];
            %plot(XYZ(3,:),acc_lb(:,s),'--')
            %plot(XYZ(3,:),acc_ub(:,s),'--')
        end
        hold off
        for g = 1:length(SubInd)
            acc_av(:,g) = mean(acc(:,grp==g),2);
            acc_lb_av(:,g) = mean(acc_lb(:,grp==g),2);
            acc_ub_av(:,g) = mean(acc_ub(:,grp==g),2);
        end
        figure
        hold on
        plot(XYZ(3,:),acc_av(1:size(XYZ,2),:)); 
        plot(XYZ(3,:),acc_lb_av(1:size(XYZ,2),:),'--')
        plot(XYZ(3,:),acc_ub_av(1:size(XYZ,2),:),'--')
        hold off


        %% STATS
        addpath(genpath('C:\Data\Matlab\TFCE'));
        % independent sample ttest, two-sided
        S.analysis = 'independent';
        S.tails = 2;
        S.g1 = find(grp==1);
        S.g2 = find(grp==2);
        S.imgs(:,1,1,:) = acc(:,S.g1);
        S.imgs2(:,1,1,:) = acc(:,S.g2);
        S.covariate = [];
        S.nuisance = [];
        S.H = [];
        S.E = [];
        S.C = [];
        S.dh = [];
        S.parworkers = [];
        S.nperm = 5000;
        [S.pcorr_pos,S.pcorr_neg] = matlab_tfce(S.analysis,S.tails,S.imgs,S.imgs2,S.covariate,S.nperm,S.H,S.E,S.C,S.dh,S.parworkers,S.nuisance);
        %fp = sum(pcorr_pos(:)<.05)+sum(pcorr_neg(:)<.05)
        save(fullfile(Din,'TFCE_stats.mat'),'S');
        find(S.pcorr_pos<0.05)
        find(S.pcorr_neg<0.05)


end