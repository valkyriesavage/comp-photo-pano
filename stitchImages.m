function stitched = stitchImages(im0,im1,im2,im3)
    % ok, we are assuming that the images have been shifted appropriately
    % so the way we want to do this is basically by summing them up.  where
    % there is data from two different images, we'll just "feather" it, by
    % which I mean multiply by 1/2
    
    stitchedy = max([size(im0,1),size(im1,1),size(im2,1),size(im3,1)]);
    stitchedx = max([size(im0,2),size(im1,2),size(im2,2),size(im3,2)]);
    
    stitched = zeros(stitchedy, stitchedx, 3);
    stitched(1:size(im0,1),1:size(im0,2),:) = im0(:,:,1:3).*cat(3,im0(:,:,4),im0(:,:,4),im0(:,:,4));
    
    stitched(1:size(im1,1),1:size(im1,2),:) = stitched(1:size(im1,1),1:size(im1,2),:) + im1(:,:,1:3).*cat(3,im1(:,:,4),im1(:,:,4),im1(:,:,4));
    
    stitched(1:size(im2,1),1:size(im2,2),:) = stitched(1:size(im2,1),1:size(im2,2),:) + im2(:,:,1:3).*cat(3,im2(:,:,4),im2(:,:,4),im2(:,:,4));
    
    stitched(1:size(im3,1),1:size(im3,2),:) = stitched(1:size(im3,1),1:size(im3,2),:) + im3(:,:,1:3).*cat(3,im3(:,:,4),im3(:,:,4),im3(:,:,4));
end