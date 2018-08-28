function [ data_forest, train_data_forest, validate_data_forest, test_data_forest, data_opencountry, train_data_opencountry, validate_data_opencountry, test_data_opencountry, data_tallbuilding, train_data_tallbuilding, validate_data_tallbuilding, test_data_tallbuilding ] = prepareRealData( )

    input_dir = '../data/real/features/forest';
    filenames = dir(fullfile(input_dir, '*.jpg_color_edh_entropy'));
    num_files = numel(filenames);

    fprintf('\nReading All forest Data files ..\n');
    for i = 1 : num_files
        if i == 1
            data_forest = importdata(fullfile(filenames(i).folder,filenames(i).name));
        else
            data_forest = [data_forest; importdata(fullfile(filenames(i).folder,filenames(i).name))];
        end
    end


    input_dir = '../data/real/features/opencountry';
    filenames = dir(fullfile(input_dir, '*.jpg_color_edh_entropy'));
    num_files = numel(filenames);

    fprintf('\nReading All opencountry Data files ..\n');
    for i = 1 : num_files
        if i == 1
            data_opencountry = importdata(fullfile(filenames(i).folder,filenames(i).name));
        else
            data_opencountry = [data_opencountry; importdata(fullfile(filenames(i).folder,filenames(i).name))];
        end
    end


    input_dir = '../data/real/features/tallbuilding';
    filenames = dir(fullfile(input_dir, '*.jpg_color_edh_entropy'));
    num_files = numel(filenames);

    fprintf('\nReading All tallbuilding Data files ..\n');
    for i = 1 : num_files
        if i == 1
            data_tallbuilding = importdata(fullfile(filenames(i).folder,filenames(i).name));
        else
            data_tallbuilding = [data_tallbuilding; importdata(fullfile(filenames(i).folder,filenames(i).name))];
        end
    end

    train_data_forest           = data_forest(1:8265,:);
    validate_data_forest        = data_forest(8266:10037,:);
    test_data_forest            = data_forest(10038:11808,:);

    train_data_opencountry      = data_opencountry(1:10332,:);
    validate_data_opencountry   = data_opencountry(10333:12547,:);
    test_data_opencountry       = data_opencountry(12548:14760,:);

    train_data_tallbuilding     = data_tallbuilding(1:8971,:);
    validate_data_tallbuilding  = data_tallbuilding(8972:10894,:);
    test_data_tallbuilding      = data_tallbuilding(10895:12816,:);

end