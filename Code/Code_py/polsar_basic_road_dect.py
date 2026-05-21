import matplotlib.pyplot as plt
import numpy as np
#
def show_image(IMG, nrows, ncols, img_rt):
    plt.figure(figsize=(20*img_rt, 20))
    escale = np.mean(IMG)*2
    plt.imshow(IMG,clim=(0.0, escale), cmap="gray")
    plt.show()
#
#def show_image_max(IMG, nrows, ncols, img_rt):
#    plt.figure(figsize=(20*img_rt, 20))
#    escale = np.max(IMG)
#    IMG = IMG / escale
#    plt.imshow(IMG,clim=(0.0, escale), cmap="gray")
#    #plt.imshow(IMG, cmap="gray")
#    plt.show()
