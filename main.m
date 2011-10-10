% Load a first image to use for format and size
test_img = double(imread(strcat('ivr1/data1/', sprintf('%08d', 1), '.jpg')))/255;
% zero-initialise an input matrix of the right size and type
input = zeros(size(test_img,1), size(test_img,2), size(test_img,3), 100, class(test_img));
% read in all the images
for i = 1:size(input, 4)
    curimg = imread(strcat('ivr1/data1/', sprintf('%08d', i), '.jpg'));
    input(:, :, :, i) = double(curimg)/255;
end

% compute the average for each pixel
% average = zeros(size(test_img));
%for m = 3:size(input, 4)
%    average = average + input(:,:,:,m);
%end
%average = average / (size(input, 4) - 2);
%imshow(average);

% compute the median for each pixel
% med =  median(input, 4);
% med =  median(input(:,:,:,60:100), 4);
med =  median(input(:,:,:,1:10:100), 4);
imshow(med);
