library(ggplot2)
library(raster)
library(invgamma)
source("GammaSAR.R")
source("imagematrix.R")

set.seed(1234)
image     <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
image_map <- stack("../../Data/road_optical/jpeg/27028720_15_map.tiff")

# Convert to grayscale
grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
dev.new()
plot(grayscale_image)

# Convert road map to single-band grayscale
image_map_gray <- calc(image_map, fun = function(x) mean(x, na.rm = TRUE))
image_map_gray <- flip(image_map_gray, direction = "y")
dev.new()
plot(image_map_gray)
# K-means clustering
n            <- 4
kMeansResult <- kmeans(grayscale_image[], centers = n)
centers      <- kMeansResult$centers
cat("K centers:", centers, "\n")

# Build class mask and raster
kmeans_mask   <- matrix(kMeansResult$cluster, nrow = nrow(grayscale_image), ncol = ncol(grayscale_image))
kmeans_raster <- raster(t(kmeans_mask))

# Normalize road map and merge (roads become class n+1)
normalized_image      <- (n + 1) * (image_map_gray / 255)
extent(kmeans_raster) <- extent(normalized_image)
merged_raster         <- overlay(kmeans_raster, normalized_image, fun = function(a, b) pmax(a, b))

# Parameters per class: 2 GI0 classes and 2 gamma classes
L <- 3
class_params <- list(
  list(model = "GI0",   a = -15, g =  140),  # classe 1: GI0 heterogenea
  list(model = "GI0",   a =  -5, g =  280),  # classe 2: GI0 moderada
  list(model = "gamma", mean = 250),          # classe 3: gamma media
  list(model = "gamma", mean =  50)           # classe 4: gamma escura
)

# Count pixels and generate SAR noise for each class i in 1:n
sum_pixels <- vector("list", n)
SAR_noise  <- vector("list", n)

for (i in 1:n) {
  sum_pixels[[i]] <- cellStats(merged_raster == i, sum)
  p <- class_params[[i]]
  if (p$model == "GI0") {
    SAR_noise[[i]] <- rGI0(sum_pixels[[i]], a = p$a, g = p$g, L)
  } else {
    SAR_noise[[i]] <- rgammaSAR(sum_pixels[[i]], L, p$mean)
  }
}

# Road class (n+1)
sum_road <- cellStats(merged_raster == (n + 1), sum)
SAR_road <- rgammaSAR(sum_road, L, 10)

# Build SAR image: assign noise per class i in 1:n
SAR <- merged_raster
for (i in 1:n) {
  SAR[merged_raster == i] <- SAR_noise[[i]]
}
SAR[merged_raster == (n + 1)] <- SAR_road
#
EQSAR <- equalize_ecdf(SAR)
# Visualization
grayscale_palette <- gray.colors(256, start = 0, end = 1)
dev.new()
plot(SAR,   col = grayscale_palette, main = "Raw Data")
dev.new()
plot(EQSAR, col = grayscale_palette, main = "Raster Image: 4 classes (2 GI0 + 2 Gamma)")
#
