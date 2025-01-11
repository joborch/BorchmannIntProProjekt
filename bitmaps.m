%Working Directory setzen
cd("C:\Users\borch\Documents\GitHub\BorchmannIntProProjekt")

% FUNKTIONIERT AKTUELL NICHT!
% currentFilePath = mfilename('fmfiullpath'); %speichern vom Pfad der genutzten Datei
% [currentFolderPath, ~, ~] = fileparts(currentFilePath); %rausspeichern vom Ordner-Pfad 
% cd(currentFolderPath); %Aktuelles Working Directory setzen!


%% Basisdaten
%Hintergrund erstellen
size = 500;
bitmap = zeros(size,size);
center = round(size/2);
%Fixationskreuz einfügen
cross_thick = 1;
cross_size = 10;
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie


%% Quadrat unten
square_size = 80; % Kantenlänge des Quadrats
square_offset = 50; % Abstand zwischen dem Kreuz und dem Quadrat
square_start_row = center + cross_size + square_offset; %Start-Reihe: von der Mitte aus das Fixationskreuz und einen Abstand nehmen.
square_start_col = center - round(square_size / 2); %von der Mitte aus die Hälfte des Quadrats nach links 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_belowcenter.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie

%% Quadrat oben
%Berechnung square_start_row ändert sich!
square_start_row = center - cross_size - square_offset-square_size; %Start-Reihe: von der Mitte aus das Fixationskreuz und einen Abstand nehmen.
square_start_col = center - round(square_size / 2); %von der Mitte aus die Hälfte des Quadrats nach links 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_overcenter.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie

%% Quadrat rechts
%Berechnung square_start_row ändert sich!
square_start_row = center - round(square_size / 2);
square_start_col = center + cross_size + square_offset; %von der Mitte aus die Hälfte des Quadrats nach links 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_rightcenter.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie


%% Quadrat links
%Berechnung square_start_row ändert sich!
square_start_row = center - round(square_size / 2);
square_start_col = center - cross_size - square_offset - square_size; %von der Mitte aus die Hälfte des Quadrats nach links 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_leftcenter.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie

%% Quadrat links-oben
%Berechnung square_start_row ändert sich!
square_start_row = center - cross_size - square_offset-square_size; %Positionierung oben
square_start_col = center - cross_size - square_offset - square_size; %Positionierung links vom Kreuz 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_leftover.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie


%% Quadrat rechts - oben
%Berechnung square_start_row ändert sich!
square_start_row = center - cross_size - square_offset-square_size; %Positionierung oben
square_start_col = center + cross_size + square_offset; %Positionierung rechts vom Kreuz
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_rightover.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie

%% Quadrat links-unten
%Berechnung square_start_row ändert sich!
square_start_row = center + cross_size + square_offset; %Positionierung unten
square_start_col = center - cross_size - square_offset - square_size; %Positionierung links vom Kreuz 
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_leftunder.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie

%% Quadrat rechts - unten
%Berechnung square_start_row ändert sich!
square_start_row = center + cross_size + square_offset; %Positionierung unten
square_start_col = center + cross_size + square_offset; %Positionierung rechts vom Kreuz
bitmap(square_start_row:square_start_row + square_size - 1, square_start_col:square_start_col + square_size - 1) = 1; %Quadrat
imwrite(bitmap, './bitmaps/sq_rightunder.bmp');

%Fixationskreuz wiederherstellen
bitmap = zeros(size,size);
bitmap(center-cross_thick:center+cross_thick, center-cross_size:center+cross_size)=1; %Horizontale Linie
bitmap(center-cross_size:center+cross_size, center-cross_thick:center+cross_thick) = 1; %Vertikale Linie