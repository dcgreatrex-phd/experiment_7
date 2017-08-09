function z_prevalue_configuration_images(subNo)

% Add the function folder to MATLAB path
addpath('./functions/') 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 - Define experimental variables.
%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up variables
% Name of the experiment;
exp_name = 'images_pvalue_';
% Name of the participant folder;
p_folder = strcat('output/P_', num2str(subNo), '/');
% Name of the stimulus image folder
img_folder = 'stimuli/stims/';
% Location of the .txt file stimulus information within current path;                        
testfilename = 'input/stim_prelist.txt';
% Location of the practice file stimulus.
%practicefilename = 'input/stim_prelist2.txt';

% Size of the onsecreen text size;
text_size = 20;

% Define all keyboard keys to be used. 
kb1 = 'c';
kb2 = 'v';
kb3 = 'b';
kb4 = 'n';
kb5 = 'm';
kbr = 'r';

% Image height dimentions of the stimulus images - ~ 6.7X6.7 visual degrees
imgwidth = 361;
% Image width dimentions of the stimulus images
imgheight = 361;
% Border colour 1 definition - Pink
%bordercolor1 = [255 105 180];
bordercolor1 = [0 190 0];
% Border width
borderwidth = 15;
% Assign dimensions of both score images to use at response collection point.
simgwidth = 960;
simgheight = 227;

% Minimum pretarget loop time
min_pretarget = 5.000;
% Maximum pretarget time
max_pretarget = 5.000;
% Array of timings to be used in the irregular condition to create gap 
irr_tarray = [0.040,0.070,0.100,0.130,0.160];

% Duration of the presented pretarget textures.
duration = 0.050; 
% Duration of the target window
target = 3.000;
% Duration of the response period
response = 5.000;



%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 - preliminary set-up commands
%%%%%%%%%%%%%%%%%%%%%%%%%

% Call screen setup function.
ptb_screen_setup()

% set p_type by calculating even odd characteristic
if mod(subNo,2) == 0
  % even  
  p_type = 1;
else
  % odd  
  p_type = 2;
end

% Define keyboard responses:
% First response
keypress_1=KbName(kb1); 
% Second response
keypress_2=KbName(kb2); 
% Third response
keypress_3=KbName(kb3); 
% Fourth response
keypress_4=KbName(kb4); 
% Fifth response
keypress_5=KbName(kb5);
% repeat response
keypress_repeat=KbName(kbr);


%%
%%%%%%%%%%%%%%%%%%%%%%
% 3 - file handling definitions
%%%%%%%%%%%%%%%%%%%%%%

% define filename and location of the output .txt result file:
datafilename = strcat(exp_name,num2str(subNo),'.txt'); % name of data file to write to
datafilename = strcat(p_folder, datafilename);                  

% Create a new file and open ready for writing set to text mode;
if(exist(datafilename, 'file'));
    display('This file already exists in the Participant folder... Do not write over exsiting data!');
    clear;
else    
    datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
end

% Open a results output file to catch any crashes
% Name of the experiment;
exp_name2 = 'pvalue_images_output_';
% define filename and location of the output .txt result file:
datafilename2 = strcat(exp_name2,num2str(subNo),'.txt'); % name of data file to write to
datafilename2 = strcat(p_folder, datafilename2);                  
% Create a new file and open ready for writing set to text mode;
if (exist(datafilename2, 'file'));
    display('This file already exists in the Participant folder... Do not write over exsiting data!');
    clear;
else    
    fopen(datafilename2,'wt'); % open ASCII file for writing
end

diary(datafilename2);



%%
%%%%%%%%%%%%%%%%%%%%%%
% 4 - Start the experimenal code  
%%%%%%%%%%%%%%%%%%%%%%

% wrap experimental code in try..catch statement to clean up, save results, close the onscreen window in the case of ML/PTB error.
try  
    
    % 4.1.1 - Open grey screen and run tests by calling the function ptb_grey_..etc
    [gray, w, wRect, slack] = ptb_open_screen(text_size);
    
    % 4.1.2 - Calculate the center point of the screen
    [xs,ys] = RectCenter(wRect);
    
    % 4.1.3 - Compute first destination picture border: 'borderRect1' 
    borderRect1 = SetRect(xs - (imgwidth+borderwidth)/2 , ys - (imgheight+borderwidth)/2, xs + (imgwidth+borderwidth)/2, ys + (imgheight+borderwidth)/2);   
        
    % 4.1.4 - Build an off screen aperture texture which will contain pre stimulus cue:
    objRect2 = SetRect(0,0, 500, 500);
    aperture2=Screen('OpenOffscreenwindow',w, gray, objRect2);
    Screen('FillOval', aperture2, [0 0 0 255], CenterRect(SetRect(0,0,10,10),objRect2));
    
    % 4.1.5 - define the aperture rect for displying text
    aperture3=Screen('OpenOffscreenwindow',w, gray, objRect2);
  
    

    % 4.1.6 - read the response score images into matlab
    scorefile1_1=strcat(img_folder,char('simage1_1.jpeg')); % assume stims are in subfolder "stims"
    scoreim1_1=imread(char(scorefile1_1));  
    scorefile1_2=strcat(img_folder,char('simage1_2.jpeg')); % assume stims are in subfolder "stims"
    scoreim1_2=imread(char(scorefile1_2));  
    scorefile1_3=strcat(img_folder,char('simage1_3.jpeg')); % assume stims are in subfolder "stims"
    scoreim1_3=imread(char(scorefile1_3));  
    
    scorefile2_1=strcat(img_folder,char('simage2_1.jpeg')); % assume stims are in subfolder "stims"
    scoreim2_1=imread(char(scorefile2_1));  
    scorefile2_2=strcat(img_folder,char('simage2_2.jpeg')); % assume stims are in subfolder "stims"
    scoreim2_2=imread(char(scorefile2_2));
    scorefile2_3=strcat(img_folder,char('simage2_3.jpeg')); % assume stims are in subfolder "stims"
    scoreim2_3=imread(char(scorefile2_3));

    
    

    % 4.1.7 - Calculate the location of the score image on screen
    % see http://matlabfun.ucsd.edu/files/2013/09/playwithtextures2.m
    % see http://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/6393 
    scorelocation = ([xs - simgwidth/2 , (ys+50) - simgheight/2, xs + simgwidth/2, (ys+50) + simgheight/2]);
    scorelocation1 = ([xs - simgwidth/2 , (ys-170) - simgheight/2, xs + simgwidth/2, (ys-170) + simgheight/2]);
    scorelocation2 = ([xs - simgwidth/2 , (ys+80) - simgheight/2, xs + simgwidth/2, (ys+80) + simgheight/2]);
    scorelocation3 = ([xs - simgwidth/2 , (ys) - simgheight/2, xs + simgwidth/2, (ys) + simgheight/2]);

    
    % 4.1.8 - Make texture image out of image matrix 'imdata'        
    score_img1_1=Screen('MakeTexture', w, scoreim1_1);
    score_img2_1=Screen('MakeTexture', w, scoreim2_1);
    score_img1_2=Screen('MakeTexture', w, scoreim1_2);
    score_img2_2=Screen('MakeTexture', w, scoreim2_2);
    score_img1_3=Screen('MakeTexture', w, scoreim1_3);
    score_img2_3=Screen('MakeTexture', w, scoreim2_3);
    
    
        
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 4.2 - Enable Alpha blending to enable opaque function in textures
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
    % 4.3 - Display instruction messages
    %%%%%%%%%%%%%%%%%%%%%% 

    % 4.3.1 - Display first instruction message - run function (onscreen_text) 
    message = 'Task 3 \n\n\n\n In each trial of this experiment you will see only the CD covers. \n\n\n\n Your task is simply to say: \n\n 1) How much do you like the picture? \n\n\n\n This task has **nothing** to do with music and is only about how much you like the CD cover design, based on just the image. \n\n Your response should represent how you feel now. \n\n\n\n Press the mouse button to continue ...';    
    onscreen_text(w, message)
    
    % 4.3.2 - Display first instruction message - run function (onscreen_text)
    if p_type == 1;
        Screen('DrawTexture', w, score_img1_3, [], scorelocation3);
    elseif p_type == 2;
        Screen('DrawTexture', w, score_img2_3, [], scorelocation3);   
    end    
        
    message = 'Your response options look like this: \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n If you want to see the image again, press the _R_ key. \n\n\n\n Press the mouse button to continue ...';  
    onscreen_text(w, message)  
         
    % 4.3.5 - Display the correct key assignment instructions depending on
    % p_type.
%     if p_type == 1
%         message = 'Now try with three practice trials \n\n\n\n Use response keys "C" "V" "B" "N" "M" as indicated on screen. \n\n\n\n Press the mouse button to start...'; 
%     elseif p_type == 2 
%         message = 'Now try with three practice trials \n\n\n\n Use response keys "C" "V" "B" "N" "M" as indicated on screen. \n\n\n\n Press the mouse button to start...'; 
%     end   
%     
%     % Write 'message' centered in the middle of the display, in white color.
%     DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
%     
%     % Update the display to show the instruction text:
%     Screen('Flip', w); 
%     
%     % Wait for mouse click:
%     GetClicks(w); 
%     
%     
%     %%%%%
%     %% 5 - PRACTICE TRIAL CODE.
%     %%%%%
%        
%     try           
%         % Call the practice run function
%         prevalue_practice_trials(w, xs, ys, practicefilename, img_folder, imgwidth, imgheight, bordercolor1, borderRect1, min_pretarget, max_pretarget, irr_tarray, target, duration, response, aperture2, aperture3, p_type, keypress_1, keypress_2, keypress_3, keypress_4, keypress_5, keypress_repeat, scorelocation, score_img1_1, score_img1_2, score_img2_1, score_img2_2)        
%     catch
%         % catch error: This is executed in case something goes wrong in the
%         % 'try' part due to programming error etc.:
%         ptb_cleanup ()
%         
%         % Output the error message that describes the error:
%         psychrethrow(psychlasterror);             
%     end    
      
    % 4.2.1 - Display first instruction message - run function (onscreen_text) 
    message = 'Do you have any questions? \n\n OK, start task 3 now. \n\n\n\n Press the mouse button to begin...';    
    onscreen_text(w, message)
    
    

    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 6 - Read in the conditions and stimuli locations (from trailfilename.txt
    %%%%%%%%%%%%%%%%%%%%%% 

    % read list of conditions/stimulus images -- textread() is a matlab function
    % objnumber  arbitrary number of stimulus
    % direction    stimulus direction L=2 R=1
    % metrical   is trial to be metrical or irregular?          
    [ objnumber, filename1, genre, soundname1] = textread(testfilename,'%d %s %s %s');
    
    % Randomize order of list
    ntrials=length(objnumber);         % get number of trials
    randomorder=randperm(ntrials);     % randperm() is a matlab function
    objnumber=objnumber(randomorder);  % need to randomize each list!
    filename1=filename1(randomorder);
    genre=genre(randomorder);
    soundname1=soundname1(randomorder);
    
        
    %%    
    %%%%%%%%%%%%%%%%%%%%%%
    % 6.1 - Final screen prepair prior to trial initiation
    %%%%%%%%%%%%%%%%%%%%%%
    
    trial = 1;
    % famil_counter = 0;
    
     
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 7 - EXPERIMENTAL PRESENTATION LOOPS
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Loop through all trial detailed in testfilename variable
    %for trial=1:ntrials;
    while (trial <= ntrials);
    
%         if trial == 26;
%             % Display a break page and require a click to continue. 
%             message = 'Please take a break until the experimenter tells you to begin! \n\n Press the mouse button to continue ...';    
%             onscreen_text(w, message) 
%         end    
        
        
        % read stimulus image 1 into matlab matrix 'imdata':
        stimfilename=strcat(img_folder,char(filename1(trial))); % assume stims are in subfolder "stims"
        imdata1=imread(char(stimfilename));  

%         wavfilename = strcat(img_folder,char(soundname1(trial)));
%         
%         % Call the load audio buffer function to prepare for audio
%         % presentation
%         %[pahandle] = load_audio_buffer(wavfilename);      
%         
%             % 1 - Read WAV file from filesystem:
%             [y, freq] = wavread(wavfilename);
%             wavedata = y';
%             nrchannels = size(wavedata,1); % Number of rows == number of channels.
% 
%             % Make sure we have always 2 channels stereo output.
%             % Why? Because some low-end and embedded soundcards
%             % only support 2 channels, not 1 channel, and we want
%             % to be robust in our demos.
%             if nrchannels < 2
%                 wavedata = [wavedata ; wavedata];
%                 nrchannels = 2;
%             end
% 
%             % Perform basic initialization of the sound driver:
%             InitializePsychSound(1);   
% 
%             try
%                 % Try with the 'freq'uency we wanted:
%                 pahandle = PsychPortAudio('Open', [], [], 3, freq, nrchannels);
%             catch
%                 psychlasterror('reset');
%                 pahandle = PsychPortAudio('Open', [], [], 3, [], nrchannels);
%             end      
% 
%             % Fill the audio playback buffer with the audio data 'wavedata':
%             PsychPortAudio('FillBuffer', pahandle, wavedata);

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
        % 8 - Loop through aperture 2 creating a jittering effect
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
        % 9 - Create and present target.
        %%%%%%%%%%%%%%%%%%%%%%

        % Initialize KbCheck and variables:
        [~, endrt, keyCode]=KbCheck;              
             
        % Draw the target texture to screen       
        Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
        Screen('DrawTexture', w, target_img1, [], targetlocation);                                 

        % play the preloaded sound file.
        %PsychPortAudio('Start', pahandle, 1, when2-slack, 1);

        % Show stimulus on screen at next possible display refresh cycle,
        [~, StimulusOnsetTime]=Screen('Flip', w, when2-slack);
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 10 - Call and present the response window
        %%%%%%%%%%%%%%%%%%%%%% 
        
        % Record a time value for the target presentation onset
        when = StimulusOnsetTime + target;
        
        % Draw the aperture3 texture
        Screen('DrawTexture', w, aperture3);
        
        % Display first instruction message 
        if p_type == 1
            Screen('DrawTexture', w, score_img1_3, [], scorelocation);
        elseif p_type == 2 
            Screen('DrawTexture', w, score_img2_3, [], scorelocation);
        end        
               
        message = '\n\n\n\n  LIKING \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';
        
        % Write 'message' centered in the middle of the display, in white color.
        DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
       
        % Flip screen with the new texture - record system time
        [~, StimulusOnsetTime_RT] = Screen('Flip', w, when-slack);  
    
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 11 - Record reaction times at 1 m/s intervals
        %%%%%%%%%%%%%%%%%%%%%%
        
        % Record reaction times at 1 m/s intervals - Target showing 
        
        % While loop to show stimulus until subjects response or until
        % "duration" seconds elapsed
   
        repeat1_count = 0;
        
        while (keyCode(keypress_1)~=1 || keyCode(keypress_2)~=1 ||  keyCode(keypress_3)~=1 ||  keyCode(keypress_4)~=1 ||  keyCode(keypress_5)~=1)
            % poll for a resp
            % during test phase, subjects can response
            % before stimulus terminates
    
            if (keyCode(keypress_1)==1 || keyCode(keypress_2)==1 ||  keyCode(keypress_3)==1 ||  keyCode(keypress_4)==1 ||  keyCode(keypress_5)==1 )
                break;
            end
            [~, endrt, keyCode]=KbCheck(-1);
                      
            if (keyCode(keypress_repeat)== 1)
                
                % Draw the target texture to screen       
                Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
                Screen('DrawTexture', w, target_img1, [], targetlocation);                                 

                % play the preloaded sound file.
                %PsychPortAudio('Start', pahandle, 1, when2-slack, 1);

                % Show stimulus on screen at next possible display refresh cycle,
                [~, StimulusOnsetTime]=Screen('Flip', w, 0);
                
                % Record a time value for the target presentation onset
                when = StimulusOnsetTime + target;
                
                % update the repeat1 counter
                repeat1_count = repeat1_count + 1;
                
                % Draw the aperture3 texture
                Screen('DrawTexture', w, aperture3);
        
                % Display first instruction message 
                if p_type == 1                                                                                             
                    Screen('DrawTexture', w, score_img1_1, [], scorelocation);
                elseif p_type == 2 
                    Screen('DrawTexture', w, score_img2_1, [], scorelocation);
                end        

                message = '\n\n\n\n  LIKING \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';

                % Write 'message' centered in the middle of the display, in white color.
                DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));

                % Flip screen with the new texture - record system time
                [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
                
                % Flush Keycode event information
                FlushEvents(keyCode)              
            end
            
            % Wait 1 ms before checking the keyboard again to prevent
            % overload of the machine at elevated Priority():
            WaitSecs(0.0005);
        end        
        
        % Make all slow keypresses 0
        if (keyCode(keyCode(keypress_1)==0 && keyCode(keypress_2)==0 &&  keyCode(keypress_3)==0 &&  keyCode(keypress_4)==0 &&  keyCode(keypress_5)==0 ))
            endrt = StimulusOnsetTime;
        end
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 12 - Compute and write reaction time data to file
        %%%%%%%%%%%%%%%%%%%%%%
            
        % compute response time
        rt=round(1000*(endrt-StimulusOnsetTime_RT));
                
        resp=KbName(keyCode); % get key pressed by subject
        
        if p_type == 1       
            if (resp == kb1)
                value = 1;
            elseif (resp == kb2)     
                value = 2;
            elseif (resp == kb3)     
                value = 3;
            elseif (resp == kb4)     
                value = 4;        
            elseif (resp == kb5)     
                value = 5;
            else value = 0;
                resp = 'NR';
            end
        elseif p_type == 2
            if (resp == kb5)
                value = 1;
            elseif (resp == kb4)     
                value = 2;
            elseif (resp == kb3)     
                value = 3;
            elseif (resp == kb2)     
                value = 4;        
            elseif (resp == kb1)     
                value = 5;
            else value = 0;
                resp = 'NR';
            end
        end      
        
        % update the famil_counter if famil is above 3.
%         if famil >= 4;
%             famil_counter = famil_counter + 1;
%         end
%         disp(famil_counter);
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 13 - Clear system memory in preparation for second question
        % response value
        %%%%%%%%%%%%%%%%%%%%%%
              
        % Wait until all keys are released.
        while KbCheck; end 
        
        % Flush Keycode event information
        FlushEvents(keyCode)
        
        % Initialize KbCheck and variables:
        [~, endrt2, keyCode]=KbCheck;  
        
%         % Draw the target texture to screen
%         Screen('DrawTexture', w, aperture3);                              
%         
%         % Show stimulus on screen at next possible display refresh cycle,
%         [~, StimulusOnsetTime]=Screen('Flip', w, 0);
%              
% 
%             
%         %%
%         %%%%%%%%%%%%%%%%%%%%%%
%         % 14 - Call and present the response window
%         %%%%%%%%%%%%%%%%%%%%%% 
%         
%         % Record a time value for the target presentation onset
%         when = StimulusOnsetTime;
%         
%         % Draw the aperture3 texture
%         Screen('DrawTexture', w, aperture3);
%         
%         % Display first instruction message 
%         % 85 words
%         if p_type == 1
%             Screen('DrawTexture', w, score_img1_2, [], scorelocation);
%         elseif p_type == 2 
%             Screen('DrawTexture', w, score_img2_2, [], scorelocation);
%         end   
%         
%         message = '\n\n\n\nPREFERENCE \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';
%         
%         % Write 'message' centered in the middle of the display, in white color.
%         DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
%        
%         % Flip screen with the new texture - record system time
%         [~, StimulusOnsetTime_RT] = Screen('Flip', w, when-slack);  
%     
%         
%         
%         %%
%         %%%%%%%%%%%%%%%%%%%%%%
%         % 15 - Record reaction times at 1 m/s intervals
%         %%%%%%%%%%%%%%%%%%%%%%
%         
%         % Record reaction times at 1 m/s intervals - Target showing 
%         
%         % While loop to show stimulus until subjects response or until
%         % "duration" seconds elapsed
%    
%         repeat2_count = 0;
%         
%         while (keyCode(keypress_1)~=1 || keyCode(keypress_2)~=1 ||  keyCode(keypress_3)~=1 ||  keyCode(keypress_4)~=1 ||  keyCode(keypress_5)~=1)
%             % poll for a resp
%             % during test phase, subjects can response
%             % before stimulus terminates
%     
%             if (keyCode(keypress_1)==1 || keyCode(keypress_2)==1 ||  keyCode(keypress_3)==1 ||  keyCode(keypress_4)==1 ||  keyCode(keypress_5)==1 )
%                 break;
%             end           
%             [~, endrt2, keyCode]=KbCheck(-1);
%                            
%             if (keyCode(keypress_repeat)== 1)
%                 
%                 % Draw the target texture to screen       
%                 Screen('DrawTexture', w, targetcolor, [], borderRect1 , [], 0);                
%                 Screen('DrawTexture', w, target_img1, [], targetlocation);                                 
% 
%                 % play the preloaded sound file.
%                 %PsychPortAudio('Start', pahandle, 1, when2-slack, 1);
% 
%                 % Show stimulus on screen at next possible display refresh cycle,
%                 [~, StimulusOnsetTime]=Screen('Flip', w, 0);
%                 
%                 % Record a time value for the target presentation onset
%                 when = StimulusOnsetTime + target;
%         
%                 % update the repeat2 counter
%                 repeat2_count = repeat2_count + 1;
%                 
%                 % Draw the aperture3 texture
%                 Screen('DrawTexture', w, aperture3);
%         
%                 % Display first instruction message 
%                 if p_type == 1
%                     Screen('DrawTexture', w, score_img1_2, [], scorelocation);
%                 elseif p_type == 2 
%                     Screen('DrawTexture', w, score_img2_2, [], scorelocation);
%                 end        
% 
%                 message = '\n\n\n\nPREFERENCE \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress R to repeat';
% 
%                 % Write 'message' centered in the middle of the display, in white color.
%                 DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
% 
%                 % Flip screen with the new texture - record system time
%                 [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
%                 
%                 % Flush Keycode event information
%                 FlushEvents(keyCode)           
%             end
%             
%             % Wait 1 ms before checking the keyboard again to prevent
%             % overload of the machine at elevated Priority():
%             WaitSecs(0.0005);
%         end        
%         
%         % Make all slow keypresses 0
%         if (keyCode(keyCode(keypress_1)==0 && keyCode(keypress_2)==0 &&  keyCode(keypress_3)==0 &&  keyCode(keypress_4)==0 &&  keyCode(keypress_5)==0 ))
%             endrt2 = StimulusOnsetTime;
%         end
%         
%         
%         %%
%         %%%%%%%%%%%%%%%%%%%%%%
%         % 16 - Compute and write reaction time data to file
%         %%%%%%%%%%%%%%%%%%%%%%
%             
%         % compute response time
%         rt2=round(1000*(endrt2-StimulusOnsetTime_RT));
%                 
%         resp2=KbName(keyCode); % get key pressed by subject
%         
%         if p_type == 1       
%             if (resp2 == kb1)
%                 value = 1;
%             elseif (resp2 == kb2)     
%                 value = 2;
%             elseif (resp2 == kb3)     
%                 value = 3;
%             elseif (resp2 == kb4)     
%                 value = 4;        
%             elseif (resp2 == kb5)     
%                 value = 5;
%             else value = 0;
%                 resp2 = 'NR';
%             end
%         elseif p_type == 2
%             if (resp2 == kb5)
%                 value = 1;
%             elseif (resp2 == kb4)     
%                 value = 2;
%             elseif (resp2 == kb3)     
%                 value = 3;
%             elseif (resp2 == kb2)     
%                 value = 4;        
%             elseif (resp2 == kb1)     
%                 value = 5;
%             else value = 0;
%                 resp2 = 'NR';
%             end
%         end    
%         

        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 17 - Trial information to file
        %%%%%%%%%%%%%%%%%%%%%%
 
        % Write trial result to file:
        fprintf(datafilepointer,'%i %s %s %s %s %i %i %i\n', ...  
          objnumber(trial), ...
          filename1{trial}, ...
          soundname1{trial}, ...
          genre{trial}, ...
          resp, ...
          value, ...
          rt, ...
          repeat1_count); 
          
    % Tidy up all of the used off screen textures to save memory  
    Screen('Close', [target_img1, targetcolor]);
    PsychPortAudio('Close');   
         
    % update trail counter
    trial = trial + 1;
    
    % end the trials loop
    end    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 18 - Say thank you and clean up
    %%%%%%%%%%%%%%%%%%%%%%

    message = 'End of Task 3. Thank you. \n\n press the mouse button to exit ...';
    onscreen_text(w, message)
    ptb_cleanup ()
  
% end of experiment:
catch
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    ptb_cleanup ()
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);  
end
clear all
end  