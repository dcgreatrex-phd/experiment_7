function [leftlocation, rightlocation, target_img1, target_img2, leftcolor, rightcolor, leftcolor2, rightcolor2] = ptb_loadimages(w, img_folder, filename1, filename2, location, trial, xs, ys, imgwidth, imgheight, img_gap, borderRect1, borderRect2, bordercolor1, bordercolor2)

% 5.0.3 - Load the target images so that they can be called as textures
        
% read stimulus image 1 into matlab matrix 'imdata':
stimfilename=strcat(img_folder,char(filename1(trial))); % assume stims are in subfolder "stims"
imdata1=imread(char(stimfilename));  
        
% read stimulus image 2 into matlab matrix 'imdata':
stimfilename=strcat(img_folder,char(filename2(trial))); % assume stims are in subfolder "stims"
imdata2=imread(char(stimfilename));  
        
% Calculate the location of both images on screen
% see http://matlabfun.ucsd.edu/files/2013/09/playwithtextures2.m
% see http://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/6393 
leftlocation = ([xs-img_gap - imgwidth/2 , ys - imgheight/2, xs-img_gap + imgwidth/2, ys + imgheight/2]);
rightlocation = ([xs+img_gap - imgwidth/2, ys - imgheight/2, xs+img_gap + imgwidth/2, ys + imgheight/2]);
        

% Assign the image data to relevant variable based on location(trial) value
if  location(trial) == 0 
    % make texture image out of image matrix 'imdata'        
    target_img1=Screen('MakeTexture', w, imdata1);
    leftcolor=Screen('OpenOffscreenwindow', w, bordercolor1, borderRect1);
    leftcolor2=Screen('OpenOffscreenwindow', w, [0 160 255], borderRect1);
    target_img2=Screen('MakeTexture', w, imdata2);
    rightcolor=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);
    rightcolor2=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);

    
else
    % make texture image out of image matrix 'imdata'        
    target_img1=Screen('MakeTexture', w, imdata2);
    leftcolor=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);
    leftcolor2=Screen('OpenOffscreenwindow', w, bordercolor2, borderRect2);
    target_img2=Screen('MakeTexture', w, imdata1);
    rightcolor=Screen('OpenOffscreenwindow', w, bordercolor1, borderRect1);
    % 0 179 255
    rightcolor2=Screen('OpenOffscreenwindow', w, [0 160 255], borderRect1);
end

end
