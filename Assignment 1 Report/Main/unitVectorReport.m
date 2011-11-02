%Define unit vectors in the direction of the bounding
%box centroid for each of the rgb channels respectively
CenterMassR = [CenterMassXR CenterMassYR];
DR = (CentroidR - CenterMassR);

CenterMassG = [CenterMassXG CenterMassYG];
DG = (CentroidG - CenterMassG);

CenterMassB = [CenterMassXB CenterMassYB];
DB = (CentroidB - CenterMassB);

%Calculate the unit vectors for each channel
DR = DR/norm(DR);
DG = DG/norm(DG);
DB = DB/norm(DB);

%*****************************************************
%Excerpt of code for plotting the arrows connecting the
%centroids and center of mass of each robot
plot_arrow(trueCMXR,trueCMYR, trueCentroidBBXR+30*DR(1),trueCentroidBBYR+30*DR(2)...
,'linewidth',2,'headwidth',0.25,'headheight',0.33,'color',LineColRArrow,...
'facecolor',LineColRArrow);
hold on
plot_arrow(trueCMXG,trueCMYG, trueCentroidBBXG+30*DG(1),trueCentroidBBYG+30*DG(2)...
,'linewidth',2,'headwidth',0.25,'headheight',0.33,'color',LineColGArrow,...
'facecolor',LineColGArrow);
hold on
plot_arrow(trueCMXB,trueCMYB, trueCentroidBBXB+30*DB(1),trueCentroidBBYB+30*DB(2)...
,'linewidth',2,'headwidth',0.25,'headheight',0.33,'color',LineColBArrow,...
'facecolor',LineColBArrow);
