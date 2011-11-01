function [verticesX, verticesY, centroidX, falseImageX] = calcBoundingBox(TImgX)
global HaveToolbox;
%Set the image thresholds
thresholdUpper=4000;
thresholdLower=1500;
falseImageX=0;

%Label the image
[labelX, numXBlobs] = mybwlabel(TImgX);

centroidX = zeros(1,2);
%Then extract the various properties from the image
if HaveToolbox==1
blobMeasurements = regionprops(labelX, ['basic']);
if size(blobMeasurements,1) == 0
    verticesX = [0 0 0 0 0];
    verticesY = [0 0 0 0 0];
    centroidX = [0 0];
    return;
end
end

%Calculate the area for each blob
allBlobAreas = [];
for i=1:numXBlobs
    [rows,cols,vals] = find(labelX==i);
    blobSize = sum(vals);
    allBlobAreas = [allBlobAreas blobSize];
    
end

if numXBlobs == 0
    verticesX = [0 0 0 0 0];
    verticesY = [0 0 0 0 0];
    centroidX = [0 0];
    return;
end


%allBlobAreas = [blobMeasurements.Area];
%Find the maximum area in the image
[maxBlobArea, index] = max(allBlobAreas);



if HaveToolbox==1
%Extract the bounding box from the image toolbox
boundingBox = blobMeasurements(index).BoundingBox;
x1 = boundingBox(1);
y1 = boundingBox(2);
x2 = x1 + boundingBox(3) - 1;
y2 = y1 + boundingBox(4) - 1;
elseif HaveToolbox==0
%Without using the image toolkit, extract the bounding box

[rows,cols,vals] = find(labelX==index);
x1 = min(cols);
x2 = max(cols);
y1 = min(rows);
y2 = max(rows);

end
verticesX = [x1 x2 x2 x1 x1];
verticesY = [y1 y1 y2 y2 y1];
centroidX(1,1) = (x2+x1)/2;
centroidX(1,2) = (y2+y1)/2;

%Check the area of the blob to determine
%whether the blob falls within the correct region.


    %If the blob falls out of a certain limit
    if(maxBlobArea> thresholdUpper || ...
            maxBlobArea<thresholdLower)
        falseImageX= 1;
    else
        falseImageX=0;
    end
    
    

end
