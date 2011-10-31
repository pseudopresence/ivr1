function I = myreadimg(folder, num)
   %I = zeros(480,640,3);
    I = double(imread([folder, sprintf('%08d', num+50), '.jpg']))/255;