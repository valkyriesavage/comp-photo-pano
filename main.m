HAWAII = true;
ROSE_GARDEN = false;
MUNICH = false;

USER = false;
AUTO = true;

CALCULATE = false;

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

if USER
    % load user-defined homography point pairs
    
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
end
if AUTO
    if CALCULATE
        % collect harris corners
        [ohx,ohy,ohv] = harris(im0);
        [onex,oney,onev] = harris(im1);
        [twox,twoy,twov] = harris(im2);

        % adaptive non-maximal suppression for fewer points
        numpts = 500;
        ohpts = ANMS(ohx,ohy,ohv,numpts);
        onepts = ANMS(onex,oney,onev,numpts);
        twopts = ANMS(twox,twoy,twov,numpts);

        % visualize one
        imagesc(im0);
        colormap(gray);
        hold on;
        plot(ohpts(:,1),ohpts(:,2),'r.');
        hold off;

        % structure correctly
        ohto1 = struct;
        oneto2 = struct;
        ohto1.inputPoints = ohpts;
        ohto1.basePoints = onepts;
        oneto2.inputPoints = onepts;
        oneto2.basePoints = twopts;
    else
        load('hawaii-auto.mat');
    end
    
    % get correspondences
    ohto1 = russianGranny(ohto1,im0,im1);
    oneto2 = russianGranny(oneto2,im1,im2);
    
    % RANSAC that shit.  which points make a good homography?
    [g01, ohto1] = RANSAC(ohto1);
    [g12, oneto2] = RANSAC(oneto2);
end


% a note about these points: for each structure it's like this:
% ohto1.basePoints = points in im1
% ohto1.inputPoints = points in im0

% now that we have refined points, make some dang homographies!
% these homographies should take
% image 0 to image 1, image 2 to image 1

h01 = computeH(ohto1.inputPoints,ohto1.basePoints);
h21 = computeH(oneto2.basePoints,oneto2.inputPoints);

% before we warp, let's set some alphas.
im0 = alphanate(im0);
im1 = alphanate(im1);
im2 = alphanate(im2);

% now, to warp! -- let's restrict to 3 images and 
% just warp the outer two into the center.
[imwarp0in1,xshift01,yshift01] = warpImage(im0,h01);
[imwarp2in1,xshift21,yshift21] = warpImage(im2,h21);

% now we shift

im0z = shiftImage(imwarp0in1,0,0);
im1z = shiftImage(im1,xshift01,yshift01);
im2z = shiftImage(imwarp2in1,xshift01-xshift21,yshift01-yshift21);
stitchedz = stitchImages(im0z,im1z,im2z);

% aaaand we stitch
imshow(stitchedz(:,:,1:3));