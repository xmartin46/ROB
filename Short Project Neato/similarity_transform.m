function [tx, ty, theta] = similarity_transform(LandMarks, CalculatedLandMarks)
    A = [];
    for i=1:size( LandMarks , 2)
        A = [A;[ LandMarks(1,i), LandMarks(2,i),1,0]];
        A = [A;[ LandMarks(2,i),-LandMarks(1,i),0,1]];
    end
    B = [];
    for i=1:size( CalculatedLandMarks , 2)
        B = [B; CalculatedLandMarks(1,i); CalculatedLandMarks(2,i)];
    end

    X = inv((A'*A))*A'*B;
    tx = X(3);
    ty= X(4);
    theta = atan2(X(2),X(1));
end

