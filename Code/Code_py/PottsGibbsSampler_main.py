import numpy as np
import matplotlib.pyplot as plt
#
def PottsGibbsSampler(lado,beta,replic):
    x1 = np.random.binomial(1, 0.5, lado * lado)
    x1 = np.reshape(x1, (lado,lado))
    plt.imshow(x1)
    plt.show()
    #
    ker = 6
    soma_viz = np.zeros(ker)
    for i in range(ker):
        soma_viz[i] = i
    prob_viz = np.exp(beta*soma_viz) / (np.exp(beta * (4 - soma_viz)) + np.exp(beta * soma_viz))
    lm1 = lado - 1
    r = 0
    while r < replic:
        r = r + 1
        for i in range(1,lm1):
            for j in range(1,lm1):
                soma_viz = x1[i-1,j] + x1[i+1,j] + x1[i,j-1] + x1[i,j+1]
                x1[i,j] = np.random.binomial(1, prob_viz[soma_viz])
    return(x1)
# main()
lado = 128
beta = 0.8
replic = 100
x = PottsGibbsSampler(lado,beta,replic)
print(type(x))
print(np.max(x))
print(np.min(x))
plt.imshow(x)
plt.show()
