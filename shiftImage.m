function shifted = shiftImage(im,xshift,yshift)
    % for the purposes of this function, we assume that all shifts are <0
    shifted = zeros(size(im,1)-2*yshift,size(im,2)-2*xshift,4);
    if (yshift <= 0)
        shifted(1-yshift:size(im,1)-yshift,1-xshift:size(im,2)-xshift,:) = im;
    end
    if (yshift > 0)
        shifted(1:size(im,1)-yshift,1-xshift:size(im,2)-xshift,:) = im(yshift+1:size(im,1),:,:);
    end
    shifted(isnan(shifted)) = 0;
end