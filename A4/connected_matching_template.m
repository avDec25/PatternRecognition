

%%let score be the score matrix
score = [];

index_matrix = [];%stores index numbers for all combinations of 2 and 3 digit models
index = 1;
for i=1:3
    for j=1:3
        str = sprintf('%d%d', i , j );
        index_matrix = [index_matrix str2num(str)];
    end
end
for i=1:3
    for j=1:3
        for k=1:3
        str = sprintf('%d%d%d', i , j ,k);
        index_matrix = [index_matrix str2num(str)];
    end
    end
end