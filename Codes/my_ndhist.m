function [edgesX2,edgesY2,N,h] = my_ndhist(x, y)

leftEdge = -1; riteEdge = 1; botEdge = -1; topEdge = 1;
rangeX = riteEdge-leftEdge;
rangeY =  topEdge -botEdge;

% Instate a mininum and maximum number of bins
numBinsX = 20;
numBinsY = 20;
binWidthX=2/(numBinsX);
binWidthY=2/(numBinsY);
axisXY = [leftEdge riteEdge botEdge topEdge];
% set the bins
edgesX=axisXY(1):binWidthX:axisXY(2);
edgesY=axisXY(3):binWidthY:axisXY(4);

N =  hist3(x,y,edgesX,edgesY);
[X,Y]=meshgrid(edgesX,edgesY);

edgesX2 = edgesX+binWidthX/2;
edgesY2 = edgesY+binWidthY/2;

h = spcolor(edgesX2,edgesY2,N); colorbar;
axis('tight');
axis([min(edgesX) max(edgesX) min(edgesY) max(edgesY)]);
shading('flat');
xlabel('Valence'); ylabel('Arousal');
end
%%
% 2D histogram which is actually kind of fast making use of matlab's histc
function allN = hist3(x,y,edgesX,edgesY)
    allN = zeros(length(edgesY),length(edgesX));
    [~,binX] = histc(x,edgesX);
    for ii=1:length(edgesX)
        I = (binX==ii);
        N = histc(y(I),edgesY);
        allN(:,ii) = N';
    end
end % BAM how small is this function? sweet peas!

%%


% This function accomodates the crazy 'pcolor' thing where it isn't
% centered and cuts off the edges.
function h = spcolor(x,y,A)

%%

[S1, S2] = size(A);

A2 = [A zeros(S1,1);
    zeros(1,S2) 0];

xx = [x 2*x(end)-x(end-1)]-(x(end)-x(end-1))/2;
yy = [y 2*y(end)-y(end-1)]-(y(end)-y(end-1))/2;

h = pcolor(xx,yy,A2);

end
