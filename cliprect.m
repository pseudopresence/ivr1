function [Out] = cliprect(Img, Centre, Size)
    YMin = round(max(1, Centre(1) - Size/2));
    YMax = round(min(size(Img, 1), Centre(1) + Size/2));
    XMin = round(max(1, Centre(2) - Size/2));
    XMax = round(min(size(Img, 2), Centre(2) + Size/2));
    Out = Img(YMin:YMax, XMin:XMax);
end