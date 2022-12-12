%% This has been downloaded from Mathworks on the 2021-05-27
%% I changed few things to make it work, e.g. the part with the C++ code was not working

function [andorImage, bFileDoesNotExist] = readAndorDatImage(rawDataFileName, param_file_name)
% Input
%param_file_name = 'acquisitionmetadata.txt';
%rawDataFileName = '0000000000spool.dat';

% Output
% andorImage: image contained in a dat file, of size nxmxp where n and m
% are the sizes of the field of view while p is the number of images per
% .dat file.
% bFileDoesNotExist: flag if the file does not exist.

% parse the paramFile here
param_ch1 = struct('fileName', param_file_name);
param_file_ptr = fopen(param_ch1.fileName);
tokeniser = '=';

%%

file = textscan(param_file_ptr,'%s','Delimiter','\n');
file = file{1};
for i = 1:length(file)
    line = file{i};
    if ~isempty(line) && ~contains(line,'[')
        paramValue = line ((strfind (line, tokeniser) + 2):end);
        paramName = line (1:(strfind (line, tokeniser) - 2));
        if (contains(paramName, 'AOI'))
            paramValue = str2double(paramValue);
        end
        if (contains(paramName, 'Bytes'))
            paramValue = str2double(paramValue);
        end
        if (contains(paramName, 'ImagesPerFile'))
            paramValue = str2double(paramValue);
        end
        param_ch1.(paramName) = paramValue;
    end
end
fclose(param_file_ptr);

%%

% Original:Call C function to readAndor dat file
% Here I created a m version instead of c
filePtr = fopen(rawDataFileName);
if (filePtr == -1)
    bFileDoesNotExist = 1;
else
    bFileDoesNotExist = 0;
    fclose (filePtr);
end

if (bFileDoesNotExist)
    andorImage = zeros(param_ch1.AOIWidth, param_ch1.AOIHeight);
else
    andorImage = readAndorDatFile(rawDataFileName,param_ch1);
end

%%

andorImage2 = uint16(andorImage);

%%


    function andorImage = readAndorDatFile(rawDataFileName,params)
        fid = fopen(rawDataFileName);
        file = fread(fid);
        file = reshape(file,[],params.ImagesPerFile);
        
        for iImage = 1:params.ImagesPerFile
            usInputPixels = file(:,iImage);
            aoiHeight = params.AOIHeight;
            aoiStrideLength = params.AOIStride;
            aoiWidth = params.AOIWidth;
            
            % % Unpack the 12MonoPacked to unsigned shorts*/
            if strcmp(params.PixelEncoding,'Mono32')
                for iRow = 0:aoiHeight-1
                    iInputRowStart = iRow * aoiStrideLength;
                    iOutputRowStart = iRow * aoiWidth;
                    for iColumn = 0:2:aoiWidth-1
                        iInputPixel = iInputRowStart + (iColumn * 8)/2;
                        iOutputPixel = iOutputRowStart + iColumn;
                        usOutputPixels(iOutputPixel+1) = (usInputPixels(iInputPixel+1)*1+usInputPixels(iInputPixel+2)*2^8);
                        usOutputPixels(iOutputPixel+2) = (usInputPixels(iInputPixel+5)*1+usInputPixels(iInputPixel+6)*2^8);
                    end
                end
            elseif strcmp(params.PixelEncoding,'Mono12Packed')
                for iRow = 0:aoiHeight-1
                    iInputRowStart = iRow * aoiStrideLength;
                    iOutputRowStart = iRow * aoiWidth;
                    for iColumn = 0:2:aoiWidth-1
                        iInputPixel = iInputRowStart + (iColumn * 3)/2;
                        iOutputPixel = iOutputRowStart + iColumn;
                        usOutputPixels(iOutputPixel+1) = (usInputPixels(iInputPixel+1)*2^4+mod(usInputPixels(iInputPixel+2),16));
                        usOutputPixels(iOutputPixel+2) = (usInputPixels(iInputPixel+3)*2^4+floor(usInputPixels(iInputPixel+2)/2^4));
                    end
                end
            end
            
            Image = reshape(usOutputPixels,aoiWidth,aoiHeight);
            andorImage(:,:,iImage) = flip(Image',1);
            
        end
        fclose(fid);
    end

end