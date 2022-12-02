% Author: Santosh Chapaneri

%% Load the data
load('AllSongRatingsDEAM.mat');
Y(:,:,1) = AllSongRatingsDEAM(:,:,1); Y(:,:,2) = AllSongRatingsDEAM(:,:,2);
[Yhat, VarAnn] = AnnotatorsConsensus(Y,1000);
% Save the consensus targets and variance
DEAM1802AnnotatorsConsensus.YValence = Yhat(:,1);
DEAM1802AnnotatorsConsensus.YArousal = Yhat(:,2);
DEAM1802AnnotatorsConsensus.VarAnn = VarAnn;
save('DEAM1802AnnotatorsConsensus.mat','DEAM1802AnnotatorsConsensus');