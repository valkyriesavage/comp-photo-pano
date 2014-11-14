function H = computeH(pts1, pts2)
    % first we need to put these into a "third dimension"
    % so homography calculations come out correctly

    bigger1 = ones(size(pts1,1),3);
    bigger1(:,1:2) = pts1;
    bigger2 = ones(size(pts2,1),3);
    bigger2(:,1:2) = pts2;
    
    % then, we know that bigger1*H = bigger2
    % If A is a square n-by-n matrix and B is a matrix with n rows,
    % then x = A\B is a solution to the equation A*x = B, if it exists.
    H = bigger1\bigger2;
end