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
img_test <- list()
for (i in 1:dim_img_test){
  join_path <- file.path(dir_test_labels, fnames_test_labels[[i]])
  img_aux <- readTIFF(join_path)
  img_test[[i]] <- img_aux 
}
n_sample_test <- 4
img_test_sample <- sample(img_test, n_sample_test)
# Set parameters to build matrix cropped
nKerFilter <- 21
dimg <- 100
niter <- 100
k <- 4
rep <- 15
nKerPotts <- 2
#
NumImagBack <- 4
MatList <- list()
MatListAux <- list()
Classes1pRoads <- list()
SARImage <- list()
for (i in 1:NumImagBack){
  MatListAux <- build_potts_matrix_crop(nKerFilter, dimg, niter, k, nKerPotts)
  RepImg <- matrix_replicate(MatListAux[[2]], rep)
  SARImage_aux <- list()
  for (j in 1: n_sample_test){
    roads <- img_test_sample[[j]] 
    Classes1pRoads <- pmax(RepImg, roads*(k+1))
    ## Distributions and data for Classes1pRoads
    L <- 4
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
    SARImage_aux[[j]] <- SAR1
    }
  SARImage[[i]] <- SARImage_aux
}
dir_road_sim_visapp_img <- "../../Data/road_sim_visapp/img"
dir_road_sim_visapp_img_label <- "../../Data/road_sim_visapp/img_label"
for (i in 1:NumImagBack){
  for (j in 1: n_sample_test){
    filename_img       <- paste0(i,"_",j,".tiff")
    filename1 <- file.path(dir_road_sim_visapp_img, filename_img)
    filename2 <- file.path(dir_road_sim_visapp_img_label, filename_img)
    imagematrixTiff(imagematrix(equalize(SARImage[[i]][[j]])), name =filename1)
    imagematrixTiff(imagematrix(img_test_sample[[j]]), name =filename2)
  }
}