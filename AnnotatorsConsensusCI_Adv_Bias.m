% Author: Santosh Chapaneri

function [Yhat,f_WhoIsAdversary,VarAnn,VarAnnLB] = AnnotatorsConsensusCI_Adv_Bias(Y, alpha, maxIter)
% Obtain consensus to estimate gold standard (no dependency on features)
% Can also handle missing annotations
% Input Y is Tensor : N x M x D, where N is number of instances, M is
% number of annotators, D is dimension of annotation responses, here D = 2,
% i.e. (valence, arousal) values for each instance

N = size(Y,1); % number of instances
R = size(Y,2); % number of annotators
D = size(Y,3); % dimension of responses, here D = 2 (V, A)

%% Initialize EM algorithm 
% Init y with median of the data
Yhat = zeros(N,D);
for i = 1:N
    for d = 1:D
        T = Y(i,:,d);
        idx = ~isnan(T);
        Yhat(i,d) = median(T(idx));
%         stderror(i,d) = std(T(idx));
    end
end

% Init bias
sB = 0.1; muB = 0;
% bias = zeros(R, 1);
% how far is mth annotator away from median?
for m = 1:R
    T = Y(:,m,1); % 1st dimension is ok to check, others would be similar
    idx = ~isnan(T);
    bias(m,1) = mean(T(idx,1) - Yhat(idx,1));
end


% Init reliability of each annotator from data
for m = 1:R
    for d = 1:1
        T = Y(:,m,d);
        idx = ~isnan(T);
        VarAnn_tmp(m,d) = var(T(idx));
    end
end
VarAnn = mean(VarAnn_tmp,2);

% Init adversariness
adv = zeros(R,1);
for m = 1:R
    T = Y(:,m,1); % same indices in both dimensions i.e. V and A together given by a single annotator
    idx = find(~isnan(T));
    for d = 1:D
        Z = Y(idx,m,d);
    end
    for k = 1:numel(idx)
        adv(m) = adv(m) + sum( Z(k) .* (Yhat(idx(k),:) + bias(m)) );
    end
    adv(m) = sign(adv(m));
    clear Z;
end

% a=-1; b=1; Yhat = a + (b-a).*rand(N,D);
% VarAnn = zeros(1,R); % initialize %% See above, initialized from data
VarAnnLB = zeros(R,1); % initialize 

% stopCr = 1e-8; % stopping criterion
stopCr = 1e-6; % stopping criterion
oldYhat = zeros(N,D); oldVar = 0;

for iter=1:maxIter
    
    % Compute Variance of each Annotator
    for m=1:R
        T = Y(:,m,1); % same indices in both dimensions i.e. V and A together given by a single annotator
        idx = find(~isnan(T));
        for d = 1:D
            Z(:,d) = Y(idx,m,d);
        end
        
        % Update bias of mth annotator
        num = 0;
        for k = 1:numel(idx)
            num = num + adv(m)*norm(Z(k,:)) - norm(Yhat(idx(k),:)) + VarAnn(m)*muB/sB;
        end
        den = numel(idx) + VarAnn(m)/sB;
        bias(m) = num/den;

        % Update adversariness of mth annotator
        adv(m) = 0;
        for k = 1:numel(idx)
            adv(m) = adv(m) + sum( Z(k,:) .* (Yhat(idx(k),:) + bias(m)) );
        end
        adv(m) = sign(adv(m));
        
        
        sumnorm = 0;
        for k = 1:numel(idx)
%             sumnorm = sumnorm + (norm(Z(k,:) - Yhat(idx(k),:))/stderror(idx(k),1));
            sumnorm = sumnorm + norm( Z(k,:) - adv(m)*(Yhat(idx(k),:)+bias(m)) );
        end
        % Using Upper Bound of Confidence Interval with Chi-square
        % distribution
%         VarAnn(m) = sumnorm/chi2inv(alpha,numel(idx));
        % Avoid VarAnn(m) = 0 to avoid division by zero in Yhat computation
        VarAnn(m) = (sumnorm+0.0001)/chi2inv(alpha,numel(idx));
        VarAnnLB(m) = (sumnorm+0.0001)/chi2inv(1-alpha,numel(idx));
%         VarAnn(m) = sumnorm/numel(idx);
        clear Z;
    end

    % Compute Yhat (estimated gold standard)
    for i = 1:N
        for d=1:D
            T = Y(i,:,d);
            idx = find(~isnan(T));
            Dval = adv(idx)'.*Y(i,idx,d) - bias(idx)';
            Wval = 1./VarAnn(idx);
            % Use of weighted median automatically takes care of outlier
            % responses by some annotators; thus, no need of taking care of
            % removing outliers separately; whereas, with weighted average
            % must use MCD to remove outliers, since weighted average is
            % sensitive to outliers and weighted median is robust to
            % outliers
            Yhat(i,d) = weightedMedian(Dval', Wval);
%             Yhat(i,d) = sum((1./VarAnn(idx)*Y(i,idx,d)'))/sum(1./VarAnn(idx));
        end
    end
    
	delta_Yhat = 0;
    for i = 1:size(Yhat,1)
        delta_Yhat = delta_Yhat + norm(Yhat(i,:)-oldYhat(i,:),1); % sum of element magnitudes
    end
    delta_VarAnn = sum(abs(VarAnn-oldVar));
    
    oldVar = VarAnn; oldYhat = Yhat;
   
    fprintf('iter:%d\t delta_Yhat:%.6f\t delta_var:%.12f\n',iter,delta_Yhat,delta_VarAnn);
    if delta_Yhat<stopCr && delta_VarAnn<stopCr || iter==maxIter
        fprintf('converged after %d iters\n',iter);
        f_WhoIsAdversary = (adv==-1); % 1 if adversary, 0 else
        break;
    end
    
end
end

