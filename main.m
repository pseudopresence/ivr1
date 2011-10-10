test_img = imread(strcat('ivr1/data1/', sprintf('%08d', 1), '.jpg'));
input = zeros(100, size(i,1),size(i,2),size(i,3));
for i = 3:size(input, 1)
    input(i-2, :, :, :) = imread(strcat('ivr1/data1/', sprintf('%08d', i), '.jpg'));
end
