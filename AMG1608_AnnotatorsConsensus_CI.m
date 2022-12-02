% Author: Santosh Chapaneri

clear;clc;
%% Load the data
load('MyMoodDataAMG1608_X_Y.mat');
Y(:,:,1) = AMG1608MoodData.Y_Valence; Y(:,:,2) = AMG1608MoodData.Y_Arousal;
alpha = 0.05; % Significance level, i.e. we are 95% confident of results
[Yhat_CI, VarAnn_CI, VarAnnLB_CI] = AnnotatorsConsensusCI(Y,alpha,1000);
% Proposed Annotations: Generate "estimated" gold standard using proposed multi-annotator
% regression model
% We are going to use this output as "estimated gold standard" and BONUS: we
% also know the variance of each annotator

% Save the consensus targets and variance
AMG1608AnnotatorsConsensusCIWM.YValence = Yhat_CI(:,1);
AMG1608AnnotatorsConsensusCIWM.YArousal = Yhat_CI(:,2);
AMG1608AnnotatorsConsensusCIWM.VarAnn = VarAnn_CI;
AMG1608AnnotatorsConsensusCIWM.VarAnnLB = VarAnnLB_CI;
save('AMG1608AnnotatorsConsensusCIWM.mat','AMG1608AnnotatorsConsensusCIWM');
% NOTE: AMG1608AnnotatorsConsensusCIWM.mat is FINAL result of Truth Discovery
% Analysis: 11 Dec 2016, 11 pm
% STOP here, DO NOT proceed below; it is just for testing

% load('AMG1608AnnotatorsConsensus.mat');
% YhatValence = AMG1608AnnotatorsConsensus.YValence;
% YhatArousal = AMG1608AnnotatorsConsensus.YArousal;
% figure; set(gcf,'color','white');
% scatter(YhatValence,YhatArousal);grid on;axis([-1 1 -1 1]);
% for i=1:length(YhatValence)
%     text(YhatValence(i)+0.02,YhatArousal(i)+0.02,num2str(i),'FontSize',11);
% end

%% Load data without Outliers obtained using FastMCD
load('AMG1608MoodDataNoOutliers.mat');
YMCD(:,:,1) = AMG1608MoodDataNoOutliers.Y_Valence_NoOutliers; 
YMCD(:,:,2) = AMG1608MoodDataNoOutliers.Y_Arousal_NoOutliers;
[YhatMCD_CI, VarAnnMCD_CI] = AnnotatorsConsensusCI(YMCD,alpha,1000);

% Save the consensus targets and variance
AMG1608AnnotatorsConsensusMCD_CI.YValence = YhatMCD_CI(:,1);
AMG1608AnnotatorsConsensusMCD_CI.YArousal = YhatMCD_CI(:,2);
AMG1608AnnotatorsConsensusMCD_CI.VarAnn = VarAnnMCD_CI;
save('AMG1608AnnotatorsConsensusMCD_CI.mat','AMG1608AnnotatorsConsensusMCD_CI');

% load('AMG1608AnnotatorsConsensusMCD.mat');
% YhatMCDValence = AMG1608AnnotatorsConsensusMCD.YValence;
% YhatMCDArousal = AMG1608AnnotatorsConsensusMCD.YArousal;
% figure; set(gcf,'color','white');
% scatter(YhatMCDValence,YhatMCDArousal);grid on;axis([-1 1 -1 1]);
% for i=1:length(YhatValence)
%     text(YhatMCDValence(i)+0.02,YhatMCDArousal(i)+0.02,num2str(i),'FontSize',11);
% end

%% Load data without Outliers obtained using Classical Mahalanobis
load('AMG1608MoodDataNoOutliersMahal.mat');
YMahal(:,:,1) = AMG1608MoodDataNoOutliersMahal.Y_Valence_NoOutliersMahal; 
YMahal(:,:,2) = AMG1608MoodDataNoOutliersMahal.Y_Arousal_NoOutliersMahal;
[YhatMahal_CI, VarAnnMahal_CI] = AnnotatorsConsensusCI(YMahal,alpha,1000);

% Save the consensus targets and variance
AMG1608AnnotatorsConsensusMahal_CI.YValence = YhatMahal_CI(:,1);
AMG1608AnnotatorsConsensusMahal_CI.YArousal = YhatMahal_CI(:,2);
AMG1608AnnotatorsConsensusMahal_CI.VarAnn = VarAnnMahal_CI;
save('AMG1608AnnotatorsConsensusMahal_CI.mat','AMG1608AnnotatorsConsensusMahal_CI');

%% Observations:
% Mahal technique results are almost identical to regular technique, i.e. first part above
% However, MCD technique seems to give "better" results
