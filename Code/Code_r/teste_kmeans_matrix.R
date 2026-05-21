library(jpeg)
library(ggplot2)
library(raster)
library(magick)
library(gridExtra)
#
#image <- stack("../../Data/road_optical/jpeg/27028720_15.jpeg")
#image <- stack("../../Data/road_optical/jpeg/27028720_15.tiff")
image <- image_read("../../Data/road_optical/jpeg/27028720_15.tiff")
#image <- stack("../../Data/SAR/campan_10501_15033_007_150402_L090_CX_01_pauli.tif")
#
# Converta a imagem para escala de cinza
GIMG <- image_convert(image, colorspace = "gray")
#
# Salve a imagem em escala de cinza
#image_write(imagem_cinza, path = "caminho/para/sua/imagem_cinza.tiff")
# Converta as imagens para objetos raster
raster_original <- as.raster(image)
raster_cinza <- as.raster(GIMG)
#GIMG <- as.integer(image_data(GIMG))

# Crie os gráficos das imagens
plot_original <- grid::rasterGrob(raster_original, interpolate = FALSE)
plot_cinza <- grid::rasterGrob(raster_cinza, interpolate = FALSE)

# Combine os gráficos lado a lado
grid.arrange(plot_original, plot_cinza, ncol = 2, top = "Comparação de Imagens")
#
# Run K-Means clustering
n <- 2
kMeansResult <- kmeans(raster_cinza, centers=n)
# Convert image data to raster object
#result <- raster(GIMG)

# Set cluster values
result <- setValues(raster_cinza, kMeansResult$cluster)
#
plot(result)
