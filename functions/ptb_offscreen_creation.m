function [aperture1, aperture2, borderRect1, borderRect2, borderRect3, borderRect4, left_gray_rect, right_gray_rect] = ptb_offscreen_creation(w, gray, objRect, xs, ys, img_gap, imgwidth, borderwidth, imgheight)
    
% 4.3.2 - First circular object texture to place over the noise (blue)
    
% Build an off screen aperture texture:
aperture1=Screen('OpenOffscreenwindow', w, gray, objRect);
% clear the alpha channel of the aperture disk to zero (4th number in colour) to enable In background noise stimulus to be seen:
Screen('FillOval', aperture1, [255 255 255 0], objRect);
% draw a blue border around the disk, with a maximum alpha, ie, opaque:
Screen('FrameOval', aperture1, [0 0 0 255], objRect);
% Draw a small green opaque fixation spot in the center of the texture:
%Screen('FillOval', aperture1, [255 105 180 255], CenterRect(SetRect(0,0,10,10),objRect));
Screen('FillOval', aperture1, [0 190 0 255], CenterRect(SetRect(0,0,10,10),objRect));

% 4.3.3 - Second object texture for presenting the response window
    
% Build an off screen aperture texture which will contain pre stimulus cue:
objRect2 = SetRect(0,0, 500, 500);
aperture2=Screen('OpenOffscreenwindow',w, gray, objRect2);
Screen('FillOval', aperture2, [0 0 0 255], CenterRect(SetRect(0,0,10,10),objRect2));


% 4.3.4 Compute first destination picture border: 'borderRect1' 
borderRect1 = SetRect(xs-img_gap - (imgwidth+borderwidth)/2 , ys - (imgheight+borderwidth)/2, xs-img_gap + (imgwidth+borderwidth)/2, ys + (imgheight+borderwidth)/2);    
% Compute second destination picture border: 'borderRect2'
borderRect2 = SetRect(xs+img_gap - (imgwidth+borderwidth)/2, ys - (imgheight+borderwidth)/2, xs+img_gap + (imgwidth+borderwidth)/2, ys + (imgheight+borderwidth)/2);        
% Compute first destination picture border: 'borderRect3' 
borderRect3 = SetRect(xs-(img_gap-40) - (imgwidth+80)/2 , ys - (imgheight+30)/2, xs-(img_gap-40) + (imgwidth+80)/2, ys + (imgheight+30)/2);    
% Compute second destination picture border: 'borderRect4'
borderRect4 = SetRect(xs+(img_gap-40) - (imgwidth+80)/2, ys - (imgheight+30)/2, xs+(img_gap-40) + (imgwidth+80)/2, ys + (imgheight+30)/2);
% Make off screen textures for the cue border locations.
left_gray_rect=Screen('OpenOffscreenwindow', w, gray, borderRect3);
right_gray_rect=Screen('OpenOffscreenwindow', w, gray, borderRect4); 


end
