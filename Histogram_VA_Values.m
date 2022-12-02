% Author: Santosh Chapaneri

clear
clc
close all

% Reproduce Fig. 2 (histogram of emotion annotations) of paper
tot = 1608;

load('AllSongLabelsAMG1608.mat'); % results in All_subset of size 1608x665x2
All_valence = allsonglabels(:,:,1);
All_arousal = allsonglabels(:,:,2);
valence = nan(tot,665);
arousal = nan(tot,665);

for i=1:tot
    kv=All_valence(i,:); kv = kv(~isnan(kv));
    ka=All_arousal(i,:); ka = ka(~isnan(ka));
    valence(i,1:length(kv))=kv';
    arousal(i,1:length(ka))=ka';
end

% Collect all annotations of each V and A in a single vector
val_all = []; aro_all = [];
for i=1:tot
    vt = valence(i,:);
    val_all = [val_all vt(~isnan(vt))];
    at = arousal(i,:);
    aro_all = [aro_all at(~isnan(at))];
end

% my_ndhist(val_all, aro_all);


%% All annotations
nbins = 20;
bins = linspace(-1,1,nbins);
figure;
A = [val_all;aro_all]; A = A';
hist(A, bins); xlim([-1 1]);
% h1 = hist(A, bins); 
% h1p = h1./sum(h1);
% bar(h1p); axis([-1 1 0 1]);
legend('Valence','Arousal')

%% AMG CIWM annotations
% load('AMG1608AnnotatorsConsensusCIWM.mat')
% val_all = AMG1608AnnotatorsConsensusCIWM.YValence;
% aro_all = AMG1608AnnotatorsConsensusCIWM.YArousal;
nbins = 20;
bins = linspace(-1,1,nbins);
load('AMG1608Consensus_CI_Adv.mat');
val_all = Yhat_CI_Adv(:,1);
aro_all = Yhat_CI_Adv(:,2);
AC = [val_all aro_all];
figure;
% hist(AC, bins); xlim([-1 1]);
[h2,c] = hist(AC, bins); 
h2p(:,1) = h2(:,1)./sum(h2(:,1));
h2p(:,2) = h2(:,2)./sum(h2(:,2));
hb = bar(c, h2p); axis([-1 1 0 0.2]);
set(hb(1), 'FaceColor','r','LineWidth',2.5);
set(hb(2), 'FaceColor','b','LineWidth',2.5);
legend('Valence (AMG)','Arousal (AMG)','Location','NorthWest');
set(gcf,'color','white');
set(gca,'FontSize',18);
grid on;
saveas(gcf,'AMG1608Consensus_CI_Adv','epsc');

%% DEAM CIWM annotations
% load('DEAM1802AnnotatorsConsensusCIWM.mat')
% val_all_D = DEAM1802AnnotatorsConsensusCIWM.YValence;
% aro_all_D = DEAM1802AnnotatorsConsensusCIWM.YArousal;
load('DEAM1802Consensus_CI_Adv.mat');
val_all_D = Yhat_CI_Adv_DEAM(:,1);
aro_all_D = Yhat_CI_Adv_DEAM(:,2);
AC_D = [val_all_D aro_all_D];
figure;
% hist(AC_D, bins); xlim([-1 1]);
[h2_D,c_D] = hist(AC_D, bins); 
h2p_D(:,1) = h2_D(:,1)./sum(h2_D(:,1));
h2p_D(:,2) = h2_D(:,2)./sum(h2_D(:,2));
hb_D = bar(c_D,h2p_D); axis([-1 1 0 0.2]);
set(hb_D(1), 'FaceColor','r','LineWidth',2.5);
set(hb_D(2), 'FaceColor','b','LineWidth',2.5);
legend('Valence (DEAM)','Arousal (DEAM)','Location','NorthWest');
set(gcf,'color','white');
set(gca,'FontSize',18);
grid on;
saveas(gcf,'DEAM1802Consensus_CI_Adv','epsc');
