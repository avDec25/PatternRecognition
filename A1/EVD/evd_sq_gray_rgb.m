image = imread('24_square.jpg');
im = rgb2gray(image);


%A = im2double(image(:,:,1));
A = im2double(im);
[X,D]=eig(A);
[M,N] = size(A);
Z = zeros(M,N)
x_eigen = zeros(1,M);
y_error = zeros(1,M);

k=1;

for i =[1:1:M]
    D1 = zeros(M,N);
for j=[1:1:i]
    D1(j,j) = D(j,j); 
end
    Y = inv(X);
    newimage = X*D1*Y;
    %{
    subplot(2,4,k)
    imshow(cat(3,Z,Z,newimage));
    title(['Reconstructed with ' num2str(i) ' eigen values']);
    subplot(2,4,k+1)
    imshow(A-newimage);
    title(['Error for ' num2str(i) ' eigen values']);
    %}
    C = ((A) - (newimage)).^2;
    error = sqrt(sum(sum(C)));
    x_eigen(1,i) = i;
    y_error(1,i) = error;
k=k+2;
end

i = (x_eigen == 0);
y_error(i) = [];
x_eigen(i) = [];
plot(x_eigen,y_error);


%{
for i =[1:1:2]
    Rnd = randi([0 1],1,M);
    D1 = D;
    for j =[1:1:M]
        D1(j,j) = D1(j,j)* Rnd(1,j);
    end
    Y = inv(X);
    newimage = X*D1*Y;
    
    subplot(1,4,k)
    imshow(newimage);
    title('Reconstructed with random eigen values');
    subplot(1,4,k+1)
    imshow(A-newimage);
    title('Error image');
    
    
k=k+2;
end
%}

