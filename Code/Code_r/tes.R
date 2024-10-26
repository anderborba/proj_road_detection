# Swendsen-Wang for a 2x2 lattice
n <- matrix(c(5,2,5,3,  1,5,5,4,  5,4,1,5,  3,5,2,5), nrow=4, ncol=4, byrow=TRUE)
b <- list(c(1,4), c(2,3))
r.sw <- swNoData(0.7, 3, n, b, niter=200)
r.sw$z
r.sw$sum[200]