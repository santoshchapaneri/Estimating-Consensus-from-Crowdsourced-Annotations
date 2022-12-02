% Author: Santosh Chapaneri

% Demo of Proposed Annotators Strategy for obtaining consensus
clear;clc;close all;
R = 7;  % number of annotators
N = 4; % maximum number of samples
D = 2; % dimension of responses
fPlot = 0;
% Data
y(:,:,1) = [1, 1.1, 0.9, NaN, 5, NaN, NaN;3, 3.1, -3, -3.1, 5, -2.9, -3.05;1, 0.9, NaN, 1.1, -5, NaN, NaN;0.95, 1, NaN, 1.05, 5, NaN, NaN];
y(:,:,2) = [1, 1.1, 0.9, NaN, 5, NaN, NaN;3, 3.1, -3, -3.1, 5, -2.9, -3.05;1, 0.9, NaN, 1.1, -5, NaN, NaN;0.95, 1, NaN, 1.05, 5, NaN, NaN];
% Ground Truth
zt = [1;1;1;1];

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

% Compute MSE
sumnorm = 0;
for i = 1:size(zt,1)
    sumnorm = sumnorm + norm(zt(i,:)-yavg(i,:));
end
MSEAvg = sumnorm/size(zt,1)
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
    axis([min(x) max(x) floor(nanmin(nanmin(y(:,:,d)))) ceil(nanmax(nanmax(y(:,:,d))))+1]);
    strTitle = sprintf('MSE Average = %0.4f, MSE Proposed = %0.4f',MSEAvg,MSEProp);
    strVar = sprintf('Variance: ');
    strTrueVar = sprintf('TrueVar: ');
    for m = 1:R
        strVar = strcat(strVar,32,32,sprintf('%0.4f',VarAnn(m)));
        strTrueVar = strcat(strTrueVar,32,32,sprintf('%0.4f',exp(noise(m))));
    end

    if d==1
        title(char(strTitle,char(strVar,strTrueVar)),'FontSize',12);
    end
    legend('True','Proposed','Avg');
    legend('Location','Northwest')
    box;
end

