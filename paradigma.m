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
%Define how many different Index Arrays you want to exist!
indexArrays = 40;
%Define how many Targets you want to exist in each Index Array!
targetAmount = 8;

%Define the time of Bitmap presentation
BM_pres = 0.5;
%Define the time of FixCross presentation
FC_pres = 2.5;




%% Working Directory
currentFilePath = mfilename('fullpath'); %speichern vom Pfad der genutzten Datei
[currentFolderPath, ~, ~] = fileparts(currentFilePath); %rausspeichern vom Ordner-Pfad 
cd(currentFolderPath); %Aktuelles Working Directory setzen!

%% Vorbereitung von Index-Arrays
%Die Index-Arrays sind für das randomisierte Darstellen der Bitmaps und Töne verantwortlich
%Es wird kontrolliert ob mindestens 10 und maximal 13 "n-2" Treffer exisitieren
%Indexe für die Bitmap-Darstellung
%1 Back Index
indLib1b = cell(indexArrays,1);
i=1;
while i <= indexArrays
    ind(1,:) = randi([1, 8], 1, 20);
    ind(2,:) = zeros(1,20);

    rep = 0;
    for j = 2:(20)
        if ind(1,j) == ind(1,j-1)
            rep = rep + 1;
            ind(2,j) = 1;
        end
    end
    if rep == targetAmount
        if i>1
            for k = 1:i
                if ind == indLib1b{k}
                    disp("Abbruch");
                    break;
                else
                    disp("saved");
                    indLib1b{i} = ind;
                    i = i+1;
                    break;
                end
            end
        elseif i==1
            disp("saved");
            indLib1b{i} = ind;
            i = i+1;        
        end
    end
end

%2 Back Index
indLib2b = cell(indexArrays,1);
i=1;

while i <= indexArrays
    ind(1,:) = randi([1, 8], 1, 20);
    ind(2,:) = zeros(1,20);

    rep = 0;
    for j = 3:(20)
        if ind(1,j) == ind(1,j-2)
            rep = rep + 1;
            ind(2,j) = 1;
        end
    end
    if rep == 5
        if i>1
            for k = 1:i
                if ind == indLib2b{k}
                    disp("Abbruch");
                    break;
                else
                    disp("saved");
                    indLib2b{i} = ind;
                    i = i+1;
                    break;
                end
            end
        elseif i==1
            disp("saved");
            indLib2b{i} = ind;
            i = i+1;        
        end
    end
end

%3 Back Index
indLib3b = cell(indexArrays,1);
i=1;

while i <= indexArrays
    ind(1,:) = randi([1, 8], 1, 20);
    ind(2,:) = zeros(1,20);

    rep = 0;
    for j = 4:(20)
        if ind(1,j) == ind(1,j-3)
            rep = rep + 1;
            ind(2,j) = 1;
        end
    end
    if rep == 5
        if i>1
            for k = 1:i
                if ind == indLib3b{k}
                    disp("Abbruch");
                    break;
                else
                    disp("saved");
                    indLib3b{i} = ind;
                    i = i+1;
                    break;
                end
            end
        elseif i==1
            disp("saved");
            indLib3b{i} = ind;
            i = i+1;        
        end
    end
end

%Definition dargebotener indexArrays für Töne und Bitmaps
toneIndexNum = randi([4 indexArrays]);
BMIndexNum = round(toneIndexNum*0.7);

toneIndex1b = indLib1b{toneIndexNum};
toneIndex2b = indLib2b{toneIndexNum};
toneIndex3b = indLib3b{toneIndexNum};
disp("Ton-Reihenfolgen Intialisiert!");

BMIndex1b = indLib1b{BMIndexNum};
BMIndex2b = indLib2b{BMIndexNum};
BMIndex3b = indLib3b{BMIndexNum};
disp("Bitmap-Reihenfolgen Intialisiert!");

%Vorbereitung von Versuchsspeicherung
rt = nan(2,20);
KeyIsDown = 0; %Vordefinieren von KeyIsDown!

%% Geräte-Spezifika einstellen
%Gerätefarben
white  = WhiteIndex(currentScreen); %Color Index White
black = BlackIndex(currentScreen); %Color Index Black
gray = (white+black)/2; %Color Index Gray

[width, height] = Screen('WindowSize', currentScreen); %Reads indivdual Screen Size

ratio = [0 0 width*ratioFactor height*ratioFactor]; %Definition of Ratio for myWindow

try
    win = Screen('OpenWindow', currentScreen, black, ratio); %Opens a window on the defined Screen, with the defined ratioFactor (see Changable Setting Section)
    InitializePsychSound(1);
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

    %% Fixationskreuz
    fixcross = imread('.\fixcross.bmp');
    fixcrossTexture = Screen('MakeTexture', win, fixcross); %Textur für Fixationskreuz definieren

    %% Experimentsdarbietung
    %Test-Trial mit 2b Bedingung
    Screen('DrawTexture', win, fixcrossTexture);
    tStart = Screen('Flip', win, tOnset + BM_pres);
    for i = 1:20
        if i == 1
            Screen('DrawTexture', win, bitmapTextures(BMIndex2b(1,i)));
            tOnset = Screen('Flip', win, tStart + 5);
            PsychPortAudio('Start', pahandle(toneIndex2b(1,i)), 1, tStart + 5);
            Screen('DrawTexture', win, fixcrossTexture);
            [tFix, StimulusOnsetTime] = Screen('Flip', win, tOnset + BM_pres);
            
            %Reaktionszeitmessung und Keyboardcheck
            while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=2.4
                [KeyIsDown, endRT, KeyCode, ~] = KbCheck();
                
                WaitSecs(0.001);
            end
            rt(1,i) = endRT - StimulusOnsetTime;
            rt(2,i) = KeyIsDown;
            KeyIsDown = 0;
        else
            Screen('DrawTexture', win, bitmapTextures(BMIndex2b(1,i)));
            tOnset = Screen('Flip', win, tFix + FC_pres);
            PsychPortAudio('Start', pahandle(toneIndex2b(1,i)), 1, tStart + 5);
            Screen('DrawTexture', win, fixcrossTexture);
            [tFix, StimulusOnsetTime] = Screen('Flip', win, tOnset + BM_pres);
            
            %Reaktionszeitmessung und Keyboardcheck
            while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=2.4
                [KeyIsDown, endRT, KeyCode, ~] = KbCheck();
                
                WaitSecs(0.001);
            end
            rt(1,i) = endRT - StimulusOnsetTime;
            rt(2,i) = KeyIsDown;
            KeyIsDown = 0;
        end
    end

catch ME
    Screen('CloseAll');
    disp("An error occured:");
    disp(ME.message);
end

KbWait;
PsychPortAudio('Close');
Screen('CloseAll');