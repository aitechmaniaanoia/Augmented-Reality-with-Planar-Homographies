% Q4.5
close all;
clear all;

img1 = imread('../data/pano_left.jpg');
img2 = imread('../data/pano_right.jpg');

[pt1, pt2] = matchPics(img1, img2);

[H2to1] = computeH_ransac(pt1, pt2);

% choose random points
count = 10;
[length, width] = size(img1);
x = randi(length, count,1);
y = randi(width, count,1);

random_pts1 = [x y];
pts1 = [random_pts1 ones(count,1)];

pts2 = pts1*H2to1;
pts2 = pts2./pts2(:,3);
pts2(:,3) = [];
random_pts2 = int16(pts2);

figure;
showMatchedFeatures(img1, img2, random_pts1, random_pts2, 'montage');
title('Showing all matches');


