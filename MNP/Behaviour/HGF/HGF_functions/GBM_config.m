function c = GBM_config(S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Config structure
c = struct;

    % modelspecs (add these to calling function)
    m=1;
    S.modelspec{m}.type = 'AL'; % AL (associative learning), PL (perceptual learning), PR (priming)
    S.modelspec{m}.likelihood = 'binary'; % binary, continuous
    S.modelspec{m}.inputvar = 'uncertain_unequal'; % uncertain_equal (variance), uncertain_unequal, certain
    S.modelspec{m}.n_inputcond = 1; % Number of conditions with unique input variance
    S.modelspec{m}.priortype = 'hierarchical'; % constant, hierarchical, state
    S.modelspec{m}.n_priorlevels = 3; % in prior hierarchy. For binary models, 3 is minimum; for continuous 2 is minimum.
    S.modelspec{m}.priorupdate = 'dynamic'; % static, dynamic (unique estimate on each trial)
    S.modelspec{m}.respmodel = true; % use variables in response model?


%% General settings (specific to experimental design but not to the model)
% Input intervals
% If input intervals are irregular, the last column of the input
% matrix u has to contain the interval between inputs k-1 and k
% in the k-th row, and this flag has to be set to true
c.irregular_intervals = false;
% Number of target stimuli
c.n_targets = 1;
    
%%
nparams =[];
c.priormus=[];
c.priorsas=[];
c.nModels = length(S.modelspec);
st = [];
pn=0;
for m = 1:c.nModels
    
    type = S.modelspec{m}.type;
    
    % Model name
    c.(type).model = 'GBM';
    c.type{m} = type;

    %% add modelspecs to config struct
    for fn = fieldnames(S.modelspec{m})'
       c.(type).(fn{1}) = S.modelspec{m}.(fn{1});
    end
    
    %% Settings
    switch S.modelspec{m}.likelihood 
        case 'binary'
            % Eta0
            c.(type).eta0mu = 0;
            c.(type).eta0sa = 0;

            % Eta1
            c.(type).eta1mu = 1;
            c.(type).eta1sa = 0;

            %% Input variance: Alpha
            switch S.modelspec{m}.inputvar
                case 'uncertain_unequal'
                    c.(type).logal0mu = repmat(log(0.05),1,c.(type).n_inputcond);
                    c.(type).logal0sa = repmat(1,1,c.(type).n_inputcond); % unfixed
                    c.(type).logal0var = true; % this is a variance parameter
                    c.(type).logal1mu = repmat(log(0.05),1,c.(type).n_inputcond);
                    c.(type).logal1sa = repmat(1,1,c.(type).n_inputcond); % unfixed
                    c.(type).logal1var = true; % this is a variance parameter
                case 'uncertain_equal'
                    % only specify al0
                    c.(type).logal0mu = repmat(log(0.05),1,c.(type).n_inputcond);
                    c.(type).logal0sa = repmat(1,1,c.(type).n_inputcond); % unfixed
                    c.(type).logal0var = true; % this is a variance parameter
                case 'certain'
                    % only specify al0
                    c.(type).logal0mu = repmat(log(0.05),1,c.(type).n_inputcond); 
                    c.(type).logal0sa = repmat(0,1,c.(type).n_inputcond); % fixed
                    c.(type).logal0var = true; % this is a variance parameter
            end
    end
    
    
    %% Priors
    switch S.modelspec{m}.priortype
        case 'hierarchical'
            % Initial hidden state mean and variance
                % HIERARCHICAL MODELS
                % For all but the first two levels, this is usually best
                % kept fixed to 1 (determines origin on x_i-scale). The 
                % first level is NaN because it is determined by the second,
                % and the second implies neutrality between outcomes when it
                % is centered at 0.
            
            switch S.modelspec{m}.priorupdate
                case 'dynamic'
                    switch S.modelspec{m}.n_priorlevels
                        case 2
                            c.(type).mu_0mu = [NaN, 0];
                            c.(type).mu_0sa = [NaN, 0];% prior fixed to 0 at k=0 but dynamically updates after that
                            c.(type).logsa_0mu = [NaN, log(0.5)];
                            c.(type).logsa_0sa = [NaN, 0];
                            c.(type).logsa_0var = true; % this is a variance parameter
                        case 3
                            c.(type).mu_0mu = [NaN, 0, 1];
                            c.(type).mu_0sa = [NaN, 0, 0];% prior fixed to 0 at k=0 but dynamically updates after that
                            c.(type).logsa_0mu = [NaN, log(0.5), log(1)];
                            c.(type).logsa_0sa = [NaN, 0, 0];
                            c.(type).logsa_0var = true; % this is a variance parameter
                    end

                case 'static'
                    switch S.modelspec{m}.n_priorlevels
                        case 2
                            c.(type).mu_0mu = [NaN, 0.5];
                            c.(type).mu_0sa = [NaN, 1];% estimated mean
                            c.(type).logsa_0mu = [NaN, log(0.1)];
                            c.(type).logsa_0sa = [NaN, 0];
                            c.(type).logsa_0var = true; % this is a variance parameter
                        case 3
                            c.(type).mu_0mu = [NaN, 0.2, 1];
                            c.(type).mu_0sa = [NaN, 1, 0];% estimated mean
                            c.(type).logsa_0mu = [NaN, log(0.1), log(1)];
                            c.(type).logsa_0sa = [NaN, 0, 0];
                            c.(type).logsa_0var = true; % this is a variance parameter
                    end
                    
            end
            % Format: row vector of length n_levels.
            % Undefined (therefore NaN) at the first level.
            c.(type).ommu = [NaN, repmat(-6, 1, length(c.(type).mu_0mu)-1)];
            c.(type).omsa = [NaN, repmat(4^2, 1, length(c.(type).mu_0mu)-1)];
            
            % Rhos
            % Format: row vector of length n_levels.
            % Undefined (therefore NaN) at the first level.
            % Fix this to zero to turn off drift.
            c.(type).rhomu = [NaN, repmat(0, 1, length(c.(type).mu_0mu)-1)];
            c.(type).rhosa = [NaN, repmat(0, 1, length(c.(type).mu_0mu)-1)];

            % Kappas
            % Format: row vector of length n_levels-1.
            % Undefined (therefore NaN) at the first level.
            % This should be fixed (preferably to 1) if the observation model
            % does not use mu_i+1 (kappa then determines the scaling of x_i+1).
            c.(type).logkamu = [NaN, repmat(log(1), 1, length(c.(type).mu_0mu)-2)];
            c.(type).logkasa = [NaN, repmat(0, 1, length(c.(type).mu_0mu)-2)];
            c.(type).logkavar = true; % this is a variance parameter
            
        case 'state'
            % PRIOR STATE MODELS
            % e.g. Kalman Filter or Rascorla-Wagner
            % 99991   Value of the first input
            %         Usually a good choice for mu_0mu(1)
            % 99992   Variance of the first 20 inputs
            %         Usually a good choice for mu_0sa(1)
            c.(type).mu_0mu = 0.5;
            c.(type).mu_0sa = 1;
            
            % Initial Kalman gain
            c.(type).logg_0mu = 0.1;
            c.(type).logg_0sa = 1;
            
        case 'constant'
            % must be static
            c.(type).mu_0mu = [NaN, 0.5];
            c.(type).mu_0sa = [NaN, 0];% constant mean
            c.(type).logsa_0mu = [NaN, log(0.1)];
            c.(type).logsa_0sa = [NaN, 0];
            c.(type).logsa_0var = true; % this is a variance parameter
    end
    
    %% Response bias
    c.(type).rbmu = 0;
    c.(type).rbsa = 0;

    %% Parameter names
    % only names added here will be estimated
    % second column: 1 if it is a variance parameter
%     c.(type).pnames = {
%         'eta0',0
%         'eta1',0
%         'logal0',1
%         'logal1',1
%         'mu_0',0
%         'logsa_0',1
%         'om',0
%         'rho',0
%         'logka',1
%         'rb',0
%         };

    %% Gather prior settings and their indices in vectors
   
    fn=fieldnames(c.(type));
    for i = 1:length(fn)
        if strcmp(fn{i}(end-1:end),'mu')
            pn=pn+1;
            c.pnames{pn,1} = [type '_' fn{i}(1:end-2)];
            eval(['c.priormus = [c.priormus c.(type).' fn{i} '];']);
            eval(['nparams(pn) = length(c.(type).' fn{i} ');']);
            if isfield(c.(type),[fn{i}(1:end-2) 'var'])
                c.varparam(pn)=1;
            else
                c.varparam(pn)=0;
            end
        elseif strcmp(fn{i}(end-1:end),'sa')
            eval(['c.priorsas = [c.priorsas c.(type).' fn{i} '];']);
        else
            continue
        end
        if isempty(st)
            st = 0;
        else
            st=sum(nparams(1:pn-1));
        end
        c.priormusi{pn} = st+1:sum(nparams(1:pn));
    end
end

% Check whether we have the right number of priors
%expectedLength = 2*c.n_levels+c.n_inputs*4+1;
%if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
%    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
%end

%% Model function handle
c.prc_fun = @GBM;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @GBM_transp;

return;
