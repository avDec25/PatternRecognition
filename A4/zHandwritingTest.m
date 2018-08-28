clear; clc; close all;

% K = 6;	% Number of cluster centers, for kMeans

% n_a = importdata(fullfile('../dhmm/data/handwriting/features/n_test_a.ldf'));
% x_a = importdata(fullfile('../dhmm/data/handwriting/features/x_test_a.ldf'));
% y_a = importdata(fullfile('../dhmm/data/handwriting/features/y_test_a.ldf'));

% slope = zeros(size(x_a,1),1);
% for	i = 1 : size(x_a,1)-1
% 	slope(i) = (y_a(i+1) - y_a(i)) / (x_a(i+1) - x_a(i));
% 	slope(i) = atand(slope(i));
% end

% slope(size(x_a,1)) = slope(size(x_a,1)-1) * 2 ;
% all_features_a = [x_a y_a slope];



% n_b = importdata(fullfile('../dhmm/data/handwriting/features/n_test_chA.ldf'));
% x_b = importdata(fullfile('../dhmm/data/handwriting/features/x_test_chA.ldf'));
% y_b = importdata(fullfile('../dhmm/data/handwriting/features/y_test_chA.ldf'));

% slope = zeros(size(x_b,1),1);
% for	i = 1 : size(x_b,1)-1
% 	slope(i) = (y_b(i+1) - y_b(i)) / (x_b(i+1) - x_b(i));
% 	slope(i) = atand(slope(i));
% end

% slope(size(x_b,1)) = slope(size(x_b,1)-1) * 2 ;
% all_features_b = [x_b y_b slope];



% n_c = importdata(fullfile('../dhmm/data/handwriting/features/n_test_tA.ldf'));
% x_c = importdata(fullfile('../dhmm/data/handwriting/features/x_test_tA.ldf'));
% y_c = importdata(fullfile('../dhmm/data/handwriting/features/y_test_tA.ldf'));

% slope = zeros(size(x_c,1),1);
% for	i = 1 : size(x_c,1)-1
% 	slope(i) = (y_c(i+1) - y_c(i)) / (x_c(i+1) - x_c(i));
% 	slope(i) = atand(slope(i));
% end

% slope(size(x_c,1)) = slope(size(x_c,1)-1) * 2 ;
% all_features_c = [x_c y_c slope];


% % Concatenating all features
% all_features = [all_features_a; all_features_b; all_features_c];

% load('cluster_means.mat','mu');
% save('test_handwriting.mat');

load('test_handwriting.mat');

for i = 1 : size(all_features,1)
	
	temp = [];	
	for k = 1 : size(mu,1)
		temp = [temp norm(all_features(i) - mu(k))];
	end

	[s_val,s_indx] = sort(temp);

	if i == 1
		normalized = s_indx(1);
	else
		normalized = [normalized; s_indx(1)];
	end
end

% Save data to files
fid = fopen( 'test_for_hmm_a.txt', 'wt' );
start_index = 0;
end_index = 0;
for i = 1 : size(n_a,1)
	start_index = end_index + 1;
	end_index   = end_index + n_a(i);
	cc_row_a{i} = normalized(start_index:end_index);
	
	fprintf( fid, '%g ', cc_row_a{i});
	fprintf( fid, '\n');
end
fclose(fid);


fid = fopen( 'test_for_hmm_b.txt', 'wt' );
for i = 1 : size(n_b,1)
	start_index = end_index + 1;
	end_index   = end_index + n_b(i);
	cc_row_b{i} = normalized(start_index:end_index);

	fprintf( fid, '%g ', cc_row_b{i});
	fprintf( fid, '\n');
end
fclose(fid);


fid = fopen( 'test_for_hmm_c.txt', 'wt' );
for i = 1 : size(n_c,1)
	start_index = end_index + 1;
	end_index   = end_index + n_c(i);
	cc_row_c{i} = normalized(start_index:end_index);

	fprintf( fid, '%g ', cc_row_c{i});
	fprintf( fid, '\n');
end
fclose(fid);
