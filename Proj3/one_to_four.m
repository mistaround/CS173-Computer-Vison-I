function [Four] = one_to_four(One)
% Cut a picture into 4 parts
[row,col] = size(One);
Four = cell(1,4);
r = floor(row/2);
c = floor(col/2);
%
first = zeros(r,c);
for i = 1:r
    for j = 1:c
        first(i,j) = One(i,j);
    end
end
Four{1,1} = single(first);

second = zeros(r,col-c);
for i = 1:r
    for j = c+1:col
        second(i,j-c) = One(i,j);
    end
end
Four{1,2} = single(second);

third = zeros(row-r,c);
for i = r+1:row
    for j = 1:c
        third(i-r,j) = One(i,j);
    end
end
Four{1,3} = single(third);

fourth = zeros(row-r,col-c);
for i = r+1:row
    for j = c+1:col
        second(i-r,j-c) = One(i,j);
    end
end
Four{1,4} = single(fourth);

end

