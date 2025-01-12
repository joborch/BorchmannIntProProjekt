%author: Jonas Borchmann
%Description: This file operates the Psychtoolbox Paradigma.
%Configuration: You dont need to change anything. Changable Settings will be showed in a block at the front.

%% Changable Settings
%Change this to the preferred Screen for PTB!
currentScreen = 1;
%Change this to your preferred Screen-Ratio for the PTB-Screen (1 = Fullscreen)
ratioFactor = 0.25;
%Change this if you want to change the path of the stored Bitmaps
bitmapPath = '.\bitmaps\';
%Change this if you want to change the path of the stored Tones
tonePath = '.\tondateien\';



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

try
    win = Screen('OpenWindow', currentScreen, black, ratio); %Opens a window on the defined Screen, with the defined ratioFactor (see Changable Setting Section)

    %% Einlesen der Bitmaps
    bitmapsFolder = dir(bitmapPath); %Definition of "Bitmaps" Folder

    bitmaps = cell(8,1);
    bitmapTextures = double(8);

    for i = 3:10
        bitmaps{i-2} = imread(fullfile(bitmapPath ,bitmapsFolder(i).name));
        bitmapTextures(i-2) = Screen('MakeTexture', win, bitmaps{i-2});
    end
    disp("Bitmaps eingelesen!");

    %% Einlesen der Tondateien
    tondateienFolder = dir(tonePath); %Definition of "Tondateien" Folder

    wavedata = cell(26,1);
    freq = double(26);
    pahandle = double(26);

    for i = 3:28
        [wavedata{i-2}, freq(i-2)] = audioread(fullfile(tonePath, tondateienFolder(i).name));
        pahandle(i-2) = PsychPortAudio('Open', [], [], 1, freq(i-2), 1, 0);
        PsychPortAudio('FillBuffer', pahandle(i-2), wavedata{i-2}');
    end
    disp("Tondateien eingelesen!");
catch ME
    Screen('CloseAll');
    disp("An error occured:");
    diso(ME.message);
end

KbWait;
Screen('CloseAll');