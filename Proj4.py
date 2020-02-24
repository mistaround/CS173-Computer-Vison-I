import torch
import torch.nn as nn
from torchvision import datasets, transforms
from torch.autograd import Variable

batch_size = 64

data_train = datasets.MNIST(root = "./data",  transform = transforms.ToTensor(), train = True, download = True)
data_test = datasets.MNIST(root = "./data", transform = transforms.ToTensor(), train = False)

data_loader_train = torch.utils.data.DataLoader(dataset = data_train,
                                              batch_size = batch_size,
                                              shuffle = True)
data_loader_test = torch.utils.data.DataLoader(dataset = data_test,
                                             batch_size = batch_size,
                                             shuffle = True)

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        # Two Conv layers
        self.conv1 = nn.Conv2d( 1, 10, 5)
        self.conv2 = nn.Conv2d(10, 40, 5)
        #self.pool = nn.MaxPool2d(2)
        # One FC layer
        self.fc = nn.Linear(16000, 10)

    def forward(self, x):
        # Take relu as non-linear function
        in_size = x.size(0)
        # x: 64*1*28*28
        x = nn.functional.relu(self.conv1(x))
        # x: 64*10*12*12  feature map =[(28-4)/2]^2=12*12
        x = nn.functional.relu(self.conv2(x))
        # x: 64*40*4*4  feature map =[(12-4)/2]^2=4*4
        x = x.view(in_size, -1)
        x = self.fc(x)
        # x: 64*640 -> 64*10
        return nn.functional.log_softmax(x)  

model = Net()

print(model)
optimizer = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.5)

def train(epoch):
    for batch_idx, (data, target) in enumerate(data_loader_train):
        output = model(data)
        loss = nn.functional.nll_loss(output, target)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    print('Train {}: Loss:{:.6f}'.format(epoch,loss.item()))

def test():
    correct = 0
    for data, target in data_loader_test:
        data, target = Variable(data, volatile=True), Variable(target)
        output = model(data)
        predict = output.data.max(1, keepdim=True)[1]
        correct += predict.eq(target.data.view_as(predict)).cpu().sum()

    print('\nTest Accuracy: {}/{} ({:.2f}%)\n'.format(
        correct, len(data_loader_test.dataset),
        100. * correct / len(data_loader_test.dataset)))


for epoch in range(1,6):
    train(epoch)
    test()



