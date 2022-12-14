% Author: Santosh Chapaneri

% Demo of Proposed Annotators Strategy for obtaining consensus
clear;clc;close all;
load('ToyAnnDataset.mat');
zt = ToyAnnDataset.Truths;
y = ToyAnnDataset.Claims;

R = size(y,2);  % number of annotators
N = size(y,1); % maximum number of samples
D = 1; % dimension of responses
fPlot = 0;
x = linspace(0,1,N)';

% Determine average annotations 
yavg = zeros(N,D);
for i = 1:N
    for d = 1:D
        T = y(i,:,d);
        idx = ~isnan(T);
        yavg(i,d) = mean(T(idx));
    end
end

% [Yhat,VarAnn] = AnnotatorsConsensus(y,1000);
[Yhat,VarAnn] = AnnotatorsConsensusCI(y,0.05,1000);

%% Run CATD
% load data
load('step_dataset.txt') % name of variable is step_dataset
load('step_ground_truth.txt') % name of variable: step_ground_truth
% set parameters
iteration=2; % number of iterations
alpha=0.05; % significant level

% run CATD
disp('running CATD on');
[truth_minvar,weight]=CATD(step_dataset,iteration,alpha);


%% Compute MSE
sumnorm = 0;
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-yavg(i,:));
end
MSEAvg = sumnorm/size(zt,1)
sumnorm = 0;
CATDYhat = truth_minvar(:,2);
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-CATDYhat(i,:));
end
MSECATD = sumnorm/size(zt,1)
sumnorm = 0;
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-Yhat(i,:));
end
MSEProp = sumnorm/size(zt,1)

% figure;
for d = 1:D
    figure;
%     subplot(2,1,d);
    set(gcf,'color','white');
    hold on; grid on;
    plot(x,zt(:,d),'kd-','LineWidth',2);
    plot(x,Yhat(:,d),'r+--','LineWidth',1.5);
    plot(x,yavg(:,d),'bd--','LineWidth',1.5);
    plot(x,CATDYhat(:,d),'gs-','LineWidth',1.5);
    axis([min(x) max(x) floor(nanmin(nanmin(y(:,:,d)))) ceil(nanmax(nanmax(y(:,:,d))))+1]);
    strTitle = sprintf('MSE Average = %0.4f, MSE Proposed = %0.4f',MSEAvg,MSEProp);
    title(strTitle);
    legend('True','Proposed','Avg','CATD');
    legend('Location','Northwest')
    box;
end

