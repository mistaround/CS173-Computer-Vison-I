% First set vlfeat if not set

disp('Divide');
% Read in data
TrainDir=('full_test/train');
TestDir=('full_test/test');
TrainSet = imageSet(TrainDir,'recursive');
TestSet = imageSet(TestDir,'recursive');
classes = size(TrainSet,2);
trainnum = TrainSet(1,1).Count;
testnum = TestSet(1,1).Count;

% Parameter
K = 80;

disp('SIFT');
% Get features
Train_SIFT = cell(1,classes*trainnum);
Test_SIFT = cell(1,classes*testnum);
for i = 1:classes
    for j = 1:trainnum
        train_name = TrainSet(1,i).ImageLocation{1,j};
        train_img = imresize(imread(train_name),[NaN 100]);
        if size(train_img,3) == 3
            train_img = single(rgb2gray(train_img));
        else
            train_img = single(train_img);
        end
        [~,Train_SIFT{1,(i-1)*trainnum+j}] = vl_sift(train_img);
    end    
end

for i = 1:classes
    for j = 1:testnum
        test_name = TestSet(1,i).ImageLocation{1,j};
        test_img = imresize(imread(test_name),[NaN 100]);
        if size(test_img,3) == 3
            test_img = single(rgb2gray(test_img));
        else
            test_img = single(test_img);
        end
        [~,Test_SIFT{1,(i-1)*testnum+j}] = vl_sift(test_img);
    end    
end

disp('Bag');
% Get Bag of Features and Words
Bag = [];
count = 1;
for i = 1:classes*trainnum
    c = size(Train_SIFT{i},2);
    for j = 1:c
        Bag(:,count) = Train_SIFT{i}(:,j);
        count = count + 1;
    end
end

[~,Words] = kmeans(Bag',K);

disp('Histogram');
% Get the Histogram
Train_Histos = cell(1,classes*trainnum);
Test_Histos = cell(1,classes*testnum);

for i = 1:classes
    for j = 1:trainnum
        h = zeros(1,K);
        pic_sifts = double(Train_SIFT{1,(i-1)*trainnum+j});
        sift_size = size(pic_sifts,2);
        for l = 1:sift_size      
            ind = 1;
            min = 10000000;
            keypoint = pic_sifts(:,l);
            for k = 1:K
                val = (keypoint - transpose(Words(k,:)))'*(keypoint - transpose(Words(k,:)));
                if val < min
                    min = val;
                    ind = k;
                end
            end
            h(ind) = h(ind) + 1;
        end
        Train_Histos{1,(i-1)*trainnum+j} = h;
    end
end

for i = 1:classes
    for j = 1:testnum
        h = zeros(1,K);
        pic_sifts = double(Test_SIFT{1,(i-1)*testnum+j});
        sift_size = size(pic_sifts,2);
        for l = 1:sift_size      
            ind = 1;
            min = 10000000;
            keypoint = pic_sifts(:,l);
            for k = 1:K
                val = (keypoint - transpose(Words(k,:)))'*(keypoint - transpose(Words(k,:)));
                if val < min
                    min = val;
                    ind = k;
                end
            end
            h(ind) = h(ind) + 1;
        end
        Test_Histos{1,(i-1)*testnum+j} = h;
    end
end

disp('SVM');
% SVM
TrainLabels = zeros(classes*trainnum,1);
TrainMatrix = zeros(classes*trainnum,K);
for i = 1:classes
    for j = 1:trainnum
        TrainLabels((i-1)*trainnum+j,1) = double(i);
        TrainMatrix((i-1)*trainnum+j,:) = Train_Histos{1,(i-1)*trainnum+j}(1,:);
    end
end
Classifier = svmtrain(TrainLabels,TrainMatrix);

disp('Predict');
% Predict
TestLabels = zeros(classes*testnum,1);
TestMatrix = zeros(classes*testnum,K);
for i = 1:classes
    for j = 1:testnum
        TestLabels((i-1)*testnum+j,1) = double(i);
        TestMatrix((i-1)*testnum+j,:) = Test_Histos{1,(i-1)*testnum+j}(1,:);
    end
end

[Predict_Label] = svmpredict(TestLabels,TestMatrix,Classifier);











