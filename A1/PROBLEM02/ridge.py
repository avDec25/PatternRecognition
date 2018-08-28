import numpy as np
import random
import matplotlib.pyplot as plt

''' Loading data '''

data = []
with open('./data_2D.txt') as f:
	for line in f:
		entry = map(float, line.strip().split())
		data.append((entry[:-1], entry[-1]))

n = len(data)
m = len(data[0][0])

indices = range(n)
random.shuffle(indices)

n_train = int(n * 0.7)
n_valid = int(n * 0.2)
n_test  = n - n_train - n_valid

train, test, valid = indices[0: n_train], indices[n_train: n_train + n_valid], indices[n_train + n_valid: ]

x_train = np.float32([data[i][0] for i in train])
x_valid = np.float32([data[i][0] for i in valid])
x_test  = np.float32([data[i][0] for i in test])

Y_train = np.float32([data[i][1] for i in train])
Y_valid = np.float32([data[i][1] for i in valid])
Y_test  = np.float32([data[i][1] for i in test])

print x_train.shape, x_valid.shape, x_test.shape
print Y_train.shape, Y_valid.shape, Y_test.shape

''' Append 1 column in X '''
X_train = np.zeros((x_train.shape[0],x_train.shape[1]+1)); X_train[:,:-1] = x_train
X_valid = np.zeros((x_valid.shape[0],x_valid.shape[1]+1)); X_valid[:,:-1] = x_valid
X_test = np.zeros((x_test.shape[0],x_test.shape[1]+1)); X_test[:,:-1] = x_test

print X_train.shape, X_valid.shape, X_test.shape
print Y_train.shape, Y_valid.shape, Y_test.shape

def RSE(W, X, Y):
	return np.sum((np.matmul(X, W) - Y) * (np.matmul(X,W) - Y))


''' Getting right lambda '''
ldb_res = []
for lbd in np.linspace(0.000001, 10, num = 5000):
	temp = np.linalg.inv( np.matmul(X_train.T, X_train) + np.identity(m + 1)*lbd)
	W    = np.matmul(temp, np.matmul(X_train.T, Y_train))

	ldb_res.append( (lbd, RSE(W, X_valid, Y_valid)))

plt.plot( [ele[0] for ele in ldb_res], [ele[1] for ele in ldb_res])
plt.show()


print 'Final Test error', RSE(W, X_test, Y_test)


# W =  X_train.T @ Y_train