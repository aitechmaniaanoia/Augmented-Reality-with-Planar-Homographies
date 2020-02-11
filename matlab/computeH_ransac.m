function [ bestH2to1, inliers, pt1, pt2] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
n = 0;
count = 4;
len = size(locs1,1);
%iters = 10000;
%tolerance = 71400;
iters = 50000; % for AR
tolerance = 750000;

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
        R = p2(j,:) * H * p1(j,:).';
        
        lines1 = H * p2(j,:).';
        lines2 = p1(j,:) * H;
        
        SED_2 = R.^2/(lines1(1).^2 + lines1(2).^2) + R.^2/(lines2(1).^2 + lines2(2).^2);
        %disp(SED_2);
        
        if SED_2 < tolerance
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
        [bestH2to1] = computeH_norm(inp1, inp2);
    end
end
%Q2.2.3
end

