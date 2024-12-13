rm(list=ls())
library("nat")
source("findNeighSNWE.R")
source("clust.R")
source("rlang")
#
s <- findNeighSNWE(3,3,5)
print(s)
v <- sub2ind(c(5, 5), c(3, 3))
cat(v)
set.seed(1)
n=50
x <- sample(seq(100), n)
y <- sample(seq(100), n)
z <- runif(n)
#cbind(x,y,z)

library(Matrix)
s.mat <- sparseMatrix(i=x, j=y, x=z)
dim(s.mat)
print(dim)
dim <- clust(s)
cat(dim)