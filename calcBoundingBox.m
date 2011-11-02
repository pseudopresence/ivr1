function [verticesX, verticesY, centroidX, falseImageX] = calcBoundingBox(TImgX)
global HaveToolbox;
%Set the image thresholds used to determine
%if the detected object is indeed a robot
thresholdUpper=4000;
thresholdLower=1500;
falseImageX=0;

%Label the image
[labelX, numXBlobs] = mybwlabel(TImgX);

%Initialise the centroid variable to hold the coordinates
%of the bounding box
centroidX = zeros(1,2);

%Then extract the various properties from the image 

%if the image toolbox is available
if HaveToolbox==1
blobMeasurements = regionprops(labelX, ['basic']);
if size(blobMeasurements,1) == 0
    verticesX = [0 0 0 0 0];
    verticesY = [0 0 0 0 0];
    centroidX = [0 0];
    return;
end
end

%Calculate the area for each blob obtained from 'labelX'
allBlobAreas = [];
for i=1:numXBlobs
    [rows,cols,vals] = find(labelX==i);
    blobSize = sum(vals);
    allBlobAreas = [allBlobAreas blobSize];
    
end

%Find the blob with the maximum area in the image
[maxBlobArea, index] = max(allBlobAreas);

%If there are no 'blobs'(objects) in the image
if numXBlobs == 0 || maxBlobArea==0
    verticesX = [0 0 0 0 0];
    verticesY = [0 0 0 0 0];
    centroidX = [0 0];
    return;
end


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
%determine the vertices of the bounding box
verticesX = [x1 x2 x2 x1 x1];
verticesY = [y1 y1 y2 y2 y1];
%Determine the centroid of the bounding box surrounding the robot
centroidX(1,1) = (x2+x1)/2;
centroidX(1,2) = (y2+y1)/2;

%**************************************************
%Not fully implemented as it was found that this 
%algorithm depends on the camera position

%Check the area of the blob to determine
%whether the blob falls within the correct region.
    if(maxBlobArea> thresholdUpper || ...
            maxBlobArea<thresholdLower)
        %If the blob is greater than the predetermined
        %threshold size of the robot, then the blob
        %is probably not a robot
        falseImageX= 1;
    else
        falseImageX=0;
    end
 %**************************************************   
    

end
