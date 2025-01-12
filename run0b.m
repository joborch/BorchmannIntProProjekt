function [answers, tLast] = run0b(BMInd,ToneInd, toneLib, bitmapLib, BitmapTime, fixcrossTexture, FixCrossTime, tStart, WindowPtr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
answers = nan(2,20);
KeyIsDown = 0;
for i = 1:20
    if i == 1
        Screen('DrawTexture', WindowPtr, bitmapLib(BMInd(1,i)));
        tOnset = Screen('Flip', WindowPtr, tStart + 5);
        PsychPortAudio('Start', toneLib(ToneInd(1,i)), 1, tStart + 15);
        Screen('DrawTexture', WindowPtr, fixcrossTexture);
        [tFix, StimulusOnsetTime] = Screen('Flip', WindowPtr, tOnset + BitmapTime);
        
        %Reaktionszeitmessung und Keyboardcheck
        while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=2.4
            [KeyIsDown, endRT, ~, ~] = KbCheck();
            
            WaitSecs(0.001);
        end
        answers(1,i) = endRT - StimulusOnsetTime;
        answers(2,i) = KeyIsDown;
        KeyIsDown = 0;
    else
        Screen('DrawTexture', WindowPtr, bitmapLib(BMInd(1,i)));
        tOnset = Screen('Flip', WindowPtr, tFix + FixCrossTime);
        PsychPortAudio('Start', toneLib(ToneInd(1,i)), 1, tStart + 5);
        Screen('DrawTexture', WindowPtr, fixcrossTexture);
        [tFix, StimulusOnsetTime] = Screen('Flip', WindowPtr, tOnset + BitmapTime);
        
        %Reaktionszeitmessung und Keyboardcheck
        while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=2.4
            [KeyIsDown, endRT, ~, ~] = KbCheck();
            
            WaitSecs(0.001);
        end
        answers(1,i) = endRT - StimulusOnsetTime;
        answers(2,i) = KeyIsDown;
        KeyIsDown = 0;
    end
    tLast = tFix+FixCrossTime;
end

end