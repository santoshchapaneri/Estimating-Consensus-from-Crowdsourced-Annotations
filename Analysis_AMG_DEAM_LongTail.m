% Author: Santosh Chapaneri

% Benefit of CIWM

% Weighted Average, no CI
load('AMG1608AnnotatorsConsensus.mat');
VarAnn = AMG1608AnnotatorsConsensus.VarAnn;

% Modified: Weighted Medians with 95% Confidence Interval, Adv
load('AMG1608Consensus_CI_Adv.mat');
VarAnn_CIWM = VarAnn_CI_Adv;
VarAnnLB_CIWM = VarAnnLB_CI_Adv;

% How many songs were annotated by each annotator?
load('AMG1608Annotators.mat'); % loads NumSongs and SongLabels of each annotator
numSongs = AMG1608Annotators.NumSongs;
SongLabels = AMG1608Annotators.SongLabels; % just in case if needed

% Do we have a long tail problem?
[numSongsSorted, IdxSorted] = sort(numSongs,'descend');
VarAnn_Sorted = VarAnn(IdxSorted);
VarAnn_CIWM_Sorted = VarAnn_CIWM(IdxSorted);
VarAnnLB_CIWM_Sorted = VarAnnLB_CIWM(IdxSorted);

% YES, long tail is seen; so CI should help in penalizing annotators who provided too few responses
% bar(numSongsSorted,'r','LineWidth',1.5); xlabel('Annotator Index'); ylabel('# Songs Annotated'); title('Long-tail in AMG1608 dataset');
% set(gcf,'color','white'); box on; grid on;

subplot(211);
bar(numSongsSorted,'r','LineWidth',2); 
xlim([1 700]);
xlabel('AMG Annotator Index (sorted)','FontSize',18); 
ylabel('# Annotations','FontSize',18); 
% title('Long-tail in AMG dataset','FontSize',18);
set(gcf,'color','white'); box on; grid on;
set(gca,'FontSize',18);

% Weighted Average, no CI
load('DEAM1802AnnotatorsConsensus.mat');
VarAnn = DEAM1802AnnotatorsConsensus.VarAnn;

% Modified: Weighted Medians with 95% Confidence Interval, Adv
load('DEAM1802Consensus_CI_Adv.mat');
VarAnn_CIWM = VarAnn_CI_Adv_DEAM;
VarAnnLB_CIWM = VarAnnLB_CI_Adv_DEAM;

% How many songs were annotated by each annotator?
load('DEAMAnnotators.mat'); % loads NumSongs and SongLabels of each annotator
numSongs = DEAMAnnotators.NumSongs;
SongLabels = DEAMAnnotators.SongLabels; % just in case if needed

% Do we have a long tail problem?
[numSongsSorted, IdxSorted] = sort(numSongs,'descend');
% IdxSorted = 1:194;numSongsSorted=numSongs;
VarAnn_Sorted = VarAnn(IdxSorted);
VarAnn_CIWM_Sorted = VarAnn_CIWM(IdxSorted);
VarAnnLB_CIWM_Sorted = VarAnnLB_CIWM(IdxSorted);

% YES, long tail is seen; so CI should help in penalizing annotators who provided too few responses
subplot(212);
bar(numSongsSorted,'r','LineWidth',2); 
xlim([1 200]);
set(gca, 'XTick', [0 50 100 150 200]);
xlabel('DEAM Annotator Index (sorted)','FontSize',18); 
ylabel('# Annotations','FontSize',18); 
% title('Long-tail in DEAM dataset','FontSize',18);
set(gcf,'color','white'); box on; grid on;
set(gca,'FontSize',18);
saveas(gcf,'AMG_DEAM_LongTail','epsc');