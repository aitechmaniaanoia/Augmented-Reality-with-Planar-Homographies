function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = [mean(x1(:,1)) mean(x1(:,2))];
centroid2 = [mean(x2(:,1)) mean(x2(:,2))];

%% Shift the origin of the points to the centroid
std1 = mean(sqrt((x1(:,1) - centroid1(1)).^2 + (x1(:,2) - centroid1(2)).^2));
std2 = mean(sqrt((x2(:,1) - centroid2(1)).^2 + (x2(:,2) - centroid2(2)).^2));

scale1 = sqrt(2)/std1;
scale2 = sqrt(2)/std2;

translate_1 = [-scale1*centroid1(1) -scale1*centroid1(2)];
translate_2 = [-scale2*centroid2(1) -scale2*centroid2(2)];

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
%% similarity transform 1
T1 = [scale1 0 translate_1(1);
      0 scale1 translate_1(2);
      0 0 1];

%% similarity transform 2
T2 = [scale2 0 translate_2(1);
      0 scale2 translate_2(2);
      0 0 1];

%% Compute Homography
len = size(x1,1);
% add one column become [x y 1] and change shape to 3*N
x1 = [x1 ones(len,1)].';
x2 = [x2 ones(len,1)].';

x1_norm = T1*x1;
x2_norm = T2*x2;

%x1_norm = x1*scale1 + translate_1;
%x2_norm = x2*scale2 + translate_2;

% build matrix A
A = [];
for i = 1:len
    %a = [-x1_norm(1,i) -x1_norm(2,i) -1 0 0 0 x1_norm(1,i)*x2_norm(1,i) x1_norm(2,i)*x1_norm(1,i) x2_norm(1,i);
    %     0 0 0 -x1_norm(1,i) -x1_norm(2,i) -1 x1_norm(1,i)*x2_norm(2,i) x1_norm(2,i)*x2_norm(2,i) x2_norm(2,i)];
    a = [-x2_norm(1,i) -x2_norm(2,i) -1 0 0 0 x2_norm(1,i)*x1_norm(1,i) x2_norm(2,i)*x2_norm(1,i) x1_norm(1,i);
         0 0 0 -x2_norm(1,i) -x2_norm(2,i) -1 x2_norm(1,i)*x1_norm(2,i) x2_norm(2,i)*x1_norm(2,i) x1_norm(2,i)];

    A = [A; a];
end

% svd of A
[~,~,V] = svd(A);

%H = V(:,end);
%H2to1 = reshape(H,3,3);
H2to1 = [V(1, 9) V(2, 9) V(3, 9);
         V(4, 9) V(5, 9) V(6, 9); 
         V(7, 9) V(8, 9) V(9, 9)];
%[u, s, v] = svd(H2to1);
%H2to1 = u(:, 1) * s(1,1) * v(:, 1).' + u(:, 2) * s(2,2) * v(:, 2).';
%% Denormalization
H2to1 = T1\H2to1*T2;
H2to1 = H2to1/H2to1(3,3);
