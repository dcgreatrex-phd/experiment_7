function ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)

% draw the correct cue textures to screen
    Screen('DrawTexture', w, leftcolor2, [], borderRect1 , [], 0);  
    Screen('DrawTexture', w, rightcolor2, [], borderRect2 , [], 0);
    Screen('DrawTexture', w, left_gray_rect, [], borderRect3);
    Screen('DrawTexture', w, right_gray_rect, [], borderRect4);       
end        