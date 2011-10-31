function [verticesX, verticesY, centroidX, falseImageX] = calcBoundingBox(TImgX)

%Set the image thresholds
thresholdUpper=4000;
thresholdLower=1500;
falseImageX=0;

%Label the image
[labelX, numXBlobs] = mybwlabel(TImgX);

centroidX = zeros(1,2);
%Then extract the various properties from the image
blobMeasurements = regionprops(labelX, ['basic']);
%Look at the image bounding box
%boundingBox = cat(1,propsX.BoundingBox)


if size(blobMeasurements,1) == 0
    verticesX = [0 0 0 0 0];
    verticesY = [0 0 0 0 0];
    centroidX = [0 0];
    return;
end

allBlobAreas = [blobMeasurements.Area];
[maxBlobArea, index] = max(allBlobAreas);

boundingBox = blobMeasurements(index).BoundingBox;	 % Get box.
x1 = boundingBox(1);
y1 = boundingBox(2);
x2 = x1 + boundingBox(3) - 1;
y2 = y1 + boundingBox(4) - 1;
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


