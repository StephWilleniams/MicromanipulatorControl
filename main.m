% Scipt to do the micromanipulator correction.

%% Add function folder to filepath

exeLoc = '~/python.exe' % This is the location of the python executable. This will likely be in /spyder/.
pe = pyenv('Version',exeLoc); % Initialise the python engine.
addpath('functions/'); % Load the MatLab functions.
py.importlib.import_module('serial');
addpath('pythonCode'); % Load the Python functions.
fileLoc = 'data/'; % set the location of the images to be processed.

%%

% Set the time window between corrections.
waitTime = 600; % Measured in seconds.

% Set the base image (requires image to be taken using zyla).
[basefiName, baseImage] = GCI(fileLoc,1);

% Imagesc shows image. Use the data-tip tool to determine a ROI.
figure
imagesc(baseImage) % Shows the whole of the loaded 'base' image.

% coordinates for the ROI.
dxy = 50;
x1 = 100; % Leftmost co-ord.
x2 = x1 + dxy;
y1 = 100; % Topmost co-ord.
y2 = y2 + dxy;

% Check to ensure the ROI is done.
disp('Press any key to continue once you have determined the ROI (requires rerun of code.')
pause 

% Displays a ROI example to ensure it's right.
figure
disp('Displayin the ROI to compare future images to.')
imagesc(baseImage)

pyrunfile("zeroer.py");

% Loop runs forever.
while( 1 ) % Use stop/ctrl-x to cancel the run.

    pause(waitTime) % Wait until next correction.

    % Get the new image for comparison.
    [newfiName, newImage] = GCI(fileLoc,1);

    % Get the shift values.
    [dx,dy,dz] = process_image_subpix(newImage,baseImage,x1,x2,y1,y2);

    % Move the micropipette by the desired amounts, set new position to
    % 'zero'.
    pyrunfile("mover.py",x=dx,y=dy,z=dz); % Move the MP.
    pyrunfile("zeroer.py"); % Recenter.

end
