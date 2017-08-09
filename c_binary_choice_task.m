function c_binary_choice_task(subNo)

% Add the function folder to MATLAB path
addpath('./functions/') 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 - Define experimental variables.
%%%%%%%%%%%%%%%%%%%%%%%%%
format long;

% Name of the participant folder;
p_folder = strcat('output/P_', num2str(subNo), '/');
% Location of the input trial generation file name                        
testfilename = strcat(p_folder,'reduced_generation_', num2str(subNo), '.txt');
% Location of the practice input trials
testpfilename = 'input/stim_testpractice.txt';
testpfilename2 = 'input/stim_testpractice2.txt';
% Name of the input stimulus image folder
img_folder = 'stimuli/stims/';
% Name of the experiment;
exp_name = 'exp_1_responses_p_';

% Size of the onsecreen text size;
text_size = 20;
% Define keyboard responses:
% First response
keyone = 'c';
low_keypress=KbName(keyone); 
% Second response
keytwo = 'm';
high_keypress=KbName(keytwo);
% Image height dimentions of the stimulus images - ~ 5.7X5.7 visual degrees
% http://www.psypress.co.uk/mather/resources/swf/Demo6_3.swf
% http://www.translatorscafe.com/cafe/units-converter/typography/calculator/pixel-%28X%29-to-centimeter-%5Bcm%5D/
imgwidth = 361;
% Image width dimentions of the stimulus images
imgheight = 361;
% Gap in pixels beteen screen center point and center point of image -
% 11.11 visual degrees apart from 1 meter viewing.
% http://www.psypress.co.uk/mather/resources/swf/Demo6_3.swf
% http://www.translatorscafe.com/cafe/units-converter/typography/calculator/pixel-%28X%29-to-centimeter-%5Bcm%5D/
img_gap = 360;
% Border colour 1 definition - Pink
%bordercolor1 = [255 105 180];
% Border colour 1 definition - Pink
bordercolor1 = [0 190 0];
% Border colour 2 definition - White
bordercolor2 = [0 0 0];
% Border width
borderwidth = 15;

% Recurring texture variables
% set configuration size values for stimulus area
numRects = 1;
rectSize = 264;
scale = 1;

% Experimental proceedure variables

% forced break array of all trial numbers in which a forced break will be
% issued
forcedbreak = [7, 13, 19, 31, 37, 43, 55, 61, 67, 79, 85, 91, 103, 109, 115, 127, 133, 139, 151, 157, 163, 175, 181, 187, 199, 205, 211, 223, 229, 235, 247, 253, 259];
% trial number in which a distractor trail should follow
distractor = [2,8,11,17,19,27,33,40,48,50,55,62,68,77,80,84,90,98,104,106,108,116,121,130,133,138,145,149,152,158,166,169,177,183,185,194,200];
%distractor = [3,7,12,16,22,27,33,40,45,51,53,58,64,73,82,86,89,96,104,103,108,116,122,124,132,138,143,148,155,158,165,168,173,181,186,192,200];
%distractor = [2,9,12,15,24,27,32,40,45,50,54,57,63,72,81,86,89,92,100,106,108,117,121,123,132,138,145,148,153,158,161,168,175,183,186,194,200];
%distractor = [3,8,12,16,24,28,32,41,45,50,52,57,64,73,81,85,88,92,99,106,108,115,121,123,131,137,146,148,154,158,161,167,174,183,187,193,200];

% Duration of the cue.
cue_duration = 0.400; 
% Duration of the presented pretarget textures.
duration = 0.050;
% Minimum pretarget loop time
min_pretarget = 6.000;
% Maximum pretarget time
max_pretarget = 6.000;
% Standard gap between pretarget flashes
std_gap = 0.350;
% Array of timings to be used in the irregular condition to create gap 
irr_tarray = [0.150,0.250,0.350,0.450,0.550];
% Duration of the target window
target = 1.320;
% Duration of the response period
response = 3.000;



%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2 - preliminary set-up commands
%%%%%%%%%%%%%%%%%%%%%%%%%

% Call screen setup function.
ptb_screen_setup()



%%
%%%%%%%%%%%%%%%%%%%%%%
% 3 - file handling definitions
%%%%%%%%%%%%%%%%%%%%%%

% define filename and location of the output .txt result file:
datafilename = strcat(exp_name,num2str(subNo),'.txt'); % name of data file to write to
datafilename = strcat(p_folder, datafilename);                  
% Create a new file and open ready for writing set to text mode;
datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing


% Open a results file for the distractor trials
% Name of the experiment;
exp_name2 = 'distractor_trial_responses_p_';
% define filename and location of the output .txt result file:
datafilename2 = strcat(exp_name2,num2str(subNo),'.txt'); % name of data file to write to
datafilename2 = strcat(p_folder, datafilename2);                  
% Create a new file and open ready for writing set to text mode;
datafilepointer2 = fopen(datafilename2,'wt'); % open ASCII file for writing


% Open a results output file to catch any crashes
% Name of the experiment;
exp_name3 = 'Output_p_2_';
% define filename and location of the output .txt result file:
datafilename3 = strcat(exp_name3,num2str(subNo),'.txt'); % name of data file to write to
datafilename3 = strcat(p_folder, datafilename3);                  
% Create a new file and open ready for writing set to text mode;
fopen(datafilename3,'wt'); % open ASCII file for writing

diary(datafilename3);


%%
%%%%%%%%%%%%%%%%%%%%%%
% 3 - Start the experimenal code  
%%%%%%%%%%%%%%%%%%%%%%

% wrap experimental code in try..catch statement to clean up, save results, close the onscreen window in the case of ML/PTB error.
try      
    % Open grey screen and run tests by calling the function ptb_grey_..etc
    [gray, w, wRect, slack] = ptb_open_screen(text_size);
    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 4.2 - Display instruction messages
    %%%%%%%%%%%%%%%%%%%%%% 

    % 4.2.1 - Display first instruction message - run function (onscreen_text) 
    message = 'Task 2 \n\n\n\n Imagine you must decide quickly what music to listen to. What do you choose? \n\n\n\n During each trial of this experiment, you will see two CD covers and \n\n hear short sound clips from both. Decide which track you prefer to \n\n listen to by pressing "C" for the one on the left and "M" for the one on the right. \n\n\n\n Each trial begins with a flashing disk containing a green dot. Focus \n\n on this dot. When the CD covers appear, only look at the one with\n\n the green border. This will change so pay attention. Before the covers \n\n appear, there is a blue line at one side of the screen, and a black\n\n line at the other. The blue line indicates which side of the screen \n\n (left or right) the first CD cover will appear. This is so you know\n\n where to look as soon as the covers appear. \n\n\n\n Press the mouse button to see an example...';    
    onscreen_text(w, message)
    
    try           
        % Call the practice run function
        test_practice_trials2(testpfilename2,w,gray,wRect,rectSize,numRects,scale,img_gap,imgwidth,imgheight,borderwidth,img_folder,bordercolor1,bordercolor2,cue_duration,min_pretarget,max_pretarget,duration,response,std_gap,irr_tarray,target,low_keypress,high_keypress,slack)
    catch
        % catch error: This is executed in case something goes wrong in the
        % 'try' part due to programming error etc.:
        ptb_cleanup ()
        
        % Output the error message that describes the error:
        psychrethrow(psychlasterror);             
    end
    
    
    
    % 4.2.2 - Display first instruction message - run function (onscreen_text) 
    message = 'It is very important that you focus on the green dot and only look at \n\n the cover with the green border. As soon as the green border switches \n\n to the other cover, look at that one. \n\n\n\n At the end of the experiment we will pick a trial at random. You have \n\n to spend your itunes voucher on tracks from your preferred CD of this\n\n pair directly after the experiment. (If you do not want that CD we will\n\n pick another pair at random.) If you make honest decisions you will\n\n walk away owning the best music possible!\n\n\n\nPress the mouse button to continue ...';  
    onscreen_text(w, message)  
    
    % 4.2.3 - Display first instruction message - run function (onscreen_text) 
    message = 'Now try three practice trials. Remember:- \n\n\n\n Use the blue cue.\n\n Focus on the green dot.\n\n Only look at the cover that has the green border.\n\n Make an honest decision. \n\n\n\n Choose which track you prefer as quickly as possible as the next trial will start after 2 seconds. \n\n\n\n  Press the mouse button to begin ...';    
    onscreen_text(w, message)
  
    
%     % 4.2.7 - Display second instruction message - run above function
%     str = sprintf('Press _%s_ for the LEFT item and _%s_ for the RIGHT item\n\n\n\n',KbName(low_keypress),KbName(high_keypress));
%     message = ['We will now run three practice trials to familiarise yourself with the procedure \n\n\n\n Remember: Look at the cue \n\n Focus on the green dot \n\n Only look at the items with the green border \n\n Make an honest decision \n\n\n\n Choose which option you prefer when prompted \n\n' str ' You have 2 seconds to make a decision and must pick one of the two options. \n\n Do not think too hard about the decision and select your intuitive response within the timeframe. \n\n\n\n Press the mouse button to begin ...'];  
%     onscreen_text(w, message)
    

    %%%%%
    %% PRACTICE TRIAL CODE.
    %%%%%
       
    try           
        % Call the practice run function
        test_practice_trials(testpfilename,w,gray,wRect,rectSize,numRects,scale,img_gap,imgwidth,imgheight,borderwidth,img_folder,bordercolor1,bordercolor2,cue_duration,min_pretarget,max_pretarget,duration,response,std_gap,irr_tarray,target,low_keypress,high_keypress,slack)
    catch
        % catch error: This is executed in case something goes wrong in the
        % 'try' part due to programming error etc.:
        ptb_cleanup ()
        
        % Output the error message that describes the error:
        psychrethrow(psychlasterror);             
    end
   
    % Display first instruction message - run function (onscreen_text)
    message = 'Great! Just one more thing to add and then you can start the task proper.\n\n\n\n On some trials your task will be slightly different. \n\n\n\nThe green dot will change colour on the last flashing disk and you will\n\n be asked what colour it was. Press "C" for the colour on the left and "M"\n\n for the colour on the right. \n\n\n\n Pay attention to the green dot and respond as quickly as possible. \n\n You must pick one of the two options. \n\n\n\n Now try with three practice trials. \n\n\n\n  Press the mouse button to continue ...';    
    onscreen_text(w, message)    
    
%     str = sprintf('Press _%s_ for the LEFT colour and _%s_ for the RIGHT colour\n\n\n\n',KbName(low_keypress),KbName(high_keypress));
%     message = ['We will now run three practice trials to familiarise yourself with the procedure \n\n\n\n Remember: Focus on the central fixation point and respond as quickly as possible. \n\n\n\n Choose the correct colour when prompted \n\n' str ' You must pick one of the two options. \n\n\n\n Press the mouse button to begin ...'];  
%     onscreen_text(w, message)
    
    % run the distractor trial if the trial appears within the distractor array.        
    for i = 1:3
        distractor_trials_practice(datafilepointer2, w, wRect, gray, rectSize, numRects, scale, img_gap, imgwidth, borderwidth, imgheight, bordercolor2, cue_duration, min_pretarget, max_pretarget, duration, std_gap, irr_tarray, low_keypress, high_keypress, keyone, keytwo,slack)    
    end

    % Display first instruction message - run function (onscreen_text)
    message = 'Do you have any questions?\n\n\n\n OK, start Task 2 now, it should take ~1 hour. The task contians\n\n8 long breaks and lots of short breaks ever 6-9 trials so that you can rest your eyes. \n\n\n\n When you are ready, press the mouse button to start the experiment ...';    
    onscreen_text(w, message)
    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 4.3 - Create the recurring stimuli textures and offscreen windows
    %%%%%%%%%%%%%%%%%%%%%% 
   
    % 4.3.1 - Calculate the center point of the screen
    [xs,ys] = RectCenter(wRect);
    
    % 4.3.2 - Calculate and create all Rects to be used
    
    % 4.3.3 - Compute destination rectangle locations: 'objRect'
    objRect = SetRect(0,0, rectSize, rectSize);

    % 4.3.4 - ArrangeRects creates 'numRects' copies of 'objRect', all distributed evenly in window of size 'w':
    dstRect = ArrangeRects(numRects, objRect, wRect);

    % 4.3.5 - Rescale all rects: They are scaled in size by a factor 'scale':
    for i=1:numRects
        % Compute center position [xc,yc] of the i'th rectangle:
        [xc, yc] = RectCenter(dstRect(i,:));
        % Create a new rectange, centered at the same position, but 'scale'
        % times the size of our pixel noise matrix 'objRect':
        dstRect(i,:)=CenterRectOnPoint(objRect * scale, xc, yc);
    end


    
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 4.4 - Enable Alpha blending to enable opaque function in textures
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
    % 4.5 - Read in the conditions and stimuli locations (from trailfilename.txt
    %%%%%%%%%%%%%%%%%%%%%% 

    % read list of conditions/stimulus images -- textread() is a matlab function
    % objnumber  arbitrary number of stimulus
    % direction    stimulus direction L=2 R=1
    % metrical   is trial to be metrical or irregular?          
    [ objnumber,filename1,soundname1,filename2,soundname2,metrical, location, condition, block_no] = textread(testfilename,'%d %s %s %s %s %d %d %d %d');
    
    % Randomize order of list
    ntrials=length(objnumber);         % get number of trials
    % randomorder=randperm(ntrials);     % randperm() is a matlab function
    % objnumber=objnumber(randomorder);  % need to randomize each list!
    % filename1=filename1(randomorder);
    % soundname1=soundname1(randomorder);
    % filename2=filename2(randomorder);
    % soundname2=soundname2(randomorder);
    % metrical=metrical(randomorder);
    % location=location(randomorder);
        
    
    %%    
    %%%%%%%%%%%%%%%%%%%%%%
    % 4.6 - Final screen prepair prior to trial initiation
    %%%%%%%%%%%%%%%%%%%%%%
    
    block_counter = 1;

    
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 5 - EXPERIMENTAL PRESENTATION LOOPS
    %%%%%%%%%%%%%%%%%%%%%%

    % Loop through all trial detailed in testfilename variable
    for trial=1:ntrials;              
             
        % Call function to create all of the experimental off screen windows
        [aperture1, aperture2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect] = ptb_offscreen_creation(w, gray, objRect, xs, ys, img_gap, imgwidth, borderwidth, imgheight);  
    
        % run a pause if the block counter after 2 blocks
        if block_no(trial) ~= block_counter 
                % 4.2.1 - Display first instruction message - run function (onscreen_text) 
                message = 'Well done you have reached a break. If you are tired please take a break now. \n\n If you want to continue, press the mouse button to continue ...';    
                onscreen_text(w, message)
                message = 'Remember - It is very important that you focus on and really pay attention to the flash, only look at \n\n the cover with the green border and make an honest decision. \n\n press the mouse button to continue ...';
                onscreen_text(w, message) 
        end
        
        % run a short forced break every 6 trails for 5 seconds blank
        % screen
        if any(trial==forcedbreak) 
            Screen('Flip', w, 0);
            WaitSecs(2);     
        end
        
        % run the distractor trial if the trial appears within the distractor array.        
        if any(trial == distractor)
            distractor_trials(datafilepointer2, w, gray, rectSize, numRects, objRect, dstRect, xs, ys, img_gap, imgwidth, borderwidth, imgheight, bordercolor2, cue_duration, min_pretarget, max_pretarget, duration, std_gap, irr_tarray, low_keypress, high_keypress, keyone, keytwo, slack)   
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%
        % 5 - PRE_TRIAL PREPARATION
        %%%%%%%%%%%%%%%%%%%%%%
        
        % 5.0.1 - Call function ptb_loadimages to load the target images as textures        
        [leftlocation, rightlocation, target_img1, target_img2, leftcolor, rightcolor, leftcolor2, rightcolor2] = ptb_loadimages(w, img_folder, filename1, filename2, location, trial, xs, ys, imgwidth, imgheight, img_gap, borderRect1, borderRect2, bordercolor1, bordercolor2);
         
        % 5.0.2 - Call the functions to load both sound clips into the
        % audio buffer.     
        wavfilename = strcat(img_folder,char(soundname1(trial)));
        
        % Call the load audio buffer function to prepare for audio
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
        % 5.1 - PRE_TARGET CUE PRESENTATION
        %%%%%%%%%%%%%%%%%%%%%%
        
        % Loop through pretarget cues while counter <= to t_before_onset
        while (StimulusOnsetTime+std_gap)<=(StartTime+t_before_onset+0.600);                                   
            
            % draw the correct cue borders on screen
            ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)        
            
            % Create and present the pretarget - run function ptb_pretarget
            [tex] = ptb_pretarget(rectSize, w, dstRect, numRects, aperture1);  
            
            if (loopcount <1)                            
                % Flip screen with the new texture - record system time
                [~, StimulusOnsetTime] = Screen('Flip', w, StartTime);
                %        disp(StimulusOnsetTime);
            else     
                when = StimulusOnsetTime + stim_interval;
                [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
                %        disp(StimulusOnsetTime);
            end   

            % draw the correct cue borders on screen
            ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)
        
            % Define the timestamp for the when variable
            when = StimulusOnsetTime + duration;            
            
            % Return the display back to standard screen as defined by when.
            [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);  
            %        disp(StimulusOnsetTime);
            
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
        % 5.2 - TARGET PRESENTATION
        %%%%%%%%%%%%%%%%%%%%%%
               
        % 5.2.1 - Penultimate pretarget cue set at at std_gap + duration values.
                
        % Define the timestamp for the when variable
        when = StimulusOnsetTime + std_gap;
        
        % draw the correct cue borders on screen
        ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)
        
        % present the penultimate pretarget cue - run function ptb_pretarget.
        [tex] = ptb_pretarget(rectSize, w, dstRect, i, aperture1);
        
        % Flip screen with the new texture - record system time
        [~, StimulusOnsetTime] = Screen('Flip', w, when-slack); 
        
        % Define the timestamp for the when variable
        when = StimulusOnsetTime + duration;
        
        % draw the correct cue borders on screen
        ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect)
        
        % Return the display back to standard screen as defined by when.
        [~, StimulusOnsetTime] = Screen('Flip', w, when-slack);
       
        
        %%%%%%%%%%%%%%%%%%%%%%
        % 5.3 - Create and present target.
        %%%%%%%%%%%%%%%%%%%%%%

        % 5.3.1 - Initialize KbCheck and variables:
        [~, endrt, keyCode]=KbCheck;         
        
        % 5.3.2 - Record a time value for the target presentation onset
        when = StimulusOnsetTime + std_gap;       
             
        % 5.3.3 - Draw the target texture to screen
        Screen('DrawTexture', w, leftcolor, [], borderRect1 , [], 0);                
        Screen('DrawTexture', w, target_img1, [], leftlocation);                
        % 5.3.4 - Draw the target texture to screen
        Screen('DrawTexture', w, rightcolor, [], borderRect2 , [], 0);       
        Screen('DrawTexture', w, target_img2, [], rightlocation);                   

        % 5.3.5 - Play the preloaded sound file.
        PsychPortAudio('Start', pahandle, 1, when-slack, 1);
        
        % 5.3.6 - Show stimulus on screen at next possible display refresh cycle,
        [~, StimulusOnsetTime]=Screen('Flip', w, when-slack);
                   
        % 5.3.7 - Record a time value for the target presentation onset
        when = StimulusOnsetTime + target;
         
        % 5.3.8 - Draw the target texture to screen
        Screen('DrawTexture', w, rightcolor, [], borderRect1 , [], 0);                
        Screen('DrawTexture', w, target_img1, [], leftlocation);        
        % 5.3.9 - Draw the target texture to screen
        Screen('DrawTexture', w, leftcolor, [], borderRect2 , [], 0);       
        Screen('DrawTexture', w, target_img2, [], rightlocation);                   

        % 5.3.10 - Preload the second sound file and reset the audio buffer.
        wavfilename = strcat(img_folder,char(soundname2(trial)));
        
        % 5.3.11 - Call the load audio buffer function to prepare for audio
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

        % 5.3.12 - Play the preloaded sound file.
        PsychPortAudio('Start', pahandle, 1, when-slack, 1);

        
        % 5.3.13 - Show stimulus on screen at next possible display refresh cycle,
        [~, StimulusOnsetTime]=Screen('Flip', w, when-slack);    
        
                
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 5.4 - Call and present the response window
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
        % 6 - Record reaction times at 1 m/s intervals
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
            [~, endrt, keyCode]=KbCheck(-1);
            % Wait 1 ms before checking the keyboard again to prevent
            % overload of the machine at elevated Priority():
            WaitSecs(0.0005);
        end               

        % make all slow keypresses 0
        if (keyCode(low_keypress)==0 && keyCode(high_keypress)==0 )
            endrt = StimulusOnsetTime;
        end
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%
        % 7 - Compute and write reaction time data to file
        %%%%%%%%%%%%%%%%%%%%%%
            
        % compute response time
        rt=round(1000*(endrt-StimulusOnsetTime));
                
        resp=KbName(keyCode); % get key pressed by subject
        
        % calculate which option was chosen from the order
        if location(trial) == 0; 
            if resp == keyone;
               result = 1;
            elseif resp == keytwo; 
               result = 2;
            else
               resp = 'NR';
               result = 0;
            end    
        elseif location(trial) == 1;
            if resp == keyone;
               result = 2;
            elseif resp == keytwo; 
               result = 1;
            else
               resp = 'NR'; 
               result = 0;
            end   
        end    
               
        % Write trial result to file:
        fprintf(datafilepointer,'%i %i %i %i %i %i %s %i %i\n', ...  
          objnumber(trial), ...
          condition(trial), ...
          block_no(trial), ...
          metrical(trial), ...
          location(trial), ...
          t_before_onset, ...
          resp, ...
          result, ...
          rt);      
    
        % Increment the block counter
        block_counter = block_no(trial);      

        % Clear all off screen buffer images that are no longer required.
        Screen('Close', [target_img1, target_img2, leftcolor, rightcolor, leftcolor2, rightcolor2, tex, aperture1, aperture2, left_gray_rect, right_gray_rect]);
        PsychPortAudio('Close');  
    
    % end the trials loop
    end   

    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 8 - Say thank you and clean up
    %%%%%%%%%%%%%%%%%%%%%%

    message = 'End of Task 2! Thank you \n\n\n\n Press the mouse button to exit ...';
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