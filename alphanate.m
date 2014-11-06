function alphad = alphanate(image)
    buff = floor(min(size(image,1),size(image,2))/8);
    alphadata = zeros(size(image,1),size(image,2));
    alphadata(buff:(size(image,1)-buff), buff:(size(image,2)-buff)) = 1;
    gauss = fspecial('gaussian', [100,100], 80);
    alphadata = conv2(alphadata,gauss,'same');
    alphad = cat(3,image,alphadata);
end