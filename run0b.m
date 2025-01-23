function [answers, tLast] = run0b(BMInd,ToneInd, toneLib, bitmapLib, BitmapTime, fixcrossTexture, FixCrossTime, tStart, WindowPtr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
answers = nan(4,10);
KeyIsDown = 0;
for i = 1:10
    if i == 1
        Screen('DrawTexture', WindowPtr, bitmapLib(BMInd(1,i)));
        tOnset = Screen('Flip', WindowPtr, tStart + 15);
        PsychPortAudio('Start', toneLib(ToneInd(1,i)), 1, tStart + 15);
        Screen('DrawTexture', WindowPtr, fixcrossTexture);
        [tFix, StimulusOnsetTime] = Screen('Flip', WindowPtr, tOnset + BitmapTime);
        
        %Reaktionszeitmessung und Keyboardcheck
        while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=(FixCrossTime-0.1)
            [KeyIsDown, endRT, ~, ~] = KbCheck();
            
            WaitSecs(0.001);
        end
        answers(1,i) = endRT - StimulusOnsetTime;
        answers(2,i) = KeyIsDown;
        KeyIsDown = 0;
        PsychPortAudio('Stop', toneLib(ToneInd(1,i)))
    else
        Screen('DrawTexture', WindowPtr, bitmapLib(BMInd(1,i)));
        tOnset = Screen('Flip', WindowPtr, tFix + FixCrossTime);
        PsychPortAudio('Start', toneLib(ToneInd(1,i)), 1, tFix + FixCrossTime);
        Screen('DrawTexture', WindowPtr, fixcrossTexture);
        [tFix, StimulusOnsetTime] = Screen('Flip', WindowPtr, tOnset + BitmapTime);
        
        %Reaktionszeitmessung und Keyboardcheck
        while (KeyIsDown == 0) && (GetSecs - StimulusOnsetTime)<=(FixCrossTime-0.1)
            [KeyIsDown, endRT, ~, ~] = KbCheck();
            
            WaitSecs(0.001);
        end
        answers(1,i) = endRT - StimulusOnsetTime;
        answers(2,i) = KeyIsDown;
        KeyIsDown = 0;
        PsychPortAudio('Stop', toneLib(ToneInd(1,i)))
    end
    tLast = tFix+FixCrossTime;
end
end