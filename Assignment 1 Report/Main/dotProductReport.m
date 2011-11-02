 

%Colour for the orientation arrows on the main image
    LineColRArrow = [0 0 1];
    LineColGArrow = [0 0 1];
    LineColBArrow = [0 0 1];
 %Calculate the dot product between the arrows current 
 %orientation and its previous orientation. If the value
 %is less than 0.5, then the arrow is pointing in an incorrect
 %direction
    if dot(DR, OldDirR) < 0.5
        
  %Arrow is pointing in an incorrect direction,
  %therefore make the arrow red to indicate this.
        LineColR = 'r-';
        LineColRArrow = [1 0 0];
    end
    if dot(DG, OldDirG) < 0.5
        LineColG = 'r-';
        LineColGArrow = [1 0 0];
    end
    if dot(DB, OldDirB) < 0.5
        LineColB = 'r-';
        LineColBArrow = [1 0 0];
    end
    OldDirR = DR;
    OldDirG = DG;
    OldDirB = DB;