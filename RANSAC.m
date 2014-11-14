function [good, bettered_cpstruct] = RANSAC(cpstruct)

    % ok, RANSAC.  how does it work?
    
    bestidxes = [0,0,0,0];
    mostInliers = 0;
    
    thresh = 3;
    
    % we pick 4 points
    for i0 = [1:size(cpstruct.inputPoints)]
        for i1 = [i0+1:size(cpstruct.inputPoints)]
            for i2 = [i1+1:size(cpstruct.inputPoints)]
                for i3 = [i2+1:size(cpstruct.inputPoints)]
                    p0i = cpstruct.inputPoints(i0,:);
                    p1i = cpstruct.inputPoints(i1,:);
                    p2i = cpstruct.inputPoints(i2,:);
                    p3i = cpstruct.inputPoints(i3,:);
                    pis = [p0i,p1i,p2i,p3i];
                    pis = reshape(pis,2,4);
                    pis = pis.';
                    
                    p0b = cpstruct.basePoints(i0,:);
                    p1b = cpstruct.basePoints(i1,:);
                    p2b = cpstruct.basePoints(i2,:);
                    p3b = cpstruct.basePoints(i3,:);
                    pbs = [p0b,p1b,p2b,p3b];
                    pbs = reshape(pbs,2,4);
                    pbs = pbs.';
                    
                    H = computeH(pis,pbs);
                    inliers = 0;
                    outliers = 0;
                    
                    for j=[1:size(cpstruct.inputPoints)]
                        jay = [cpstruct.inputPoints(j,:),1];
                        kay = [cpstruct.basePoints(j,:),1];
                        jayprime = jay*H;
                        if(sum((kay-jayprime).^2).^0.5 < thresh)
                            inliers = inliers + 1;
                        else
                            outliers = outliers + 1;
                        end
                    end
                    
                    if inliers > mostInliers
                        mostInliers = inliers;
                        bestidxes = [i0,i1,i2,i3];
                    end
                end
            end
        end
    end
    
    bettered_cpstruct = struct;
    bettered_cpstruct.inputPoints = cpstruct.inputPoints(bestidxes,:);
    bettered_cpstruct.basePoints = cpstruct.basePoints(bestidxes,:);
    
    good = (mostInliers/size(cpstruct.inputPoints,1) > .75);
end