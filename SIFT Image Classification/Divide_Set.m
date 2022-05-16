A = dir('256_ObjectCategories');
% testnum + trainnum should be no more than 80
testnum = 30;
trainnum = 10;
% classes no more than 257
classes = 30;

ind = 3;
while strcmp(A(ind).name(1:3),'001') ~= 1
    ind = ind + 1;
end

for i = ind:classes+3
    folder_name = strcat(A(i).folder,'/',A(i).name);
    to_name = strcat('full_test/train/',A(i).name);
    mkdir(to_name);
    Sub = dir(folder_name);
    for j = 3:trainnum+2
        from_name = strcat(Sub(j).folder,'/',Sub(j).name);
        copyfile(from_name,to_name);
    end
end

for i = ind:classes+3
    folder_name = strcat(A(i).folder,'/',A(i).name);
    to_name = strcat('full_test/test/',A(i).name);
    mkdir(to_name);
    Sub = dir(folder_name);
    for j = trainnum+3:trainnum+2+testnum
        from_name = strcat(Sub(j).folder,'/',Sub(j).name);
        copyfile(from_name,to_name);
    end
end

