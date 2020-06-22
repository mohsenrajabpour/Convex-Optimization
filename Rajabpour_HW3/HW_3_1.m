                % % ------- Convex Optimization -------
                % % ------- Homework 3, Problem 1 -------
                % % ------- Mohsen Rajabpour -------

clear all
close all
clc

I = imread('cguitar.tif');

m = 50;  % Column
n = 250; % Row

Corrupted_Image_Upper_left = I(1:n, 1:m);
e_c_up = Corrupted_Image_Upper_left;
e_c_up = double(e_c_up);

True_Image_Upper_left = 250 * ones(n, m);
e_up = True_Image_Upper_left;

    cvx_begin

            variable a
            variable b
            variable c

            for i = 1:250
                for j = 1:50
                    r(i, j) = a*i + b*j + c;
                end
            end
            
            minimize( norm( e_up .* r - e_c_up, 2 ) )
            subject to
                r <= 1
                r >= 0

    cvx_end

for i = 1:511
    for j = 1:205
        r(i, j) = a*i + b*j + c;
    end
end

Corrupted_Image = double(I);
True_Image = Corrupted_Image ./ r;
Y = uint8(True_Image);

subplot(1, 2, 1)
imshow (I)
title('Corrupted Image');
subplot(1, 2, 2)
imshow(Y)
title('True Image');
