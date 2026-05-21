library(jpeg)
library(ggplot2)
library(raster)
library(reshape2)
library(ggthemes)
source("GammaSAR.R")
source("imagematrix.R")
#library(magick)
#
# Set seed value
set.seed(1234)
image <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
image_map <- stack("../../Data/road_optical/jpeg/27028720_15_map.tiff")
# Convert the image to grayscale by averaging the RGB channels
grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
# Clustreing with n centers
# Run K-Means clustering
n <- 4
kMeansResult <- kmeans(grayscale_image[], centers=n)
# Convert image data to raster object
centers <- kMeansResult$centers
cat("K centers", centers)
# Create a mask from the K-means clustering result
kmeans_mask <- matrix(kMeansResult$cluster, nrow = nrow(grayscale_image), ncol = ncol(grayscale_image))

# Convert the mask to a raster
kmeans_raster <- raster(t(kmeans_mask))
plot(kmeans_raster)
# Set cluster values
result <- setValues(result, kMeansResult$cluster)
# Normalize the image
dimension1 <- dim(kmeans_raster)
dimension2 <- dim(image_map)
normalized_image <- calc(image_map, fun = function(x) { x / 255 })
normalized_image <- (n + 1) * normalized_image
# Plot the normalized raster image
plot(normalized_image, main = "Normalized Raster Image (0 to 1)")
# Merge the raster images 
extent(kmeans_raster) <- extent(normalized_image)
merged_raster <- overlay(kmeans_raster, normalized_image, fun = max)
plot(merged_raster, main = "Merge Raster Image")
#
# Insert gamma noise
#
L <- 3
sum_img_pixels1 <- cellStats(merged_raster==1, sum)
sum_img_pixels2 <- cellStats(merged_raster==2, sum)
sum_img_pixels3 <- cellStats(merged_raster==3, sum)
sum_img_pixels4 <- cellStats(merged_raster==4, sum)
sum_img_road    <- cellStats(merged_raster==5, sum)
#
SARclass1 <- rGI0(sum_img_pixels1, a= -2, g= 2, L)
SARclass2 <- rGI0(sum_img_pixels2, a= -4,  g= 4, L)
SARclass3 <- rgammaSAR(sum_img_pixels3, L, 50)
SARclass4 <- rgammaSAR(sum_img_pixels4, L, 200)
SARroad   <- rgammaSAR(sum_img_road, L, 10)
#
SAR <- merged_raster
SAR[merged_raster==1] <- SARclass1
SAR[merged_raster==2] <- SARclass2
SAR[merged_raster==3] <- SARclass3
SAR[merged_raster==4] <- SARclass4
SAR[merged_raster==5] <- SARroad
plot(SAR, main = "Noise")
#
EQSAR <- equalize_ecdf(SAR)
plot(EQSAR, main = "Noise equalized")
#
plot(EQSAR, col=c("lightyellow", "green", "blue", "black"), main = "Noise equalized 1")
#
grayscale_palette <- gray.colors(4, start = 0, end = 1)
plot(EQSAR, col = grayscale_palette, main = "Raster Image with 4 Grayscale Colors")
#
# Densities Validation
x <- seq(.001, 400, by=.01)
d3 <- dgammaSAR(x, L, 150)
d4 <- dgammaSAR(x, L, 200)

DensitiesSAR2.melt <-
  melt(data=data.frame(x, d3, d4), measure.vars=-1)
names(DensitiesSAR2.melt) <- c("x", "Distr", "Density")

#p1 <- ggplot(DensitiesSAR2.melt, aes(x=x, y=Density, col=Distr)) + 
#  geom_line(size=2, alpha=.7) +
#  theme_few(base_size = 30) +
#  theme(legend.position="top",
#        legend.margin=margin(t = 0, unit='cm'))
#print(p1) 