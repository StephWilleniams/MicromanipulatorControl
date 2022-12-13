
README file. 
Author: Stephen Williams.
Date: 12/12/22.

>>>>> 

Code controls the Scientifica micro-manipulator, correcting for a drift periodically.

>>>>> Code history:

12/12/2022: Initial commit.

>>>>> Code description 

At the moment the code requires some user input. 
The wait time between corrections must be input in main.m as the variable waitTime.
After this is inserted a base image is selected using the function GCI (get current image). This is the image to which all future images are compared.
The user sets the ROI size (dxy), which is a dxy-by-dxy square (this can be modified as needed). Runtime will go as ~dxy^2, so smaller is better. 
The corners of the ROI are x1,x2,y1,y2. 
The position is then zero-ed (this means the 'base' image is marked as 'correct').
The loop then does the bulk of the work.
First, it waits some time (this must be frequent enough that the expected drift (~3um/hr or 17pix/hr) is still within the ROI. The default is set at 600 sec (10 min).
Process_image_subpix then works out how much motion is needed to ensure that the movement of the micropipette corrects the drift.
The two pyrun files then implement this change: the first doing the movement, the second re-zeros the image.

>>>>> TBD/comments 

TBD: the code currently does not invoke camera image acquisition. This would be a likely next step, as doing so would enable the user to make an autofocusing routine. This would go something like:
> move to position -Z
> loop I until -Z + I*dz = +Z:
	take image 
	move to position -Z + dz 
> Get image contrast(/quality metric), choose height with best metric.

Comment: when Matlab executes a python script, as yet, I am unsure how to include a preexisting python script containing functions. Thus, the functions need to be redefined in each script in which they are executed (which is why mover and zeroer have replicated functions).

Comment: there is a routine in the micropipette which can be used the set the speed at which the movements occur. If there is a `jerkiness' to the motion it could be that using this feature will fix this? 