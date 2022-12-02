% Author: Santosh Chapaneri

% How many and which outliers detected by Classical technique?

clc; clear all; close all;
% Load the data
load('MyMoodDataAMG1608_X_Y.mat');

%% Determine Outliers as per Classical Mahalanobis distance technique
YV = AMG1608MoodData.Y_Valence;
YA = AMG1608MoodData.Y_Arousal;
YVO = YV; YAO = YA;
Outliers = cell(1,size(YV,1)); % 1 x 1608 cell
count = 0;
for idx = 1:size(YV,1)
    fprintf('Song %d\n',idx);
    zV = YV(idx,:);
    zA = YA(idx,:);
    % Classicial outlier detection
    zVM=zV(~isnan(zV)); zAM=zA(~isnan(zA));
    indFin = find(~isnan(zV));
    zM = [zVM',zAM'];
%     figure;scatter(zVM,zAM); 
%     axis([-1.5 1.5 -1.5 1.5]);
%     set(gcf,'color','white');
%     box; grid on;
    out = moutlier1(zM,0.10);
    Outliers{idx} = out;
    YVO(idx,out) = NaN; YAO(idx,out) = NaN;
    count = count + numel(out);
end

% 376 outliers have been removed by Classical algorithm
%% Save the data without outliers
AMG1608MoodDataNoOutliersMahal.Y_Valence_NoOutliersMahal = YVO;
AMG1608MoodDataNoOutliersMahal.Y_Arousal_NoOutliersMahal = YAO;
AMG1608MoodDataNoOutliersMahal.Outliers = Outliers;
save('AMG1608MoodDataNoOutliersMahal.mat','AMG1608MoodDataNoOutliersMahal');
fCheck = 0;

%% Just checking
if fCheck
    load('MyMoodDataAMG1608_X_Y.mat');
    YV = AMG1608MoodData.Y_Valence;
    YA = AMG1608MoodData.Y_Arousal;
    load('AMG1608MoodDataNoOutliers.mat');
    YVO = AMG1608MoodDataNoOutliers.Y_Valence_NoOutliers;
    YAO = AMG1608MoodDataNoOutliers.Y_Arousal_NoOutliers;
    load('AMG1608MoodDataNoOutliersMahal.mat');
    YVOM = AMG1608MoodDataNoOutliersMahal.Y_Valence_NoOutliersMahal;
    YAOM = AMG1608MoodDataNoOutliersMahal.Y_Arousal_NoOutliersMahal;
    for idx=1:1608
    %     close all; 
        subplot(3,1,1);
        scatter(YV(idx,:),YA(idx,:));axis([-1 1 -1 1]);grid on;
        strTitle = sprintf('Song %d',idx);
        title(strTitle);
        subplot(3,1,2);
        scatter(YVO(idx,:),YAO(idx,:));axis([-1 1 -1 1]);grid on;
        title('MCD');
        subplot(3,1,3);
        scatter(YVOM(idx,:),YAOM(idx,:));axis([-1 1 -1 1]);grid on;
        title('Mahalanobis');
        set(gcf,'color','white'); box;
        screen_size = get(0, 'ScreenSize');
        set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to screen size
    %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        pause;
    end
end