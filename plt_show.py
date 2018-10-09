
NR_FIGURES=6
NR_RECORDS=10+1
X = []
Y = []
LABELS = ["8", "32", "128", "512", "2048", "4096"]

with open("output.csv", "r") as fin:
    lines = fin.read().splitlines()
    for i in range(NR_FIGURES):
        X0 = []
        Y0 = []
        for j in range(NR_RECORDS):
            if j == 0:
                continue
            off = i * NR_RECORDS + j
            x, y = lines[off].split(',')
            X0.append(int(x))
            Y0.append(float(y))
        X.append(X0)
        Y.append(Y0)
    print(X, Y)

import matplotlib.pyplot as plt

for i in range(NR_FIGURES):
    plt.plot(X[i], Y[i], label=LABELS[i])
plt.xlabel("nr_concurr_msgs")
plt.ylabel("throughput (Mops)")
plt.legend()
plt.show()

