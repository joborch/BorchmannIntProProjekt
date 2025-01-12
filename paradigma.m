%author: Jonas Borchmann
%Description: This file operates the Psychtoolbox Paradigma.
%Configuration: You dont need to change anything. Changable Settings will be showed in a block at the front.

%% Changable Settings
a = 1;
b = 2;

%% Working Directory
currentFilePath = mfilename('fullpath'); %speichern vom Pfad der genutzten Datei
[currentFolderPath, ~, ~] = fileparts(currentFilePath); %rausspeichern vom Ordner-Pfad 
cd(currentFolderPath); %Aktuelles Working Directory setzen!