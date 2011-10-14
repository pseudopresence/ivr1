function I = myreadimg(folder, num)
    I = double(imread([folder, sprintf('%08d', num), '.jpg']))/255;