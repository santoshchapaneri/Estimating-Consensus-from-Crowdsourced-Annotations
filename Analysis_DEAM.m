% Author: Santosh Chapaneri

% Benefit of CIWM
clear

% Weighted Average, no CI
load('DEAM1802AnnotatorsConsensus.mat');
VarAnn = DEAM1802AnnotatorsConsensus.VarAnn;

% Modified: Weighted Medians with 95% Confidence Interval, Adv
load('DEAM1802Consensus_CI_Adv.mat');
VarAnn_CIWM = VarAnn_CI_Adv_DEAM;
VarAnnLB_CIWM = VarAnnLB_CI_Adv_DEAM;
% 
% load('DEAM1802Consensus_CI_Adv_B.mat');
% VarAnn_CIWM = VarAnn_CI_Adv_DEAM_B;
% VarAnnLB_CIWM = VarAnnLB_CI_Adv_DEAM_B;

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
bar(numSongsSorted,'r','LineWidth',2); 
xlim([1 194]);
xlabel('DEAM Annotator Index (sorted)','FontSize',18); 
ylabel('# Songs Annotated','FontSize',18); 
% title('Long-tail in DEAM dataset','FontSize',18);
set(gcf,'color','white'); box on; grid on;
set(gca,'FontSize',18);
saveas(gcf,'DEAM_LongTail','epsc');

% See the 95% Confidence Interval of selected annotators
% Ann = [159, 12, 193, 3, 38, 115, 71, 100, 187, 35, 13, 45, 26, 35];
Ann = [1 15 48 82 26];
% Ann = [1 4 7 12 15 24 25 29 35 49 52 53 62 85 103 126 150 154 191 192 194];
% Ann = [1 23 257 58 126];
for idx = 1:length(Ann)
    AnnIdx = find(IdxSorted==Ann(idx));
    CI_LB(idx) = VarAnnLB_CIWM_Sorted(AnnIdx);
    CI_UB(idx) = VarAnn_CIWM_Sorted(AnnIdx);
    SongsAnnotated(idx) = numSongsSorted(AnnIdx);
    VarRaykar(idx) = VarAnn_Sorted(AnnIdx);
%     AnnIdx = idx;
%     CI_LB(idx) = VarAnnLB_CIWM(AnnIdx);
%     CI_UB(idx) = VarAnn_CIWM(AnnIdx);
%     SongsAnnotated(idx) = numSongs(AnnIdx);
end
CI = [CI_LB;CI_UB];
CI'

% Observe how different variances are
figure; set(gcf,'color','white');
% plot(VarAnn_CIWM_Sorted,'r-','LineWidth',2);hold on; plot(VarAnn_Sorted,'b--','LineWidth',2); 
plot(VarAnn_CIWM,'r-','LineWidth',3);
hold on; 
plot(VarAnn,'b--','LineWidth',3); 
ylim([0 130]);
xlim([1 194]);
legend('Proposed','Raykar'); box on; grid on;
xlabel('DEAM Annotator Index','FontSize',18); 
ylabel('Estimated Reliability','FontSize',18);
set(gca,'FontSize',18);
grid on;
saveas(gcf,'DEAM_Reliability','epsc');
