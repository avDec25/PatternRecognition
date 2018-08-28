
image = imread('24_rectangle.jpg');
Ar= double(image(:,:,1));
Ag= double(image(:,:,2));
Ab= double(image(:,:,3));
[M,N] = size(Ar);
A = zeros(M,N);
for i=[1:1:M]
    for j=[1:1:N]
        r=(Ar(i,j));
        g=(Ag(i,j));
        b=(Ab(i,j));
        A(i,j) = double(r*(2^16))+double(g*(2^8))+double(b);
    end
end

% A = double(A);
B = A'*A;
[M1,N1] = size(B);
[X,D] = eig(B);
Y = inv(X);
D1 =zeros(M1,N1);
Z = zeros(M1,N1)

x_eigen = zeros(1,M1);
y_error = zeros(1,M1);

k=1;
for l =[1024:256:M1] %remove this line for iterative version, use it only for specific number of eigen values
    D1 = D;
    for j =[1:1:M1-l]
        D1(j,j) = 0;
    end
    %{
    %random
    for i=[1:1:2]
    Rnd = randi([0 1],1,M);
    D1 = D;
    for j =[1:1:M]
        D1(j,j) = D1(j,j)* Rnd(1,j);
    end
    %}
    newimg = real(pinv(A')*X*D1*Y);
    for i=[1:1:M]
        for j=[1:1:N]
         Ar(i,j) = bitshift(bitand(uint32(newimg(i,j)),16711680),-16);
         Ag(i,j) = bitshift(bitand(uint32(newimg(i,j)),65280),-8);
         Ab(i,j) = bitand(uint32(newimg(i,j)),255);
    end
end

%B = zeros(M,N);
 B = uint8(cat(3,Ar,Ag,Ab));
 
 subplot(2,4,k);
 imshow(uint8(cat(3,Ar,Ag,Ab)));
 title(['Reconstructed with ' num2str(l) ' eigen values']);
 subplot(2,4,k+1);
 imshow(image - uint8(cat(3,Ar,Ag,Ab)));
 title(['error with ' num2str(l) ' eigen values']);
 
 C = (uint8(image) - (B).^2);
 error = sqrt(sum(sum(sum(C))));
 x_eigen(1,l) = l;
 y_error(1,l) = error; 
 k=k+2;
end
l = (x_eigen == 0);
y_error(l) = [];
x_eigen(l) = [];
plot(x_eigen,y_error);



    
