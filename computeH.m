function H = computeH(pts1, pts2)
    % first we need to put these into a "third dimension"
    % so homography calculations come out correctly

    bigger1 = ones(size(pts1,1),3);
    bigger1(:,1:2) = pts1;
    bigger2 = ones(size(pts2,1),3);
    bigger2(:,1:2) = pts2;
    
    % then, we know that bigger1*H = bigger2
    H = bigger1\bigger2;
    %H = H.';
end