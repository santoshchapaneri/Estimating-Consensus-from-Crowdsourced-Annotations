% Author: Santosh Chapaneri

clc; clear all; close all;
% Load the data
load('MyMoodDataAMG1608_X_Y.mat')

%% Determine Outliers as per FastMCD
YV = AMG1608MoodData.Y_Valence;
YA = AMG1608MoodData.Y_Arousal;
YVO = YV; YAO = YA;
Outliers = cell(1,size(YV,1)); % 1 x 1608 cell
count = 0;
for idx = 1:size(YV,1)
    fprintf('Song %d\n',idx);
    zV = YV(idx,:);
    zA = YA(idx,:);
%     % Classicial outlier detection
%     zVM=zV(~isnan(zV)); zAM=zA(~isnan(zA));
%     zM = [zVM',zAM'];
%     figure;scatter(zVM,zAM); 
%     axis([-1.5 1.5 -1.5 1.5]);
%     set(gcf,'color','white');
%     box; grid on;
%     out = moutlier1(zM,0.10);
%     if numel(out) > 0
%         out1 = out;
%     end
%     count = count + numel(out);
    % Use FastMCD to determine outliers
    z = [zV',zA'];
%     figure; 
    [res,raw]=fastmcd(z);
    axis([-1.5 1.5 -1.5 1.5]);
    set(gcf,'color','white');
    box; grid on;
    idxOutlier = find(res.flag2==0);
    Outliers{idx} = idxOutlier;
    % Remove these outliers
    YVO(idx,idxOutlier)=NaN;YAO(idx,idxOutlier)=NaN;
%     zVT=zV(~isnan(zV));
%     fprintf('Total Annotators = %d\n',numel(zVT));
%     fprintf('Outliers=%d\n', idxOutlier);
%     pause;
%     close all;
end

%% Save the data without outliers
AMG1608MoodDataNoOutliers.Y_Valence_NoOutliers = YVO;
AMG1608MoodDataNoOutliers.Y_Arousal_NoOutliers = YAO;
AMG1608MoodDataNoOutliers.Outliers = Outliers;
save('AMG1608MoodDataNoOutliers.mat','AMG1608MoodDataNoOutliers');
fCheck = 0;

%% Just checking
if fCheck
    load('MyMoodDataAMG1608_X_Y.mat');
    YV = AMG1608MoodData.Y_Valence;
    YA = AMG1608MoodData.Y_Arousal;
    load('AMG1608MoodDataNoOutliers.mat');
    YVO = AMG1608MoodDataNoOutliers.Y_Valence_NoOutliers;
    YAO = AMG1608MoodDataNoOutliers.Y_Arousal_NoOutliers;
    for idx=58:1608
    %     close all; 
        subplot(2,1,1);
        scatter(YV(idx,:),YA(idx,:));axis([-1 1 -1 1]);grid on;
        subplot(2,1,2);
        scatter(YVO(idx,:),YAO(idx,:));axis([-1 1 -1 1]);grid on;
        set(gcf,'color','white'); box;
        screen_size = get(0, 'ScreenSize');
        set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to screen size
    %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        strTitle = sprintf('Song %d',idx);
        title(strTitle);
        pause;
    end
end

% T1=isnan(YV);length(find(T1==0))
% 26914
% T2=isnan(YVO);length(find(T2==0))
% 25127
% 
% 1787 outliers have been removed by FastMCD algorithm
