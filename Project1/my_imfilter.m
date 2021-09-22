function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
[k_r,k_c] = size(filter);
[i_r,i_c] = size(image(:,:,1));
output = zeros(i_r,i_c,3);
c_r = floor(k_r/2);
c_c = floor(k_c/2);
% Upsidedown Kernel
new_kernel = zeros(k_r,k_c);
for r = 1:k_r
    for c = 1:k_c
        new_kernel(r,c) = filter(k_r + 1 - r,k_c + 1 - c);
    end
end

for im = 1:3
    % mirror
    new_matrix = zeros((i_r + c_r),(i_c + c_c));
    % Four corners
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(c_r - r + 1,c_c - c + 1) = image(r,c,im);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(i_r + r,c_c - c + 1) = image(i_r - r + 1,c,im);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(c_r - r + 1,i_c + c) = image(r,i_c - c + 1,im);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(i_r + r,i_c + c) = image(i_r - r,i_c - c,im);
        end
    end
    % Four edges
    for r = 1:c_r
        for c = c_c + 1 : c_c + i_c
            new_matrix(r,c) = image(c_r - r + 1,c - c_c,im);
        end
    end
    for r = 1:c_r
        for c = c_c + 1 : c_c + i_c
            new_matrix(r + c_r + i_r,c) = image(i_r - r + 1,c - c_c,im);
        end
    end
    for r = c_r + 1:c_r + i_r
        for c = 1:c_c
            new_matrix(r,c) = image(r - c_r,c_c - c + 1,im);
        end
    end
    for r = c_r + 1:c_r + i_r
        for c = 1:c_c
            new_matrix(r,c + c_c + i_c) = image(r - c_r,i_c - c + 1,im);
        end
    end
    % Middle
    for r = 1:i_r
        for c = 1:i_c
            new_matrix(c_r + r,c_c + c) = image(r,c,im);
        end
    end
    % Convolution
    for r = 1 + c_r:i_r + c_r
        for c = 1 + c_c:i_c + c_c
            tmp = 0;
            for i = 1:k_r
                for j = 1:k_c
                    tmp = tmp + new_matrix(r - c_r + i - 1,c - c_c + j - 1).*new_kernel(i,j);
                end
            end
            output(r - c_r,c - c_c,im) = tmp;
        end
    end
end




