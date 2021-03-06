% pop_logisticregression() - Determine linear discriminating vector between two datasets.
%                            using logistic regression.
%
% Usage:
%   >> pop_logisticregression( ALLEEG, datasetlist, chansubset, chansubset2, trainingwindowlength, trainingwindowoffset, regularize, lambda, lambdasearch, eigvalratio, vinit, show,LOO);
%
% Inputs:
%   ALLEEG               - array of datasets
%   datasetlist          - list of datasets
%   chansubset           - vector of channel subset for dataset 1          [1:min(Dset1,Dset2)]
%   chansubset2          - vector of channel subset for dataset 2          [chansubset]
%   trainingwindowlength - Length of training window in samples            [all]
%   trainingwindowoffset - Offset(s) of training window(s) in samples      [1]
%   regularize           - regularize [1|0] -> [yes|no]                    [0]
%   lambda               - regularization constant for weight decay.       [1e-6]
%                            Makes logistic regression into a support 
%                            vector machine for large lambda
%                            (cf. Clay Spence)
%   lambdasearch         - [1|0] -> search for optimal regularization 
%                            constant lambda
%   eigvalratio          - if the data does not fill D-dimensional
%                            space, i.e. rank(x)<D, you should specify 
%                            a minimum eigenvalue ratio relative to the 
%                            largest eigenvalue of the SVD.  All dimensions 
%                            with smaller eigenvalues will be eliminated 
%                            prior to the discrimination. 
%   vinit                - initialization for faster convergence           [zeros(D+1,1)]
%   show                 - display discrimination boundary during training [0]
%
% References:
%
% @article{gerson2005,
%       author = {Adam D. Gerson and Lucas C. Parra and Paul Sajda},
%       title = {Cortical Origins of Response Time Variability
%                During Rapid Discrimination of Visual Objects},
%       journal = {{NeuroImage}},
%       year = {in revision}}
%
% @article{parra2005,
%       author = {Lucas C. Parra and Clay D. Spence and Adam Gerson 
%                 and Paul Sajda},
%       title = {Recipes for the Linear Analysis of {EEG}},
%       journal = {{NeuroImage}},
%       year = {in revision}}
%
% Authors: Adam Gerson (adg71@columbia.edu, 2004),
%          with Lucas Parra (parra@ccny.cuny.edu, 2004)
%          and Paul Sajda (ps629@columbia,edu 2004)

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2004 Adam Gerson, Lucas Parra and Paul Sajda
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% 5/21/2005, Fixed bug in leave one out script, Adam

function [ALLEEG, com] = pop_logisticregression(ALLEEG, setlist, chansubset, chansubset2, trainingwindowlength, trainingwindowoffset, regularize, lambda, lambdasearch, eigvalratio, vinit, show,LOO);

showaz=1;
com = '';
if nargin < 1
    help pop_logisticregression;
    return;
end;   
if isempty(ALLEEG)
    error('pop_logisticregression(): cannot process empty sets of data');
end;
if nargin < 2
    % which set to save
    % -----------------
    uilist = { { 'style' 'text' 'string' 'Enter two datasets to compare (ex: 1 3):' } ...
            { 'style' 'edit' 'string' [ '1 2' ] } ... 
            { 'style' 'text' 'string' 'Enter channel subset ([] = all):' } ...
            { 'style' 'edit' 'string' '' } ... 
            { 'style' 'text' 'string' 'Enter channel subset for dataset 2 ([] = same as dataset 1):' } ...
            { 'style' 'edit' 'string' '' } ... 
            { 'style' 'text' 'string' 'Training Window Length (samples [] = all):' } ...
            { 'style' 'edit' 'string' '50' } ... 
            { 'style' 'text' 'string' 'Training Window Offset (samples, 1 = epoch start):' } ...
            { 'style' 'edit' 'string' '1' } ... 
            { 'style' 'text' 'string' 'Regularize' } ...
            { 'style' 'checkbox' 'string' '' 'value' 0 } {} ...
            { 'style' 'text' 'string' 'Regularization constant for weight decay' } ...
            { 'style' 'edit' 'string' '1e-6' } ... 
            { 'style' 'text' 'string' 'Search for optimal regularization constant' } ...
            { 'style' 'checkbox' 'string' '' 'value' 0 } {} ...
            { 'style' 'text' 'string' 'Eigenvalue ratio for subspace reduction' } ...
            { 'style' 'edit' 'string' '1e-6' } ...
            { 'style' 'text' 'string' 'Initial discrimination vector [channels+1 x 1] for faster convergence (optional)' } ...
            { 'style' 'edit' 'string' '' } ...                    
            { 'style' 'text' 'string' 'Display discrimination boundary' } ...
            { 'style' 'checkbox' 'string' '' 'value' 0 } {} ...
            { 'style' 'text' 'string' 'Leave One Out' } ...
            { 'style' 'checkbox' 'string' '' 'value' 0 } {} };
    
    result = inputgui( { [2 .5] [2 .5] [2 .5] [2 .5] [2 .5] [3.1 .4 .15] [2 .5] [3.1 .4 .15] [2 .5] [2 .5] [3.1 .4 .15] [3.1 .4 .15] }, ...
        uilist, 'pophelp(''pop_logisticregression'')', ...
        'Logistic Regression -- pop_logisticregression()');           
    
    if length(result) == 0 return; end;
    setlist   	 = eval( [ '[' result{1} ']' ] );
    chansubset   = eval( [ '[' result{2} ']' ] );
    if isempty( chansubset ), chansubset = 1:min(ALLEEG(setlist(1)).nbchan,ALLEEG(setlist(2)).nbchan); end;
    
    chansubset2  = eval( [ '[' result{3} ']' ] );
    if isempty(chansubset2), chansubset2=chansubset; end
    
    trainingwindowlength    = str2num(result{4});
    if isempty(trainingwindowlength)
        trainingwindowlength = ALLEEG(setlist(1)).pnts;
    end;
    trainingwindowoffset    = str2num(result{5});
    if isempty(trainingwindowoffset)
        trainingwindowoffset = 1;
    end;
    regularize=result{6};
    if isempty(regularize),
        regularize=0;    
    end
    lambda=str2num(result{7});
    if isempty(lambda),
        lambda=1e-6;
    end
    lambdasearch=result{8};
    if isempty(lambdasearch),
        lambdasearch=0;    
    end
    eigvalratio=str2num(result{9});
    if isempty(eigvalratio),
        eigvalratio=1e-6;
    end    
    vinit=eval([ '[' result{10} ']' ]);
    if isempty(vinit),
        vinit=zeros(length(chansubset)+1,1);
    end
    vinit=vinit(:); % Column vector
    show=result{11};
    if isempty(show),
        show=0;    
    end
    LOO=result{12};
    if isempty(LOO),
        show=0;    
    end
    
end;

try, icadefs; set(gcf, 'color', BACKCOLOR); catch, end;

if max(trainingwindowlength+trainingwindowoffset-1)>ALLEEG(setlist(1)).pnts,
    error('pop_logisticregression(): training window exceeds length of dataset 1');
end
if max(trainingwindowlength+trainingwindowoffset-1)>ALLEEG(setlist(2)).pnts,
    error('pop_logisticregression(): training window exceeds length of dataset 2');
end
if (length(chansubset)~=length(chansubset2)),
    error('Number of channels from each dataset must be equal.');
end

truth=[zeros(trainingwindowlength.*ALLEEG(setlist(1)).trials,1); ones(trainingwindowlength.*ALLEEG(setlist(2)).trials,1)];

ALLEEG(setlist(1)).icaweights=zeros(length(trainingwindowoffset),ALLEEG(setlist(1)).nbchan);
ALLEEG(setlist(2)).icaweights=zeros(length(trainingwindowoffset),ALLEEG(setlist(2)).nbchan);

% In case a subset of channels are used, assign unused electrodes in scalp projection to NaN
ALLEEG(setlist(1)).icawinv=nan.*ones(length(trainingwindowoffset),ALLEEG(setlist(1)).nbchan)';
ALLEEG(setlist(2)).icawinv=nan.*ones(length(trainingwindowoffset),ALLEEG(setlist(2)).nbchan)';
ALLEEG(setlist(1)).icasphere=eye(ALLEEG(setlist(1)).nbchan);
ALLEEG(setlist(2)).icasphere=eye(ALLEEG(setlist(2)).nbchan);

for i=1:length(trainingwindowoffset),
    x=cat(3,ALLEEG(setlist(1)).data(chansubset,trainingwindowoffset(i):trainingwindowoffset(i)+trainingwindowlength-1,:), ...
        ALLEEG(setlist(2)).data(chansubset,trainingwindowoffset(i):trainingwindowoffset(i)+trainingwindowlength-1,:));
    x=x(:,:)'; % Rearrange data for logist.m [D (T x trials)]'
    %v=logist(x,truth)';
    
    v = logist(x,truth,vinit,show,regularize,lambda,lambdasearch,eigvalratio);
    y = x*v(1:end-1) + v(end);
    bp = bernoull(1,y);
    
    [Az,Ry,Rx] = rocarea(bp,truth); if showaz, fprintf('Window Onset: %d; Az: %6.2f\n',trainingwindowoffset(i),Az); end
    
    a = y \ x;
    
    asetlist1=y(1:trainingwindowlength.*ALLEEG(setlist(1)).trials) \ x(1:trainingwindowlength.*ALLEEG(setlist(1)).trials,:);
    asetlist2=y(trainingwindowlength.*ALLEEG(setlist(1)).trials+1:end) \ x(trainingwindowlength.*ALLEEG(setlist(1)).trials+1:end,:);
    
    
    ALLEEG(setlist(1)).icaweights(i,chansubset)=v(1:end-1)';
    ALLEEG(setlist(2)).icaweights(i,chansubset2)=v(1:end-1)';
    ALLEEG(setlist(1)).icawinv(chansubset,i)=a'; % consider replacing with asetlist1
    ALLEEG(setlist(2)).icawinv(chansubset2,i)=a'; % consider replacing with asetlist2
    
    
    if LOO
        % LOO
        clear y;
        N=ALLEEG(setlist(1)).trials+ALLEEG(setlist(2)).trials;
        ploo=zeros(N*trainingwindowlength,1);
        
        for looi=1:length(x)./trainingwindowlength,
            indx=ones(N*trainingwindowlength,1);
            indx((looi-1)*trainingwindowlength+1:looi*trainingwindowlength)=0;
            tmp = x(find(indx),:); % LOO data
            tmpt = [truth(find(indx))];   % Target
            
            vloo(:,looi)=logist(tmp,tmpt,vinit,show,regularize,lambda,lambdasearch,eigvalratio);
            y(:,looi) = [x((looi-1)*trainingwindowlength+1:looi*trainingwindowlength,:) ones(trainingwindowlength,1)]*vloo(:,looi);
            
            ymean(looi)=mean(y(:,looi));
            
            %      ploo(find(1-indx)) = bernoull(1,y(:,looi));
            
            ploo((looi-1)*trainingwindowlength+1:looi*trainingwindowlength) = bernoull(1,y(:,looi));
            ploomean(looi)=bernoull(1,ymean(looi));
            
        end
        truthmean=([zeros(ALLEEG(setlist(1)).trials,1); ones(ALLEEG(setlist(2)).trials,1)]);
        [Azloo,Ryloo,Rxloo] = rocarea(ploo,truth);
        [Azloomean,Ryloomean,Rxloomean,fract_correct] = rocarea(ploomean,truthmean);
        fprintf('LOO Az: %6.2f\n Correct: %6.2f\n',Azloomean,fract_correct);
        
    end
    
    if 0
        ALLEEG(setlist(1)).lrweights(i,:)=v;
        ALLEEG(setlist(1)).lrweightsinv(:,i)=pinv(v);
        ALLEEG(setlist(2)).lrweights(i,:)=v;
        ALLEEG(setlist(2)).lrweightsinv(:,i)=pinv(v);
        
        ALLEEG(setlist(1)).lrsources(i,:,:)=shiftdim(reshape(v*[ALLEEG(setlist(1)).data(:,:); ones(1,ALLEEG(setlist(1)).pnts.*ALLEEG(setlist(1)).trials)], ...
            ALLEEG(setlist(1)).pnts,ALLEEG(setlist(1)).trials),-1);
        ALLEEG(setlist(2)).lrsources(i,:,:)=shiftdim(reshape(v*[ALLEEG(setlist(2)).data(:,:); ones(1,ALLEEG(setlist(2)).pnts.*ALLEEG(setlist(2)).trials)], ...
            ALLEEG(setlist(2)).pnts,ALLEEG(setlist(2)).trials),-1);    
    end
    
end;

if 0
    ALLEEG(setlist(1)).lrtrainlength=trainingwindowlength;
    ALLEEG(setlist(1)).lrtrainoffset=trainingwindowoffset;
    ALLEEG(setlist(2)).lrtrainlength=trainingwindowlength;
    ALLEEG(setlist(2)).lrtrainoffset=trainingwindowoffset;
end


% save channel names
% ------------------
%plottopo( tracing, ALLEEG(setlist(1)).chanlocs, ALLEEG(setlist(1)).pnts, [ALLEEG(setlist(1)).xmin ALLEEG(setlist(1)).xmax 0 0]*1000, plottitle, chansubset );

% recompute activations (temporal sources) and check dataset integrity

eeg_options; 
for i=1:2,
    if option_computeica
        ALLEEG(setlist(i)).icaact    = (ALLEEG(setlist(i)).icaweights*ALLEEG(setlist(i)).icasphere)*reshape(ALLEEG(setlist(i)).data, ALLEEG(setlist(i)).nbchan, ALLEEG(setlist(i)).trials*ALLEEG(setlist(i)).pnts);
        ALLEEG(setlist(i)).icaact    = reshape( ALLEEG(setlist(i)).icaact, size(ALLEEG(setlist(i)).icaact,1), ALLEEG(setlist(i)).pnts, ALLEEG(setlist(i)).trials);
    end;
end

for i=1:2, [ALLEEG]=eeg_store(ALLEEG,ALLEEG(setlist(i)),setlist(i)); end

com = sprintf('pop_logisticregression( %s, [%s], [%s], [%s], [%s]);', inputname(1), num2str(setlist), num2str(chansubset), num2str(trainingwindowlength), num2str(trainingwindowoffset));
fprintf('Done.\n');
return;
