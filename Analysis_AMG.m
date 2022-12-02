% Author: Santosh Chapaneri

% Benefit of CIWM

% Weighted Average, no CI
load('AMG1608AnnotatorsConsensus.mat');
VarAnn = AMG1608AnnotatorsConsensus.VarAnn;

% Modified: Weighted Medians with 95% Confidence Interval, Adv
load('AMG1608Consensus_CI_Adv.mat');
VarAnn_CIWM = VarAnn_CI_Adv;
VarAnnLB_CIWM = VarAnnLB_CI_Adv;

% load('AMG1608Consensus_CI_AdvB.mat');
% VarAnn_CIWM = VarAnn_CI_AdvB;
% VarAnnLB_CIWM = VarAnnLB_CI_AdvB;

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

bar(numSongsSorted,'r','LineWidth',2); 
xlim([1 665]);
xlabel('AMG Annotator Index (sorted)','FontSize',18); 
ylabel('# Songs Annotated','FontSize',18); 
% title('Long-tail in AMG dataset','FontSize',18);
set(gcf,'color','white'); box on; grid on;
set(gca,'FontSize',18);
saveas(gcf,'AMG_LongTail','epsc');

% See the 95% Confidence Interval of selected annotators
% Ann = [159, 479, 193, 664, 38, 115, 71, 216, 499, 35, 542, 647];
Ann = [159 664 216 542 647];
for idx = 1:length(Ann)
    AnnIdx = find(IdxSorted==Ann(idx));
    CI_LB(idx) = VarAnnLB_CIWM_Sorted(AnnIdx);
    CI_UB(idx) = VarAnn_CIWM_Sorted(AnnIdx);
    SongsAnnotated(idx) = numSongsSorted(AnnIdx);
end
CI = [CI_LB;CI_UB];
CI'

% Observe how different variances are
% figure; set(gcf,'color','white');
% % plot(VarAnn_CIWM_Sorted,'r-','LineWidth',2);hold on; plot(VarAnn_Sorted,'b--','LineWidth',2); 
% plot(VarAnn_CIWM,'r-','LineWidth',2);hold on; plot(VarAnn,'b--','LineWidth',2); 
% legend('Estimated Consensus with Upper Bound of CI (Eq. (3)','Solution of Eq. (2)'); box on; grid on;
% xlabel('Annotator Index'); ylabel('Estimated Variance/Reliability');

figure; set(gcf,'color','white');
% plot(VarAnn_CIWM_Sorted,'r-','LineWidth',2);hold on; plot(VarAnn_Sorted,'b--','LineWidth',2); 
plot(VarAnn_CIWM,'r-','LineWidth',3);
hold on; 
plot(VarAnn,'b--','LineWidth',3); 
ylim([0 12]);
xlim([1 665]);
legend('Proposed','Raykar','Location','NorthWest'); box on; grid on;
xlabel('AMG Annotator Index','FontSize',18); 
ylabel('Estimated Reliability','FontSize',18);
set(gca,'FontSize',18);
grid on;
saveas(gcf,'AMG_Reliability','epsc');

