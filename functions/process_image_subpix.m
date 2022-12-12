function [dx,dy,dz] = process_image_subpix(image1, base_image1,x1,x2,y1,y2)

    % um per pixel.
    umppxl = 1;

    % pointless code to stop errors.
    dx = 0;
    dy = 0;
    dz = 0;

    % Bad methond, runtime goes as runtime_0*f^2?
    f = 2; % Scale factor (1/f sets smallest resolution of move detected).

    % Scale the ROI position.
    x1 = f*x1;
    x2 = f*x2;
    y1 = f*y1;
    y2 = f*y2;

    % Gaussian filter to smooth the data over the blown up space.
    image1 = imgaussfilt(blowup(image1,f));
    base_image1 = imgaussfilt(blowup(base_image1,f));

    % Attempt at background subtraction.
    image1 = cleanimageNorm(image1);
    base_image1 = cleanimageNorm(base_image1);

    % Define the region of interest and get the base image segment.
    baseR = base_image1(x1:x2,y1:y2);
    %imR = image1(x1roi:x2roi,y1roi:y2roi);

    % Define size of the search window.
    xsi = f*20; % These values set the maximum movement between processing steps.
    ysi = f*20;
    quality = zeros(2*xsi+1,2*ysi+1);
    
    % Loop on the shifts.
    for i = 0:2*xsi
        for j = 0:2*ysi

            % Convert to a pixel shift.
            deltax = -xsi+i;
            deltay = -ysi+j;

            % Get the shifted comparison image segment.
            imR = image1(x1+deltax:x2+deltax, ...
                           y1+deltay:y2+deltay);

            % Calculate the sum of the pixel-wise product of the image.
            % Can FFT this to improve runtime.
            quality(i+1,j+1) = sum(sum(imR.*baseR));

        end
    end    

    %% try to fit quality curve here and extract peak
    %% or get local COM.

    % Get the maximal value of the quality metric.
    [~,indX] = max(max(quality));
    [~,indY] = max(quality(:,indX));

    % Calculate the shift to be performed.
    dx = umppxl*(-xsi+indX-1)/f;
    dy = umppxl*(-ysi+indY-1)/f;
    dz = 0;

end

