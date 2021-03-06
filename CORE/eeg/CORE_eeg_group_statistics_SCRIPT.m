clear all
close all
dbstop if error
restoredefaultpath
run('C:\Data\Matlab\Matlab_files\CORE\CORE_addpaths')
spath = 'C:\Data\CORE\eeg\ana\stats';

sfiles = {
    
    % DRAFT MODELS

    %'stats_SC_all_chan_RT_notrans_20180720T154154.mat' % absolute
    %'stats_SC_all_chan_RT_arcsinh_20180720T150942.mat' % absolute
    %'stats_SC_all_chan_RT_notrans_20180720T174428.mat' % relative mismatch
    %'stats_SC_all_chan_RT_arcsinh_20180720T175126.mat' % relative mismatch
    %'stats_SC_all_chan_RT_notrans_20180720T195507.mat' % mismatch, no smoothing/dsample
    %'stats_MR_all_chan_RT_notrans_20180720T231023.mat'
    %'stats_MR_all_chan_RT_arcsinh_20180720T225208.mat'
    %'stats_PEB_all_chan_RT_arcsinh_20180720T222913.mat'
    %'stats_RR_all_chan_RT_arcsinh_20180721T081753.mat'
    %'stats_BRR_all_chan_RT_arcsinh_20180721T083416.mat' % 100 samples
    %'stats_SC_comp_recon_RT_arcsinh_20180721T221137.mat'
    %'stats_BRR_all_chan_RT_arcsinh_20180721T172647.mat' % 1000 samples
    %'stats_RR_all_chan_RT_arcsinh_20180730T174602.mat' % includes decoded RTs
    %'stats_RR_all_chan_cond_arcsinh_20180802T075724.mat' % mismatch effect, unflipped
    %'stats_RR_all_chan_cond_arcsinh_20180802T115759.mat' % mismatch effect, chan flipped
    %'stats_RR_all_chan_RT_arcsinh_20180802T122607.mat' % RR RT flipped
    %'stats_RR_all_chan_RT_arcsinh_20180802T130052.mat' % contains sigma for group averaging
    %'stats_RR_all_chan_HGF_arcsinh_20180802T182620.mat' % HGF resp model 16, perc model 10, PE predictors
    %'stats_RR_all_chan_HGF_arcsinh_20180802T204720.mat'% epsi only
    %'stats_RR_all_chan_HGF_arcsinh_20180802T222818.mat' % unsigned PE
    %'stats_RR_all_chan_HGF_arcsinh_20180803T000144.mat' % unsigned EPSI
    %'stats_RR_all_chan_HGF_arcsinh_20180803T072502.mat' % unsigned epsi2
    %'stats_RR_all_chan_HGFcond_arcsinh_20180803T080350.mat' % unsigned epsi2 and mismatch
    %'stats_RR_all_chan_HGFcond_arcsinh_20180803T082358.mat' % signed epsi2 and mismatch
    %'stats_SC_all_chan_HGF_arcsinh_20180803T092935.mat' % SC signed epsi2
    %'stats_MR_all_chan_HGF_arcsinh_20180803T095317.mat' % MR signed epsi2
    %'stats_MR_all_chan_HGF_arcsinh_20180803T103810.mat' % MR signed epsi2 - arcsinh
    %'stats_MR_all_chan_HGF_arcsinh_20180803T104102.mat' % MR signed epsi2 - rank
    %'stats_MR_all_chan_HGFcond_arcsinh_20180803T130723.mat' % MR mismatch signed epsi2
    %'stats_MR_all_chan_RT_arcsinh_20180803T102948.mat' % MR RT re-test of code
    %'stats_MR_all_chan_cond_arcsinh_20180803T113032.mat' % MR mismatch
    %'stats_MR_all_chan_HGF_arcsinh_20180803T113646.mat' % MR HGF, all PEs
    %'stats_MR_all_chan_HGF_arcsinh_20180803T121754.mat' % MR HGF, EPSIs
    %'stats_MR_all_chan_HGFcond_arcsinh_20180803T122143.mat' % MR HGF, all PEs and mismatch
    %'stats_MR_all_chan_HGF_arcsinh_20180803T133437.mat' % 3 epsi respmodel 12
    %'stats_MR_all_chan_HGF_arcsinh_20180803T143130.mat' % HGF beliefs
    %'stats_MR_all_chan_HGFcond_arcsinh_20180803T151437.mat' % HGF beliefs & mismatch
    %'stats_MR_all_chan_RT_arcsinh_20180803T233645.mat' % new, containing S.testidx
    %'stats_MR_all_chan_HGF_arcsinh_20180803T233457.mat' % mu and epsi (0.5 train frac)
    %'stats_MR_all_chan_HGF_arcsinh_20180804T081114.mat' % mu and epsi (1.0 train frac)
    %'stats_MR_all_chan_cond_arcsinh_20180804T144006.mat' % repeat of MR mismatch, with decoding
    %'stats_MR_all_chan_HGF_arcsinh_20180808T105013.mat' % Mu1 only with decoding
    %'stats_MR_all_chan_HGF_arcsinh_20180808T161954.mat' % Dau
    %'stats_MR_all_chan_HGF_arcsinh_20180808T164243.mat' % rectified Dau
    %'stats_MR_all_chan_HGF_arcsinh_20180808T171340.mat' %Baysopt Dau
    
%     'stats_BRR_all_chan_cond_arcsinh_20180802T203757.mat'
%     'stats_BRR_all_chan_HGF_arcsinh_20180808T220203.mat' % BRR Dau
%     'stats_BRR_all_chan_HGF_arcsinh_20180808T220230.mat' % BRR rectified Dau
%     'stats_BRR_all_chan_HGF_arcsinh_20180809T070051.mat' % BRR Dau bayesopt
%     'stats_BRR_all_chan_HGF_arcsinh_20180809T074443.mat' % BRR rectified Dau bayesopt
%     'stats_BRR_all_chan_HGF_arcsinh_20180809T135940.mat' % BRR Dau rectified, EEG estimated (model 36), controlling for design
%     'stats_BRR_all_chan_HGF_arcsinh_20180809T135927.mat' % BRR Dau rectified, EEG estimated (model 28), controlling for design
    
    %'stats_MR_all_chan_condHGF_arcsinh_20180809T130038.mat' % Dau rectified, bayesopt, controlling for design
    %'stats_MR_all_chan_condHGF_arcsinh_20180809T130159.mat' % Dau rectified, RT estimated, controlling for design
    %'stats_MR_all_chan_condHGF_arcsinh_20180809T132920.mat' % Dau rectified, EEG estimated (model 36), controlling for design
    %'stats_MR_all_chan_condHGF_arcsinh_20180809T133019.mat' % Dau rectified, EEG estimated (model 28), controlling for design
    
    
    
    %'stats_MVPA_all_chan_RT_arcsinh_20180815T073017.mat' % mismatch trials
    %'stats_MVPA_all_chan_RT_arcsinh_20180815T073135.mat' % mismatch-standard
    %'stats_MVPA_all_chan_cond_arcsinh_20180815T124954.mat'
    %'stats_MR_all_chan_condRT_arcsinh_20180815T155650.mat'
    %'stats_MR_all_chan_condRT_arcsinh_20180922T080308.mat'
    
    % FINAL VERION
    
    %'stats_BRR_all_chan_RT_arcsinh_20180813T211834.mat' % RT with subtracted mismatch-standard
    %'stats_BRR_all_chan_RT_arcsinh_20180813T211745.mat' % RT with mismatch only
    
    %'stats_MR_all_chan_condHGF_arcsinh_20180830T122634.mat' 
    %'stats_MR_all_chan_cond_arcsinh_20180830T130620.mat' % old
    %'stats_MR_all_chan_cond_arcsinh_20180923T152816.mat' % new - with skew/kurt
    %'stats_MR_all_chan_HGF_arcsinh_20180923T165454.mat' % full real PE
    %'stats_subtractR2_MR_all_chan_cond_arcsinh_20180830T130620.mat'
    
%      'stats_BRR_all_chan_condHGF_arcsinh_20180830T195051.mat' % abs PE
%     %'stats_subtractR2_BRR_all_chan_cond_arcsinh_20180830T145121.mat' % abs PE
%      'stats_BRR_all_chan_condHGF_arcsinh_20180831T131157.mat' % real PE
%     %'stats_subtractR2_BRR_all_chan_HGF_arcsinh_20180831T160611.mat' % real PE
%     
%     %'stats_BRR_all_chan_condHGF_arcsinh_20180831T104101.mat' % abs Dau
%     %'stats_BRR_all_chan_condHGF_arcsinh_20180901T050543.mat' % real Dau
%     'stats_BRR_all_chan_HGF_arcsinh_20180901T124507.mat' % real Dau epsi2
%     %'stats_BRR_all_chan_condHGF_arcsinh_20180901T102103.mat' % real Dau epsi2

%     'stats_BRR_all_chan_cond_arcsinh_20180923T171935.mat' % t dist, cond, g prior
%     'stats_BRR_all_chan_HGF_arcsinh_20180925T161430.mat' % abs PE, t dist
     'stats_BRR_all_chan_HGF_arcsinh_20180925T161455.mat' % real PE, t dist
%     'stats_BRR_all_chan_HGF_arcsinh_20180926T070703.mat' % abs Dau, t dist
%     'stats_BRR_all_chan_HGF_arcsinh_20180926T070557.mat' % real Dau, t dist
%     'stats_BRR_all_chan_HGF_arcsinh_20180926T215653.mat' % epsi 1/2, t dist
%     'stats_BRR_all_chan_HGF_arcsinh_20180926T215735.mat'% abs epsi 1/2, t dist
%    'stats_BRR_all_chan_condHGF_arcsinh_20181013T141703.mat' % t dist, real PE
    %'stats_BRR_all_chan_HGF_arcsinh_20181013T141528.mat'  % bayesopt, t dist, real PE
%    'stats_BRR_all_chan_cond_arcsinh_20181015T171840.mat' % t dist, cond, hs+
    %'stats_BRR_all_chan_HGF_arcsinh_20181015T171749.mat' % t dist, abs PE, hs+
    %'stats_BRR_all_chan_HGF_arcsinh_20181014T100638.mat'  % t dist, real PE, hs+
    %'stats_BRR_all_chan_condHGF_arcsinh_20181014T101006.mat'  % t dist, real PE, hs+
    %'stats_BRR_all_chan_condHGF_arcsinh_20181014T210924.mat' % t dist, Dau/Da, hs+
    %'stats_BRR_all_chan_condHGF_arcsinh_20181014T211017.mat' % t dist, epsi, hs+
    %'stats_BRR_all_chan_condHGF_arcsinh_20181015T084814.mat' % t dist, dau & epsi2/3, hs+
    %'stats_BRR_all_chan_condHGF_arcsinh_20181016T174019.mat'  % t dist, real Dau, ridge
    %'stats_BRR_all_chan_condHGF_arcsinh_20181016T174126.mat'  % t dist, real Dau, lasso
    %'stats_BRR_all_chan_condHGF_arcsinh_20181017T180759.mat'  % t dist, real PE, ridge
    %'stats_BRR_all_chan_condHGF_arcsinh_20181017T180714.mat'  % t dist, real PE, lasso
    %'stats_BRR_all_chan_HGF_arcsinh_20181018T191420.mat' % t dist, real PE, ridge
    %'stats_BRR_all_chan_HGF_arcsinh_20181018T191439.mat' % t dist, real PE, lasso
    %'stats_BRR_all_chan_cond_arcsinh_20181019T173732.mat' % t dist, cond, ridge
    %'stats_BRR_all_chan_cond_arcsinh_20181019T173649.mat' % t dist, cond, lasso
    
%    'stats_MR_all_chan_condHGF_arcsinh_20181013T121111.mat' % epsi 1/2, t dist
%    'stats_MR_all_chan_condHGF_arcsinh_20181013T121146.mat' % abs epsi 1/2, t dist

% response model 20
% 'stats_BRR_all_chan_HGF_arcsinh_20181022T212651.mat' % g, t, PE
 %'stats_BRR_all_chan_HGF_arcsinh_20181022T212551.mat' % hs+, t, PE
 
% response model 2, alternative HGF priors
%'stats_BRR_all_chan_condHGF_arcsinh_20181025T082046.mat' % alpha=0.2, t dist, real PE, hs+
%'stats_BRR_all_chan_condHGF_arcsinh_20181024T172020.mat' % alpha = 1, t dist, real PE, hs+

%'stats_BRR_all_chan_condHGF_arcsinh_20181130T080045.mat' % 'GBM_config_alpha4BO_var2_bo', t dist, real PE, hs+
'stats_BRR_all_chan_HGF_arcsinh_20181130T080120.mat'; % 'GBM_config_alpha4BO_var2_bo', t dist, real PE, g

    };
subtract = [];
encoding_types = {'spear','MR','PEB','RR','BRR','mvpa'}; % only these will be analysed
statfield = {'beta','b','s','rho','weights','transweights','kurt','skew'}; % for t-test stats
%statfield = {'s','r2'};
clims = []; % t value limits for plotting
xticks = 0:4:600;
topo_range = [0 600];
param=[6]; % multiple param's betas are summed
load('C:\Data\CORE\eeg\ana\prep\chanlocs.mat')


% get data
allstat={};
i=0; % index for fig handles
for f = 1:length(sfiles)
    load(fullfile(spath,sfiles{f}));
    allstat{f} = stats;
    
    % get group info
    grplist = S.designmat(2:end,strcmp(S.designmat(1,:),'groups'));
    [grpuni,iA,iB] = unique(grplist,'stable');
    
    % groups stats for each analysis
    an = fieldnames(allstat{f});
    an = an(ismember(an,encoding_types));
    for a = 1:length(an)
        da = fieldnames(allstat{f}.(an{a}));
        sf_names=fieldnames(allstat{f}.(an{a}).(da{1}));
        statfield = statfield(ismember(statfield,sf_names));
        
        for sf = 1:length(statfield)
        
            % if there are multiple runs, average the outputs
            for d = 1:length(da)
                nsub = size(allstat{f}.(an{a}).(da{d}),1);
                nrun = size(allstat{f}.(an{a}).(da{d}),2);
                if nrun>1
                    runcell={};meandat={};
                    for ns = 1:nsub
                        for nr = 1:nrun
                            runcell{ns,nr} = allstat{f}.(an{a}).(da{d})(ns,nr).(statfield{sf});
                        end
                        meandat{ns,1} = mean(cat(3,runcell{ns,:}),3);
                    end
                    allstat{f}.(an{a}).(da{d})(1).(statfield{sf}) = meandat;
                end
            end
        end
        allstat{f}.(an{a}).(da{d})(2:end) = [];
        
        for sf = 1:length(statfield)

            nc = size(allstat{f}.(an{a}).(da{1}).(statfield{sf}),2);
            for c = 1:nc 
                h1=figure('Name',['file_' num2str(f) '_' an{a} ', comp: ' num2str(c)]);pl = 0; % plot index
                h2=figure('Name',['file_' num2str(f) '_' an{a} ', comp: ' num2str(c)]);pl2 = 0; % plot index
                h3=figure('Name',['file_' num2str(f) '_' an{a} ', comp: ' num2str(c)]);pl3 = 0; % plot index
                h4=figure('Name',['file_' num2str(f) '_' an{a} ', comp: ' num2str(c)]);pl4 = 0; % plot index
                for d = 1:length(da)
                    disp(['file' num2str(f) ', analysis: ' an{a} ', data type: ' da{d}, ', comp: ' num2str(c)])

                    nr = size(allstat{f}.(an{a}).(da{d}).(statfield{sf}),1);

                    clear alldat h p ci t
                    for r=1:nr
                        dat=allstat{f}.(an{a}).(da{d}).(statfield{sf}){r,c};
                        if ndims(dat)==3
                            dat=sum(dat(:,:,param),3);
                        elseif ndims(dat)==2 && strcmp(da{d},'GFP')
                            dat=sum(dat(:,param),3);
%                         else
%                             dat = dat;
                        end
                        sizdat=size(dat);
                        if ~any(sizdat==1) % if a matrix
                            dat = reshape(dat,prod(sizdat),[]);
                        end
                        alldat(r,:)=dat;
                    end
                    grpmeandat = mean(alldat,1);
                    
                    %% one-sample t-test (vs. zero) on beta weights
                    for s=1:size(alldat,2)
                        [h(s),p(s),~,stt] = ttest(double(alldat(:,s)));
                        t(s)=stt.tstat;
                    end

                    % remove NaNs
                    t(isnan(t))=0;
                    h(isnan(h))=0;
                    p(isnan(p))=Inf;

                    % FDR correction
                    [~,fdr_mask] = fdr(p,0.05);
                    fdr_p=p.*double(fdr_mask);
                    fdr_t=t.*double(fdr_mask);
                    % reshape
                    if ~any(sizdat==1) 
                        h=reshape(h,sizdat(1),sizdat(2));
                        p=reshape(p,sizdat(1),sizdat(2));
                        t=reshape(t,sizdat(1),sizdat(2));
                        fdr_t=reshape(fdr_t,sizdat(1),sizdat(2));
                        fdr_p=reshape(fdr_p,sizdat(1),sizdat(2));
                        grpmeandat=reshape(grpmeandat,sizdat(1),sizdat(2));
                    end
                    % output
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_mean'])=reshape(mean(alldat,1)',sizdat(1),sizdat(2));
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest']).h=h;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest']).p=p;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest']).t=t;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest']).fdr_t=fdr_t;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest']).fdr_p=fdr_p;

                    trange = dsearchn(xticks',[topo_range(1);topo_range(2)]);

                    %% plot group mean of data

                    if isempty(clims)
                        clim=[min(grpmeandat(:)) max(grpmeandat(:))];
                    else
                        clim=clims;
                    end
                    
                    figure(h1)
                    hold on
                    pl=pl+1;
                    subplot(length(da)*2,2,pl)
                    imagesc(xticks,[],grpmeandat,clim); 
                    [~,mi]=max(mean(abs(grpmeandat(:,trange(1):trange(2))),1));
                    mi=mi+trange(1)-1;
                    line(xticks(mi*[1 1]),[1 92],'color','k','linewidth',2)
                    title([statfield{sf} ', mean values']);
                    colorbar

                    pl=pl+1;
                    if ~any(sizdat==1) 
                        subplot(length(da)*2,2,pl)
                        topoplot(grpmeandat(:,mi),chanlocs,'maplimits',clim);
                    end
                    
                    %% plot t stats
                    if isempty(clims)
                        clim=[min(t(:)) max(t(:))];
                    else
                        clim=clims;
                    end
                    
                    figure(h2)
                    hold on
                    pl2=pl2+1;
                    subplot(length(da)*2,2,pl2)
                    imagesc(xticks,[],t,clim); 
                    [~,mi]=max(mean(abs(t(:,trange(1):trange(2))),1));
                    mi=mi+trange(1)-1;
                    line(xticks(mi*[1 1]),[1 92],'color','k','linewidth',2)
                    title([statfield{sf} ', t values for one-sample t-test']);
                    colorbar

                    pl2=pl2+1;
                    if ~any(sizdat==1) 
                        subplot(length(da)*2,2,pl2)
                        topoplot(t(:,mi),chanlocs,'maplimits',clim);
                    end
                    
                    if isempty(clims)
                        clim=[min(fdr_t(:)) max(fdr_t(:))];
                        if ~any(clim)
                            clim=[-5 5];
                        end
                    else
                        clim=clims;
                    end

                    pl2=pl2+1;
                    subplot(length(da)*2,2,pl2)
                    imagesc(xticks,[],fdr_t,clim); 
                    [~,mi]=max(mean(abs(fdr_t(:,trange(1):trange(2))),1));
                    mi=mi+trange(1)-1;
                    line(xticks(mi*[1 1]),[1 92],'color','k','linewidth',2)
                    title([statfield{sf} ', fdr thresholded t values']);
                    colorbar

                    pl2=pl2+1;
                    if ~any(sizdat==1) 
                        subplot(length(da)*2,2,pl2)
                        topoplot(fdr_t(:,mi),chanlocs,'maplimits',clim);
                    end
                    
                    %% two-sample t-test
                    clear t h p stt
                    for g = 1:length(grpuni)
                        grpdat{g}=alldat(strcmp(grplist,grpuni{g}),:);
                    end
                    for s=1:size(alldat,2)
                        [h(s),p(s),~,stt] = ttest2(double(grpdat{1}(:,s)),double(grpdat{2}(:,s)));
                        t(s)=stt.tstat;
                    end

                    % remove NaNs
                    t(isnan(t))=0;
                    h(isnan(h))=0;
                    p(isnan(p))=Inf;

                    % FDR correction
                    [~,fdr_mask] = fdr(p,0.05);
                    fdr_p=p.*double(fdr_mask);
                    fdr_t=t.*double(fdr_mask);
                    % reshape
                    if ~any(sizdat==1) 
                        h=reshape(h,sizdat(1),sizdat(2));
                        p=reshape(p,sizdat(1),sizdat(2));
                        t=reshape(t,sizdat(1),sizdat(2));
                        fdr_t=reshape(fdr_t,sizdat(1),sizdat(2));
                        fdr_p=reshape(fdr_p,sizdat(1),sizdat(2));
                    end
                    % output
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest2']).h=h;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest2']).p=p;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest2']).t=t;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest2']).fdr_t=fdr_t;
                    allstat{f}.(an{a}).(da{d}).([statfield{sf} '_grpttest2']).fdr_p=fdr_p;

                    trange = dsearchn(xticks',[topo_range(1);topo_range(2)]);
                    
                    if isempty(clims)
                        clim=[min(t(:)) max(t(:))];
                    else
                        clim=clims;
                    end

                    figure(h3)
                    hold on
                    pl3=pl3+1;
                    subplot(length(da)*2,2,pl3)
                    imagesc(xticks,[],t,clim); 
                    [~,mi]=max(mean(abs(t(:,trange(1):trange(2))),1));
                    mi=mi+trange(1)-1;
                    line(xticks(mi*[1 1]),[1 92],'color','k','linewidth',2)
                    title([statfield{sf} ', t values for two-sample t-test']);
                    colorbar

                    pl3=pl3+1;
                    if ~any(sizdat==1) 
                        subplot(length(da)*2,2,pl3)
                        topoplot(t(:,mi),chanlocs,'maplimits',clim);
                    end
                    
                    if isempty(clims)
                        clim=[min(fdr_t(:)) max(fdr_t(:))];
                        if ~any(clim)
                            clim=[-5 5];
                        end
                    else
                        clim=clims;
                    end

                    pl3=pl3+1;
                    subplot(length(da)*2,2,pl3)
                    imagesc(xticks,[],fdr_t,clim); 
                    [~,mi]=max(mean(abs(fdr_t(:,trange(1):trange(2))),1));
                    mi=mi+trange(1)-1;
                    line(xticks(mi*[1 1]),[1 92],'color','k','linewidth',2)
                    title([statfield{sf} ', fdr thresholded t values']);
                    colorbar

                    pl3=pl3+1;
                    if ~any(sizdat==1) 
                        subplot(length(da)*2,2,pl3)
                        topoplot(fdr_t(:,mi),chanlocs,'maplimits',clim);
                    end
                    
                    figure(h4)
                    pl4=pl4+1;
                    subplot(length(da),1,pl4)
                    scatdat=[];
                    for g = 1:length(grpdat)
                        dat=reshape(grpdat{g},[],sizdat(1),sizdat(2));
                        scatdat=[scatdat;mean(abs(dat(:,:,mi)),2)];
                    end
                    scatter(iB,scatdat);
                    set(gca,'xtick',1:2,'XTickLabel',grpuni);
                    title('group difference in mean absolute EEG at time of greatest group difference')
                    
                    % model comparison
                    if strcmp(an{a},'BRR')
                        % separate LME into groups for model comparison
                        LME=[stats.BRR.alldata.logl];
                        for g = 1:length(grpuni)
                            LMEall=LME(strcmp(grplist,grpuni{g}));
                            LMEmat = cat(3,LMEall{:});
                            LMEmean =double(squeeze(mean(mean(LMEmat,1),2)));
                            LMEgrp{1,g}(f,:) = LMEmean;
                        end
                        
                        % separate WAIC into groups for model comparison
                        WAIC=[stats.BRR.alldata.waic];
                        for g = 1:length(grpuni)
                            WAICall=WAIC(strcmp(grplist,grpuni{g}));
                            WAICmat = cat(3,WAICall{:});
                            WAICmean =double(squeeze(mean(mean(WAICmat,1),2)));
                            WAICgrp{1,g}(f,:) = WAICmean;
                        end
                    end
                end
            end
        end
        
        % compare groups regarding predictions
        try
            recons = allstat{f}.biem.alldata.recons;
        catch
            try
                for i = 1:length(allstat{f}.mvpa.alldata)
                    recons{i} = mean(cat(3,{allstat{f}.mvpa.alldata(i,:).testdata_pred}),3);
                end
            end
        end
        try
            dat=cellfun(@mean,recons,'uniformoutput',0);
            subidx=ismember(stats.subname,S.designmat(2:end,2));
            dat=dat(subidx);
            p_rs = ranksum(dat(iB==1),dat(iB==2))
            figure; scatter(iB,dat);
            set(gca,'xtick',1:2,'XTickLabel',grpuni);
            title(['group difference in mean reconstructed predictor variable: p = ' num2str(p_rs)])
        end
        
    end
    
    stats=allstat{f};
    sname = strrep(sfiles{f},'stats','stats_grp');
    save(fullfile(spath,sname),'stats');
    
end

% subtract R2 between datasets
if ~isempty(subtract) && length(allstat)==2
    for r=1:nr 
        %datsub{1}=allstat{1}.MR.alldata.R2{r,1};
        %datsub{2}=allstat{2}.MR.alldata.R2{r,1};
        datsub{1}=allstat{1}.BRR.alldata.r2{r,1};
        datsub{2}=allstat{2}.BRR.alldata.r2{r,1};
        subdat{r,1} = subtract(1)*datsub{1} + subtract(2)*datsub{2};
    end
    stats = allstat{1};
    %stats.MR.alldata.R2 = subdat;
    stats.BRR.alldata.r2 = subdat;
    sname = strrep(sfiles{f},'stats','stats_subtractR2');
    save(fullfile(spath,sname),'stats','S');
end
    
% group model comparison
if strcmp(an{a},'BRR')
    runvar=WAICgrp;
    if exist('WAICgrp','var') && size(runvar{1},1)>1
        [bmc.gposterior,bmc.gout] = VBA_groupBMC_btwGroups(runvar)
    end
end

% best predictors
if 0
    for f = 1:length(allstat)
        
        % absolute betas (probably not very useful!)
        meanb=squeeze(mean(mean(abs(cat(4,allstat{f}.BRR.alldata.b{:})),2),1));
        x=repmat([1:size(meanb,1)]',1,size(meanb,2));
        figure;scatter(x(:),meanb(:))
        title(['mean b for file ' num2str(f)])
    end
end

% plot R2
clear meanr2
if 0
    for f = 1:length(allstat)
        meanr2{f}=squeeze(mean(mean(cat(3,allstat{f}.BRR.alldata.r2{:}),2),1));
        x=repmat([1:size(meanr2{f},1)]',1,size(meanr2{f},2));
        figure;scatter(x(:),meanr2{f}(:))
        title(['r2 for file ' num2str(f)])
    end
    if f==2
        submeanr2= subtract(1)*meanr2{1} + subtract(2)*meanr2{2};
        x=repmat([1:size(submeanr2,1)]',1,size(submeanr2,2));
        figure;scatter(x(:),submeanr2(:))
        title(['subtracted r2'])
        pc_r2 = submeanr2*100./meanr2{1};
        figure;scatter(x(:),pc_r2(:))
        title(['percent increase in r2'])
    end
end