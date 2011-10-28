function [verticesX, verticesY, centroidX] = calcBoundingBox(TImgX)

%Label the image
[labelX, numXBlobs] = mybwlabel(TImgX);

centroidX = zeros(1,2);
%Then extract the various properties from the image
blobMeasurements = regionprops(labelX, ['basic']);
%Look at the image bounding box
%boundingBox = cat(1,propsX.BoundingBox)

allBlobAreas = [blobMeasurements.Area];
[maxBlobArea, index] = max(allBlobAreas);

%for k = 1 : numXBlobs
    boundingBox = blobMeasurements(index).BoundingBox;	 % Get box.
    %Get the centroid values for the image
    %centroidX = blobMeasurements(index).Centroid;
    x1 = boundingBox(1);
    y1 = boundingBox(2);
    x2 = x1 + boundingBox(3) - 1;
    y2 = y1 + boundingBox(4) - 1;
    verticesX = [x1 x2 x2 x1 x1];
    verticesY = [y1 y1 y2 y2 y1];
    centroidX(1,1) = (x2+x1)/2;
    centroidX(1,2) = (y2+y1)/2;
    % Calculate width/height ratio.
    aspectRatio(index) = boundingBox(3) / boundingBox(4);
    fprintf('For blob #%d, area = %d, aspect ratio = %.2f\n', ...
        index, allBlobAreas(index), aspectRatio(index));
% Plot the box in the overlay.
%plot(verticesX, verticesY, 'r-', 'LineWidth', 2);
%end
end