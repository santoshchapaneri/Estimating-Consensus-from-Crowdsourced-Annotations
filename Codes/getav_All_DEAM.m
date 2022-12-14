% Author: Santosh Chapaneri

clear
clc
close all

% DEAM dataset visualization

% Reproduce Fig. 2 (histogram of emotion annotations) of (AMG1608) paper
tot = 1802;

load('AllSongRatingsDEAM.mat'); % results in All_subset of size 1608x665x2
All_valence = AllSongRatingsDEAM(:,:,1);
All_arousal = AllSongRatingsDEAM(:,:,2);
valence = nan(tot,195);
arousal = nan(tot,195);

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

my_ndhist(val_all, aro_all);
figure;scatter(val_all, aro_all);

% va(:,1)=val_all;
% va(:,2)=aro_all;
% n=hist3(va,[9 9]);
% n1 = n';
% n1(size(n,1) + 1, size(n,2) + 1) = 0;
% xb = linspace(min(va(:,1)),max(va(:,1)),size(n,1)+1);
% yb = linspace(min(va(:,2)),max(va(:,2)),size(n,1)+1);
% h = spcolor(xb,yb,n1);
% % figure; h = pcolor(xb,yb,n1);
% % my_ndhist2(val_all, aro_all);
