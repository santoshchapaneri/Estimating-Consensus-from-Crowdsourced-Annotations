% Author: Santosh Chapaneri

clear;clc;
%% Load the data
load('MyMoodDataAMG1608_X_Y.mat');
Y(:,:,1) = AMG1608MoodData.Y_Valence; Y(:,:,2) = AMG1608MoodData.Y_Arousal;
alpha = 0.05; % Significance level, i.e. we are 95% confident of results
[Yhat_CI, f_WhoIsAdversary, VarAnn_CI, VarAnnLB_CI] = AnnotatorsConsensusCI_Adv_Bias2(Y,alpha,50);
[Yhat_NA, VarAnn_NA] = AnnotatorsConsensus(Y,1000);
disp('Adversaries are:');
adv_AMG = find(f_WhoIsAdversary==1)

%% Load the DEAM ratings data
load('AllSongRatingsDEAM.mat'); % 1802 x 194 x 2 (V, A)
clear Y;
Y(:,:,1) = AllSongRatingsDEAM(:,:,1); Y(:,:,2) = AllSongRatingsDEAM(:,:,2);
alpha = 0.05; % Significance level, i.e. we are 95% confident of results
[Yhat_CI_DEAM, f_WhoIsAdversary_DEAM, VarAnn_CI_DEAM, VarAnnLB_CI_DEAM] = AnnotatorsConsensusCI_Adv_Bias2(Y,alpha,50);
[Yhat_NA_DEAM, VarAnn_NA_DEAM] = AnnotatorsConsensus(Y,1000);
disp('DEAM Adversaries are:');
adv_DEAM = find(f_WhoIsAdversary_DEAM==1)


%
% AMG Adversaries are:
%      2     5    58   106   112   172   209   247   323   346   361   370   468
%     535   597   612   613   622   635
%    
% DEAM Adversaries are:
%     39   168   178   186   194