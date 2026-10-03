import numpy as np
import matplotlib.pyplot as plt

gamma = np.array([
    5.12, 2.56, 1.71, 1.28, 1,
    0.85, 0.73, 0.64, 0.512, 0.256, 0.102
])

R = np.array([
    0.031, 0.024, 0.034, 0.070, 23,
    0.077, 0.035, 0.030, 0.020, 0.013, 0.011
])

# 按 gamma 从小到大排序
idx = np.argsort(gamma)
gamma = gamma[idx]
R = R[idx]

# ===== 全局图 =====
plt.figure(figsize=(7, 5))

plt.plot(gamma, R, '-o', linewidth=1.8)

# gamma 跨度较大，同时 R 在 gamma=1 处有巨大峰值
plt.xscale('log')
plt.yscale('log')

plt.xlabel(r'$\gamma$', fontsize=14)
plt.ylabel(r'$R_{\mathrm{empirical}}$', fontsize=14)

plt.grid(True, which='both', alpha=0.3)
plt.tight_layout()
plt.show()


# ===== gamma > 1 局部放大 =====
mask = gamma > 1

g = gamma[mask]
r = R[mask]

plt.figure(figsize=(7, 5))

plt.plot(g, r, '-o', linewidth=1.8)

plt.xlabel(r'$\gamma$', fontsize=14)
plt.ylabel(r'$R_{\mathrm{empirical}}$', fontsize=14)

# 手动限制纵轴，突出小量之间的区别
plt.ylim(0.018, 0.076)

for x, y in zip(g, r):
    plt.text(x, y + 0.0015, f'{y:.3f}',
             ha='center', fontsize=10)

plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()