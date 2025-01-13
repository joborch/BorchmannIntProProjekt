%author: Jonas Borchmann
%Description: This file operates the Psychtoolbox Paradigma.
%Configuration: You dont need to change anything. Changable Settings will be showed in a block at the front.

%% Changable Settings
%Change this to the preferred Screen for PTB!
currentScreen = 0;
%Change this to your preferred Screen-Ratio for the PTB-Screen (1 = Fullscreen)
ratioFactor = 1;
%Change this if you want to change the path of the stored Bitmaps
bitmapPath = '.\bitmaps\';
%Change this if you want to change the path of the stored Tones
tonePath = '.\tondateien\';
%Define how many different Index Arrays you want to exist!
indexArrays = 40;
%Define the time of Bitmap presentation
BM_pres = 0.5;
%Define the time of FixCross presentation
FC_pres = 2.5;


%Define the Time for which the Instructions are showed!
showTimeInst = 15;
%Instruktion am Start
inst = ['Herzlich willkommen in dieser Studie! \n danke das du dir die Zeit nimmst dein Arbeitsgedächtnis herauszufordern. \n Du bekommst gleich visuelle und akustische Stimuli dargeboten. \n Diese werden in einer 0-Back, 1-Back, 2-Back oder 3-Back Bedingung präsentiert. \n '];
%Instruktion für 0b
B0Inst = ['Instruktion 0 BACK\n In dieser Aufgabe musst du immer dann die \n Leertaste drücken, wenn du entweder Q hörst \n oder ein Quadrat in der Ecke unten-links siehst'];
%Instruktion für 1b
B1Inst = ['Instruktion 1 BACK \n In dieser Aufgabe musst du immer dann die \n Leertaste drücken, wenn ein Element akustisch oder visuell \n dem letzten gleicht.'];
%Instruktion für 2b
B2Inst = ['Instruktion 2 BACK \n In dieser Aufgabe musst du immer dann die \n Leertaste drücken, wenn ein Element akustisch oder visuell \n dem vorletzten gleicht.'];
%Instruktion für 3b
B3Inst = ['Instruktion 3 BACK \n In dieser Aufgabe musst du immer dann die \n Leertaste drücken, wenn ein Element akustisch oder visuell \n dem vorvorletzten gleicht.'];

%% Working Directory
currentFilePath = mfilename('fullpath'); %speichern vom Pfad der genutzten Datei
[currentFolderPath, ~, ~] = fileparts(currentFilePath); %rausspeichern vom Ordner-Pfad 
cd(currentFolderPath); %Aktuelles Working Directory setzen!

%% Vorbereitung von Index-Arrays
%Die Index-Arrays sind für das randomisierte Darstellen der Bitmaps und Töne verantwortlich
%Es wird kontrolliert ob mindestens 10 und maximal 13 "n-2" Treffer exisitieren
%Indexe für die Bitmap-Darstellung
%1 Back Index
indLib1b = createLib(1, indexArrays, 0);
%2 Back Index
indLib2b = createLib(2, indexArrays, 0);
%3 Back Index
indLib3b = createLib(3, indexArrays, 0);

%Sicherung, dass mindestens 2 Hits pro Kategorie in 0B sein werden
%0 Back Index - Bitmaps
indLib0bBM = createLib(0, indexArrays, 4);
%0 Back Index - Tones
indLib0bT = createLib(0, indexArrays, 6);

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
rt = nan(4,180);

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
    Screen('TextSize', win, 40);
    DrawFormattedText(win, 'Wähle den Ausführungsmodus! \n Drücke d für Demo. \n Drücke r für Testmodus', 'center', 'center', white);
    Screen('Flip', win);
    KeyIsDown = 0;
    modus = 'a';
    while (KeyIsDown == 0)
        [KeyIsDown, ~, keyCode, ~] = KbCheck();
        modus = KbName(keyCode);
        WaitSecs(0.001);
    end
    if modus == 'd'
        DrawFormattedText(win, inst, 'center', 'center', white);
        tStart = Screen('Flip', win);
        k=1;
        if perm(1) == 1
            indBM = BMIndex1b;
            indT = toneIndex1b;
            NBInst = B1Inst;
        elseif perm(1) == 2
            indBM = BMIndex2b;
            indT = toneIndex2b;
            NBInst = B2Inst;
        elseif perm(1) == 3
            indBM = BMIndex3b;
            indT = toneIndex3b;
            NBInst = B3Inst;
        end

        %Instruktion 0b
        DrawFormattedText(win, B0Inst, 'center', 'center', white);
        tInst = Screen('Flip', win, tStart + showTimeInst);
        
        [rt(:,k:k+9), endTime] = run0b(indLib0bBM{1}, indLib0bT{1}, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
        k = 11;
        %Instruktion Nb
        DrawFormattedText(win, NBInst, 'center', 'center', white);
        tInst = Screen('Flip', win, tInst + showTimeInst);
        [rt(:,k:k+19), endTime] = runNb(indBM, indT, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
    elseif modus == 'r'
        DrawFormattedText(win, inst, 'center', 'center', white);
        tStart = Screen('Flip', win);
        k=1;
        for i = 1:6
            if perm(i) == 1
                indBM = BMIndex1b;
                indT = toneIndex1b;
                NBInst = B1Inst;
            elseif perm(1) == 2
                indBM = BMIndex2b;
                indT = toneIndex2b;
                NBInst = B2Inst;
            elseif perm(1) == 3
                indBM = BMIndex3b;
                indT = toneIndex3b;
                NBInst = B3Inst;
            end
            if i == 1
                %Instruktion 0b
                DrawFormattedText(win, B0Inst, 'center', 'center', white);
                tInst = Screen('Flip', win, tStart + showTimeInst);
                
                [rt(:,k:k+9), endTime] = run0b(indLib0bBM{i}, indLib0bT{i}, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
                k = k+10;
                %Instruktion Nb
                DrawFormattedText(win, NBInst, 'center', 'center', white);
                tInst = Screen('Flip', win, tInst + showTimeInst);
                [rt(:,k:k+19), endTime] = runNb(indBM, indT, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
                k = k+20;
            else
                %Instruktion 0b
                DrawFormattedText(win, B0Inst, 'center', 'center', white);
                tInst = Screen('Flip', win, tInst + showTimeInst);

                [rt(:,k:k+9), endTime] = run0b(indLib0bBM{i}, indLib0bT{i}, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
                k = k+10;
                %Instruktion Nb
                DrawFormattedText(win, NBInst, 'center', 'center', white);
                tInst = Screen('Flip', win, tInst + showTimeInst);

                [rt(:,k:k+19), endTime] = runNb(indBM, indT, pahandle, bitmapTextures, BM_pres, fixcrossTexture, FC_pres, tInst, win);
                k = k+20;
            end
        end
    else
        PsychPortAudio('Close');
        Screen('CloseAll');
        disp("Experiment wurde nicht Ordnungsgemäß gestartet!");
    end
catch ME
    Screen('CloseAll');
    disp("An error occured:");
    disp(ME.message);
end

%% Meta-Daten einschreiben
l = 1;
for i = 1:6
    if perm(i) == 1
        indBM = BMIndex1b;
        indT = toneIndex1b;
        NBInst = B1Inst;
        task = 1;
    elseif perm(i) == 2
        indBM = BMIndex2b;
        indT = toneIndex2b;
        NBInst = B2Inst;
        task = 2;
    elseif perm(i) == 3
        indBM = BMIndex3b;
        indT = toneIndex3b;
        NBInst = B3Inst;
        task = 3;
    end
    indNBM = indLib0bBM{i};
    indNT = indLib0bT{i};
    rt(3,l:l+9) = 0; %Task Information 0 = 0Back;
    %Target Hits definiert auf Bitmap 4 (in diesem Fall leftunder.bmp)
    %Target Hits definiert auf Ton 6 (in diesem Fall Q.mp3)
    for j = 1:10
        if indNBM(2,j) == 1
            rt(4,l) = 1;
            l=l+1;
        elseif indNT(2,j) == 1
            rt(4,l) = 1;
            l=l+1;
        else
            rt(4,l) = 0;
            l=l+1;
        end
    end
    rt(3,l:l+19) = task;
    %Target hits einschreiben für akustisch oder visuelle Targets
    for j = 1:20
        if indBM(2,j) == 1 || indT(2,j) == 1
            rt(4,l) = 1;
            l=l+1;
        else
            rt(4,l) = 0;
            l=l+1;
        end
    end
end

writematrix(rt, 'test-RT');
%% Abschluss
KbWait;
PsychPortAudio('Close');
Screen('CloseAll');