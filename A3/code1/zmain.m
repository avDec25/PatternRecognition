clear; clc; close all;

[ train_data_C1, train_data_C2, validate_data_C1, validate_data_C2, test_data ] = prepareSynDataMats();

data_C1 = train_data_C1;
data_C2 = train_data_C2;

% data_C1 = importdata('syndata/class1.txt');
% data_C2 = importdata('syndata/class2.txt');

K = 16;    num_iterations = 100;    prec = 5;

[c1_pie_k, c1_mu_k, c1_sigma_k] = emout( data_C1, K, num_iterations, prec );
[c2_pie_k, c2_mu_k, c2_sigma_k] = emout( data_C2, K, num_iterations, prec );

for i=1:K
    temp = c1_sigma_k{i};
    %c1_sigma_k{i} = diag(diag(temp));
    c1_sigma_k{i} = temp;
end
    
%% Computing probability for a temporary point
% pointX = 11.2;
% pointY = 7.3;
% point = [pointX pointY];
% point_prob_in_class_c1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k )
% point_prob_in_class_c2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k )

%% Computing minX, minY  and  maxX, maxY
data_all = [data_C1; data_C2];
minX = min(data_all(:,1));
minY = min(data_all(:,2));
maxX = max(data_all(:,1));
maxY = max(data_all(:,2));

intervals = 100;
incX = (maxX - minX) / intervals;
incY = (maxY - minY) / intervals;
[X,Y] = meshgrid(minX:incX:maxX, minY:incY:maxY);

fprintf('\nPlotting Mesh Background ..\n');
for x_itertor = minX:incX:maxX
    for y_itertor = minY:incY:maxY
        pointX = x_itertor;
        pointY = y_itertor;
        point = [pointX pointY];
        likelihood_point_c1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k );
        likelihood_point_c2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k );

        if likelihood_point_c1 >= likelihood_point_c2
            plot(pointX, pointY, 's','MarkerEdgeColor', 'none' ,'MarkerFaceColor', 'g');
        else
            plot(pointX, pointY, 's','MarkerEdgeColor', 'none' ,'MarkerFaceColor', 'y');
        end
        hold on;
    end
end


%% Plotting Contours for Class_1 =============================================
fprintf('\nPlotting contour for Class 1 ..\n');
for k = 1 : K
    temp_mu = c1_mu_k{k};
    temp_sigma = c1_sigma_k{k};

    [X,Y] = meshgrid(minX:incX:maxX, minY:incY:maxY);

    x_minus_mu = [(X(:) - temp_mu(1)) (Y(:) - temp_mu(2))];

    prob_den = (1 / (2 * pi * sqrt(det(temp_sigma)))) * exp(-0.5 * diag((x_minus_mu) * (inv(temp_sigma))* (x_minus_mu')));
    prob_den = reshape(prob_den, size(X)) ;

    contour(X,Y,prob_den,'r');
    hold on;
end

%% Plotting Contours for Class_2 =============================================
fprintf('\nPlotting contour for Class 2 ..\n');
for k = 1 : K
    temp_mu = c2_mu_k{k};
    temp_sigma = c2_sigma_k{k};

    [X,Y] = meshgrid(minX:incX:maxX, minY:incY:maxY);

    x_minus_mu = [(X(:) - temp_mu(1)) (Y(:) - temp_mu(2))];

    prob_den = (1 / (2 * pi * sqrt(det(temp_sigma)))) * exp(-0.5 * diag((x_minus_mu) *(inv(temp_sigma))* (x_minus_mu'))) ;   
    prob_den = reshape(prob_den, size(X)) ;

    contour(X,Y,prob_den,'b');
    hold on;
end

%% Plot Data Points ========================================================
hold on;
scatter(data_all(:,1), data_all(:,2),2,'k');
hold on;

% target = [];
% nontarget = [];
% N = size(data_all,1);
% for i = 1 : N
%     point = data_all(i,:);
%     point_prob_in_class_c1 = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k );
%     point_prob_in_class_c2 = computeProb( point, c2_pie_k, c2_mu_k, c2_sigma_k );

%     pointX = point(1,1);
%     pointY = point(1,2);
%     if point_prob_in_class_c1 >= point_prob_in_class_c2
%         plot(pointX, pointY, 'ko', 'MarkerFaceColor', 'r');
%         target = [target; point_prob_in_class_c1];
%         nontarget = [nontarget; point_prob_in_class_c2];
%     else
%         plot(pointX, pointY, 'ko', 'MarkerFaceColor', 'b');
%         target = [target; point_prob_in_class_c2];
%         nontarget = [nontarget; point_prob_in_class_c1];
%     end
%     hold on;
% end