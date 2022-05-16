function [matches] = match(sift1, sift2)
%match - This function matches two buntches of SIFT features by seeking the nearest neighbor of each feature.
%Consulted material:
%[1] - http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf
%in [1] it is recommended also to take into account the second nearest neighbour and ignore it if the distance is more than 0.8 between these two neighbours
% INPUT: 
% SIFT feature of the first image: sift1[128*n]
% SIFT feature of the second image: sift2[128*m]
% n may or may not equal to m
% OUTPUT:
% matches: M * 2 matrix, each row represents a match [index of p1, index of p2]

%
% Syntax: matches = match(sift1, sift2)
%

inlier = 30;

count = 0;
[~,col1] = size(sift1);
[~,col2] = size(sift2);
    for i = 1:col1
        f_min = inlier;
        s_min = inlier;
        flag = 0;
        i_min = 0;
        i_smin = 0;
        j_min = 0;
        j_smin = 0;
        for j = 1:col2
            v = double(sift1(:,i) - sift2(:,j));
            v = v.*v;
            tmp = sqrt(v);            
            if tmp < f_min
                flag = 1;
                f_min = tmp;
                i_min = i;
                j_min = j;
            elseif tmp < s_min
                s_min = tmp;
                i_smin = i;
                j_smin = j;
            end
        end
        if flag == 1
            ratio = sqrt((i - i_min).^2 + (j - j_min).^2)/sqrt((i - i_smin).^2 + (j - j_smin).^2);
            if ratio <= 0.8
                count = count + 1;
                matches(count,1) = i_min;
                matches(count,2) = j_min;
            end
        end
    end
end