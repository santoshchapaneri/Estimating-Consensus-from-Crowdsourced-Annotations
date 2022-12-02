% Author: Santosh Chapaneri

function AnalyzeDEAMLabels(idx, flagAnn)
% Checking for 58, Aqua Barbie Girl
% idx = 58; flagAnn = 0;

load('DEAM_Metadata.mat'); % loads 'SongIDs','Artist','SongTitle','Genre', each is 1802 x 1

tot = 1; % We want to see results of only particular one song
load('AllSongRatingsDEAM.mat');
All_valence = AllSongRatingsDEAM(idx,:,1);
All_arousal = AllSongRatingsDEAM(idx,:,2);
valence = nan(tot,194);
arousal = nan(tot,194);

% NOTE: for loop has no effect as such, we are analyzing only one song here
for i=1:tot
    kv=All_valence(i,:); 
    ka=All_arousal(i,:); 
    
    % Who are the annotators that labeled this song
    Ann = ~isnan(kv);
    AnnID = find(Ann == 1);
    
    % Remove NaNs
    kv = kv(~isnan(kv));
    ka = ka(~isnan(ka));
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

% Display some statistics
numAnnotators = length(AnnID);
artist = Artist{idx,1};
songtitle = SongTitle{idx,1};
genre = Genre{idx,1};
songid = SongIDs(idx);
outText = sprintf('%d annotators labeled %d.wav', numAnnotators, songid);
disp(outText);

T = sprintf('SongID %d: %s: %s: %s; %d Annotators',songid, artist, songtitle, genre, numAnnotators);
figure;scatter(val_all,aro_all,'+','LineWidth',2);axis([-1 1 -1 1]); title(T);
xlabel('Valence','FontSize',12);ylabel('Arousal','FontSize',12);
grid on; hold on; set(gcf,'color','white'); box;

% Show the value from proposed estimates
load('DEAM1802AnnotatorsConsensusCIWM.mat');
shift = 0.01;
% scatter(YhatValence(idx),YhatArousal(idx),'rd','LineWidth',4);
% text(YhatValence(idx)+shift,YhatArousal(idx)+shift,'MA','FontSize',12);
% Show the value from proposed estimates using MCD
YV = DEAM1802AnnotatorsConsensusCIWM.YValence(idx);
YA = DEAM1802AnnotatorsConsensusCIWM.YArousal(idx);
VarAnn = DEAM1802AnnotatorsConsensusCIWM.VarAnn;

load('DEAM1802Consensus_CI_Adv.mat');
% Loads proposed estimates of gold standard
YV_Adv = Yhat_CI_Adv_DEAM(idx,1);
YA_Adv = Yhat_CI_Adv_DEAM(idx,2);
VarAnn_CIWM_Adv = VarAnn_CI_Adv_DEAM;

% scatter(YV,YA,'rs','LineWidth',5);
% text(YV+shift,YA+shift,'CIWM','FontSize',12);
scatter(YV_Adv,YA_Adv,'rs','LineWidth',5);
text(YV_Adv+shift,YA_Adv+shift,'EC','FontSize',14);

% Show the average value
scatter(mean(val_all),mean(aro_all),'ko','LineWidth',5);
text(mean(val_all)+shift,mean(aro_all)+shift,'Avg','FontSize',14);
set(gcf,'color','white'); box;
screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to screen size
title(T,'FontSize',12);
set(gca,'FontSize',10);

% % Show the median value
% scatter(median(val_all),median(aro_all),'s','LineWidth',4);
% text(median(val_all)+0.03,median(aro_all)+0.03,'Median','FontSize',12);


% Put Annotator labels on each data point
if flagAnn
    shift2 = 0.01;
    for i=1:length(val_all)
        strAnn = sprintf('%d',AnnID(i));
        text(val_all(i)+shift2,aro_all(i)+shift2,strAnn,'FontSize',14);
%         strAnn = sprintf('%d(%0.4f)',AnnID(i), VarAnn(AnnID(i)));
        strAnn = sprintf('%d(%0.4f)',AnnID(i), VarAnn_CIWM_Adv(AnnID(i)));
        text(val_all(i)+shift2,aro_all(i)+shift2,strAnn,'FontSize',14);
%         text(val_all(i)+shift2,aro_all(i)+shift2,num2str(AnnID(i)),'FontSize',11);
%         text(val_all(i)+2.5*shift2,aro_all(i)+3*shift2,num2str(VarAnnMCD(AnnID(i))),'FontSize',11);
%         text(val_all(i)-2.5*shift2,aro_all(i)-3*shift2,num2str(VarAnn(AnnID(i))),'FontSize',11);
    end
end

if 0 % Make it 1 to play the song
% Play the song
filename = sprintf('D:\\Santosh\\MusicPhD\\2017\\DEAM\\DEAM_audio\\%d.mp3',songid);
[y, fs] = mp3read(filename, 0, 1, 2, 0); 
% y = mean(y,2);
y = y(1:floor(length(y)/4)); % Edit to change duration of song
% y = y(1:floor(length(y)/4)); % Edit to change duration of song
player = audioplayer(y, fs);
hFig = figure;
set(gcf,'color','white'); box;
hold on;
plot(y, 'g'); % plot audio data
ylimits = get(gca, 'YLim'); % get the y-axis limits
set(hFig, 'Position', [50 50 length(y)/fs 100]);
plotdata = ylimits(1):0.1:ylimits(2);
plot(zeros(size(plotdata)), plotdata, 'r'); % plot the marker
% setup the timer for the audioplayer object
player.TimerFcn = {@plotMarker, player, gcf, plotdata}; % timer callback function (defined below)
player.TimerPeriod = 0.01; % period of the timer in seconds
% start playing the audio
% this will move the marker over the audio plot at intervals of 0.01 s
play(player);
pause(length(y)/fs);
end