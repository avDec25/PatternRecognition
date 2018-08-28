a = importdata('h_train1.txt.hmm');
b1 = a.data;
a = importdata('h_train2.txt.hmm');
b2 = a.data;
a = importdata('h_train3.txt.hmm');
b3 = a.data;
p=0.4;  
q=0.6;

% generating all 3 digit hmm models, 11 12 13 21 22 23 31 32 32
b=[];
[r c] = size(b1);

for i=1:3
    for j=1:3
     for k=1:3   
        if i==1
            tmp1 = b1;
        elseif i==2
            tmp1 = b2;
        else
            tmp1 = b3;
        end
        
        if j==1
            tmp2 = b1;
        elseif j==2
            tmp2 = b2;
        else
            tmp2 = b3;
        end
        
        if k==1
            tmp3 = b1;
        elseif k==2
            tmp3 = b2;
        else
            tmp3 = b3;
        end
        %modifying the last state of hmm1
        b = tmp1;
        b(r-1,1) = p;
        b(r,1) = q;
        %inserting dummy state
        for x=1:c
            if x==1
                b(r+1,x) = 0;
                b(r+2,x) = 1;
            else
                b(r+1,x) = 0;
                b(r+2,x) = 0;
            end
        end
        %modofying the last state of hmm2
        b = [b;tmp2];
        b(2*r+1,1) = p;
        b(2*r+2,1) = q;
        %inserting dummy state
        for x=1:c
            if x==1
                b(2*r+3,x) = 0;
                b(2*r+4,x) = 1;
            else
                b(2*r+3,x) = 0;
                b(2*r+4,x) = 0;
            end
        end
        b = [b;tmp3];
        
        %wrting the matrix back into an hmm file
        str = sprintf('h_model%d%d%d.txt.hmm', i , j , k );
        str1 = sprintf('states: %d', 3*(r/2) + 2 );
        str2 = sprintf('symbols: %d', c-1 );
        fid = fopen( str, 'wt' );
        
        fprintf( fid, '%s\n', str1);
        fprintf( fid, '%s\n', str2);
        
        for i1 = 1:3*r + 4
            for j1 = 1:c
                a=b(i1,j1);
                fprintf( fid, '%f\t', a);
            end
            fprintf( fid, '\n');
            ii = mod(i1,2);
            if ii == 0
                fprintf( fid, '\n');
            end
        end
        
        fclose(fid);
        
    end
    end
end

        