library(ggplot2)
library(raster)
# Load the image
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
plot(imagematrix(img_test))
# Set seed value
set.seed(1234)

# Run K-Means clustering
kMeansResult <- kmeans(img_test, centers=2)
#
# Convert image data to raster object
result <- raster(img_test)

# Set cluster values
#result <- setValues(result, kMeansResult$cluster)