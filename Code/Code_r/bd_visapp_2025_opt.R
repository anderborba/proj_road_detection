# Visapp data base
rm(list=ls())
require(bayesImageS)
require(tiff)
require(reshape)
# Libraries
require(bayesImageS)
require(tiff)
require(ggplot2)
require(reshape)
library("raster")
# Libraries own
source("imagematrix.R")
source("GammaSAR.R")
source("build_potts_matrix_crop.R")
source("matrix_replicate.R")
###################################
dir_test_labels <- "../../Data/road_optical/tiff/test_labels"
#
#dir_train_labels <- "../../Data/road_optical/tiff/train_labels"
#
#dir_val_labels <- "../../Data/road_optical/tiff/val_labels"
#
fnames_test_labels <- list.files(dir_test_labels)
#
#fnames_train_labels <- list.files(dir_train_labels)
#
#fnames_val_labels <- list.files(dir_val_labels)
#
dim_img_test <- length(fnames_test_labels)
#dim_img_train <- length(fnames_train_labels)
#dim_img_val <- length(fnames_val_labels)
#img_test <- list()
n_sample_test <- 40
# Set parameters to build matrix cropped
nKerFilter <- 21
dimg <- 100
niter <- 100
k <- 4
rep <- 15
nKerPotts <- 2
#
dir_road_sim_visapp_img <- "../../Data/road_sim_visapp/img"
dir_road_sim_visapp_img_label <- "../../Data/road_sim_visapp/img_label"
#
NumImagBack <- 40
MatList <- list()
MatListAux <- list()
Classes1pRoads <- list()
SARImage <- list()
for (i in 1:NumImagBack){
  MatListAux <- build_potts_matrix_crop(nKerFilter, dimg, niter, k, nKerPotts)
  RepImg <- matrix_replicate(MatListAux[[2]], rep)
  SARImage_aux <- list()
  L <- 3
  for (j in 1: n_sample_test){
    join_path <- file.path(dir_test_labels, fnames_test_labels[[j]])
    img_aux_label <- readTIFF(join_path)
    img_aux <- img_aux_label
    roads_noise_aux <- img_aux
    aux_noise <- rgammaSAR(sum(roads_noise_aux==1), L, 0.7)
    img_aux[roads_noise_aux==1] <- aux_noise
    Classes1pRoads <- pmax(RepImg, img_aux*(k+1))
    ## Distributions and data for Classes1pRoads
    # Increasingly brighter classes
    SARclass1 <- rgammaSAR(sum(Classes1pRoads==1), L, 50)
    SARclass2 <- rgammaSAR(sum(Classes1pRoads==2), L, 100)
    SARclass3 <- rgammaSAR(sum(Classes1pRoads==3), L, 150)
    SARclass4 <- rgammaSAR(sum(Classes1pRoads==4), L, 200)
    #
    SAR1 <- Classes1pRoads
    #
    SAR1[Classes1pRoads==1] <- SARclass1
    SAR1[Classes1pRoads==2] <- SARclass2 
    SAR1[Classes1pRoads==3] <- SARclass3
    SAR1[Classes1pRoads==4] <- SARclass4
    #
    SARImage <- SAR1
    #
    filename_img       <- paste0(i,"_",j,".tiff")
    filename1 <- file.path(dir_road_sim_visapp_img, filename_img)
    filename2 <- file.path(dir_road_sim_visapp_img_label, filename_img)
    imagematrixTiff(imagematrix(equalize(SARImage)), name =filename1)
    imagematrixTiff(imagematrix(img_aux_label), name =filename2)
  }
}