HAWAII = false;
ROSE_GARDEN = true;
MUNICH = false;

% load images

if HAWAII

    im0 = im2double(imread('samples/hawaii-0-left.jpg'));
    im1 = im2double(imread('samples/hawaii-1-leftcenter.jpg'));
    im2 = im2double(imread('samples/hawaii-2-rightcenter.jpg'));

end
if ROSE_GARDEN

    im0 = im2double(imread('samples/rose1-1.jpg'));
    im1 = im2double(imread('samples/rose1-2.jpg'));
    im2 = im2double(imread('samples/rose1-3.jpg'));

end
if MUNICH

    im0 = im2double(imread('samples/munich-0.png'));
    im1 = im2double(imread('samples/munich-1.png'));
    im2 = im2double(imread('samples/munich-2.png'));

end

% load user-selected homography point pairs

if HAWAII
    load 'cps-hawaii.mat'
end
if ROSE_GARDEN
    load 'cps-rose.mat'
end
if MUNICH
    load 'cps-munich.mat'
end

% now refine automatically

ohto1 = refine(ohto1,im0,im1);
oneto2 = refine(oneto2,im1,im2);
% twoto3 = refine(twoto3,im2,im3);

% a note about these points: for each structure it's like this:
% ohto1.basePoints = points in im1
% ohto1.inputPoints = points in im0

% now that we have refined points, make some dang homographies!

h01 = computeH(ohto1.inputPoints,ohto1.basePoints);
% h12 = computeH(oneto2.inputPoints,oneto2.basePoints);
h21 = computeH(oneto2.basePoints,oneto2.inputPoints);
% h23 = computeH(twoto3.inputPoints,twoto3.basePoints);

% so, just to be clear, these homographies should take
% image 0 to image 1, image 1 to image 2, image 2 to image 3

% before we warp, let's set some alphas.
im0 = alphanate(im0);
im1 = alphanate(im1);
im2 = alphanate(im2);
% im3 = alphanate(im3);

% now, to warp! -- let's restrict to 3 images and 
% just warp the outer two into the center.
[imwarp0in1,xshift01,yshift01] = warpImage(im0,h01);
% [imwarp0in2,xshift02,yshift02] = warpImage(imwarp0in1,h12);
% [imwarp0in3,xshift03,yshift03] = warpImage(imwarp0in2,h23);
% xshift0 = sum([xshift01,xshift02,xshift03]);
% yshift0 = sum([yshift01,yshift02,yshift03]);

% [imwarp1in2,xshift12,yshift12] = warpImage(im1,h12);
% [imwarp1in3,xshift13,yshift13] = warpImage(imwarp1in2,h23);
% xshift1 = sum([xshift12,xshift13]);
% yshift1 = sum([yshift12,yshift13]);

[imwarp2in1,xshift21,yshift21] = warpImage(im2,h21);

% [imwarp2in3,xshift23,yshift23] = warpImage(im2,h23);
% xshift2 = sum([xshift23]);
% yshift2 = sum([yshift23]);

% now we shift
% im0s = imwarp0in3;
% im1s = shiftImage(imwarp1in3,xshift0-xshift1,yshift0-yshift1);
% im2s = shiftImage(imwarp2in3,xshift0-xshift2,yshift0-yshift2);
% im3s = shiftImage(im3,xshift0,yshift0);

im0z = shiftImage(imwarp0in1,0,0);
im1z = shiftImage(im1,xshift01,yshift01);
im2z = shiftImage(imwarp2in1,xshift01-xshift21,yshift01-yshift21);
stitchedz = stitchImages(im0z,im1z,im2z);

imshow(stitchedz(:,:,1:3));

% aaaand we stitch
% stitched = stitchImages(im0s,im1s,im2s,im3s);
% 
% H=imshow(stitched);