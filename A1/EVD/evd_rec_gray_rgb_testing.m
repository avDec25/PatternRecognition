image = imread('13.jpg');
im = rgb2gray(image);
A = im2double(im);
%A = im2double(image(:,:,1));
B = A'*A;

[M, N] = size(B);
[X,D]=eig(B);
x_eigen = zeros(1,M);
y_error = zeros(1,M);
Y = inv(X);
[M1,N1] = size(A);
Z = zeros(M1,N1);

for i=[1:10:M]
    
    D1 = D;
    for j=[i+1:1:M]
        D1(j,j) = 0;
    end
    %{
    %this is for random assignment
    for i=[1:1:2]
    Rnd = randi([0 1],1,M);
    D1 = D;
    for j =[1:1:M]
        D1(j,j) = D1(j,j)* Rnd(1,j);
    end
    %}
    newimage = pinv(A')*X*D1*Y;
    imshow(newimage)
    C = (A-newimage).^2;
    %imshow(newimage);
    error = sqrt(sum(sum(C)));
    x_eigen(1,i) = i;
    y_error(1,i) = error;
end

i = (x_eigen == 0);
y_error(i) = [];
x_eigen(i) = [];
plot(x_eigen,y_error);

