% Please put this file under the photoset folder
clear;clc;clf
% Parameter
k = 1;

% First get Source Vectors into Matrix S
% Modify the '28' if want to run on other set
raw_name = importdata('yaleB28_P00.info');
S = ones(64,3);
for i = 2:65
    S(i-1,1) = str2double(raw_name{i}(13:16));
    S(i-1,2) = str2double(raw_name{i}(18:20));
end
for i = 1:64
    [S(i,3),S(i,1),S(i,2)] = sph2cart(deg2rad(S(i,1)),deg2rad(S(i,2)),S(i,3));
end
V = k*S;

% Second get the Intensity Function Matrix
img = cell(1,64);
for i = 1:64
    img{i} = imread(raw_name{i+1});
end

% Using Least Square to get g(x,y)
g = cell(192,168);
for x = 1:192
    for y = 1:168
        I_vector = zeros(64,1);
        for j = 1:64
            I_vector(j) = img{j}(x,y);
        end
        %V_N * g = I_n
        g{x,y} = (transpose(V)*V) \ (transpose(V)*I_vector);
    end
end

% Then we can get the albedo and Norm Matrix
albedo = zeros(192,168);
N_x = zeros(192,168);
N_y = zeros(192,168);
N_z = zeros(192,168);
N = cell(192,168);
for x = 1:192
    for y = 1:168
        albedo(x,y) = norm(g{x,y});
        N_x(x,y) = g{x,y}(1)/albedo(x,y);
        N_y(x,y) = g{x,y}(2)/albedo(x,y);
        N_z(x,y) = g{x,y}(3)/albedo(x,y);
        N{x,y} = g{x,y}/albedo(x,y);
    end
end
figure(1);imshow(albedo,[]);
figure(2);S_x = subplot(1,3,1);imshow(N_x,[]);title('N_x');colormap(S_x,jet);colorbar;
figure(2);S_y = subplot(1,3,2);imshow(N_y,[]);title('N_y');colormap(S_y,jet);colorbar;
figure(2);S_z = subplot(1,3,3);imshow(N_z,[]);title('N_z');colormap(S_z,jet);colorbar;
figure(3);quiver3(surfnorm(N_x,N_y,N_z),N_x,N_y,N_z);

% Get the depth f(x,y)
f = zeros(192,168);
f_x = zeros(192,168);
f_y = zeros(192,168);
for x = 1:192
    for y = 1:168
        f_x(x,y) = g{x,y}(1)/g{x,y}(3);
        f_y(x,y) = g{x,y}(2)/g{x,y}(3);
    end
end

for x = 1:192
    for y = 1:168
        for i = 1:y
            f(x,y) = f(x,y) + f_x(1,i);
        end
        for j = 1:x
            f(x,y) = f(x,y) + f_y(j,y);
        end
        f(x,y) = f(x,y) - (f_x(1,y) + f_y(1,y))/2;
    end
end

 % For robust
for x = 1:192
    for y = 1:168
        for j = 1:x
            f(x,y) = f(x,y) + f_y(j,1);
        end
        for i = 1:y
            f(x,y) = f(x,y) + f_x(x,i);
        end
        f(x,y) = f(x,y) - (f_x(x,1)+f_y(x,1))/2;
        f(x,y) = f(x,y)/2;
    end
end

% plot the diagram
X = ones(1,192*168);
Y = ones(1,192*168);
Z = reshape(f,[1,192*168]);
C = reshape(albedo,[1,192*168]);
for y = 1:168
    for x = 1:192
        X(1,(y-1)*192+x) = y;
    end
end
for y = 1:168
    for x = 1:192
        Y(1,(y-1)*192+x) = x;
    end
end
figure(4);scatter3(X,Y,Z,1,C);colormap(gray);xlabel("x");ylabel("y");
