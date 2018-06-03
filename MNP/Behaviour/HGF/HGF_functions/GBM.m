function [traj] = GBM(r, pvec, varargin)
% GENERAL BINARY (INPUT) MODEL

% NOTES
% 1. in and N defined separately
% 2. representation Mu has no variance in SDT, there is just noise (alpha)
% that influences it's mean value.
% 3. must be a two-level model because the 2nd level sets the prior for the
% first, even if the prior is fixed

% PLANNED UPDATES
% 1. Allow separate evaluation of alpha for targets and non-targets - done
% 2. Estimate prior expectation (fixed)
% 3. Prior and alpha variable by block type
% 4. Prior and alpha variable by trial (Kalman)
% 5. Hierarchical priors
mu=[];
% Transform paramaters back to their native space if needed
if ~isempty(varargin) 
    if strcmp(varargin{1},'trans')
        pvec = GBM_transp(r, pvec);
    end
end

% Add dummy "zeroth" trial
u = [zeros(1,size(r.u,2)); r.u(:,:)];

% Number of trials (including prior)
n = size(u,1);

% Assume that if u has more than one column, the last contains t
try
    if r.c_prc.irregular_intervals
        if size(u,2) > 1
            t = [0; r.u(:,end)];
        else
            error('tapas:hgf:InputSingleColumn', 'Input matrix must contain more than one column if irregular_intervals is set to true.');
        end
    else
        t = ones(n,1);
    end
catch
    if size(u,2) > 1
        t = [0; r.u(:,end)];
    else
        t = ones(n,1);
    end
end

%% INITIALISE

% Create param struct
nme=r.c_prc.pnames;
idx=r.c_prc.priormusi;
type='like';
for pn=1:length(nme)
    if strcmp(nme{pn,1}(1:length(type)),type)
        nme2 = strsplit(nme{pn,1},[type '_']);
        nme3 = strsplit(nme2{end},'log');
        M.(type).p.(nme3{end}) = pvec(idx{pn});
        %eval([nme3{end} ' = pvec(idx{pn});']);
    end
end

M.like.tr.al = NaN(n,1);
% joint trajectories (if needed)
M.like.tr.vj_mu = NaN(n,1);
M.like.tr.xc = NaN(n,1);
M.like.tr.xchat = NaN(n,1);
    
for m=1:r.c_prc.nModels
    type = r.c_prc.type{m};
    
    % Create param struct
    for pn=1:length(nme)
        if strcmp(nme{pn,1}(1:length(type)),type)
            nme2 = strsplit(nme{pn,1},[type '_']);
            nme3 = strsplit(nme2{end},'log');
            M.(type).p.(nme3{end}) = pvec(idx{pn});
            %eval([nme3{end} '(:,:,m) = pvec(idx{pn});']);
        end
    end

    % Number of levels
    M.(type).l = r.c_prc.(type).n_priorlevels;

    if isfield(M.(type).p,'om')
        if length(M.(type).p.om)>1
            M.(type).p.th   = exp(M.(type).p.om(end));
            M.(type).p.om(end)=[];
        end
    end

    % Representations
    M.(type).tr.mu0 = NaN(n,1);
    M.(type).tr.mu = NaN(n,M.(type).l);
    M.(type).tr.pi = NaN(n,M.(type).l);

    % Other quantities
    M.(type).tr.muhat = NaN(n,M.(type).l);
    M.(type).tr.pihat = NaN(n,M.(type).l);
    M.(type).tr.v     = NaN(n,M.(type).l);
    M.(type).tr.w     = NaN(n,M.(type).l-1);
    M.(type).tr.da    = NaN(n,M.(type).l);
    M.(type).tr.dau   = NaN(n,1);
    M.like.tr.al   = NaN(n,1);

    % Representation priors
    % Note: first entries of the other quantities remain
    % NaN because they are undefined and are thrown away
    % at the end; their presence simply leads to consistent
    % trial indices.
    M.(type).tr.mu(1,1) = tapas_sgm(M.(type).p.mu_0(1), 1);
    M.(type).tr.pi(1,1) = Inf;
    if M.(type).l>1
        M.(type).tr.mu(1,2:end) = M.(type).p.mu_0(2:end);
        M.(type).tr.pi(1,2:end) = 1./M.(type).p.sa_0(2:end);
    end
    if isfield(M.(type).p,'g_0')
        %if r.c_prc.(type).one_alpha
        %    g  = NaN(n,1); % Kalman gain (optional)
        %else
            M.(type).tr.g  = NaN(n,2); % Kalman gain (optional)
        %end
        M.(type).tr.g(1,:)  = M.(type).p.g_0; % Kalman gain (optional)
        M.(type).p.expom = exp(M.(type).p.om);
    end
end

% Unpack from struct to double for efficiency
type='like';
pnames = fieldnames(M.(type).p);
for pn=1:length(pnames)
    eval([pnames{pn} ' = M.(type).p.(pnames{pn});']);
end
for m=1:r.c_prc.nModels
    type = r.c_prc.type{m};
    l(m)=M.(type).l;

    % Unpack prior parameters
    pnames = fieldnames(M.(type).p);
    for pn=1:length(pnames)
        eval([pnames{pn} '(:,:,m) = M.(type).p.(pnames{pn});']);
    end

    %Unpack prior traj
    tnames = fieldnames(M.(type).tr);
    for tn=1:length(tnames)
        eval([tnames{tn} '(:,1:size(M.(type).tr.(tnames{tn}),2),m) = M.(type).tr.(tnames{tn});']);
    end
end

%% UPDATES
for k=2:1:n
    
    for m=1:r.c_prc.nModels
        if not(any(r.ign==k-1))
            
%             % Unpack likelihood parameters
%             type='like';
%             pnames = fieldnames(M.(type).p);
%             for pn=1:length(pnames)
%                 p.(pnames{pn}) = M.(type).p.(pnames{pn});
%             end
% 
            type = r.c_prc.type{m};
%             
%             % Unpack prior parameters
%             pnames = fieldnames(M.(type).p);
%             for pn=1:length(pnames)
%                 p.(pnames{pn}) = M.(type).p.(pnames{pn});
%             end
%             
%             %Unpack prior traj
%             tnames = fieldnames(M.(type).tr);
%             for tn=1:length(tnames)
%                 tr.(tnames{tn}) = M.(type).tr.(tnames{tn});
%             end
        
            %% Predictions (from previous trial or fixed parameters)
            if strcmp(r.c_prc.(type).priortype,'hierarchical')
                if strcmp(r.c_prc.(type).priorupdate,'fixed')
                    if r.c_prc.(type).n_muin>1
                        muhat(1,2,m) = mu_0(1+u(k,2),1,m);
                        pihat(1,2,m) = 1./sa_0(1+u(k,2),1,m);
                    else
                        muhat(1,2,m) = mu_0(2,1,m);
                        pihat(1,2,m) = 1./sa_0(2,1,m);
                    end
                    % 2nd level prediction
                    muhat(k,2,m) = muhat(1,2,m);%mu(k-1,2) +t(k) *rho(2); % fixed to initial value - not updated on each trial

                elseif strcmp(r.c_prc.(type).priorupdate,'dynamic')
                    % 2nd level prediction
                    muhat(k,2,m) = mu(k-1,2,m) +t(k,1,m) *rho(2,1,m);

                end
                % Prediction from level 2 (which can be either fixed or dynamic)
                muhat(k,1,m) = tapas_sgm(muhat(k,2,m), 1);

            elseif strcmp(r.c_prc.(type).priortype,'state')
                % Prediction from prior state, e.g. Kalman filter
                muhat(k,1,m) =  mu(k-1,1,m);

            end

            % Precision of prediction
            pihat(k,1,m) = 1/(muhat(k,1,m)*(1 -muhat(k,1,m)));


            %% Updates

            % Value prediction error, e.g. for Kalman filter, also known as the
            % "innovation"
            dau(k,1,m) = u(k,1) -muhat(k,1,m);

            % set alpha
            if ~exist('al1','var')
                al1=al0;
            end
            if u(k,1)==0
                al(k,1,m)=al0(u(k,2),1,m);
            elseif u(k,1)==1
                al(k,1,m)=al1(u(k,2),1,m);
            end

            % 
            if strcmp(r.c_prc.(type).priortype,'hierarchical')
                % Likelihood functions: one for each
                % possible signal
                if r.c_prc.n_inputcond >1
                    und1 = exp(-(u(k,1,m) -eta1(1,1,m))^2/(2*al1(u(k,2),1,m)));
                    und0 = exp(-(u(k,1,m) -eta0(1,1,m))^2/(2*al0(u(k,2),1,m)));
                else
                    und1 = exp(-(u(k,1,m) -eta1(1,1,m))^2/(2*al1));
                    und0 = exp(-(u(k,1,m) -eta0(1,1,m))^2/(2*al0));
                end


                
                if strcmp(type,'AL')
                    if u(k,3)==2
                        mu0(k,1) = muhat(k,1) *und1 /(muhat(k,1) *und1 +(1 -muhat(k,1)) *und0);
                        mu(k,1) = mu0(k,1);
                    elseif u(k,3)==1
                        mu0(k,1) = (1-muhat(k,1)) *und1 /(muhat(k,1) *und0 +(1 -muhat(k,1)) *und1);
                        mu(k,1) = 1-mu0(k,1);

                        % calculate prediction error for mu0 - muhat

                    end
                elseif strcmp(type,'PL')
                    mu(k,1) = muhat(k,1) *und1 /(muhat(k,1) *und1 +(1 -muhat(k,1)) *und0);
                    mu0(k,1) = mu(k,1);
                end


                %%
                % Representation prediction error
                da(k,1) = mu(k,1) -muhat(k,1);

                % second level predictions and precisions
                if strcmp(r.c_prc.(type).priorupdate,'fixed')
                    mu(k,2) = muhat(k,2); % for a model with higher level predictions, which are fixed
                    % At second level, assume Inf precision for a model with invariable predictions
                    pi(k,2) = Inf;
                    pihat(k,2) = Inf;

                elseif strcmp(r.c_prc.(type).priorupdate,'dynamic')
                    % Precision of prediction
                    pihat(k,2) = 1/(1/pi(k-1,2) +exp(ka(2) *mu(k-1,3) +om(2)));

                    % Updates
                    pi(k,2) = pihat(k,2) +1/pihat(k,1);
                    mu(k,2) = muhat(k,2) +1/pi(k,2) *da(k,1);

                    % Volatility prediction error
                    da(k,2) = (1/pi(k,2) +(mu(k,2) -muhat(k,2))^2) *pihat(k,2) -1;
                end

                % Implied posterior precision at first level
                sgmmu2 = tapas_sgm(mu(k,2), 1);
                pi(k,1) = pi(k,2)/(sgmmu2*(1-sgmmu2));

                if l(m) > 3
                    % Pass through higher levels
                    % ~~~~~~~~~~~~~~~~~~~~~~~~~~
                    for j = 3:l(m)-1
                        % Prediction
                        muhat(k,j) = mu(k-1,j) +t(k) *rho(j);

                        % Precision of prediction
                        pihat(k,j) = 1/(1/pi(k-1,j) +t(k) *exp(ka(j) *mu(k-1,j+1) +om(j)));

                        % Weighting factor
                        v(k,j-1) = t(k) *exp(ka(j-1) *mu(k-1,j) +om(j-1));
                        w(k,j-1) = v(k,j-1) *pihat(k,j-1);

                        % Updates
                        pi(k,j) = pihat(k,j) +1/2 *ka(j-1)^2 *w(k,j-1) *(w(k,j-1) +(2 *w(k,j-1) -1) *da(k,j-1));

                        if pi(k,j) <= 0
                            error('tapas:hgf:NegPostPrec', 'Negative posterior precision. Parameters are in a region where model assumptions are violated.');
                        end

                        mu(k,j) = muhat(k,j) +1/2 *1/pi(k,j) *ka(j-1) *w(k,j-1) *da(k,j-1);

                        % Volatility prediction error
                        da(k,j) = (1/pi(k,j) +(mu(k,j) -muhat(k,j))^2) *pihat(k,j) -1;
                    end
                end
                if l(m)>2
                    % Last level
                    % ~~~~~~~~~~
                    % Prediction
                    muhat(k,l(m)) = mu(k-1,l(m)) +t(k) *rho(l(m));

                    % Precision of prediction
                    pihat(k,l(m)) = 1/(1/pi(k-1,l(m)) +t(k) *th);

                    % Weighting factor
                    v(k,l(m))   = t(k) *th;
                    v(k,l(m)-1) = t(k) *exp(ka(l(m)-1) *mu(k-1,l(m)) +om(l(m)-1));
                    w(k,l(m)-1) = v(k,l(m)-1) *pihat(k,l(m)-1);

                    % Updates
                    pi(k,l(m)) = pihat(k,l(m)) +1/2 *ka(l(m)-1)^2 *w(k,l(m)-1) *(w(k,l(m)-1) +(2 *w(k,l(m)-1) -1) *da(k,l(m)-1));

                    if pi(k,l(m)) <= 0
                        error('tapas:hgf:NegPostPrec', 'Negative posterior precision. Parameters are in a region where model assumptions are violated.');
                    end

                    mu(k,l(m)) = muhat(k,l(m)) +1/2 *1/pi(k,l(m)) *ka(l(m)-1) *w(k,l(m)-1) *da(k,l(m)-1);

                    % Volatility prediction error
                    da(k,l(m)) = (1/pi(k,l(m)) +(mu(k,l(m)) -muhat(k,l(m)))^2) *pihat(k,l(m)) -1;
                end

            elseif strcmp(r.c_prc.(type).priortype,'state') % Kalman
                % Gain update - optimal gain is calculated from ratio of input
                % variance to representation variance

                % Same gain function modified by two different alphas
                g(k) = (g(k-1) +al(k)*expom)/(g(k-1) +al(k)*expom +1);
                % Hidden state mean update
                mu(k,1) = muhat(k,1)+g(k)*dau(k);
                mu0(k,1) = mu(k,1);
                pi(k,1) = (1-g(k)) *al(k)*expom; 

                % Alternative: separate gain functions for each stimulus type
          %      if r.c_prc.(type).one_alpha
          %          pi_u=al0(u(k,2));
          %          g(k,1) = (g(k-1,1) +pi_u*expom)/(g(k-1,1) +pi_u*expom +1);
          %          % Hidden state mean update
          %          mu(k,1) = muhat(k,1)+g(k,1)*dau(k);
          %          pi(k,1) = (1-g(k,1)) *pi_u*expom;
          %      else
          %          if u(k,1)==0
          %              pi_u=al0(u(k,2));
          %              g(k,1) = (g(k-1,1) +pi_u*expom)/(g(k-1,1) +pi_u*expom +1);
          %              g(k,2) = g(k-1,2);
          %              % Hidden state mean update
          %              mu(k,1) = muhat(k,1)+g(k,1)*dau(k);
          %              pi(k,1) = (1-g(k,1)) *pi_u*expom;
          %          elseif u(k,1)==1
          %              pi_u=al1(u(k,2));
          %              g(k,2) = (g(k-1,2) +pi_u*expom)/(g(k-1,2) +pi_u*expom +1);
          %              g(k,1) = g(k-1,1);
          %              % Hidden state mean update
          %              mu(k,1) = muhat(k,1)+g(k,2)*dau(k);
          %              pi(k,1) = (1-g(k,2)) *pi_u*expom;
          %          end
          %      end

                % Representation prediction error
                da(k,1) = mu(k,1) -muhat(k,1);

            end

            % RESPONSE BIAS
            if isfield(M.(type).p,'rb')
                mu(k,1) = mu(k,1)+rb;
            end

        else
            mu(k,:) = mu(k-1,:); 
            pi(k,:) = pi(k-1,:);

            muhat(k,:) = muhat(k-1,:);
            pihat(k,:) = pihat(k-1,:);

            v(k,:)  = v(k-1,:);
            w(k,:)  = w(k-1,:);
            da(k,:) = da(k-1,:);
            dau(k) = dau(k-1);
            if isfield(M.(type).tr,'g')
                g(k,:)=g(k-1,:);
            end
            al(k)  = al(k-1);
        end
        
%         % Repack parameters
%         for pn=1:length(pnames)
%             if isfield(M.(type).p,pnames{pn})
%                 (pnames{pn}) = p.(pnames{pn});
%             end
%         end
% 
%         % Repack traj
%         for tn=1:length(tnames)
%             if isfield(M.(type).tr,tnames{tn})
%                 (tnames{tn}) = tr.(tnames{tn});
%             end
%         end
%         
%         % Repack like parameters
%         type='like';
%         for pn=1:length(pnames)
%             if isfield(M.(type).p,pnames{pn})
%                 (pnames{pn}) = p.(pnames{pn});
%             end
%         end
    end
    
    % Joint prediction if more than one model
    if r.c_prc.nModels>1
        
%         % Unpack like parameters
%         type='like';
%         pnames = fieldnames(M.(type).p);
%         for pn=1:length(pnames)
%             p.(pnames{pn}) = (pnames{pn});
%         end
        
        % set alpha
        if ~isfield(M.like.p,'al1')
            al1=al0;
        end
        if u(k,1)==0
            al(k)=al0(u(k,2));
        elseif u(k,1)==1
            al(k)=al1(u(k,2));
        end
        
        v_mu=[];
        v_phi=[];
        v_mu_phi=[];
        for m=1:r.c_prc.nModels

            type = r.c_prc.type{m};
            l(m)=M.(type).l;
            
            % define mu phi
            rep = (r.c_prc.(type).jointrep);
            v_mu(m) = rep(k+r.c_prc.(type).jointrepk,r.c_prc.(type).jointreplev);
            v_phi(m) = phi;
            v_mu_phi(m) = v_phi(m)*v_mu(m);
        
        end
    
        % joint probability
        vj_phi = sum(v_phi);
        vj_mu(k,1) = sum(v_mu_phi)/vj_phi;

        % joint prediction
        rt=exp((eta1-vj_mu(k,1))^2 - (eta0-vj_mu(k,1))^2)/vj_phi^-2;
        xchat(k,1) = 1/(1+rt);
        
        % Likelihood functions: one for each
        % possible signal
        if r.c_prc.n_inputcond >1
            und1 = exp(-(u(k,1) -eta1)^2/(2*al1(u(k,2))));
            und0 = exp(-(u(k,1) -eta0)^2/(2*al0(u(k,2))));
        else
            und1 = exp(-(u(k,1) -eta1)^2/(2*al1));
            und0 = exp(-(u(k,1) -eta0)^2/(2*al0));
        end

        % Update
        xc(k,1) = xchat(k,1) *und1 /(xchat(k,1) *und1 +(1 -xchat(k,1)) *und0);
        
%         % Repack like parameters
%         type='like';
%         for pn=1:length(pnames)
%             if isfield(M.(type).p,pnames{pn})
%                 (pnames{pn}) = p.(pnames{pn});
%             end
%         end
    end
    
end

%% COMPILE RESULTS
al(1)     = [];
 
% joint trajectories (if needed)
vj_mu(1) = [];
xc(1) = [];
xchat(1) = [];

for m=1:r.c_prc.nModels

%     % Unpack likelihood parameters
%     type='like';
%     pnames = fieldnames(M.(type).p);
%     for pn=1:length(pnames)
%         p.(pnames{pn}) = (pnames{pn});
%     end

    type = r.c_prc.type{m};
    l(m)=M.(type).l;
    
%     % Unpack prior parameters
%     pnames = fieldnames(M.(type).p);
%     for pn=1:length(pnames)
%         p.(pnames{pn}) = (pnames{pn});
%     end
% 
%     %Unpack prior traj
%     tnames = fieldnames(M.(type).tr);
%     for tn=1:length(tnames)
%         tr.(tnames{tn}) = (tnames{tn});
%     end

    if l(m)>1
        % Implied learning rate at the first level
        sgmmu2 = tapas_sgm(mu(:,2), 1);
        lr1    = diff(sgmmu2)./da(2:n,1);
        lr1(da(2:n,1)==0) = 0;
    end

    % Remove representation priors
    mu0(1,:)  = [];
    mu(1,:)  = [];
    pi(1,:)  = [];
    % Check validity of trajectories
    if any(isnan(mu(:))) %|| any(isnan(pi(:)))
        error('tapas:hgf:VarApproxInvalid', 'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
    else
        % Check for implausible jumps in trajectories
        % CAB: only use first 500 trials - after that changes in precision become too small
        ntrials = min(length(mu),500);
        dmu = diff(mu(1:ntrials,2:end));
        dpi = diff(pi(1:ntrials,2:end));
        rmdmu = repmat(sqrt(mean(dmu.^2)),length(dmu),1);
        rmdpi = repmat(sqrt(mean(dpi.^2)),length(dpi),1);

        jumpTol = 16;
        if any(abs(dmu(:)) > jumpTol*rmdmu(:)) || any(abs(dpi(:)) > jumpTol*rmdpi(:))
            error('tapas:hgf:VarApproxInvalid', 'Variational approximation invalid. Parameters are in a region where model assumptions are violated.');
            disp('Use plot for diagnosis: see within function'); % plot(abs(dpi(:,2))); hold on; plot(rmdpi(:,2),'r'); hold on; plot(jumpTol*rmdpi(:,2),'g')
        end
    end

    % Remove other dummy initial values
    muhat(1,:) = [];
    pihat(1,:) = [];
    v(1,:)     = [];
    w(1,:)     = [];
    da(1,:)    = [];
    dau(1)     = [];
    if isfield(M.(type).tr,'g')
        g(1,:)  = [];
    end
   

    % Create result data structure
    traj = struct;
    
    traj.like.vj_mu = vj_mu;
    traj.like.xc = xc;
    traj.like.xchat = xchat;

    traj.(type).mu0    = mu0;
    traj.(type).mu     = mu;
    traj.(type).sa     = 1./pi;

    traj.(type).muhat  = muhat;
    traj.(type).sahat  = 1./pihat;
    traj.(type).v      = v;
    traj.(type).w      = w;
    traj.(type).da     = da;
    traj.(type).dau    = dau;
    if isfield(M.(type).tr,'g')
        traj.(type).g     = g;
    end

    % Updates with respect to prediction
    traj.(type).ud = muhat -mu;

    % Psi (precision weights on prediction errors)
    psi        = NaN(n-1,l(m)+1);
    psi(:,1)   = 1./(al.*pi(:,1)); % dot multiply only if al is a vector
    if l(m)>1; psi(:,2)   = 1./pi(:,2);end
    if l(m)>2; psi(:,3:l(m)) = pihat(:,2:l(m)-1)./pi(:,3:l(m));end
    traj.(type).psi   = psi;

    % Epsilons (precision-weighted prediction errors)
    epsi        = NaN(n-1,l(m));
    epsi(:,1)   = psi(:,1) .*dau;
    if l(m)>1; epsi(:,2:l(m)) = psi(:,2:l(m)) .*da(:,1:l(m)-1);end
    traj.(type).epsi   = epsi;

    % Full learning rate (full weights on prediction errors)
    wt        = NaN(n-1,l(m));
    if l(m)==1; lr1=psi(:,1);end
    wt(:,1)   = lr1;
    if l(m)>1; wt(:,2)   = psi(:,2); end
    if l(m)>2; wt(:,3:l(m)) = 1/2 *(v(:,2:l(m)-1) *diag(ka(2:l(m)-1))) .*psi(:,3:l(m)); end
    traj.(type).wt   = wt;

    % Create matrices for use by the observation model
%     infStates = NaN(n-1,l(m),11);
%     infStates(:,:,1) = traj.muhat;
%     infStates(:,:,2) = traj.sahat;
%     infStates(:,:,3) = traj.mu;
%     infStates(:,:,4) = traj.sa;
%     infStates(:,:,5) = traj.da;
%     infStates(:,:,6) = traj.epsi;
%     infStates(:,1,7) = traj.dau;
%     infStates(:,1,8) = traj.mu0;
%     infStates(:,1,9) = traj.vj_mu;
%     infStates(:,1,10) = traj.xc;
%     infStates(:,1,11) = traj.xchat;
end

return;
