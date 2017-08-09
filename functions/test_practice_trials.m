function test_practice_trials(testpfilename,w,gray,wRect,rectSize,numRects,scale,img_gap,imgwidth,imgheight,borderwidth,img_folder,bordercolor1,bordercolor2,cue_duration,min_pretarget,max_pretarget,duration,response,std_gap,irr_tarray,target,low_keypress,high_keypress,slack)


    
%%
%%%%%%%%%%%%%%%%%%%%%%
% 1 - Create the recurring stimuli textures and offscreen windows
%%%%%%%%%%%%%%%%%%%%%% 
   
% 1.1 - Calculate the center point of the screen
[xs,ys] = RectCenter(wRect);
    
% 1.2 - Calculate and create all Rects to be used
    
% 1.3 - Compute destination rectangle locations: 'objRect'
objRect = SetRect(0,0, rectSize, rectSize);

% 1.4 - ArrangeRects creates 'numRects' copies of 'objRect', all distributed evenly in window of size 'w':
dstRect = ArrangeRects(numRects, objRect, wRect);

% 1.5 - Rescale all rects: They are scaled in size by a factor 'scale':
for i=1:numRects
    % Compute center position [xc,yc] of the i'th rectangle:
    [xc, yc] = RectCenter(dstRect(i,:));
    % Create a new rectange, centered at the same position, but 'scale'
    % times the size of our pixel noise matrix 'objRect':
    dstRect(i,:)=CenterRectOnPoint(objRect * scale, xc, yc);
end   
    
    
%%
%%%%%%%%%%%%%%%%%%%%%%
% 2 - Enable Alpha blending to enable opaque function in textures
%%%%%%%%%%%%%%%%%%%%%% 
    
% Enable alpha blending: This makes sure that the alpha channel
% (transparency channel) of our 'aperture' texture is used properly: 
% This blending mode will allow to draw partially opaque shapes or
% texture images, where the opacity is controlled by the alpha value of
% the current pen color (shape drawing) or of the alpha channel of
% textures. 
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
%%
%%%%%%%%%%%%%%%%%%%%%%
% 3 - Read in the conditions and stimuli locations (from trailfilename.txt
%%%%%%%%%%%%%%%%%%%%%% 

% read list of conditions/stimulus images -- textread() is a matlab function
% objnumber  arbitrary number of stimulus
% direction    stimulus direction L=2 R=1
% metrical   is trial to be metrical or irregular?          
[ objnumber,filename1,soundname1,filename2,soundname2,metrical, location, ~, ~] = textread(testpfilename,'%d %s %s %s %s %d %d %d %d');
    
% Randomize order of list
ntrials=length(objnumber);         % get number of trials

        
    
%%    
%%%%%%%%%%%%%%%%%%%%%%
% 4 - Final screen prepair prior to trial initiation
%%%%%%%%%%%%%%%%%%%%%%

    
%%
%%%%%%%%%%%%%%%%%%%%%%
% 5 - EXPERIMENTAL PRACTICE LOOPS
%%%%%%%%%%%%%%%%%%%%%%

% Loop through all trial detailed in testfilename variable
for trial=1:ntrials;
        
    %%%%%%%%%%%%%%%%%%%%%%
    % 5 - PRE_TRIAL PREPARATION
    %%%%%%%%%%%%%%%%%%%%%%
       
    % Call function to create all of the experimental off screen windows
    [aperture1, aperture2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect] = ptb_offscreen_creation(w, gray, objRect, xs, ys, img_gap, imgwidth, borderwidth, imgheight);  

    % 5.0.1 - Call function ptb_loadimages to load the target images as textures        
    [leftlocation, rightlocation, target_img1, target_img2, leftcolor, rightcolor, leftcolor2, rightcolor2] = ptb_loadimages(w, img_folder, filename1, filename2, location, trial, xs, ys, imgwidth, imgheight, img_gap, borderRect1, borderRect2, bordercolor1, bordercolor2);
         
    % 5.0.2 - Call the functions to load both sound clips into the
    % audio buffer.     
    wavfilename = strcat(img_folder,char(soundname1(trial)));
        
    % 5.0.3 - Call the load audio buffer function to prepare for audio
    % presentation
    %[pahandle] = load_audio_buffer(wavfilename);
    
        % 1 - Read WAV file from filesystem:
        [y, freq] = wavread(wavfilename);
        wavedata = y';
        nrchannels = size(wavedata,1); % Number of rows == number of channels.

        % Make sure we have always 2 channels stereo output.
        % Why? Because some low-end and embedded soundcards
        % only support 2 channels, not 1 channel, and we want
        % to be robust in our demos.
        if nrchannels < 2
            wavedata = [wavedata ; wavedata];
            nrchannels = 2;
        end

        % Perform basic initialization of the sound driver:
        InitializePsychSound(1);   

        try
            % Try with the 'freq'uency we wanted:
            pahandle = PsychPortAudio('Open', [], [], 3, freq, nrchannels);
        catch
            psychlasterror('reset');
            pahandle = PsychPortAudio('Open', [], [], 3, freq, nrchannels);
        end      

        % Fill the audio playback buffer with the audio data 'wavedata':
        PsychPortAudio('FillBuffer', pahandle, wavedata);
                        
    % draw the correct cue borders on screen
    ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)
    
    [~, CueOnsetTime] = Screen('Flip', w, 0);
       
    % 5.0.7 - Define the timestamp for the when variable
    when = CueOnsetTime + cue_duration;            
   
    % draw the correct cue borders on screen
    ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)
        
    % 5.0.8 - Flip screen with the new texture - record system time
    [~, StartTime] = Screen('Flip', w, when-slack); 
        
    % 5.0.9 - Generate a random time for target cues based on input parameters.
    t_before_onset = randi([min_pretarget max_pretarget],1,1);
        
    % 5.0.10 - Set the counter variable to 0.00 for the next while statement.
    loopcount = 0;        
    StimulusOnsetTime= 0;     

        
    %%%%%%%%%%%%%%%%%%%%%%
    % 6 - PRE_TARGET CUE PRESENTATION
    %%%%%%%%%%%%%%%%%%%%%%
        
        % Loop through pretarget cues while counter <= to t_before_onset
        while StimulusOnsetTime<=(StartTime+t_before_onset);                                   
            
            % draw the correct cue borders on screen
            ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect) 
            
            % Create and present the pretarget - run function ptb_pretarget
            [tex] = ptb_pretarget(rectSize, w, dstRect, numRects, aperture1);  
            
            if (loopcount <1)                            
                % Flip screen with the new texture - record system time
                [~, StimulusOnsetTime] = Screen('Flip', w, StartTime+0.250); 
            else     
                when = StimulusOnsetTime + stim_interval;
                [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
            end             
            
            % draw the correct cue borders on screen
            ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)        
            
            % Define the timestamp for the when variable
            when = StimulusOnsetTime + duration;            
            
            % Return the display back to standard screen as defined by when.
            [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);        
            
            % close the tex offscreen window to reduce memory load
            Screen('Close', tex);
            
            % Determine how long to allocate to stim_interval (regular vs irregular)
            if (metrical(trial)==1) 
                stim_interval=std_gap;
            else
                % Select a random value from the irr_tarray. Ensure that the same interval is not directly repeated - recorded using the rgenerate_flag variable.
                if exist('rgenerate_flag', 'var') 
                    matrix = setdiff(1:5, rgenerate_flag);
                    rgenerate=matrix(randi(numel(matrix)));
                    irr_gap = irr_tarray(rgenerate);
                    stim_interval=irr_gap;
                    % record the rgenerate flag
                    rgenerate_flag = rgenerate;
                else    
                    rgenerate = round(3*rand(1)+2);
                    irr_gap = irr_tarray(rgenerate);
                    stim_interval=irr_gap;
                    % record the rgenerate flag
                    rgenerate_flag = rgenerate;
                end
            end
            % update counter to ensure loop finishes at desired moment
            %counter = counter+stim_interval;
            loopcount = loopcount+1;     
        end
        
    %%%%%%%%%%%%%%%%%%%%%%
    % 7 - TARGET PRESENTATION
    %%%%%%%%%%%%%%%%%%%%%%
               
    % 7.1 - Penultimate pretarget cue set at at std_gap + duration values.

    % draw the correct cue borders on screen
    ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect) 
    
    % present the penultimate pretarget cue - run function ptb_pretarget.
    [tex] = ptb_pretarget(rectSize, w, dstRect, i, aperture1);
        
    % Define the timestamp for the when variable
    when = StimulusOnsetTime + std_gap;
        
    % Flip screen with the new texture - record system time
    [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
        
    % Define the timestamp for the when variable
    when = StimulusOnsetTime + duration;
    
    % draw the correct cue borders on screen
    ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect) 
            
    % Return the display back to standard screen as defined by when.
    [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);
       
        
    %%%%%%%%%%%%%%%%%%%%%%
    % 8 - Create and present target.
    %%%%%%%%%%%%%%%%%%%%%%

    % 8.1 - Initialize KbCheck and variables:
    [~, ~, keyCode]=KbCheck;         
        
    % 8.2 - Record a time value for the target presentation onset
    when = StimulusOnsetTime + std_gap;       
             
    % 8.3 - Draw the target texture to screen
    Screen('DrawTexture', w, leftcolor, [], borderRect1 , [], 0);                
    Screen('DrawTexture', w, target_img1, [], leftlocation);                
    % 8.4 - Draw the target texture to screen
    Screen('DrawTexture', w, rightcolor, [], borderRect2 , [], 0);       
    Screen('DrawTexture', w, target_img2, [], rightlocation);                   

    % 8.5 - Play the preloaded sound file.
    PsychPortAudio('Start', pahandle, 1, when-slack, 1);
        
    % 8.6 - Show stimulus on screen at next possible display refresh cycle,
    [~, StimulusOnsetTime]=Screen('Flip', w, when-slack);  
           
    % 8.7 - Record a time value for the target presentation onset
    when = StimulusOnsetTime + target;
         
    % 8.8 - Draw the target texture to screen
    Screen('DrawTexture', w, rightcolor, [], borderRect1 , [], 0);                
    Screen('DrawTexture', w, target_img1, [], leftlocation);        
    % 8.9 - Draw the target texture to screen
    Screen('DrawTexture', w, leftcolor, [], borderRect2 , [], 0);       
    Screen('DrawTexture', w, target_img2, [], rightlocation);                   

    % 8.10 - Preload the second sound file and reset the audio buffer.
    wavfilename = strcat(img_folder,char(soundname2(trial)));
        
    % 8.11 - Read WAV file from filesystem:
    [y, freq] = wavread(wavfilename);
    wavedata = y';
    nrchannels = size(wavedata,1); % Number of rows == number of channels.

    % 8.12 - Make sure we have always 2 channels stereo output.
    % Why? Because some low-end and embedded soundcards
    % only support 2 channels, not 1 channel, and we want
    % to be robust in our demos.
    if nrchannels < 2
        wavedata = [wavedata ; wavedata];
        nrchannels = 2;
    end  

    try
        % 8.13 - Try with the 'freq'uency we wanted:
        pahandle = PsychPortAudio('Open', [], [], 3, freq, nrchannels);
    catch
        psychlasterror('reset');
        pahandle = PsychPortAudio('Open', [], [], 3, freq, nrchannels);
    end
        

    % 8.14 - Fill the audio playback buffer with the audio data 'wavedata':
    PsychPortAudio('FillBuffer', pahandle, wavedata);
                
    % 8.15 - Play the preloaded sound file.
    PsychPortAudio('Start', pahandle, 1, when-slack, 1);
   
    % 8.16 - Show stimulus on screen at next possible display refresh cycle,
    [~, StimulusOnsetTime]=Screen('Flip', w, when-slack);    
        
                
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 9 - Call and present the response window
    %%%%%%%%%%%%%%%%%%%%%% 
        
    % Record a time value for the target presentation onset
    when = StimulusOnsetTime + target;
        
    % Overdraw the aperture3 texture
    Screen('DrawTexture', w, aperture2);
        
    % Display first instruction message - run function (onscreen_text) 
    message = 'L                         R';    
    % Write 'message' centered in the middle of the display, in white color.
    DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
       
    % Flip screen with the new texture - record system time
    [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);  
        
    
        
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 10 - Record reaction times at 1 m/s intervals
    %%%%%%%%%%%%%%%%%%%%%%
        
    % Record reaction times at 1 m/s intervals - Target showing 
        
    % define endtime for stimulus loop (target showing)
    endtime=StimulusOnsetTime + response;
        
    % while loop to show stimulus until subjects response or until
    % "duration" seconds elapsed.
    while (GetSecs < endtime)
        % poll for a resp
        % during test phase, subjects can response
        % before stimulus terminates
    
        if ( keyCode(low_keypress)==1 || keyCode(high_keypress)==1 )
            break;
        end           
        [~, ~, keyCode]=KbCheck(-1);
        % Wait 1 ms before checking the keyboard again to prevent
        % overload of the machine at elevated Priority():
        WaitSecs(0.0005);
    end                     

    % Clear all off screen buffer images that are no longer required.
    Screen('Close', [target_img1, target_img2, leftcolor, rightcolor, leftcolor2, rightcolor2, tex, aperture1, aperture2, left_gray_rect, right_gray_rect]);
    PsychPortAudio('Close');  
    
% end the trials loop
end   

Screen('Close', [aperture1, aperture2]);

end