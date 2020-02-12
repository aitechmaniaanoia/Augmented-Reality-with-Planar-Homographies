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
 
 f_1 = detectSURFFeatures(I1);   % SURF
 f_2 = detectSURFFeatures(I2);   % SURF
%% Obtain descriptors for the computed feature locations
[features_1, locs_1] = extractFeatures(I1, f_1, 'Method', 'SURF');   % SURF
[features_2, locs_2] = extractFeatures(I2, f_2, 'Method', 'SURF'); % SURF

[desc1, locs1] = computeBrief(I1, features1.Location); %576
[desc2, locs2] = computeBrief(I2, features2.Location); %294
%% Match features using the descriptors
threshold = 10;
%indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', threshold, 'MaxRatio', 0.68); 
%indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10, 'MaxRatio', 0.75);  % for AR
indexPairs = matchFeatures(features_1, features_2, 'MatchThreshold', 10,'MaxRatio', 0.4); % SURF

locs1 = double(int16(locs_1(indexPairs(:,1),:).Location)); % SURF
locs2 = double(int16(locs_2(indexPairs(:,2),:).Location));

%locs1 = locs1(indexPairs(:,1),:); %FAST
%locs2 = locs2(indexPairs(:,2),:);
end