require(bayesImageS)
require(tiff)
require(reshape)
source("GammaSAR.R")
source("imagematrix.R")

MedianFilter <- function(y, s) {
  
  m <- dim(y)[1]
  n <- dim(y)[2]
  
  # Space for the output
  z <- y
  
  # Lazo de cálculo
  margen <- (s+1)/2
  margenm1 <- margen-1
  for(k in margen:(m-margen)) {
    for(ele in margen:(n-margen)) {
      
      valores <- as.vector(y[(k-margenm1):(k+margenm1), 
                             (ele-margenm1):(ele+margenm1)])
      
      z[k,ele] = median(valores)
    }
  }
  
  return(z)
}

### Example of simulation of a MRF
set.seed(12345)
par(mfrow = c(1, 2))

### This is the image size
mask <- matrix(1,512,512)
### This is the neighborhood
neigh <- getNeighbors(mask, c(2,2,0,0))
blocks <- getBlocks(mask, 2)
### This is the number of classes and the parameter set to the transition
k <- 3
beta <- log(1+sqrt(k))
res.sw <- swNoData(beta, k, neigh, blocks, niter=100)
### This is the output matrix
z <- matrix(max.col(res.sw$z)[1:nrow(neigh)], nrow=nrow(mask))
filtered.z <- MedianFilter(z, 21)

plot(imagematrix(equalize(z)))
plot(imagematrix(equalize(filtered.z)))

