findNeighSNWE <- function(i, j, n){
  # Find neighbors (s, n, w, e) of the (i,j)-th site of an n by n grid
  if (i < 1 | j < 1){
    print("The indexes i or j must be less than 1.")
    stop("Error")
  }
  if (i > n | j > n){
    print("The indexes i or j must be great than n.")
    stop("Error")
  }
  if (i == 1){
    if (j == 1) {
      M = matrix(c(1, 1, 2, 1, 2, 1), nrow = n - 2, ncol = 2)
    } 
    else if (j == n) {
      M = matrix(c(1, 1, 2, n, n - 1, n), nrow = n - 2, ncol = 2)
    } 
    else {
      M = matrix(c(1, 1, 1, 2, j, j - 1 , j + 1, j ), nrow = n - 1, ncol = 2)
    }
  }
  else if(i == n){
    if (j == 1) {
      M = matrix(c(n, n, n - 1, 1, 2, 1), nrow = n - 2, ncol = 2)
    } 
    else if (j == n) {
      M = matrix(c(n, n, n - 1 , n, n - 1, n), nrow = n - 2, ncol = 2)
    } 
    else {
      M = matrix(c(n, n, n, n - 1,   j, j - 1 , j + 1, j ), nrow = n - 1, ncol = 2)
    }
  }
  else{
    if (j == 1) {
      M = matrix(c(i, i, i - 1, i + 1, j, j + 1, j, j), nrow = n - 1, ncol = 2)
    } 
    else if (j == n) {
      M = matrix(c(i, i, i + 1, i - 1, n, n - 1, n, n), nrow = n - 1, ncol = 2)
    } 
    else {
      M = matrix(c(i, i, i, i + 1, i - 1,   j, j - 1 , j + 1, j, j), nrow = n, ncol = 2)
    }
  }
}