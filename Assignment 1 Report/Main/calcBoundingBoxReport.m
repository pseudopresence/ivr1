%Excerpts from the bounding box calculation

%Label the image. The labelled image is labelX
[labelX, numXBlobs] = mybwlabel(TImgX);

%Calculate the area for each object found in 'labelX'
allBlobAreas = [];
for i=1:numXBlobs
    [rows,cols,vals] = find(labelX==i);
    blobSize = sum(vals);
    allBlobAreas = [allBlobAreas blobSize];
    
end

%Find the object with the maximum area in the image
[maxBlobArea, index] = max(allBlobAreas);

if HaveToolbox==0
%Without using the image toolkit, extract the bounding box
[rows,cols,vals] = find(labelX==index);
x1 = min(cols);
x2 = max(cols);
y1 = min(rows);
y2 = max(rows);
end