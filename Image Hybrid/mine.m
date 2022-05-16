% under data file
clc;clear;close;
im1 = imread('einstein.bmp');
im2 = imread('marilyn.bmp');
% einstein & marilyn => [10 10] 15
% dog & cat => [27 27] 27
% Do some ps
kernel = fspecial('Gaussian', [11 11], 15);

figure(1);subplot(1,2,1);imshow(im1);
figure(2);subplot(1,2,1);imshow(im2);
im1 = double(im1);
im2 = double(im2);

blur = zeros(size(im1));
for i = 1:3
    blur(:,:,i) = my_conv(im1(:,:,i),kernel);
end
blur = uint8(blur);
figure(1);subplot(1,2,2);imshow(blur);

appr = zeros(size(im2));
for i = 1:3
    appr(:,:,i) = im2(:,:,i) - my_conv(im2(:,:,i),kernel);
end
appr = uint8(appr);
figure(2);subplot(1,2,2);imshow(appr);

hybird = uint8(zeros(size(im1)));
for i = 1:3
    hybird(:,:,i) = blur(:,:,i) + appr(:,:,i);
end
figure(3);imshow(hybird);

% mirror
function re = my_conv(img,kernel)
    [i_r,i_c] = size(img);
    [k_r,k_c] = size(kernel);
    c_r = floor(k_r/2);
    c_c = floor(k_c/2);
    new_matrix = zeros((i_r + c_r),(i_c + c_c));
    re = zeros(i_r,i_c);
    % Four corners
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(c_r - r + 1,c_c - c + 1) = img(r,c);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(i_r + r,c_c - c + 1) = img(i_r - r + 1,c);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(c_r - r + 1,i_c + c) = img(r,i_c - c + 1);
        end
    end
    for r = 1: c_r
        for c = 1:c_c
            new_matrix(i_r + r,i_c + c) = img(i_r - r,i_c - c);
        end
    end
    % Four edges
    for r = 1:c_r
        for c = c_c + 1 : c_c + i_c
            new_matrix(r,c) = img(c_r - r + 1,c - c_c);
        end
    end
    for r = 1:c_r
        for c = c_c + 1 : c_c + i_c
            new_matrix(r + c_r + i_r,c) = img(i_r - r + 1,c - c_c);
        end
    end
    for r = c_r + 1:c_r + i_r
        for c = 1:c_c
            new_matrix(r,c) = img(r - c_r,c_c - c + 1);
        end
    end
    for r = c_r + 1:c_r + i_r
        for c = 1:c_c
            new_matrix(r,c + c_c + i_c) = img(r - c_r,i_c - c + 1);
        end
    end
    % Middle
    for r = 1:i_r
        for c = 1:i_c
            new_matrix(c_r + r,c_c + c) = img(r,c);
        end
    end
    % Upsidedown Kernel
    new_kernel = zeros(k_r,k_c);
    for r = 1:k_r
        for c = 1:k_c
            new_kernel(r,c) = kernel(k_r + 1 -r,k_c + 1 - c);
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
            re(r - c_r,c - c_c) = tmp;
        end
    end

end

