build_potts_matrix_crop <- function(nKerFilter, dimg, niter, k, nKerPotts){
# Paramters (Flags)  
# nKerFilter - kernel dimension to median filters
# dimg  - Dimension to cropped image
# niter - Iteration number to Potts method
# k - number of the classes defined
# nKerPotts - kernel dimension to Potts 
#
# Variables inside the function
# nimg - Dimension to image build by Potts method
#
  nImg <- dimg + 2 * nKerFilter
  mask <- matrix(1, nImg, nImg)
  neigh <- getNeighbors(mask, c(nKerPotts,nKerPotts,0,0))
  blocks <- getBlocks(mask, nKerPotts)
  #
  beta <- log(1+sqrt(k))
  res.sw <- swNoData(beta, k, neigh, blocks, niter)
  Img <- matrix(max.col(res.sw$z)[1:nrow(neigh)], nrow=nrow(mask))
  ImgFiltered <- MedianFilter(Img, nKerFilter)
  CropImg <- matrix(0, dimg, dimg)
  CropImgFiltered <- matrix(0, dimg, dimg)
  #
  for (i in 1:dimg){
    id <- i + nKerFilter
    for (j in 1:dimg){
      jd <- j + nKerFilter
      CropImg[i, j] <- Img[id, jd]
      CropImgFiltered[i, j] <- ImgFiltered[id, jd]
    }
  }
  MatRet <- list(CropImg, CropImgFiltered)
  return(MatRet)
}
