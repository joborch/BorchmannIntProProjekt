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


%Define the Time for which the Instructions are showed!
showTimeInst = 3;
%Instruktion am Start
inst = ['HALLO!'];
%Instruktion für 0b
B0Inst = ['Instruktion \n in dieser Aufgabe musst du immer dann die \n Leertaste drücken, wenn du entweder Q hörst \n oder ein Quadrat in der Ecke unten-links siehst'];
%Instruktion für 1b
B1Inst = ['Du startest B1!'];
%Instruktion für 2b
B2Inst = ['Du startest B2!'];
%Instruktion für 3b
B3Inst = ['Du startest B3!'];

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

toneIndex0b = randi([1, 8], 1, 10);
toneIndex1b = indLib1b{toneIndexNum};
toneIndex2b = indLib2b{toneIndexNum};
toneIndex3b = indLib3b{toneIndexNum};
disp("Ton-Reihenfolgen Intialisiert!");

BMIndex0b = randi([1, 8], 1, 10);
BMIndex1b = indLib1b{BMIndexNum};
BMIndex2b = indLib2b{BMIndexNum};
BMIndex3b = indLib3b{BMIndexNum};
disp("Bitmap-Reihenfolgen Intialisiert!");

%Vordefinition der Randomisierten Darbietung der Elemente
a = 1;
b = 2;
c = 3;
num = [a a b b c c];
pseudoRand = perms(num);
perm = pseudoRand(randi([1, 720]),:);

%Speicher entlasten
toClear = {'toneIndexNum', 'BMIndexNum', 'pseudoRand', 'num', 'a', 'b', 'c', 'i', 'indLib1b', 'indLib2b', 'indLib3b', 'toClear'};
clear(toClear{:});

%Vorbereitung von Versuchsspeicherung
rt = nan(2,20);

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
    %Start Instruktion
    Screen('TextSize', win, 32)
    DrawFormattedText(win, inst, 'center', 'center', white);
    tStart = Screen('Flip', win);
    
    for i = 1:6
        if perm(i) == 1
            indBM = BMIndex1b;
            indT = toneIndex1b;
            NBInst = B1Inst;
        elseif perm(i) == 2
            indBM = BMIndex1b;
            indT = toneIndex1b;
            NBInst = B2Inst;
        elseif perm(i) == 3
            indBM = BMIndex1b;
            indT = toneIndex1b;
            NBInst = B3Inst;
        end
        if i == 1
            %Instruktion 0b
            DrawFormattedText(win, B0Inst, 'center', 'center', white);
            tInst = Screen('Flip', win, tStart + showTimeInst);
            

            % [rt, endTime] = run0b(BMIndex0b, toneIndex0b, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);

            %Instruktion Nb
            DrawFormattedText(win, NBInst, 'center', 'center', white);
            tInst = Screen('Flip', win, tInst + showTimeInst);

            % [rt, endTime] = runNb(indBM, indT, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
        else
            %Instruktion 0b
            DrawFormattedText(win, B0Inst, 'center', 'center', white);
            tInst = Screen('Flip', win, tInst + showTimeInst);

            % [rt, endTime] = run0b(BMIndex0b, toneIndex0b, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);

            %Instruktion Nb
            DrawFormattedText(win, NBInst, 'center', 'center', white);
            tInst = Screen('Flip', win, tInst + showTimeInst);

            % [rt, endTime] = runNb(indBM, indT, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
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