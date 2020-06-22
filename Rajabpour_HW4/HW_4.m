% % ------- Convex Optimization -------
% % ---------- Homework 4 -----------
% % ------- Mohsen Rajabpour -------

clear all
close all
clc

%%% For this problem, we need to check the optimization problem by two
%%% different images. Hence, it is needed to set two images seperatly by
%%% the command below.

I = imread('Apple.jpg');
I = imresize(I, .3);
imshow(I);
I = double(I);

count = 1;

for ite_O = 1:2
    
    [x,y] = ginput(2);
    x = floor(x);
    y = floor(y);
    
    for i = min(y):max(y)
        for j = min(x):max(x)
            
            Object(count, :) = [i j I(i, j, 1) I(i, j, 2) I(i, j, 3)];
            count = count + 1;
            
        end
    end
    
end

count = 1;
imshow(uint8(I));

for ite_B = 1:4
    
    [x_B,y_B] = (ginput(2));
    x_B = floor(x_B);
    y_B = floor(y_B);
    
    for m = min(y_B):max(y_B)
        for n = min(x_B):max(x_B)
            
            Background(count, :) = [m n I(m, n, 1) I(m, n, 2) I(m, n, 3)];
            count = count + 1;
            
        end
    end
    
end

T_1 = size(Object, 1);
T_2 = size(Background, 1);
T_3 = size(Object, 2);

cvx_begin

        variables u(T_1) v(T_2) a(T_3) b(1)
        minimize ( norm(a, 2) + 10*( sum(u) + sum(v) ) )
        subject to
        Object*a     + b*ones(T_1, 1) >=    ones(T_1, 1) - u
        Background*a + b*ones(T_2, 1) <= -( ones(T_2, 1) - v )
        u >= 0
        v >= 0
        
cvx_end

I = double(I);
S_1 = size(I, 1);
S_2 = size(I, 2);

for i = 1:S_1
    for j = 1:S_2
        
        black_white(i,j) = [i j I(i, j, 1) I(i, j, 2) I(i, j, 3)]*a + b;
        
    end
end

I = uint8(I);

Black_White = black_white >= 0;
figure
imshow( Black_White(:, :, 1) )

I_th = zeros( size(I) );
I_th(:, :, 1) = I(:, :, 1) < 150;
I_th(:, :, 2) = I(:, :, 2) < 50;
I_th(:, :, 3) = I(:, :, 3) < 100;
figure
imshow(I_th)

n = 1:2000;
figure
scatter3 (Object(n,3), Object(n,4), Object(n,5))
hold on 
scatter3 (Background(n,3), Background(n,4), Background(n,5))
[x_axis, y_axis] = meshgrid(0:200:255, 0:200:255);
Z = ( -b - a(3)*x_axis - a(4)*y_axis) ./ a(5);
surface(x_axis, y_axis, Z)