% test computeH Compute_normH and RANSAC
close all;
clear all;

img1 = imread('../data/cv_cover.jpg');
img2 = imread('../data/cv_desk.png');

%img1 = imread('../data/pano_left.jpg');
%img2 = imread('../data/pano_right.jpg');

[pt1, pt2] = matchPics(img1, img2);

%[H2to1] = computeH(pt1, pt2);
%[H2to1] = computeH_norm(pt1, pt2);
[H2to1, inliers, ransac_p1, ransac_p2] = computeH_ransac(pt1, pt2);

% choose random points
count = 15;
[length, width,~] = size(img2);
x = randi(length, count,1);
y = randi(width, count,1);

random_pts2 = [x y];
pts2 = [random_pts2 ones(count,1)];

pts1 = (H2to1*pts2.').';
pts1 = pts1./pts1(:,3);
pts1(:,3) = [];
random_pts1 = int16(pts1);

%figure;
%showMatchedFeatures(img1, img2, random_pts1, random_pts2, 'montage');
%title('Showing all matches');

%% ransac

%inlier_p1 = pt1(inliers==1);
%inlier_p2 = pt2(inliers==1);

index = [];
for k = 1:size(inliers,1)
    if inliers(k) == 1
        index = [index k];
    end
end
inlier_p1 = [pt1(index,:); ransac_p1];
inlier_p2 = [pt2(index,:); ransac_p2];

figure;
showMatchedFeatures(img1, img2, ransac_p1, ransac_p2, 'montage');
title('Showing points pairs with most inliers in RANSAC');

figure;
showMatchedFeatures(img1, img2, inlier_p1, inlier_p2, 'montage');
title('Showing all inliers using RANSAC');
