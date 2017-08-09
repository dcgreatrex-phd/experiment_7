function [pahandle] = load_audio_buffer(wavfilename)

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
    pahandle = PsychPortAudio('Open', [], [], 3, [], nrchannels);
end      

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, wavedata);
         