function [centerMassX, centerMassY] = calcBoundingBoxCM(verticesX, verticesY, TImg)

%Initialise Area counter to determine how many pixels
%the robot in the image contains
areaCounter = 0;

%The center of mass coordinates for the robot are initialised
centerMassX = 0;
centerMassY = 0;

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

%Calculate the center of mass for the image
centerMass=zeros(1,2);
for r=verticesX(1):verticesX(2)
    for c=verticesY(1):verticesY(3)
        centerMass(1,1) = centerMass(1,1)+r*TImg(c,r);
        centerMass(1,2) = centerMass(1,2)+c*TImg(c,r);
    end
end
%The x coordinate center of mass
centerMassX= centerMass(1,1)/areaCounter;
%The y coordinate center of mass
centerMassY= centerMass(1,2)/areaCounter;
