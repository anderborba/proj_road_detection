library(jpeg)
library(ggplot2)
library(raster)
#
image <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
#image <- stack("../../Data/SAR/campan_10501_15033_007_150402_L090_CX_01_pauli.tif")
#
plotRGB(image)
# Set seed value
set.seed(1234)

# Run K-Means clustering
kMeansResult <- kmeans(image[], centers=2)
#
# Convert image data to raster object
result <- raster(image[[1]])

# Set cluster values
result <- setValues(result, kMeansResult$cluster)
#
plot(result)
#
plot(result, col=c("lightyellow", "black"))
#
# Clustering with 3 centers
#
# Run K-Means clustering
kMeansResult <- kmeans(image[], centers=3)
# Convert image data to raster object
result <- raster(image[[1]])

# Set cluster values
result <- setValues(result, kMeansResult$cluster)
#
plot(result)
#
plot(result, col=c("lightyellow", "darkblue", "black"))
#
# Custreing with 4 centers
#
# Run K-Means clustering
kMeansResult <- kmeans(image[], centers=4)
# Convert image data to raster object
result <- raster(image[[1]])

# Set cluster values
result <- setValues(result, kMeansResult$cluster)
#
plot(result)
#
plot(result, col=c("lightyellow", "darkblue", "black"))
#
# Custreing with 8 centers
#
# Run K-Means clustering
kMeansResult <- kmeans(image[], centers=8)
# Convert image data to raster object
result <- raster(image[[1]])

# Set cluster values
result <- setValues(result, kMeansResult$cluster)
#
plot(result)
#
plot(result, col=c("lightyellow", "darkblue", "black"))
dim <- dim(image)
cat("dim", dim)
#cat("Clusters kmeans", kMeansResult$cluster)
cat("Centers kmeans", kMeansResult$centers)
