% Your solution to Q2.1.5 goes here!
close all;
clear all;
%% Read the image and convert to grayscale, if necessary
I = imread('../data/cv_cover.jpg');

if size(I,3)==3
    I = rgb2gray(I); % 440*350
end
hist1 = [];
hist2 = [];
%% Compute the features and descriptors
for i = 0:36
    %% Rotate image
    I_R = imrotate(I, i*10);
    %% Compute features and descriptors
    features1 = detectFASTFeatures(I);   % BRIEF
    features2 = detectFASTFeatures(I_R); % BRIEF
       
    f_1 = detectSURFFeatures(I);   % SURF
    f_2 = detectSURFFeatures(I_R); % SURF
    
    [desc1, locs1] = computeBrief(I, features1.Location);   % BRIEF
    [desc2, locs2] = computeBrief(I_R, features2.Location); % BRIEF
    
    [features_1, valid_points1] = extractFeatures(I, f_1, 'Method', 'SURF');   % SURF
    [features_2, valid_points2] = extractFeatures(I_R, f_2, 'Method', 'SURF'); % SURF
    %% Match features
    indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10); % BRIEF
    indexPairs1 = matchFeatures(features_1, features_2, 'MatchThreshold', 10); % SURF
    %% Update histogram
    hist1 = [hist1,size(indexPairs,1)]; % BRIEF
    hist2 = [hist2,size(indexPairs1,1)]; % SURF
end

%% Display histogram
x = 0:10:360;
figure;
histogram(hist1,x);
title('Histogram of the count of matches using BRIEF descriptor');

figure;
histogram(hist2,x);
title('Histogram of the count of matches using SURF descriptor');