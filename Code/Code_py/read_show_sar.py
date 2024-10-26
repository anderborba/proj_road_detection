from osgeo import gdal
import numpy as np
import matplotlib.pyplot as plt
#
import polsar_basic_road_dect as pbrd
#
#dataset = gdal.Open("../../Data/Sentinel01/slc_data/S1_230081_IW1_20240318T021755_VV_CC51-BURST.tiff", gdal.GA_ReadOnly)
dataset = gdal.Open("../../Data/Sentinel01/teste_1/S1B_WV_SLC__1SSH_20170703T134605_20170703T141442_006324_00B1EA_F61F.SAFE/measurement/s1b-wv1-slc-hh-20170703t134605-20170703t134608-006324-00b1ea-001.tiff", gdal.GA_ReadOnly)
for x in range(1, dataset.RasterCount + 1):
    band = dataset.GetRasterBand(x)
    array = band.ReadAsArray()
#
print(band)
print(array)
print(np.max(array))
print(np.min(array))
#print(len(array))
#
ImgReal    = array.real
ImgComplex = array.imag
#
print(type(ImgReal))
print(type(ImgComplex))
print(ImgReal.shape)
print(ImgComplex.shape)

[nrows, ncols] = ImgReal.shape
print(nrows)
print(ncols)
img_rt = nrows/ncols
#img_rt = ncols/nrows
#print(img_rt)
pbrd.show_image(ImgReal, nrows, ncols, img_rt)
#pbrd.show_image(ImgComplex, nrows, ncols, img_rt)
#pbrd.show_image_max(ImgReal, nrows, ncols, img_rt)
#pbrd.show_image_max(ImgComplex, nrows, ncols, img_rt)
plt.hist(ImgReal)
plt.show()
