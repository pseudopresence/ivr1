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