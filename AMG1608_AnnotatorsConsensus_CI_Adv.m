% Author: Santosh Chapaneri

clear;clc;
%% Load the data
load('MyMoodDataAMG1608_X_Y.mat');
Y(:,:,1) = AMG1608MoodData.Y_Valence; Y(:,:,2) = AMG1608MoodData.Y_Arousal;
alpha = 0.05; % Significance level, i.e. we are 95% confident of results
[Yhat_CI_Adv, f_WhoIsAdversary, VarAnn_CI_Adv, VarAnnLB_CI_Adv] = AnnotatorsConsensusCI_Adv(Y,alpha,1000);
[Yhat_CI_AdvB, f_WhoIsAdversaryB, VarAnn_CI_AdvB, VarAnnLB_CI_AdvB] = AnnotatorsConsensusCI_Adv_Bias(Y,alpha,50);
[Yhat_NA, VarAnn_NA] = AnnotatorsConsensus(Y,1000);
Adversary_Annotators_AMG = find(f_WhoIsAdversary==1);
Adversary_Annotators_AMG_B = find(f_WhoIsAdversaryB==1);
save('AMG1608Consensus_CI_Adv.mat','Yhat_CI_Adv','Adversary_Annotators_AMG','VarAnn_CI_Adv', 'VarAnnLB_CI_Adv');
save('AMG1608Consensus_CI_AdvB.mat','Yhat_CI_AdvB','Adversary_Annotators_AMG_B','VarAnn_CI_AdvB', 'VarAnnLB_CI_AdvB');

%% Load the DEAM ratings data
load('AllSongRatingsDEAM.mat'); % 1802 x 194 x 2 (V, A)
clear Y;
Y(:,:,1) = AllSongRatingsDEAM(:,:,1); Y(:,:,2) = AllSongRatingsDEAM(:,:,2);
alpha = 0.05; % Significance level, i.e. we are 95% confident of results
[Yhat_CI_Adv_DEAM, f_WhoIsAdversary_DEAM, VarAnn_CI_Adv_DEAM, VarAnnLB_CI_Adv_DEAM] = AnnotatorsConsensusCI_Adv(Y,alpha,1000);
[Yhat_CI_Adv_DEAM_B, f_WhoIsAdversary_DEAM_B, VarAnn_CI_Adv_DEAM_B, VarAnnLB_CI_Adv_DEAM_B] = AnnotatorsConsensusCI_Adv_Bias(Y,alpha,50);
[Yhat_NA_DEAM, VarAnn_NA_DEAM] = AnnotatorsConsensus(Y,1000);
Adversary_Annotators_DEAM = find(f_WhoIsAdversary_DEAM==1)
Adversary_Annotators_DEAM_B = find(f_WhoIsAdversary_DEAM_B==1)
save('DEAM1802Consensus_CI_Adv.mat','Yhat_CI_Adv_DEAM','Adversary_Annotators_DEAM','VarAnn_CI_Adv_DEAM', 'VarAnnLB_CI_Adv_DEAM');
save('DEAM1802Consensus_CI_Adv_B.mat','Yhat_CI_Adv_DEAM_B','Adversary_Annotators_DEAM_B','VarAnn_CI_Adv_DEAM_B', 'VarAnnLB_CI_Adv_DEAM_B');

%
% AMG Adversaries are:
%      2     5    58   106   112   172   209   247   323   346   361   370   468
%     535   597   612   613   622   635
%    
% DEAM Adversaries are:
%     39   168   178   186   194