% Author: Santosh Chapaneri

clear;clc;

%% Load the data
load('MyMoodDataAMG1608_X_Y.mat');
Y(:,:,1) = AMG1608MoodData.Y_Valence; Y(:,:,2) = AMG1608MoodData.Y_Arousal;
[Yhat, VarAnn] = AnnotatorsConsensus(Y,1000);
% Proposed Annotations: Generate "estimated" gold standard using proposed multi-annotator
% regression model
% We are going to use this output as "estimated gold standard" and BONUS: we
% also know the variance of each annotator

% Save the consensus targets and variance
AMG1608AnnotatorsConsensus.YValence = Yhat(:,1);
AMG1608AnnotatorsConsensus.YArousal = Yhat(:,2);
AMG1608AnnotatorsConsensus.VarAnn = VarAnn;
save('AMG1608AnnotatorsConsensus.mat','AMG1608AnnotatorsConsensus');
% 
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
[YhatMCD, VarAnnMCD] = AnnotatorsConsensus(YMCD,1000);

% Save the consensus targets and variance
AMG1608AnnotatorsConsensusMCD.YValence = YhatMCD(:,1);
AMG1608AnnotatorsConsensusMCD.YArousal = YhatMCD(:,2);
AMG1608AnnotatorsConsensusMCD.VarAnn = VarAnnMCD;
save('AMG1608AnnotatorsConsensusMCD.mat','AMG1608AnnotatorsConsensusMCD');

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
[YhatMahal, VarAnnMahal] = AnnotatorsConsensus(YMahal,1000);

% Save the consensus targets and variance
AMG1608AnnotatorsConsensusMahal.YValence = YhatMahal(:,1);
AMG1608AnnotatorsConsensusMahal.YArousal = YhatMahal(:,2);
AMG1608AnnotatorsConsensusMahal.VarAnn = VarAnnMahal;
save('AMG1608AnnotatorsConsensusMahal.mat','AMG1608AnnotatorsConsensusMahal');

%% Observations:
% Mahal technique results are almost identical to regular technique, i.e. first part above
% However, MCD technique seems to give "better" results
