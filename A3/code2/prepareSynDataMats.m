function [ train_data_C1, train_data_C2, validate_data_C1, validate_data_C2, test_data ] = preprareSynDataMats( )

    input_dir = '../data/synData';
    filenames = dir(fullfile(input_dir, '*.txt'));
    num_classes = numel(filenames);

    for i = 1:num_classes
        if  i == 1
            C1 = importdata(fullfile(filenames(i).folder,filenames(i).name));
        else
            C2 = importdata(fullfile(filenames(i).folder,filenames(i).name));
        end
    end

    % plot(C1(:,1),C1(:,2),'ko', 'MarkerFaceColor', 'r');
    % hold on;
    % plot(C2(:,1),C2(:,2),'ko', 'MarkerFaceColor', 'b');
    % hold off;
    % figure;

    train_percent = 0.7;

    shuffled_C1 = C1(randperm(size(C1,1)), :);
    % shuffled_C1 = C1;
    
    n_total          = size(shuffled_C1,1);
    n_train          = floor(train_percent * size(shuffled_C1,1));
    train_indexes    = 1 : n_train;
    n_validate       = n_train + floor(0.5 * (n_total - n_train));
    validate_indexes = (n_train + 1) : n_validate;
    test_indexes     = (n_validate + 1) : n_total;

    train_data_C1    = shuffled_C1(train_indexes,:);
    validate_data_C1 = shuffled_C1(validate_indexes,:);
    test_data        = shuffled_C1(test_indexes,:);


    shuffled_C2 = C2(randperm(size(C2,1)), :);
    % shuffled_C2 = C2;
    
    n_total          = size(shuffled_C2,1);
    n_train          = floor(train_percent * size(shuffled_C2,1));
    train_indexes    = 1 : n_train;
    n_validate       = n_train + floor(0.5 * (n_total - n_train));
    validate_indexes = (n_train + 1) : n_validate;
    test_indexes     = (n_validate + 1) : n_total;

    train_data_C2    = shuffled_C2(train_indexes,:);
    validate_data_C2 = shuffled_C2(validate_indexes,:);
    test_data        = vertcat(test_data, shuffled_C2(test_indexes,:));

    % validate_data = validate_data(randperm(size(validate_data,1)), :);
    test_data     = test_data(randperm(size(test_data,1)), :);

end