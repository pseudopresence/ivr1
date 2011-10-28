function [orientX, orientY] = calcOrientation(verticesX, verticesY, TImg)

%Initialise Area counter
areaCounter = 0;

%Calculate the area of the object within the bounding Box
 
for x = vericesX(1):verticesX(2)
   for y = verticesY(1):verticesY(3)
     if(TImg(x,y)==1)
         areaCounter  = areaCounter+1;
     else
         areaCounter;
     end
   end
end

orientx = areaCounter
orienty = areaCounter


[rows,cols,valsR] = find(TImgR==1);
 imageAreaR = sum(valsR);