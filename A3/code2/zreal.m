clear; clc; close all;

fprintf('\nPreparing All Data Matrices ..\n');
[ data_forest, train_data_forest, validate_data_forest, test_data_forest, data_opencountry, train_data_opencountry, validate_data_opencountry, test_data_opencountry, data_tallbuilding, train_data_tallbuilding, validate_data_tallbuilding, test_data_tallbuilding ] = prepareRealData( );

% data_C1 = train_data_forest;
% data_C2 = train_data_opencountry;
% data_C3 = train_data_tallbuilding;
% save('real_data_matrices');

data_C1 = validate_data_forest;
data_C2 = validate_data_opencountry;
data_C3 = validate_data_tallbuilding;
save('real_validation_data_matrices');


% fprintf('\nLoading All Data Matrices ..\n');
% load('real_data_matrices');

%% Normalizing data matrices
data_C1 = normc(data_C1);
data_C2 = normc(data_C2);
data_C3 = normc(data_C3);

K = 10;    num_iterations = 200;    prec = 5;

warning ('off','all');
fprintf('\nWorks for K = { 1');
K_works = 1;
for K = 2:100
    try
        GMModel = fitgmdist(data_C1,K);
        fprintf(', %d',K);
        K_works = [K_works K];
    catch 
        % fprintf('\nFails ..\n');
    end    
end
fprintf('}\n');

randomColumnNumber = randi(size(K_works, 2), 1);
row = 1;
K = K_works(row, randomColumnNumber);

fprintf('\nUsing K = %d\n',K);
[c1_pie_k, c1_mu_k, c1_sigma_k] = emout( data_C1, K, num_iterations, prec );
[c2_pie_k, c2_mu_k, c2_sigma_k] = emout( data_C2, K, num_iterations, prec );
[c3_pie_k, c3_mu_k, c3_sigma_k] = emout( data_C3, K, num_iterations, prec );
save('real_validation_data_all_imp_vars');

% data_all = [test_data_forest; test_data_opencountry; test_data_tallbuilding];

% N = size(data_all,1);
% for i = 1 : N
%     point = data_all(i,:);
%     point_prob_in_class_c1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k );
%     point_prob_in_class_c2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k );
%     point_prob_in_class_c3 = computeProb( point, c3_pie_k, c3_mu_k, c3_sigma_k );

%     pointX = point(1,1);
%     pointY = point(1,2);
%     if point_prob_in_class_c1 >= point_prob_in_class_c2
%         plot(pointX, pointY, 'ko', 'MarkerFaceColor', 'r');
%     else
%         plot(pointX, pointY, 'ko', 'MarkerFaceColor', 'b');
%     end
%     hold on;
% end