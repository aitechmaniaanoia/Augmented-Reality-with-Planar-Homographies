% Q3.3.1
%close all;
%clear all;

%ar_source = loadVid('../data/ar_source.mov');
%book = loadVid('../data/book.mov');
img_cover = imread('../data/cv_cover.jpg');
video = ar_source;

frame = size(ar_source,2);
imgs = zeros(frame, 480, 640, 3 );

%i = 45;
% for loop each frame
for i = 1: 20 %frame
img_ar = ar_source(i).cdata;
img_desk = book(i).cdata;

%% Extract features and match
[locs1, locs2] = matchPics(img_cover, img_desk);

%% Compute homography using RANSAC
%[bestH2to1,inliers, ransac_p1, ransac_p2] = computeH_ransac(locs1, locs2);
[bestH2to1] = computeH_norm(locs1, locs2);

% index = [];
% for k = 1:size(inliers,1)
%     if inliers(k) == 1
%         index = [index k];
%     end
% end
% inlier_p1 = [locs1(index,:); ransac_p1];
% inlier_p2 = [locs2(index,:); ransac_p2];
% 
% figure;
% showMatchedFeatures(img_cover, img_desk, inlier_p1, inlier_p2, 'montage');
% title('Showing all inliers using RANSAC');

%% Scale harry potter image to template size
crop_size = int16((size(img_ar,2) - size(img_cover,2))/2);
img_ar = img_ar(:,crop_size:end-crop_size,:);
scaled_img = imresize(img_ar, [size(img_cover,1) size(img_cover,2)]);
%% Display warped image.
%imshow(warpH(scaled_img, inv(bestH2to1), size(img_desk)));
%% Display composite image
new_img = compositeH(inv(bestH2to1), scaled_img, img_desk);
%imshow(compositeH(inv(bestH2to1), scaled_img, img_desk));
imgs(j,:,:,:) = new_img;
disp(i);
end
disp('start save video');

%% save video
writerobj = VideoWriter('ar.avi'); 
writerobj.FrameRate = 10;

open(writerobj);
for j = 1:20  %frame
    img = imgs(j,:,:,:);
    img = reshape(img, size(img,2),size(img,3),size(img,4));
    writeVideo(writerobj,img);
end
close(writerobj);


