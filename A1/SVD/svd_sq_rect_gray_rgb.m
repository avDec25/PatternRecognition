%SVD for rectangular and square image

image = imread('24_square.jpg');
image = rgb2gray(image);
A = im2double(image);

%A = im2double(image(:,:,3));

[U,D] = eig(A*A');
Vin = inv(sqrt(D))*inv(U)*A;
[M,N] = size(A);
D1 =zeros(M,N);
Z = zeros(M,N);

eigen_value = zeros(1,M);
error = zeros(1,M);

k=1;
%remove this for random N
 
for i =[5:50:M]
%i=75; %remove this line for iterative version, use it only for specific
      % number of eigen values
D1 = D;
    for j =[1:1:M-i]
        D1(j,j) = 0;
    end

%{
remove from this for top N
for i=[1:1:2]
    Rnd = randi([0 1],1,M);
    D1 = D;
    for j =[1:1:M]
        D1(j,j) = D1(j,j)* Rnd(1,j);
    end
%remove till here for manual
%}
    newimg = U*sqrt(D1)*Vin;
    subplot(1,4,k);
    imshow(cat(3,Z,Z,newimg));
    title(['Reconstructed with ' num2str(i) ' singular values']);  
    %use this for manual
    %title('Random singular values reconstruction');
    subplot(1,4,k+1);
    imshow(A - newimg);
    title(['Error image with ' num2str(i) ' singular values']);
    %title('Error ');
    B = (A - newimg).^2;
    S = sum(sum(B));
    eigen_value(i) = i;
    error(i) = S;
    k=k+2;
end

i = (error == 0);
error(i) = [];
eigen_value(i) = [];
%plot(eigen_value,error);



    


