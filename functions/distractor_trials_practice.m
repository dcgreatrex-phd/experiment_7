function distractor_trials_practice(datafilepointer2, w, wRect, gray, rectSize, numRects, scale, img_gap, imgwidth, borderwidth, imgheight, bordercolor2, cue_duration, min_pretarget, max_pretarget, duration, std_gap, irr_tarray, low_keypress, high_keypress, keyone, keytwo,slack)

% reseed the random-number generator for each expt.
randn('seed', sum(100*clock));
% generate a random location for this trial
location_gen = rand >= 0.5;
% define location value
location = location_gen;

% reseed the random-number generator for each expt.
randn('seed', sum(100*clock));
% generate a random metrical value for this trial
metrical_gen = rand >= 0.5;
% define metrical value
metrical = metrical_gen;

% reseed the random-number generator for each expt.
randn('seed', sum(100*clock));
% generate a random group (1-3) for colour assignment
group = round(rand(1)*2);

% color-group 1 = Green vs Yellow
if group == 0 
    % reseed the random-number generator for each expt.
    randn('seed', sum(100*clock)); 
    % generate a random location for this trial
    color_selection = rand >= 0.5;
    if color_selection == 0
        % define cue color value
        %cue_color = [0 255 51 255];
        cue_color = [204 0 0 255];
        cue_color_name = 'Red';
    else
        % define cue color value
        cue_color = [255 255 0 255];
        cue_color_name = 'Yellow';
    end    
end    

% color-group 1 = Green vs Blue 
if group == 1 
    % reseed the random-number generator for each expt.
    randn('seed', sum(100*clock)); 
    % generate a random location for this trial
    color_selection = rand >= 0.5;
    if color_selection == 0
        % define cue color value
        cue_color = [204 0 0 255];
        cue_color_name = 'Red';
    else
        % define cue color value
        cue_color = [0 0 255 255];
        cue_color_name = 'Blue';
    end    
end

% color-group 1 = Green vs Blue 
if group == 2 
    % reseed the random-number generator for each expt.
    randn('seed', sum(100*clock)); 
    % generate a random location for this trial
    color_selection = rand >= 0.5;
    if color_selection == 0
        % define cue color value
        cue_color = [255 255 0 255];
        cue_color_name = 'Yellow';
    else
        % define cue color value
        cue_color = [0 0 255 255];
        cue_color_name = 'Blue';
    end    
end


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


% Build an off screen aperture texture:
aperture3=Screen('OpenOffscreenwindow', w, gray, objRect);
% clear the alpha channel of the aperture disk to zero (4th number in colour) to enable In background noise stimulus to be seen:
Screen('FillOval', aperture3, [255 255 255 0], objRect);
% draw a blue border around the disk, with a maximum alpha, ie, opaque:
Screen('FrameOval', aperture3, [0 0 0 255], objRect);
% Draw a small green opaque fixation spot in the center of the texture:
Screen('FillOval', aperture3, cue_color, CenterRect(SetRect(0,0,10,10),objRect));


% Enable alpha blending: This makes sure that the alpha channel
% (transparency channel) of our 'aperture' texture is used properly: 
% This blending mode will allow to draw partially opaque shapes or
% texture images, where the opacity is controlled by the alpha value of
% the current pen color (shape drawing) or of the alpha channel of
% textures. 
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    

%%    
%%%%%%%%%%%%%%%%%%%%%%
% 1 - Final screen prepair prior to trial initiation
%%%%%%%%%%%%%%%%%%%%%%

    
%%
%%%%%%%%%%%%%%%%%%%%%%
% 2 - EXPERIMENTAL PRACTICE LOOPS
%%%%%%%%%%%%%%%%%%%%%%
      
    %%%%%%%%%%%%%%%%%%%%%%
    % 2.1 - PRE_TRIAL PREPARATION
    %%%%%%%%%%%%%%%%%%%%%%
    
    % Call function to create all of the experimental off screen windows
    [aperture1, aperture2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect] = ptb_offscreen_creation(w, gray, objRect, xs, ys, img_gap, imgwidth, borderwidth, imgheight);  
    

    % Assign the image data to relevant variable based on location(trial) value
    if  location == 0 
        % make texture image for the correct border presentation        
        leftcolor2=Screen('OpenOffscreenwindow', w, [0 179 255], borderRect1);
        rightcolor2=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);
    else
        % make texture image for the correct border presentation      
        leftcolor2=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);
        rightcolor2=Screen('OpenOffscreenwindow', w, [0 179 255], borderRect1);
    end


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
    % 3 - PRE_TARGET CUE PRESENTATION
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
            if (metrical==1) 
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
    % 4 - TARGET PRESENTATION
    %%%%%%%%%%%%%%%%%%%%%%
               
    % 4.1 - Penultimate pretarget cue set at at std_gap + duration values.

    % draw the correct cue borders on screen
    ptb_cue_call(w, leftcolor2, rightcolor2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect) 
        
    % draw the noise patch for the final pretarget
    for i=1:numRects
        % Gaussian noise with root square mean of 0.10.
        %%% http://www.mathworks.co.uk/matlabcentral/newsreader/view_thread/171971
        %%% checkout: http://www.cb.uu.se/~cris/blog/index.php/archives/150
        %%% and this: http://www.math.washington.edu/~wcasper/math326/projects/sung_kim.pdf
        %noiseimg=(128 + 50 * randn(rectSize));
        noise1=(randn(rectSize));
        noise2 = noise1/255;
        noise3 = rms(noise2);
        noise4 = rms(noise3);
        noise4_2 = 0.1/noise4;
        noiseimg=noise1*noise4_2;
            
        % Make the gausian noise rectangle into a texture
        tex=Screen('MakeTexture', w, noiseimg);

        % Draw noise texture to screen
        Screen('DrawTexture', w, tex, [], dstRect(i,:), [], 0);

        % Overdraw the aperture texture - alpha value = 0 for oval
        Screen('DrawTexture', w, aperture3, [], dstRect(i,:), [], 0);                
    end

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
       
                       
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 5 - Call and present the response window
    %%%%%%%%%%%%%%%%%%%%%% 
        
    % 5.3.1 - Initialize KbCheck and variables:
    [~, endrt, keyCode]=KbCheck;                 
    
    % Record a time value for the target presentation onset
    when = StimulusOnsetTime + std_gap;
        
    % Overdraw the aperture3 texture
    Screen('DrawTexture', w, aperture2);
        
    % Display first instruction message - run function (onscreen_text) 
    if group == 0
        message = 'What color was the last fixation point? \n\n\n\n Yellow                            Red \n\n\n\n';    
    elseif group == 1
        message = 'What color was the last fixation point? \n\n\n\n Red                              Blue \n\n\n\n';
    else
        message = 'What color was the last fixation point? \n\n\n\n Yellow                           Blue \n\n\n\n';
    end    
            
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
    endtime=StimulusOnsetTime + 5.000;
        
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
    
    % get key pressed by subject
    resp=KbName(keyCode); 
    
    % calculate which option was chosen from the order
    if group == 0;
        if resp == keyone; 
            answer = 'Yellow';
        elseif resp == keytwo;  
            answer = 'Green';
        else
            answer = 'N/A';
        end   
    elseif group == 1;
        if resp == keyone; 
            answer = 'Green';
        elseif resp == keytwo; 
            answer = 'Blue'; 
        else
            answer = 'N/A';
        end
    elseif group == 2
        if resp == keyone; 
            answer = 'Yellow';
        elseif resp == keytwo; 
            answer = 'Blue';
        else
            answer = 'N/A';
        end    
    end                   
    

    % Write trial result to file:
    fprintf(datafilepointer2,'%i %i %s %s %s %i\n', ...  
        location, ...
        metrical, ...
        cue_color_name, ...
        resp, ...
        answer, ...
        rt);      
 

    Screen('Close', [tex, aperture3, leftcolor2, rightcolor2, aperture1, aperture2, left_gray_rect, right_gray_rect]);
end