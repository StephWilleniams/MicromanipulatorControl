    
function [path,image] = GCI(baseFile, imNum, )
    
    % Get a list of all the current files.
    a = dir(baseFile); % Insert the filepath for the stored images here.
    
    % Get the various lengths for preallocation.
    n = length(a); % Total number of files.
    exFile = 3; % Index of example file.
    cn = length(a(3).name); % Character array length of useful files.
    junkStart = 2; % Files at start to omit.
    junkEnd = 1; % Files at end to omit.
    stn = length(junkStart+1:n-junkEnd); % Number of useful files.
    
    % Preallocation.
    b = zeros(cn,length(a)); % Store of the names of the useful files.
    store = zeros(stn,1); % Store of the 'image order' values.
    
    % Get the order the images where taken.
    for i = 3:n-1
        temp = a(i).name(1:10);
        temp = flip(temp);
        store(i) = str2num(temp);
    end
    
    [~,maI] = max(store); % Determine the most recent image.
    path = [baseFile a(2+maI).name]; % Get the name of that file.
    param_file_name = [baseFile 'acquisitionmetadata.txt']; % get the metadata to do .dat > .png

    [images,errcode] = readAndorDatImage(path, param_file_name);

    image = rgb2grey(images(:,:,imNum));
    
end

