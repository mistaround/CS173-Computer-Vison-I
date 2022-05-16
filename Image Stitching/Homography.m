function H = Homography(Pt1,Pt2)
%Compute Homographt Matrix
%   Computes the transformation matrix that transforms a point from
%   coordinate frame 1 to coordinate frame 2
%Input:
%   Pt1: N * 2 matrix, each row is a point in image 1
%       (N must be at least 3)
%   Pt2: N * 2 matrix, each row is the point in image 2 that
%       matches the same point in image 1 (N should be more than 3)
%Output:
%   H: 3 * 3 affine transformation matrix,
%       such that H*pt1(i,:) = pt2(i,:)

    N = size(Pt1,1);
    if size(Pt1, 1) ~= size(Pt2, 1)
        error('Dimensions unmatched.');
    elseif N<4
        error('At least 4 points are required.');
    end

    A = zeros(N*2,9);
    j = 1;
    for i = 1:N
        A(j,4) = Pt1(i,1);
        A(j,5) = Pt1(i,2);
        A(j,6) = 1;
        A(j,7) = -Pt2(i,2)*Pt1(i,1);
        A(j,8) = -Pt2(i,2)*Pt1(i,2);
        A(j,9) = -Pt2(i,2);       
        j = j + 1;
        A(j,1) = Pt1(i,1);
        A(j,2) = Pt1(i,2);
        A(j,3) = 1;
        A(j,7) = -Pt2(i,1)*Pt1(i,1);
        A(j,8) = -Pt2(i,1)*Pt1(i,2);
        A(j,9) = -Pt2(i,1); 
        j = j + 1;
    end
    [V,v] = eig(A'*A);
    [~,ind] = min(diag(v));
    H = V(:,ind);
    H = reshape(H,3,3)';
end

