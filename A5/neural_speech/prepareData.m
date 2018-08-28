%%%%%%%%%%%%%%%%%%%%%% Combine all rows of C1 %%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all; format longG;

fprintf('\nProcess: Importing Speech Data for 1 ..\n');
directory = './data/1/';
one_file = dir(fullfile(directory, '*.mfcc'));
nfiles = length(one_file);
for i = 1 : nfiles
	fid = fopen( fullfile(directory, one_file(i).name) );

	tline = fgetl(fid);
	x = 1;
   	while ischar(tline)
		row{x} = textscan(tline,'%f');
		x = x + 1;
	    tline = fgetl(fid);
	end
   data_file{i} = row;

   fclose(fid);
end
clear fid directory i nfiles one_file ans row tline x;

total_number_of_files = size(data_file,2);
total_rows = 0;

for file_number = 1 : total_number_of_files	
	num_cols(file_number,:) = data_file{file_number}{1}{1}(1);
	num_rows(file_number,:) = data_file{file_number}{1}{1}(2);
	for r = 2 : num_rows(file_number)
		row = data_file{file_number}{r}{1};
		row = row';
		total_rows = total_rows + 1;
		all_rows{total_rows} = row;
	end
end

for i = 1 : size(all_rows,2)
	c1_data(i,:) = all_rows{i};
end

clearvars -except c1_data


%%%%%%%%%%%%%%%%%%%%%% Combine all rows of C2 %%%%%%%%%%%%%%%%%%%%%%

fprintf('\nProcess: Importing Speech Data for 2 ..\n');
directory = './data/2/';
one_file = dir(fullfile(directory, '*.mfcc'));
nfiles = length(one_file);
for i = 1 : nfiles
	fid = fopen( fullfile(directory, one_file(i).name) );

	tline = fgetl(fid);
	x = 1;
   	while ischar(tline)
		row{x} = textscan(tline,'%f');
		x = x + 1;
	    tline = fgetl(fid);
	end
   data_file{i} = row;

   fclose(fid);
end
clear fid directory i nfiles one_file ans row tline x;

total_number_of_files = size(data_file,2);
total_rows = 0;

for file_number = 1 : total_number_of_files	
	num_cols(file_number,:) = data_file{file_number}{1}{1}(1);
	num_rows(file_number,:) = data_file{file_number}{1}{1}(2);
	for r = 2 : num_rows(file_number)
		row = data_file{file_number}{r}{1};
		row = row';
		total_rows = total_rows + 1;
		all_rows{total_rows} = row;
	end
end

for i = 1 : size(all_rows,2)
	c2_data(i,:) = all_rows{i};
end

clearvars -except c1_data c2_data

% %%%%%%%%%%%%%%%%%%%%%% Combine all rows of C5 %%%%%%%%%%%%%%%%%%%%%%

fprintf('\nProcess: Importing Speech Data for 5 ..\n');
directory = './data/5/';
one_file = dir(fullfile(directory, '*.mfcc'));
nfiles = length(one_file);
for i = 1 : nfiles
	fid = fopen( fullfile(directory, one_file(i).name) );

	tline = fgetl(fid);
	x = 1;
   	while ischar(tline)
		row{x} = textscan(tline,'%f');
		x = x + 1;
	    tline = fgetl(fid);
	end
   data_file{i} = row;

   fclose(fid);
end
clear fid directory i nfiles one_file ans row tline x;

total_number_of_files = size(data_file,2);
total_rows = 0;

for file_number = 1 : total_number_of_files	
	num_cols(file_number,:) = data_file{file_number}{1}{1}(1);
	num_rows(file_number,:) = data_file{file_number}{1}{1}(2);
	for r = 2 : num_rows(file_number)
		row = data_file{file_number}{r}{1};
		row = row';
		total_rows = total_rows + 1;
		all_rows{total_rows} = row;
	end
end

for i = 1 : size(all_rows,2)
	c5_data(i,:) = all_rows{i};
end

clearvars -except c1_data c2_data c5_data

save('data/all_data_rows');
