traindir=('for_test/train');
testdir=('for_test/test');
trainingSet = imageSet(traindir,'recursive');
testSet = imageSet(testdir,'recursive');
%%
bag = bagOfFeatures(trainingSet);
%%
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%%
confMatrix = evaluate(categoryClassifier, testSet);