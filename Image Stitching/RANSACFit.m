function H = RANSACFit(p1, p2, match, maxIter, seedSetSize, maxInlierError, goodFitThresh )
%RANSACFit Use RANSAC to find a robust affine transformation
% Input:
%   p1: N1 * 2 matrix, each row is a point
%   p2: N2 * 2 matrix, each row is a point
%   match: M * 2 matrix, each row represents a match [index of p1, index of p2]
%   maxIter: the number of iterations RANSAC will run
%   seedNum: The number of randomly-chosen seed points that we'll use to fit
%   our initial circle
%   maxInlierError: A match not in the seed set is considered an inlier if
%                   its error is less than maxInlierError. Error is
%                   measured as sum of Euclidean distance between transformed
%                   point1 and point2. You need to implement the
%                   ComputeCost function.
%
%   goodFitThresh: The threshold for deciding whether or not a model is
%                  good; for a model to be good, at least goodFitThresh
%                  non-seed points must be declared inliers.
%
% Output:
%   H: a robust estimation of affine transformation from p1 to p2
%
%
    N = size(match, 1);
    if N<3
        error('not enough matches to produce a transformation matrix')
    end
    if ~exist('maxIter', 'var')
        maxIter = 200;
    end
    if ~exist('seedSetSize', 'var')
        seedSetSize = ceil(0.2 * N);
    end
    seedSetSize = max(seedSetSize,3);
    if ~exist('maxInlierError', 'var')
        maxInlierError = 500;
    end
    if ~exist('goodFitThresh', 'var')
        goodFitThresh = floor(0.7 * N);
    end
    H = eye(3);
% Here you implement basic RANSAC algorithm to compute the transformation H.
% You may need ConputError function bellow.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 YOUR CODE HERE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_inlier = 0;

for i = 1: maxIter
    [seedSet,~] = part(match,seedSetSize);
    
    P1 = p1(seedSet(:,1),:);
    P2 = p2(seedSet(:,2),:);
    
    TMP = ComputeAffineMatrix(P1,P2);
    distsSet = ComputeError(TMP,p1,p2,match);
    [S,~] = size(distsSet);
    inlier_num = 0;
    inliers = [];
    for j = 1:S
        if distsSet(j,1) <= maxInlierError
            inlier_num = inlier_num + 1;
            inliers(inlier_num,:) = match(j,:);
        end
    end
    if inlier_num > max_inlier && inlier_num >= 3
        max_inlier = inlier_num;
        n1 = p1(inliers(:,1),:);
        n2 = p2(inliers(:,2),:);
        H = ComputeAffineMatrix(n1,n2);
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                             END OF YOUR CODE                                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sum(sum((H - eye(3)).^2)) == 0
        disp('No RANSAC fit was found.')
    end
    
end

function dists = ComputeError(H, pt1, pt2, match)
% Compute the error using transformation matrix H to
% transform the point in pt1 to its matching point in pt2.
%
% Input:
%   H: 3 x 3 transformation matrix where H * [x; y; 1] transforms the point
%      (x, y) from the coordinate system of pt1 to the coordinate system of
%      pt2.
%   pt1: N1 x 2 matrix where each ROW is a data point [x_i, y_i]
%   pt2: N2 x 2 matrix where each ROW is a data point [x_i, y_i]
%   match: M x 2 matrix, each row represents a match [index of pt1, index of pt2]
%
% Output:
%    dists: An M x 1 vector where dists(i) is the error of fitting the i-th
%           match to the given transformation matrix.
%           Error is measured as the Euclidean distance between (transformed pt1)
%           and pt2 in homogeneous coordinates.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE.                               %
%           Convert the points to a usable format, perform the                 %
%           transformation on pt1 points, and find their distance to their     %
%           MATCHING pt2 points.                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % hint: If you have an array of indices, MATLAB can directly use it to
    % index into another array. For example, pt1(match(:, 1),:) returns a
    % matrix whose first row is pt1(match(1,1),:), second row is
    % pt1(match(2,1),:), etc. (You may use 'for' loops if this is too
    % confusing, but understanding it will make your code simple and fast.)
    
    P1 = pt1(match(:,1),:);
    N1 = size(P1,1);
    P1 = [P1';ones(1,N1)];
    A = H * P1;
    P2 = pt2(match(:,2),:);
    N2 = size(P2,1);
    P2 = [P2';ones(1,N2)];
    dists(:,1) = sqrt((A(1,:) - P2(1,:)) .* (A(1,:) - P2(1,:)) ...
                    + (A(2,:) - P2(2,:)) .* (A(2,:) - P2(2,:)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if size(dists,1) ~= size(match,1) || size(dists,2) ~= 1
        error('wrong format');
    end
end

function [D1, D2] = part(D, splitSize)
    idx = randperm(size(D, 1));
    D1 = D(idx(1:splitSize), :);
    D2 = D(idx(splitSize+1:end), :);
end
