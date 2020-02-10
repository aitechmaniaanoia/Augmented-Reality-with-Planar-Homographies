function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
n = 0;
iters = 100;
count = 4;
len = size(locs1,1);
for i = 1:iters
    idx = randi(len, count,1);
    pt1 = locs1(idx, :);
    pt2 = locs2(idx,:);
    
    H = computeH_norm(pt1,pt2);
    
    % compute the number of inliers
    n_i = 0;
    tolerance = 50;
    
    inliers = zeros(count,1);
    
    p1 = [locs1 ones(count,1)].';
    p2 = [locs2 ones(count,1)].';
    
    for j = 1:count
        % calculate error
        R = p2(j) * H * p1.';
        
        lines1 = H * p2(j,:).';
        lines2 = p1(j,:) * H;
        
        SED_2 = R.^2/(lines1(1).^2 + lines1(2).^2) + R.^2/(lines2(1).^2 + lines2(2).^2);
        
        if SED_2 < tolerance
            n_i = n_i + 1;
            inliers(i) = 1;
        end
    end
    
    if n_i > n
        n = n_i;
        idx = inliers(inliers==1);
        bestH2to1 = comupteH_norm(pt1(idx,:), pt2(idx,:));
    end
end
%Q2.2.3
end

