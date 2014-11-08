function [warped,xshift,yshift] = warpImage(image, H)
    % hmmm... forward or inverse warp?  let's do forward and then interp2.
    
    % find the four corners so we know how big this thing is
    sizey = size(image,1);
    sizex = size(image,2);
    upperleft = [0,0,1];
    upperright = [sizex,0,1];
    lowerleft = [0,sizey,1];
    lowerright = [sizex,sizey,1];
    
    % warp those corners
    ulw = upperleft*H;
    urw = upperright*H;
    llw = lowerleft*H;
    lrw = lowerright*H;
    
    % get corners
    tsizey = ceil(max(llw(2),lrw(2)) - min(ulw(2),urw(2)));
    yshift = floor(min(ulw(2),urw(2)));
    tsizex = ceil(max(lrw(1),urw(1)) - min(ulw(1),llw(1)));
    xshift = floor(min(ulw(1),llw(1)));

    % ok, the image : we'll warp das
    [Y,X] = ndgrid(1+yshift:tsizey+yshift,1+xshift:tsizex+xshift);
    Y = Y(:);X = X(:);Z = ones(size(Y));
    querypts = [X,Y,Z]*H^-1;
    Xq = querypts(:,1)./querypts(:,3);
    Yq = querypts(:,2)./querypts(:,3);
    
    red_warped = interp2(image(:,:,1),Xq,Yq);
    red_warped = reshape(red_warped,tsizey,tsizex);
    
    blu_warped = interp2(image(:,:,2),Xq,Yq);
    blu_warped = reshape(blu_warped,tsizey,tsizex);

    grn_warped = interp2(image(:,:,3),Xq,Yq);
    grn_warped = reshape(grn_warped,tsizey,tsizex);
    
    alpha_warped = interp2(image(:,:,4),Xq,Yq);
    alpha_warped(isnan(alpha_warped)) = 0;
    alpha_warped = reshape(alpha_warped,tsizey,tsizex);
    
    warped = cat(3,red_warped,blu_warped,grn_warped,alpha_warped);
end