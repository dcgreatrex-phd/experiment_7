function [tex] = ptb_pretarget (rectSize, w, dstRect, numRects, aperture1)

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
    Screen('DrawTexture', w, aperture1, [], dstRect(i,:), [], 0);                

end

end

