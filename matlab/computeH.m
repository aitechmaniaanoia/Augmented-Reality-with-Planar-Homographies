function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
len = size(x1,1);
% add one column become [x y 1] and change shape to 3*N
x1 = [x1 ones(len,1)].';
x2 = [x2 ones(len,1)].';
% build matrix A [x*x', x*y', x, y*x', y*y', y, x', y', 1]
%A = zeros(len, 9);
A = [];
for i = 1:len
    %A = [A ;x1(1,i)*x2(1,i) x1(1,i)*x2(2,i) x1(1,i) x1(2,i)*x2(1,i) x1(2,i)*x2(2,i) x1(2,i) x2(1,i) x2(2,i) 1];
    a = [-x1(1,i) -x1(2,i) -1 0 0 0 x1(1,i)*x2(1,i) x1(2,i)*x1(1,i) x2(1,i);
         0 0 0 -x1(1,i) -x1(2,i) -1 x1(1,i)*x2(2,i) x1(2,i)*x2(2,i) x2(2,i)];
    A = [A; a];
end
% svd of A
[~,~,V] = svd(A);

H = V(:,end);
H2to1 = reshape(H,3,3);
H2to1 = H2to1/H2to1(3,3);

end
