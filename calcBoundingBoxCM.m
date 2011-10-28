function [orientX, orientY] = calcBoundingBoxCM(verticesX, verticesY, TImg)

%Initialise Area counter
areaCounter = 0;
orientX = 0;
orientY = 0;

%Convert vertices of type double to integers
verticesX = round(verticesX);
verticesY = round(verticesY);

%Calculate the area of the object within the bounding Box
 
for x = verticesX(1):verticesX(2)
   for y = verticesY(1):verticesY(3)
        TImg(y,x);
     if(TImg(y,x)==1)
        
         areaCounter  = areaCounter+1;
     else
         areaCounter;
     end
   end
end
areaCounter;

centerBoundXAxis = (verticesX(2) - verticesX(1))/2;
centerBoundYAxis = (verticesY(3) - verticesY(1))/2;

    %Calculate the center of mass for image
    centerMass=zeros(1,2);
    for r=verticesX(1):verticesX(2)
        for c=verticesY(1):verticesY(3)
            
            
           centerMass(1,1) = centerMass(1,1)+r*TImg(c,r);
           centerMass(1,2) = centerMass(1,2)+c*TImg(c,r);
        end
    end
    %rcenterR
    orientX= centerMass(1,1)/areaCounter;
    %ccenterR
    orientY= centerMass(1,2)/areaCounter;

% [rows,cols,valsR] = find(TImgR==1);
%  imageAreaR = sum(valsR);