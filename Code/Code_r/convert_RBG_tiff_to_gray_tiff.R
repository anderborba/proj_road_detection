library(raster)
# Set seed value
set.seed(1234)
image <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
# Convert the image to grayscale by averaging the RGB channels
grayscale_image <- calc(image, fun = function(x) rowMeans(x, na.rm = TRUE))
# Save the grayscale image
writeRaster(grayscale_image, "../../Data/road_optical/jpeg/27028720_15_gray.tiff", format = "GTiff", overwrite = TRUE)