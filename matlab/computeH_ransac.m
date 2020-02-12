function [ bestH2to1, inliers, pt1, pt2] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
n = 0;
count = 4;
len = size(locs1,1);

%e = 0.9; % outlirt ratio
e = 0.9;
iters = int16(log(1-0.99)/log(1-(1-e).^4));
%tolerance = 50; % for image
tolerance = 3; % for AR

for i = 1:iters
    idx = randperm(len, count);
    pt1 = locs1(idx, :);
    pt2 = locs2(idx,:);
    
    H = computeH_norm(pt1,pt2);
    %H = computeH(pt1,pt2);
    
    % compute the number of inliers
    n_i = 0;
    
    inliers = zeros(len,1);
    
    p1 = [locs1 ones(len,1)]; %[N 3]
    p2 = [locs2 ones(len,1)];
    
    for j = 1:len
        % calculate error
        %R = p1(j,:) * H * p2(j,:).';
        %disp(R)
        lines1 = H * p2(j,:).';
        %lines2 = p1(j,:) * H.';
        
        lines1 = lines1/lines1(3);
        %lines2 = lines2/lines2(3);
        
        %SED = sqrt(R.^2/(lines1(1).^2 + lines1(2).^2) + R.^2/(lines2(1).^2 + lines2(2).^2));
        D = sqrt((lines1(1) - p1(j,1)).^2 + (lines1(2) - p2(j,2)).^2);
        %disp(D);
        
        if D < tolerance
            n_i = n_i + 1;
            inliers(j) = 1;
        end
    end
    
    if n_i > n
        n = n_i;
        %idx = (inliers==1);
        index = [];
        for k = 1:size(inliers,1)
            if inliers(k) == 1
                index = [index k];
            end
        end
        %bestH2to1 = comupteH_norm(pt1(idx,:), pt2(idx,:));
        inp1 = locs1(index,:);
        inp2 = locs2(index,:);
        bestH = H;
    %else
    %    inp1 = pt1;
    %    inp2 = pt2;
        %[bestH2to1] = computeH_norm(inp1, inp2); % for hp
    end
    %[bestH2to1] = computeH_norm(inp1, inp2);
end
bestH2to1 = bestH;
end

