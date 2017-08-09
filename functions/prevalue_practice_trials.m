function prevalue_practice_trials(w, xs, ys, practicefilename, img_folder, imgwidth, imgheight, bordercolor1, borderRect1, min_pretarget, max_pretarget, irr_tarray, target, duration, response, aperture2, aperture3, p_type, keypress_1, keypress_2, keypress_3, keypress_4, keypress_5, keypress_repeat, scorelocation, score_img1_1, score_img1_2, score_img2_1, score_img2_2, slack)

%%%%%%%%%%%%%%%%%%%%%%
% 1 - Read in the conditions and stimuli locations
%%%%%%%%%%%%%%%%%%%%%% 

% read list of conditions/stimulus images -- textread() is a matlab function
% objnumber  arbitrary number of stimulus
% direction    stimulus direction L=2 R=1
% metrical   is trial to be metrical or irregular?          
[ objnumber, filename1, ~, soundname1] = textread(practicefilename,'%d %s %s %s');

% get number of trials
ntrials=length(objnumber);         


%%    
%%%%%%%%%%%%%%%%%%%%%%
% 2 - Final screen prepair prior to trial initiation
%%%%%%%%%%%%%%%%%%%%%%

% Call the function ptb_final_prepair_before_trials () - get slack fig.


%%
%%%%%%%%%%%%%%%%%%%%%%
% 3 - PRACTICE PRESENTATION LOOPS
%%%%%%%%%%%%%%%%%%%%%%

% Loop through all trial detailed in testfilename variable
for trial=1:ntrials;

    % read stimulus image 1 into matlab matrix 'imdata':
    stimfilename=strcat(img_folder,char(filename1(trial))); % assume stims are in subfolder "stims"
    imdata1=imread(char(stimfilename));  

    wavfilename = strcat(img_folder,char(soundname1(trial)));

    % Call the load audio buffer function to prepare for audio
    % presentation
    [pahandle] = load_audio_buffer(wavfilename);

    % Calculate the location of the image on screen
    % see http://matlabfun.ucsd.edu/files/2013/09/playwithtextures2.m
    % see http://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/6393 
    targetlocation = ([xs - imgwidth/2 , ys - imgheight/2, xs + imgwidth/2, ys + imgheight/2]);

    % make texture image out of image matrix 'imdata'        
    target_img1=Screen('MakeTexture', w, imdata1);
    targetcolor=Screen('OpenOffscreenwindow', w, bordercolor1, borderRect1);      

    % Generate a random time for target cues based on input parameters.
    t_before_onset = randi([min_pretarget max_pretarget],1,1);

    % Set the counter variable to 0.00 for the next while statement.
    loopcount = 0;
    StimulusOnsetTime= 0;

    % Show stimulus on screen at next possible display refresh cycle,
    [~, StartTime]=Screen('Flip', w);


    %%%%%%%%%%%%%%%%%%%%%%
    % 4 - Loop through aperture 2 creating a jittering effect
    %%%%%%%%%%%%%%%%%%%%%%        

    % Loop through pretarget cues while counter <= to t_before_onset
    while StimulusOnsetTime<=(StartTime+t_before_onset);   

        % Overdraw the aperture3 texture
        Screen('DrawTexture', w, aperture2); 

        if (loopcount <1)                            
            % Flip screen with the new texture - record system time
            [~, StimulusOnsetTime] = Screen('Flip', w, 0); 
        else     
            when = StimulusOnsetTime + stim_interval;
            [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
        end

        % Define the timestamp for the when variable
        when = StimulusOnsetTime + duration;
        when2 = StimulusOnsetTime + 0.01;

        % Return the display back to standard screen as defined by when.
        [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);

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

        % update counter to ensure loop finishes at desired moment
        %counter = counter+stim_interval;
        loopcount = loopcount+1; 
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % 5 - Create and present target.
    %%%%%%%%%%%%%%%%%%%%%%

    % Initialize KbCheck and variables:
    [~, ~, keyCode]=KbCheck;              

    % Draw the target texture to screen       
    Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
    Screen('DrawTexture', w, target_img1, [], targetlocation);                                 

    % play the preloaded sound file.
    PsychPortAudio('Start', pahandle, 1, when2-slack, 1);

    % Show stimulus on screen at next possible display refresh cycle,
    [~, StimulusOnsetTime]=Screen('Flip', w, when2-slack);


    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 6 - Call and present the response window
    %%%%%%%%%%%%%%%%%%%%%% 

    % Record a time value for the target presentation onset
    when = StimulusOnsetTime + target;

    % Draw the aperture3 texture
    Screen('DrawTexture', w, aperture3);

    
    % Display first instruction message 
    % 85 words
    if p_type == 1
        Screen('DrawTexture', w, score_img1_1, [], scorelocation);
    elseif p_type == 2 
        Screen('DrawTexture', w, score_img2_1, [], scorelocation);
    end        

    message = '\n\n\n\nFAMILIARITY \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';
    
    % Write 'message' centered in the middle of the display, in white color.
    DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

    % Flip screen with the new texture - record system time
    [~, ~] = Screen('Flip', w, when-slack);  


    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 7 - Record reaction times at 1 m/s intervals
    %%%%%%%%%%%%%%%%%%%%%%

    % Record reaction times at 1 m/s intervals - Target showing 

    % While loop to show stimulus until subjects response or until
    % "duration" seconds elapsed

    while (keyCode(keypress_1)~=1 || keyCode(keypress_2)~=1 ||  keyCode(keypress_3)~=1 ||  keyCode(keypress_4)~=1 ||  keyCode(keypress_5)~=1)
        % poll for a resp
        % during test phase, subjects can response
        % before stimulus terminates

        if (keyCode(keypress_1)==1 || keyCode(keypress_2)==1 ||  keyCode(keypress_3)==1 ||  keyCode(keypress_4)==1 ||  keyCode(keypress_5)==1 )
            break;
        end

        [~, ~, keyCode]=KbCheck;

        if (keyCode(keypress_repeat)== 1)
              
            % Draw the target texture to screen       
            Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
            Screen('DrawTexture', w, target_img1, [], targetlocation);                                 

            % play the preloaded sound file.
            PsychPortAudio('Start', pahandle, 1, when2-slack, 1);

            % Show stimulus on screen at next possible display refresh cycle,
            [~, StimulusOnsetTime]=Screen('Flip', w, 0);
                
            % Record a time value for the target presentation onset
            when = StimulusOnsetTime + target;
                
            % Draw the aperture3 texture
            Screen('DrawTexture', w, aperture3);
        
            % Display first instruction message 
            if p_type == 1                                                                                             
                Screen('DrawTexture', w, score_img1_1, [], scorelocation);
            elseif p_type == 2 
                Screen('DrawTexture', w, score_img2_1, [], scorelocation);
            end        

            message = '\n\n\n\nFAMILIARITY \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';

            % Write 'message' centered in the middle of the display, in white color.
            DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

            % Flip screen with the new texture - record system time
            [~, ~] = Screen('Flip', w, when-slack); 
                
            % Flush Keycode event information
            FlushEvents(keyCode)              
        end

        % Wait 1 ms before checking the keyboard again to prevent
        % overload of the machine at elevated Priority():
        WaitSecs(0.0005);
    end        


    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 8 - Clear system memory in preparation for second question
    % response value
    %%%%%%%%%%%%%%%%%%%%%%

    % Wait until all keys are released.
    while KbCheck; end 

    % Flush Keycode event information
    FlushEvents(keyCode)

    % Initialize KbCheck and variables:
    [~, ~, keyCode]=KbCheck;  

    % Draw the target texture to screen
    Screen('DrawTexture', w, aperture3);                              

    % Show stimulus on screen at next possible display refresh cycle,
    [~, StimulusOnsetTime]=Screen('Flip', w, 0);



    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 10 - Call and present the response window
    %%%%%%%%%%%%%%%%%%%%%% 

    % Record a time value for the target presentation onset
    when = StimulusOnsetTime;

    % Draw the aperture3 texture
    Screen('DrawTexture', w, aperture3);

    % Display first instruction message 
    % 85 words
    if p_type == 1
        Screen('DrawTexture', w, score_img1_2, [], scorelocation);
    elseif p_type == 2 
        Screen('DrawTexture', w, score_img2_2, [], scorelocation);
    end   
    
    message = '\n\n\n\nPREFERENCE \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';
    
    % Write 'message' centered in the middle of the display, in white color.
    DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

    % Flip screen with the new texture - record system time
    [~, ~] = Screen('Flip', w, when-slack);  


    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 11 - Record reaction times at 1 m/s intervals
    %%%%%%%%%%%%%%%%%%%%%%

    % Record reaction times at 1 m/s intervals - Target showing 

    % While loop to show stimulus until subjects response or until
    % "duration" seconds elapsed
    while (keyCode(keypress_1)~=1 || keyCode(keypress_2)~=1 ||  keyCode(keypress_3)~=1 ||  keyCode(keypress_4)~=1 ||  keyCode(keypress_5)~=1)
        % poll for a resp
        % during test phase, subjects can response
        % before stimulus terminates

        if (keyCode(keypress_1)==1 || keyCode(keypress_2)==1 ||  keyCode(keypress_3)==1 ||  keyCode(keypress_4)==1 ||  keyCode(keypress_5)==1 )
            break;
        end

        [~, ~, keyCode]=KbCheck;

        if (keyCode(keypress_repeat)== 1)
                
            % Draw the target texture to screen       
            Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
            Screen('DrawTexture', w, target_img1, [], targetlocation);                                 

            % play the preloaded sound file.
            PsychPortAudio('Start', pahandle, 1, when2-slack, 1);

            % Show stimulus on screen at next possible display refresh cycle,
            [~, StimulusOnsetTime]=Screen('Flip', w, 0);
                
            % Record a time value for the target presentation onset
            when = StimulusOnsetTime + target;
                
            % Draw the aperture3 texture
            Screen('DrawTexture', w, aperture3);
        
            % Display first instruction message 
            if p_type == 1
                Screen('DrawTexture', w, score_img1_2, [], scorelocation);
            elseif p_type == 2 
                Screen('DrawTexture', w, score_img2_2, [], scorelocation);
            end        

            message = '\n\n\n\nPREFERENCE \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';

            % Write 'message' centered in the middle of the display, in white color.
            DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

            % Flip screen with the new texture - record system time
            [~, ~] = Screen('Flip', w, when-slack); 
                
            % Flush Keycode event information
            FlushEvents(keyCode)           
        end
        
        % Wait 1 ms before checking the keyboard again to prevent
        % overload of the machine at elevated Priority():
        WaitSecs(0.0005);
    end        

    % Tidy up all of the used off screen textures to save memory  
    Screen('Close', [target_img1, targetcolor]);
    PsychPortAudio('Close');   

    % end the trials loop
end 
end