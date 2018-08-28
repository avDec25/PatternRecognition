import numpy as np, pdb
import random, itertools
import matplotlib.pyplot as plt

deg = 2

''' Loading data '''

data = []
with open('./data_1D.txt') as f:
	for line in f:
		entry = map(float, line.strip().split())
		data.append((entry[:-1], entry[-1]))

n = len(data)
m = len(data[0][0])

indices = range(n)
random.shuffle(indices)

n_train = int(n * 0.7)
n_test  = n - n_train

train, test = indices[0: n_train], indices[n_train: ]

x_all = np.float32([data[i][0] for i in range(n)])
Y_all = np.float32([data[i][1] for i in range(n)])

X_all = np.ones( (n,1), np.float32)

for i,j in itertools.combinations_with_replacement(range(m), deg):
	X_all = np.hstack( (X_all, x_all[:,i:i+1] * x_all[:,j:j+1]))

X_train = X_all[train, ]
X_test  = X_all[test, ]

Y_train = Y_all[train, ]
Y_test  = Y_all[test, ]

print X_train.shape, Y_train.shape
print X_test.shape, Y_test.shape

def RSE(W, X, Y):
	return np.sum((np.matmul(X, W) - Y) * (np.matmul(X,W) - Y))

temp = np.linalg.inv( np.matmul(X_train.T, X_train) + 0.01 * np.identity(X_all.shape[1]))
W    = np.matmul(temp, np.matmul(X_train.T, Y_train))

print 'Final Test error', RSE(W, X_test, Y_test)