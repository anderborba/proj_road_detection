matrix_replicate <- function(matrix, rep){
  d <- dim(matrix)
  nrow <- d[1]
  ncol <- d[2]
  n <- d[1] * rep
  m <- d[2] * rep
  mask  <- matrix(0,n,m)
  for(i in 1: nrow){
    for(j in 1: ncol){
      for(k in 1: rep){
        for(l in 1: rep){
          id <- (i - 1) * rep
          jd <- (j - 1) * rep
          mask[id + k, jd + l] <- matrix[i, j]
        }
      }
    }
  }
  return(mask)
}