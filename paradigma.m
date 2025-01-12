%author: Jonas Borchmann
%Description: This file operates the Psychtoolbox Paradigma.
%Configuration: You dont need to change anything. Changable Settings will be showed in a block at the front.

%% Changable Settings
%Change this to the preferred Screen for PTB!
currentScreen = 1;
%Change this to your preferred Screen-Ratio for the PTB-Screen (1 = Fullscreen)
ratioFactor = 0.25;



%% Working Directory
currentFilePath = mfilename('fullpath'); %speichern vom Pfad der genutzten Datei
[currentFolderPath, ~, ~] = fileparts(currentFilePath); %rausspeichern vom Ordner-Pfad 
cd(currentFolderPath); %Aktuelles Working Directory setzen!

%% Geräte-Spezifika einstellen
%Gerätefarben
white  = WhiteIndex(currentScreen); %Color Index White
black = BlackIndex(currentScreen); %Color Index Black
gray = (white+black)/2; %Color Index Gray

[width, height] = Screen('WindowSize', currentScreen); %Reads indivdual Screen Size

ratio = [0 0 width*ratioFactor height*ratioFactor]; %Definition of Ratio for myWindow

win = Screen('OpenWindow', currentScreen, black, ratio); %Opens a window on the defined Screen, with the defined ratioFactor (see Changable Setting Section)

%% Einlesen der Bitmaps
bitmapsFolder = dir('.\bitmaps\'); %Definition of "Bitmaps" Folder

bitmaps = cell(8,1);
bitmapTextures = double(8);

for i = 3:10
    bitmaps{i-2} = imread(fullfile('./bitmaps/',bitmapsFolder(i).name));
    bitmapTextures(i-2) = Screen('MakeTexture', win, bitmaps{i-2});
end
disp("Bitmaps eingelesen!");

%% Einlesen der Tondateien
tondateienFolder = dir('.\tondateien\'); %Definition of "Tondateien" Folder


KbWait;
Screen('CloseAll');