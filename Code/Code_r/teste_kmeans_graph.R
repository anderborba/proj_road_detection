require(graphics)

# a 2-dimensional example
x <- rbind(matrix(rnorm(100, sd = 0.3), ncol = 2),
           matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2))
colnames(x) <- c("x", "y")
n <- 5
(cl <- kmeans(x, n))
plot(x, col = cl$cluster)
points(cl$centers, col = 1:2, pch = 8, cex = 2)
#
#fitted.x <- fitted(cl); 
#head(fitted.x)
#resid.x <- x - fitted(cl)
