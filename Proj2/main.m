clear all;
clc;
% Set up VLfeat Toolbox here.
% Read in the images that you want to stitch together.
% Better to transform RGB images into gray scale images. vl_sift requires 'single' type.
disp('reading img');
im1 = single(rgb2gray(imresize(imread('../Wall1.JPG'),1/5)));
im2 = single(rgb2gray(imresize(imread('../Wall2.JPG'),1/5)));
im3 = single(rgb2gray(imresize(imread('../Wall3.JPG'),1/5)));

% Obtaininig SIFT Correspondences by VLfeat tool box.
% Btw, what's the meaning of the outputs?
% keep track of feature points coordinates.
disp('Obtaininig SIFT Correspondences');
% [X;Y;S;TH], where X,Y
% is the (fractional) center of the frame, S is the scale and TH is
% the orientation (in radians).
[F_1,D_1] = vl_sift(im1);
[F_2,D_2] = vl_sift(im2);
[F_3,D_3] = vl_sift(im3);

% Here you should matching the SIFT feature between adjacent images by L2 distance. 
% Please fill the function match.m
disp('matching keypoints');
match12 = uint32(match(D_1,D_2));
match32 = uint32(match(D_3,D_2));
point1 = [F_1(1,:);F_1(2,:)]; point1 = point1';
point2 = [F_2(1,:);F_2(2,:)]; point2 = point2';
point3 = [F_3(1,:);F_3(2,:)]; point3 = point3';


% Estimating Homography using RANSAC
% Please fill the function RANSACFit.m
disp('RANSACing');
H12 = RANSACFit(point1,point2,match12,500);
H32 = RANSACFit(point3,point2,match32,500);

%% Creating the panorama
% use cell() to store correspondent images and transformations
disp('Generating panorama pictures...');
IMAGES = cell(1,3);
TRANS = cell(1,2);
IMAGES{1,1} = imresize(imread('../Wall3.JPG'),1/5);
IMAGES{1,2} = imresize(imread('../Wall2.JPG'),1/5);
IMAGES{1,3} = imresize(imread('../Wall1.JPG'),1/5);
TRANS{1,1} = H12;
TRANS{1,2} = H32;
Pano = MultipleStitch( IMAGES, TRANS, 'pano.jpg' );

% In plotMatches.m you can visualize the matching results after you feed proper data stream. Feel free to create your own visualization.
