library(jpeg)
library(ggplot2)
library(raster)
source("GammaSAR.R")
source("imagematrix.R")
# Set seed value
set.seed(1234)
# set I/O directories
# Input
# Image labels test
dir_test_labels <- "../../Data/road_optical/tiff/test_labels"
fnames_test_labels <- list.files(dir_test_labels)
dim_img_test_labels <- length(fnames_test_labels)
# Image test
dir_test <- "../../Data/road_optical/tiff/test"
fnames_test <- list.files(dir_test)
dim_img_test <- length(fnames_test)
# Image train
dir_train <- "../../Data/road_optical/tiff/train"
fnames_train <- list.files(dir_train)
dim_img_train <- length(fnames_train)
# Image labels train 
dir_train_labels <- "../../Data/road_optical/tiff/train_labels"
fnames_train_labels <- list.files(dir_train_labels)
dim_img_train_labels <- length(fnames_train_labels)
# Image val
dir_val <- "../../Data/road_optical/tiff/val"
fnames_val <- list.files(dir_val)
dim_img_val <- length(fnames_val)
# Image labels val 
dir_val_labels <- "../../Data/road_optical/tiff/val_labels"
fnames_val_labels <- list.files(dir_val_labels)
dim_img_val_labels <- length(fnames_val_labels)
# Test Image
img_test <- list()
img_test_labels <- list()
for (i in 1:dim_img_test){
  join_path_test <- file.path(dir_test, fnames_test[[i]])
  img_aux_test <- stack(join_path_test)
  img_test[[i]] <- img_aux_test
  #
  join_path_test_labels <- file.path(dir_test_labels, fnames_test_labels[[i]])
  img_aux_test_labels <- stack(join_path_test_labels)
  img_test_labels[[i]] <- img_aux_test_labels
}
# Train Image
img_train <- list()
img_train_labels <- list()
for (i in 1:dim_img_train){
  join_path_train <- file.path(dir_train, fnames_train[[i]])
  img_aux_train <- stack(join_path_train)
  img_train[[i]] <- img_aux_train
  #
  join_path_train_labels <- file.path(dir_train_labels, fnames_train_labels[[i]])
  img_aux_train_labels <- stack(join_path_train_labels)
  img_train_labels[[i]] <- img_aux_train_labels
}
# val Image
img_val <- list()
img_val_labels <- list()
for (i in 1:dim_img_val){
  join_path_val <- file.path(dir_val, fnames_val[[i]])
  img_aux_val <- stack(join_path_val)
  img_val[[i]] <- img_aux_val
  #
  join_path_val_labels <- file.path(dir_val_labels, fnames_val_labels[[i]])
  img_aux_val_labels <- stack(join_path_val_labels)
  img_val_labels[[i]] <- img_aux_val_labels
}
# Output 
aux_sim <- "simulated_8_classes"
# Test
dir_test_8_class_sim <- "../../Data/dataset_8_class_sim/test_8_class_sim"
# Train
dir_train_8_class_sim <- "../../Data/dataset_8_class_sim/train_8_class_sim"
# val
dir_val_8_class_sim <- "../../Data/dataset_8_class_sim/train_8_class_sim"
#
n <- 8
# Dataset test
cat("Builting test dataset")
#dim_img_test <- length(fnames_test)
dim_img_test <- 2
for (i in 1:dim_img_test){
  #image <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
  image <- img_test[[i]]
  image_map <- img_test_labels[[i]]
  #image_map <- stack("../../Data/road_optical/jpeg/27028720_15_map.tiff")
  # Convert the image to grayscale by averaging the RGB channels
  grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
  # Clustreing with n centers
  # Run K-Means clustering
  kMeansResult <- kmeans(grayscale_image[], centers=n)
  # Create a mask from the K-means clustering result
  kmeans_mask <- matrix(kMeansResult$cluster, nrow = nrow(grayscale_image), ncol = ncol(grayscale_image))
  # Convert the mask to a raster
  kmeans_raster <- raster(t(kmeans_mask))
  # Normalize the image
  normalized_image <- calc(image_map, fun = function(x) { x / 255 })
  normalized_image <- (n + 1) * normalized_image
  # Merge the raster images 
  extent(kmeans_raster) <- extent(normalized_image)
  merged_raster <- overlay(kmeans_raster, normalized_image, fun = max)
  # Insert gamma noise
  L <- 3
  sum_img_pixels1 <- cellStats(merged_raster==1, sum)
  sum_img_pixels2 <- cellStats(merged_raster==2, sum)
  sum_img_pixels3 <- cellStats(merged_raster==3, sum)
  sum_img_pixels4 <- cellStats(merged_raster==4, sum)
  sum_img_pixels5 <- cellStats(merged_raster==5, sum)
  sum_img_pixels6 <- cellStats(merged_raster==6, sum)
  sum_img_pixels7 <- cellStats(merged_raster==7, sum)
  sum_img_pixels8 <- cellStats(merged_raster==8, sum)
  sum_img_road    <- cellStats(merged_raster==9, sum)
  #
  SARclass1 <- rGI0(sum_img_pixels1, a= -15, g= 140, L)
  SARclass2 <- rGI0(sum_img_pixels2, a= -15, g= 420, L)
  SARclass3 <- rGI0(sum_img_pixels3, a= -5,  g= 280, Lcal)
  SARclass4 <- rGI0(sum_img_pixels4, a= -12, g= 2200, Lcal)
  SARclass5 <- rgammaSAR(sum_img_pixels5, L, 250)
  SARclass6 <- rgammaSAR(sum_img_pixels6, L, 50)
  SARclass7 <- rgammaSAR(sum_img_pixels7, L, 350)
  SARclass8 <- rgammaSAR(sum_img_pixels8, L, 400)
  SARroad   <- rgammaSAR(sum_img_road, L, 10)
  #
  SAR <- merged_raster
  SAR[merged_raster==1] <- SARclass1
  SAR[merged_raster==2] <- SARclass2
  SAR[merged_raster==3] <- SARclass3
  SAR[merged_raster==4] <- SARclass4
  SAR[merged_raster==5] <- SARclass5
  SAR[merged_raster==6] <- SARclass6
  SAR[merged_raster==7] <- SARclass7
  SAR[merged_raster==8] <- SARclass8
  SAR[merged_raster==9] <- SARroad
  # Image Equalize using ecdf
  #EQSAR <- equalize_ecdf(SAR)
  filename_img <- paste0(fnames_test[[i]],"_",aux_sim,".tiff")
  filename <- file.path(dir_test_8_class_sim, filename_img)
  # Define a grayscale palette with 8 colors
  #grayscale_palette <- gray.colors(n, start = 0, end = 1)
  writeRaster(SAR, filename, format = "GTiff")
}
# dataset train
#dim_img_train <- length(fnames_train)
cat("Builting train dataset")
dim_img_train <- 2
for (i in 1:dim_img_train){
  image <- img_train[[i]]
  image_map <- img_train_labels[[i]]
  # Convert the image to grayscale by averaging the RGB channels
  grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
  # Clustreing with n centers
  # Run K-Means clustering
  kMeansResult <- kmeans(grayscale_image[], centers=n)
  # Create a mask from the K-means clustering result
  kmeans_mask <- matrix(kMeansResult$cluster, nrow = nrow(grayscale_image), ncol = ncol(grayscale_image))
  # Convert the mask to a raster
  kmeans_raster <- raster(t(kmeans_mask))
  # Normalize the image
  normalized_image <- calc(image_map, fun = function(x) { x / 255 })
  normalized_image <- (n + 1) * normalized_image
  # Merge the raster images 
  extent(kmeans_raster) <- extent(normalized_image)
  merged_raster <- overlay(kmeans_raster, normalized_image, fun = max)
  # Insert gamma noise
  L <- 3
  sum_img_pixels1 <- cellStats(merged_raster==1, sum)
  sum_img_pixels2 <- cellStats(merged_raster==2, sum)
  sum_img_pixels3 <- cellStats(merged_raster==3, sum)
  sum_img_pixels4 <- cellStats(merged_raster==4, sum)
  sum_img_pixels5 <- cellStats(merged_raster==5, sum)
  sum_img_pixels6 <- cellStats(merged_raster==6, sum)
  sum_img_pixels7 <- cellStats(merged_raster==7, sum)
  sum_img_pixels8 <- cellStats(merged_raster==8, sum)
  sum_img_road    <- cellStats(merged_raster==9, sum)
  #
  SARclass1 <- rGI0(sum_img_pixels1, a= -15, g= 140, L)
  SARclass2 <- rGI0(sum_img_pixels2, a= -15, g= 420, L)
  SARclass3 <- rGI0(sum_img_pixels3, a= -5,  g= 280, Lcal)
  SARclass4 <- rGI0(sum_img_pixels4, a= -12, g= 2200, Lcal)
  SARclass5 <- rgammaSAR(sum_img_pixels5, L, 250)
  SARclass6 <- rgammaSAR(sum_img_pixels6, L, 50)
  SARclass7 <- rgammaSAR(sum_img_pixels7, L, 350)
  SARclass8 <- rgammaSAR(sum_img_pixels8, L, 400)
  #
  SAR <- merged_raster
  SAR[merged_raster==1] <- SARclass1
  SAR[merged_raster==2] <- SARclass2
  SAR[merged_raster==3] <- SARclass3
  SAR[merged_raster==4] <- SARclass4
  SAR[merged_raster==5] <- SARclass5
  SAR[merged_raster==6] <- SARclass6
  SAR[merged_raster==7] <- SARclass7
  SAR[merged_raster==8] <- SARclass8
  SAR[merged_raster==9] <- SARroad
  # Image Equalize using ecdf
  #EQSAR <- equalize_ecdf(SAR)
  filename_img <- paste0(fnames_train[[i]],"_",aux_sim,".tiff")
  filename <- file.path(dir_train_8_class_sim, filename_img)
  # Define a grayscale palette with 8 colors
  #grayscale_palette <- gray.colors(n, start = 0, end = 1)
  writeRaster(SAR, filename, format = "GTiff")
}
# dataset val
#dim_img_val <- length(fnames_val)
cat("Builting val dataset")
dim_img_val <- 2
for (i in 1:dim_img_val){
  image <- img_val[[i]]
  image_map <- img_val_labels[[i]]
  # Convert the image to grayscale by averaging the RGB channels
  grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
  # Clustreing with n centers
  # Run K-Means clustering
  kMeansResult <- kmeans(grayscale_image[], centers=n)
  # Create a mask from the K-means clustering result
  kmeans_mask <- matrix(kMeansResult$cluster, nrow = nrow(grayscale_image), ncol = ncol(grayscale_image))
  # Convert the mask to a raster
  cat("here 1")
  kmeans_raster <- raster(t(kmeans_mask))
  # Normalize the image
  normalized_image <- calc(image_map, fun = function(x) { x / 255 })
  normalized_image <- (n + 1) * normalized_image
  # Merge the raster images 
  extent(kmeans_raster) <- extent(normalized_image)
  merged_raster <- overlay(kmeans_raster, normalized_image, fun = max)
  # Insert gamma noise
  cat("here 2")
  L <- 3
  sum_img_pixels1 <- cellStats(merged_raster==1, sum)
  sum_img_pixels2 <- cellStats(merged_raster==2, sum)
  sum_img_pixels3 <- cellStats(merged_raster==3, sum)
  sum_img_pixels4 <- cellStats(merged_raster==4, sum)
  sum_img_pixels5 <- cellStats(merged_raster==5, sum)
  sum_img_pixels6 <- cellStats(merged_raster==6, sum)
  sum_img_pixels7 <- cellStats(merged_raster==7, sum)
  sum_img_pixels8 <- cellStats(merged_raster==8, sum)
  sum_img_road    <- cellStats(merged_raster==9, sum)
  #
  SARclass1 <- rGI0(sum_img_pixels1, a= -15, g= 140, L)
  SARclass2 <- rGI0(sum_img_pixels2, a= -15, g= 420, L)
  SARclass3 <- rGI0(sum_img_pixels3, a= -5,  g= 280, Lcal)
  SARclass4 <- rGI0(sum_img_pixels4, a= -12, g= 2200, Lcal)
  SARclass5 <- rgammaSAR(sum_img_pixels5, L, 250)
  SARclass6 <- rgammaSAR(sum_img_pixels6, L, 50)
  SARclass7 <- rgammaSAR(sum_img_pixels7, L, 350)
  SARclass8 <- rgammaSAR(sum_img_pixels8, L, 400)
  #
  SAR <- merged_raster
  SAR[merged_raster==1] <- SARclass1
  SAR[merged_raster==2] <- SARclass2
  SAR[merged_raster==3] <- SARclass3
  SAR[merged_raster==4] <- SARclass4
  SAR[merged_raster==5] <- SARclass5
  SAR[merged_raster==6] <- SARclass6
  SAR[merged_raster==7] <- SARclass7
  SAR[merged_raster==8] <- SARclass8
  SAR[merged_raster==9] <- SARroad
  # Image Equalize using ecdf
  #EQSAR <- equalize_ecdf(SAR)
  cat("here 3")
  filename_img <- paste0(fnames_val[[i]],"_",aux_sim,".tiff")
  filename <- file.path(dir_val_8_class_sim, filename_img)
  cat("here 4")
  # Define a grayscale palette with 8 colors
  #grayscale_palette <- gray.colors(n, start = 0, end = 1)
  writeRaster(SAR, filename, format = "GTiff")
}
#teste <- stack("../../Data/dataset_8_class_sim/train_8_class_sim/10078660_15.tiff_simulated_8_classes.tiff")
#plot(teste, col = grayscale_palette, main = "Raster Image with 8 Grayscale Colors")