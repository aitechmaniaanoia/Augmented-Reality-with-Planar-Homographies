function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
H_template_to_img = inv(H2to1);

%% Create mask of same size as template
[length, width,~] = size(template);
mask = ones(length, width);
%% Warp mask by appropriate homography
%[length1, width1,~] = size(img);
warp_mask1 = warpH(mask, H2to1, size(img));
warp_mask = zeros(size(img));
for i = 1:size(img,3)
    warp_mask(:,:,i) = warp_mask1;
end
%% Warp template by appropriate homography
warp_template = warpH(template, H2to1, size(img));
%% Use mask to combine the warped template and the image
%composite_img = zeros(size(img));
composite_img = img;
%for i = 1:size(img,3)
%composite_img(warp_mask==1) = 0;
composite_img(warp_mask~=0) = warp_template(warp_mask~=0);
%composite_img(warp_mask==0) = img(warp_mask==0);
    
%    composite_img(:,:,i) = com_img;
%end
end