rm(list=ls())
#
library("nat")
library("Matrix")
library("pracma")
#
source("findNeighSNWE.R")
#
n <- 5              # Size of square lattice 
N <- 40              # Number of Gibbs steps
nels <- n*(5*n-4)    # Number of ones in psi_ij
beta <- 0.8    
print(nels)
#
a <- rep(0,nels)   # Preallocation of memory
b <- rep(0,nels)
c <- rep(0,nels)
#
k <- 0
for(i in 1:n){
  for(j in 1:n){
    A = findNeighSNWE(i, j, n)   
    dime =dim(A)
    n_neigh = dime[1]
    for(h in 1:n_neigh){
      a[k + h] <- sub2ind(c(n, n), c(j, i))
      b[k + h] <- sub2ind(c(n, n), c(A[h, 2], A[h, 1]))
      c[k + h] <- 1.0
    }
    k = k + n_neigh
  }
}
Psi <- sparseMatrix(i = a, j = b, x = c)
K <- 3 # Number of color
x = ceil(rand(1,n^2)*K)
za <- seq(n^2)
zb <- seq(n^2)
zc <- rep(0, n^2)
#
for(iter in 1:N){
  print(iter)
  B <- sparseMatrix(i = za, j = zb, x = zc)
  for(i in 1:n^2){
    neighbors_of_i <- which(Psi[i,] != 0)
    for(k in neighbors_of_i){
      if (i < k){
        B[i, k] <- (rand(1)  < (1 - exp(-beta))*(x[i]==x[k]));
        B[k, i] <- B[i, k] 
      }
    }
  }
  #
  
}