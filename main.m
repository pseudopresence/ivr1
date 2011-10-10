test_img = double(imread(strcat('ivr1/data1/', sprintf('%08d', 1), '.jpg')))/255;
input = zeros(size(test_img,1), size(test_img,2), size(test_img,3), 100, class(test_img));
for i = 1:size(input, 4)
    curimg = imread(strcat('ivr1/data1/', sprintf('%08d', i), '.jpg'));
    input(:, :, :, i) = double(curimg)/255;
end

