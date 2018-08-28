clear all;
close all;

x=importdata('forest.mat');
y=importdata('open.mat');
z=importdata('tall.mat');

sw1 = zeros(23,23);
sw2 = zeros(23,23);
sw3 = zeros(23,23);
mx = mean(x);my = mean(y); mz = mean(z);
for i=1:size(x,1)
    sw1 = sw1 + (x(i,:) - mx)'*(x(i,:) - mx);
end
for i=1:size(y,1)
    sw2 = sw2 + (y(i,:) - my)'*(y(i,:) - my);
end
for i=1:size(z,1)
    sw3 = sw3 + (z(i,:) - mz)'*(z(i,:) - mz);
end
sw = sw1 + sw2 + sw3;
m = mean([x;y;z]);

sb = (mx - m)'*(mx-m)*size(x,1) + (my - m)'*(my-m)*size(y,1) + (mz - m)'*(mz-m)*size(z,1); 
w=inv(sw)*sb;

[vector,value] = eig(w);

%first two eigen vectors are relecant, being from the largest eigen values
temp = vector(:,1:2);
x1 = [];y1 = []; z1 = [];
for i=1:size(x,1)
    x1 = [x1;x(i,:)*temp];
end
for i=1:size(y,1)
    y1 = [y1;y(i,:)*temp];
end
for i=1:size(z,1)
    z1 = [z1;z(i,:)*temp];
end

save('lda_forest.mat','x1');
save('lda_open.mat','y1');
save('lda_tall.mat','z1');
