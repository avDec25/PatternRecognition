%K = 12;   
accu  = zeros(1,8);
x=1;

for K=2:2:16
num_iterations = 100;    prec = 5;

a=importdata('class1.txt');
data_C1 = a([1:1400],[1:2]);
a=importdata('class2.txt');
data_C2 = a([1:1400],[1:2]);

[c1_pie_k, c1_mu_k, c1_sigma_k] = emout( data_C1, K, num_iterations, prec );
[c2_pie_k, c2_mu_k, c2_sigma_k] = emout( data_C2, K, num_iterations, prec );

a=importdata('class1.txt');
test_C1 = a([1401:1700],[1:2]);
a=importdata('class2.txt');
test_C2 = a([1401:1700],[1:2]);
[M,N] = size(test_C1);

count = 0;
for i=1:M
     point = test_C1(i,:)
     score1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k );
     score2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k );
     if score2>score1
         count = count+1;
     end
end

for i=1:M
     point = test_C2(i,:)
     score1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k );
     score2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k );
     if score2<score1
         count = count+1;
     end
end
accu(x)= (M-count)/M;
x=x+1;
end