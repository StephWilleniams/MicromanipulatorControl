function [cleanim] = cleanimageNorm(img)

    % Note: Here, instead the experiments could be set up to produce an
    % image stack at each point. Then the background could be better?
    % unclear if this is currently much of a limitation in the way this is
    % running, depends on how this progresses moving on from test to real
    % cases.

    cleanim = img - mean(mean(img)); % do some background subtraction.
    %cleanim = 255-cleanim; % Invert
    %cleanim(cleanim <= 0)=0; % Threshold the values
    
end

