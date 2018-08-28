clear; clc; close all;

%% Collecting all Variables for Classification ----------------------------- %
% fprintf('\nLoading All Data Matrices ..\n');
% load('real_data_matrices');

% num_iterations = 50;    prec = 5;

% warning ('off','all');
% fprintf('\nWorks for K = { 1');
% K_works = 1;
% for K = 2:50
%     try
%         GMModel = fitgmdist(data_C1,K);
%         fprintf(', %d',K);
%         K_works = [K_works K];
%     catch 
%         % fprintf('\nFails ..\n');
%     end    
% end
% fprintf('}\n');

% % For Automatic K value Selection
% randomColumnNumber = randi(size(K_works, 2), 1);
% row = 1;
% K = K_works(row, randomColumnNumber);

% % For Manual K value Selection
% prompt = 'Choose a K value to use? ';
% K = input(prompt);

% fprintf('\nUsing K = %d\n',K);
% [c1_pie_k, c1_mu_k, c1_sigma_k] = emout( data_C1, K, num_iterations, prec );
% [c2_pie_k, c2_mu_k, c2_sigma_k] = emout( data_C2, K, num_iterations, prec );
% [c3_pie_k, c3_mu_k, c3_sigma_k] = emout( data_C3, K, num_iterations, prec );
% -------------------------------------------------------------------------- %

% load('real_validation_data_all_imp_vars');

% % test_data_forest       = test_data_forest(1:1764,:);
% % test_data_opencountry  = test_data_opencountry(1:2196,:);
% % test_data_tallbuilding = test_data_tallbuilding(1:1908,:);

% test_data_forest       = normc(test_data_forest(1:1764,:));
% test_data_opencountry  = normc(test_data_opencountry(1:2196,:));
% test_data_tallbuilding = normc(test_data_tallbuilding(1:1908,:));

% test_data      = [test_data_forest; test_data_opencountry; test_data_tallbuilding];
% actual_class   = [ones(1764/36,1); 1+ones(2196/36,1); 2+ones(1908/36,1)];
% computed_class = [zeros((1764+2196+1908)/36,1)];

% x = 1;
% for i = 1 : size(actual_class,1)
    
%     fprintf('\nComputing Class for Patch %d ..\n',x);
%     img_patch_class_count = zeros(3,1);
%     img_patch_prob        = zeros(3,1);
%     sum_prob              = zeros(3,1);

%     for j = 1 : 36
%         img_patch = test_data(x,:);
        
%         img_patch_prob(1) = computeProb( img_patch, c1_pie_k, c1_mu_k, c1_sigma_k );
%         sum_prob(1) = sum_prob(1) + img_patch_prob(1);

%         img_patch_prob(2) = computeProb( img_patch, c2_pie_k, c2_mu_k, c2_sigma_k );
%         sum_prob(2) = sum_prob(2) + img_patch_prob(2);

%         img_patch_prob(3) = computeProb( img_patch, c3_pie_k, c3_mu_k, c3_sigma_k );
%         sum_prob(3) = sum_prob(3) + img_patch_prob(3);

%         [val, idx]                  = max(img_patch_prob);
%         img_patch_class_count(idx)  = img_patch_class_count(idx) + 1;
%         % img_patch_prob'
%     end

%     [val, idx]        = max(img_patch_class_count);
%     computed_class(x) = idx;
%     score(x,1)        = sum_prob(1) / 36;
%     score(x,2)        = sum_prob(2) / 36;
%     score(x,3)        = sum_prob(3) / 36;
    
%     % fprintf('\nImg %d Actual Class = %d', x, actual_class(x));
%     % img_patch_class_count'    
%     fprintf('Img %d is classified as Class = %d\n', x, idx);    
%     x = x + 1;
% end

% count = 0;
% for i = 1 : size(actual_class,1)
%     if abs(actual_class(i) - computed_class(i)) == 0
%         count = count + 1;
%     end
% end
% accuracy = 100 * (count / size(actual_class,1));
% fprintf('\nAccuracy = %f\n',accuracy);

% save('impVars');
%%----------------------------------------
load('impVars');

m = [actual_class computed_class score];
num_imgs = size(m,1);

tpr = zeros(num_imgs,3);
fpr = zeros(num_imgs,3);
fnr = zeros(num_imgs,3);

%classifying wrt g1
m = sortrows(m,3);

for th=1:num_imgs
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
   
   for q = 1:th
       if((m(q,1) ==1) && (m(q,1) ~= 1))
           fn=fn+1;
       end
       if(((m(q,1) ~=1) && (m(q,1) ~= 1)))
           tn=tn+1;
       end
   end
   
   %these are positive cases
   for q = th:num_imgs
       if((m(q,1) ==  1) &&(m(q,1) == 1))
           tp=tp+1;
       end
       if((m(q,1) ==  1) &&(m(q,1) ~= 1))
           fp=fp+1;
       end
   end

    % for q = 1:th
    %     if(m(q,1) == m(q,2) && (m(q,1)==1)) 
    %         fn=fn+1;
    %     else
    %         tn=tn+1;
    %     end
    % end
    
    % %these are positive cases
    % for q = th+1:num_imgs
    %     if(m(q,1) == m(q,2) && (m(q,1)==1))
    %         tp=tp+1;
    %     else
    %         fp=fp+1;
    %     end
    % end
    
    tpr(th,1) = tp/(tp+fn);
    fpr(th,1) = fp/(fp+tn);
    fnr(th,1) = 1-tpr(th,1);%fn/(tp+fn)
end


%classifying wrt g2
m = sortrows(m,4);
for th=1:num_imgs
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) ==2) && (m(q,2) ~= 2))
            fn=fn+1;
        end
        if(((m(q,1) ~=2) && (m(q,2) ~= 2)))
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:num_imgs
        if((m(q,1) ==  2) &&(m(q,2) == 2))
            tp=tp+1;
        end
        if((m(q,1) ==  2) &&(m(q,2) ~= 2))
            fp=fp+1;
        end
    end
    % for q = 1:th
    %     if((m(q,1) == m(q,2))&&(m(q,2) == 2))
    %         fn=fn+1;
    %     else
    %         tn=tn+1;
    %     end
    % end
    
    % %these are positive cases
    % for q = th:num_imgs
    %     if((m(q,1) == m(q,2))&&(m(q,2) == 2))
    %         tp=tp+1;
    %     else
    %         fp=fp+1;
    %     end
    % end
    
    tpr(th,2) = tp/(tp+fn);
    fpr(th,2) = fp/(fp+tn);
    fnr(th,2) = 1-tpr(th,2);%fn/(tp+fn)
end

%classifying wrt g3
m = sortrows(m,5);
for th=1:num_imgs
    tp=0;tn=0;fp=0;fn=0;
    %these are negative cases
    for q = 1:th
        if((m(q,1) ==3) && (m(q,2) ~= 3))
            fn=fn+1;
        end
        if(((m(q,1) ~=3) && (m(q,2) ~= 3)))
            tn=tn+1;
        end
    end
    
    %these are positive cases
    for q = th:num_imgs
        if((m(q,1) ==  3) &&(m(q,2) == 3))
            tp=tp+1;
        end
        if((m(q,1) ==  3) &&(m(q,2) ~= 3))
            fp=fp+1;
        end
    end
    
    tpr(th,3) = tp/(tp+fn);
    fpr(th,3) = fp/(fp+tn);
    fnr(th,3) = fn/(tp+fn);%1-tpr(th,3);%fn/(tp+fn);
end
% x=mean(tpr,2);%mean tpr
% y=mean(fpr,2);%mean fpr
% z=mean(fnr,2);%mean fnr

plot(fpr(:,2), tpr(:,1), 'r');
hold on;