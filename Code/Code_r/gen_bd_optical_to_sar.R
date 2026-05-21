# Code to generate dataset from optical dataset to SAR dataset 
rm(list=ls())
require(tiff)
require(ggplot2)
library("raster")
# Libraries own
source("imagematrix.R")
source("GammaSAR.R")
###################################
dir_test_labels <- "../../Data/road_optical/tiff/test_labels"
dir_test <- "../../Data/road_optical/tiff/test"
#
fnames_test_labels <- list.files(dir_test_labels)
fnames_test <- list.files(dir_test)
#
dim_img_test <- length(fnames_test_labels)
dim_img <- length(fnames_test)
#
join_path_test_labels <- file.path(dir_test_labels, fnames_test_labels[[1]])
join_path_test <- file.path(dir_test, fnames_test[[1]])
#
img_test_labels <- readTIFF(join_path_test_labels)
img_test        <- readTIFF(join_path_test)
#
#plot(imagematrix(img_test_labels))
plot(imagematrix(img_test))
#
kClusters <- 4
kMeans <- kmeans(img_test, centers = kClusters)
#
plot(kMeans$centers)
#kColours <- rgb(kMeans$centers[kMeans$cluster,])
# Obtain the dimension
#imgDm <- dim(img_test)

# Assign RGB channels to data frame
#imgRGB <- data.frame(
#  x = rep(1:imgDm[2], each = imgDm[1]),
#  y = rep(imgDm[1]:1, imgDm[2]),
#  R = as.vector(img_test[,,1]),
#  G = as.vector(img_test[,,2]),
#  B = as.vector(img_test[,,3])
#)
#
# ggplot theme to be used
#plotTheme <- function() {
#  theme(
#    panel.background = element_rect(
#      size = 3,
#      colour = "black",
#      fill = "white"),
#    axis.ticks = linewidth(
#      size = 2),
#    panel.grid.major = linewidth(
#      colour = "gray80",
#      linetype = "dotted"),
#    panel.grid.minor = linewidth(
#      colour = "gray90",
#      linetype = "dashed"),
#    axis.title.x = element_text(
#      size = rel(1.2),
#      face = "bold"),
#    axis.title.y = element_text(
#      size = rel(1.2),
#      face = "bold"),
#    plot.title = element_text(
#      size = 20,
#      face = "bold",
#      vjust = 1.5)
#  )
#}

# Plot the image
#ggplot(data = imgRGB, aes(x = x, y = y)) + 
#  geom_point(colour = rgb(imgRGB[c("R", "G", "B")])) +
#  labs(title = "Original Image: Colorful Bird") +
#  xlab("x") +
#  ylab("y") +
#  plotTheme()

#imagematrixTiff(im agematrix(img))
#
#dir_road_sim_visapp_img <- "../../Data/road_sim_visapp/img_madeia"
#dir_road_sim_visapp_img_label <- "../../Data/road_sim_visapp/img_label_madeia"
#SARImage_aux <- list()
#L <- 3
#for (j in 1: n_sample_test){
#for (j in 1: 2){
#  join_path <- file.path(dir_test_labels, fnames_test_labels[[j]])
#  img_aux_label <- readTIFF(join_path)
  #img_aux <- img_aux_label
  #roads_noise_aux <- img_aux
  #aux_noise <- rgammaSAR(sum(roads_noise_aux==1), L, 0.7)
  #img_aux[roads_noise_aux==1] <- aux_noise
  #Classes1pRoads <- pmax(RepImg, img_aux*(k+1))
  ## Distributions and data for Classes1pRoads
  # Increasingly brighter classes
  #SARclass1 <- rgammaSAR(sum(Classes1pRoads==1), L, 50)
  #SARclass2 <- rgammaSAR(sum(Classes1pRoads==2), L, 100)
  #SARclass3 <- rgammaSAR(sum(Classes1pRoads==3), L, 150)
  #SARclass4 <- rgammaSAR(sum(Classes1pRoads==4), L, 200)
  #
  #SAR1 <- Classes1pRoads
  #
  #SAR1[Classes1pRoads==1] <- SARclass1
  #SAR1[Classes1pRoads==2] <- SARclass2 
  #SAR1[Classes1pRoads==3] <- SARclass3
  #SAR1[Classes1pRoads==4] <- SARclass4
  #
  #SARImage <- SAR1
  #
  #filename_img <- paste0(1,"_",j,".tiff")
  #filename1 <- file.path(dir_road_sim_visapp_img, filename_img)
  #filename2 <- file.path(dir_road_sim_visapp_img_label, filename_img)
  #imagematrixTiff(imagematrix(equalize(SARImage)), name =filename1)
  #imagematrixTiff(imagematrix(img_aux_label), name =filename2)
#  imagematrixTiff(imagematrix(img_aux_label))
  #filename2 <- file.path(dir_road_sim_visapp_img_label, img_aux)
  #  }
#}