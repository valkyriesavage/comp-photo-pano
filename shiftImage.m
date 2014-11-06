function shifted = shiftImage(im,xshift,yshift)
    % for the purposes of this function, we assume that all shifts are <0
    shifted = zeros(size(im,1)-yshift,size(im,2)-xshift,4);
    shifted(1-yshift:size(im,1)-yshift,1-xshift:size(im,2)-xshift,:) = im;
end