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

%%Vorbereitung von Index-Arrays
%Die Index-Arrays sind für das randomisierte Darstellen der Bitmaps und Töne verantwortlich
%Es wird kontrolliert ob mindestens 10 und maximal 13 "n-2" Treffer exisitieren
%Indexe für die Bitmap-Darstellung
indLib = cell(20,1);
i=1;


while i <= 20
    ind2b(1,:) = randi([1, 8], 1, 20)
    ind2b(2,:) = zeros(1,20);

    rep = 0;
    for j = 3:(20)
        if ind2b(1,j) == ind2b(1,j-2)
            rep = rep + 1;
            ind2b(2,j) = 1;
        end
    end
    if rep == 10
        indLib{i} = ind2b
        i = i+1;
    end
end

while 1
    indBM = indBM(randperm(length(indBM)));
    countRepBM = 0;
    for i = 3:(32)
        if indBM(i) == indBM(i-2)
            countRepBM = countRepBM + 1;
        end
        
    end
    triesBM = triesBM + 1;
    if countRepBM > 10 && countRepBM < 13
        disp(countRepBM);
        disp(triesBM);
        break;
    end
end
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

    wavedata = cell(8,1);
    freq = double(8);
    pahandle = double(8);

    for i = 3:10
        [wavedata{i-2}, freq(i-2)] = audioread(fullfile(tonePath, tondateienFolder(i).name));
        pahandle(i-2) = PsychPortAudio('Open', [], [], 1, freq(i-2), 1, 0);
        PsychPortAudio('FillBuffer', pahandle(i-2), wavedata{i-2}');
    end
    disp("Tondateien eingelesen!");

    %% Experimentsvorbereitung
    

catch ME
    Screen('CloseAll');
    disp("An error occured:");
    diso(ME.message);
end

KbWait;
PsychPortAudio('Close');
Screen('CloseAll');