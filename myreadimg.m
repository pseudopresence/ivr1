function I = myreadimg(Folder, Num)
    I = double(imread([Folder, sprintf('%08d', Num), '.jpg']))/255;