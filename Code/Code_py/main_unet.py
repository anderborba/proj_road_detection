import os, cv2
import numpy as np
import pandas as pd
import random, tqdm
import seaborn as sns
import matplotlib.pyplot as plt
#%matplotlib inline

import warnings
warnings.filterwarnings("ignore")

import torch
import torch.nn as nn
from torch.utils.data import DataLoader
import albumentations as album
#
import segmentation_models_pytorch as smp
#
# Define directories (train, val, test)
DATA_DIR = './Data/road_data/tiff/'
#
x_train_dir = os.path.join(DATA_DIR, 'train_sar')
y_train_dir = os.path.join(DATA_DIR, 'train_labels')
#
x_valid_dir = os.path.join(DATA_DIR, 'val_sar')
y_valid_dir = os.path.join(DATA_DIR, 'val_labels')
#
x_test_dir = os.path.join(DATA_DIR, 'test_sar')
y_test_dir = os.path.join(DATA_DIR, 'test_labels')
#
#directory = os.path.dirname()
dirname = os.path.dirname(__file__)
print(dirname)
#image = str(image_name) + '.pdf'
#file_path = os.path.join(directory, image)
#class_dict = pd.read_csv("./Data/road_data/label_class_dict.csv")
#class_dict = pd.read_csv("/home/aborba/github/proj_road_detection/Data/road_data/label_class_dict.csv")
#class_names = class_dict['name'].tolist()
#print(class_names)
