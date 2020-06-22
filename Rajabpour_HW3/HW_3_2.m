                % % ------- Convex Optimization -------
                % % ------- Homework 3, Problem 2 -------
                % % ------- Mohsen Rajabpour -------

clear all
close all
clc


n = 4;
% % % % % % I = imread('curved_river.jpg');
% % % % % % image (I)
% % % % % % [x, y] = ginput(320);
load('matlab.mat') % This data set is collected through three lines above. It is stored to save time.
x = data(:, 1)';
y = data(:, 2)';

N_Sections = 160;
M = length(y)/N_Sections;

for i = 1: N_Sections
    u(i, :) = x(M*(i-1)+1:i*M);
    m(i) = length( u(i, :) );
end
for i = 1: N_Sections
    v(i, :) = y(M*(i-1)+1:i*M);
    mm(i) = length( v(i, :) );
end

for i = 1: N_Sections
    for j = 1:M
        A(M*(i-1)+j, :) = [1  u(i, j)  u(i, j)^2  u(i, j)^3 ];
    end
end
for i = 1: N_Sections
    for j = 1:M
        B(M*(i-1)+j, :) = [1  v(i, j)  v(i, j)^2  v(i, j)^3 ];
    end
end

cvx_begin
        variables t(n, N_Sections) tt(n, N_Sections)

        for i = 1: N_Sections
            AA(:, i) = A(M*(i-1)+1:i*M,:)*t(:, i);
        end
        AA = reshape(AA, length(x), 1);
        
        for i = 1: N_Sections
            BB(:, i) = B(M*(i-1)+1:i*M,:)*tt(:, i);
        end
        BB = reshape(BB, length(x), 1);
        
        minimize ( norm( [AA BB]- [x' y'], 2))

        subject to
        for i = 1: N_Sections-1
            [1 u(i, end) u(i, end)^2   u(i, end)^3]*t(:, i) == [1 u(i, end) u(i, end)^2   u(i, end)^3]*t(:, i+1);
            [0  1  2*u(i, end)  3*u(i, end)^2]*t(:, i) == [0  1  2*u(i, end)  3*u(i, end)^2]*t(:, i+1);
            [0  0   2  6*u(i, end)]*t(:, i) == [0  0   2  6*u(i, end)]*t(:, i+1);
        end
        
        for i = 1: N_Sections-1
            [1 v(i, end) v(i, end)^2   v(i, end)^3]*tt(:, i) == [1 v(i, end) v(i, end)^2   v(i, end)^3]*tt(:, i+1);
            [0  1  2*v(i, end)  3*v(i, end)^2]*tt(:, i) == [0  1  2*v(i, end)  3*v(i, end)^2]*tt(:, i+1);
            [0  0   2  6*v(i, end)]*tt(:, i) == [0  0   2  6*v(i, end)]*tt(:, i+1);
        end
cvx_end

for i = 1: N_Sections
    us(:, i) = linspace(u(i, 1),u(i, end),1000)';
    p(:, i) = t(1, i) + t(2, i)*us(:, i) + t(3, i)*us(:, i).^2 + t(4, i)*us(:, i).^3;
end
for i = 1: N_Sections
    vs(:, i) = linspace(v(i, 1),v(i, end),1000)';
    q(:, i) = tt(1, i) + tt(2, i).*vs(:, i) + tt(3, i).*vs(:, i).^2 + tt(4, i).*vs(:, i).^3;
end

p = reshape(p, N_Sections*1000, 1);
q = reshape(q, N_Sections*1000, 1);

plot(p, q, 'b-','LineWidth', 2)
hold on
plot(x, y,'ro')
grid on
title(['Approximation Using Spline Fitting, # of Sections:' num2str(N_Sections) ])
xlabel('x');
ylabel('f(x)');
legend('L_2 norm', 'Data points', 'Location', 'Best');


