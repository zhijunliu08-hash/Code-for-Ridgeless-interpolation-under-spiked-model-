import numpy as np
np.random.seed(42)
#import matplotlib.pyplot as plt
#data = np.load("cifar10_resnet18_features.npz")
data=np.load(
    r"D:\刘芷君小论文\double descent\cifar10_resnet18_features.npz"
)
#print(data.files)
#for k in data.files:
#    print(k, data[k].shape)
n_list=[100,150,200,250,300,350,400,450,512,600,650,700,750,800,1000,2000,5000]

#提取训练集和测试集
X_train=data["train"]
X_test=data["test"]    
#中心化
mu=X_train.mean(axis=0)
X_train=X_train-mu
X_test=X_test-mu
# 计算原始数据的covariance matrix
Sigma=X_train.T@X_train/X_train.shape[0]
# eigenvalues
eigvals=np.linalg.eigvalsh(Sigma)

eigvals=eigvals[::-1]
print("Top 20 eigenvalues:")
print(eigvals[:20])

#构造真实参数beta*
beta_star=np.random.randn(512)
beta_star=beta_star/np.linalg.norm(beta_star)
#构造训练标签
noise_level=0.1
epsilon=noise_level*np.random.randn(len(X_train))
y_train=X_train@beta_star+epsilon
#构造测试标签
epsilon_test=noise_level*np.random.randn(len(X_test))
y_test=X_test@beta_star+epsilon_test

for n in n_list:
     idx=np.random.choice(
        len(X_train),
        n,
        replace=False
    )

     X=X_train[idx]
     y=y_train[idx]
     beta_hat=np.linalg.pinv(X)@y


     pred=X_test@beta_hat


     risk=np.mean(
        (pred-y_test)**2
     )
     print(
        n,
        512/n,
        risk
     )


#计算无岭最小二乘
#beta_hat=np.linalg.solve(
 #   X_train.T@X_train,
  #  X_train.T@y_train
#)
#计算empirical risk
#y_pred=X_test@beta_hat
#R_empirical=np.mean(
#    (y_test-y_pred)**2
#)
#print(R_empirical)