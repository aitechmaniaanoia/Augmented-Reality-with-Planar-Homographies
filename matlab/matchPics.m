function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!
%% Convert images to grayscale, if necessary
if size(I1,3)==3
    I1 = rgb2gray(I1); % 440*350
end
if size(I2,3)==3
    I2 = rgb2gray(I2); % 548*731
end
%% Detect features in both images
 features1 = detectFASTFeatures(I1); % 588*1 [location metric]
 features2 = detectFASTFeatures(I2); % 295*1 [location metric]
%% Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(I1, features1.Location); %576
[desc2, locs2] = computeBrief(I2, features2.Location); %294
%% Match features using the descriptors
threshold = 10;
%indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', threshold, 'MaxRatio', 0.68); 
indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10, 'MaxRatio', 0.68);  % for AR

locs1 = locs1(indexPairs(:,1),:);
locs2 = locs2(indexPairs(:,2),:);
end