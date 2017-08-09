function onscreen_text (w, message)

% Write 'message' centered in the middle of the display, in white color.
DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

% Update the display to show the instruction text:
Screen('Flip', w); 

% Wait for mouse click:
GetClicks(w); 

end