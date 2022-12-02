% Analyze ALL songs of DEAM
% Author: Santosh Chapaneri

load('DEAM_Metadata.mat'); % loads 'SongIDs','Artist','SongTitle','Genre', each is 1802 x 1

% change these parameters to analyze specific songs
start = find(SongIDs == 2); % which song to listen to
% start = randperm(1802,1);
NumSongs = 1;
flagAnn = 1;

fStart = 0;
fList = 0;
fAnnotator = 1;

%% Analyze specific songs
if fStart
for i=start:start+NumSongs-1
    i
    AnalyzeDEAMLabels(i, flagAnn);
    pause; % so that can close running via CTRL+C
    close all;
end
end

%% Which songs to analyze?
if fList
    % 513, 736
SongIdx = [2,60,71,92,126,219,347,356,366,392,408,435,444,513,613,629,632,634,652,663,699,725,731,736,826,891,893,939,978];
% SongIdx = [2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,2048,2049,2050,2051,2052,2053,2054,2055,2056,2057,2058];
% SongIdx = 58;
for k = 1:numel(SongIdx)
    AnalyzeDEAMLabels(find(SongIDs == SongIdx(k)), flagAnn);
    pause;
    close all;
end
end
%% Annotator specific song
if fAnnotator
load('DEAMAnnotators.mat'); % loads NumSongs and SongLabels of each annotator
Ann = 12;
numSongs = DEAMAnnotators.NumSongs(Ann);
SongLabels = DEAMAnnotators.SongLabels(Ann); SongLabels = SongLabels{1,1};
for k = 1:length(SongLabels)
    AnalyzeDEAMLabels(SongLabels(k), flagAnn);
    pause;
    close all;
end
end