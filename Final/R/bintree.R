bintree <- function(){
  args <- list(
    tree <- matrix(NA,3,1)
  )

  class(args) <- c(class(args), "bintree")
  return(args)
}

push.bintree <- function(obj, value, col=1){
  # If head value is NA, just assign value to head value
  if(col == 1 && obj$tree[1,1] == NA){
    obj$tree[1,1] <- value
    return(obj$tree)
  }
  nextCol <- ncol(obj$tree) + 1
  # Go left
  if(value <= obj$tree[1,col]){
    # If current node's left index is blank, assign it to the next column number
    #   to be created and create the column with values: 'value', NA, NA
    if(obj$tree[2,col] == NA){
      obj$tree[2,col] <- nextCol
      nextCol <- nextCol + 1
      obj$tree <- cbind(obj$tree, c(value,NA,NA))
      return(obj$tree)
    }
    # Otherwise, next index is the value at row 2 so recursively call with that index
    nextIndex <- obj$tree[2,col]
    obj$tree <- push.bintree(obj,value,nextIndex)
    return(obj$tree)
  }

  # Go right
  if(value > obj$tree[1,col]){
    # If current node's right index is blank, assign it to the next column number
    #   to be created and create the column with values: 'value', NA, NA
    if(obj$tree[3,col] == NA){
      obj$tree[3,col] <- nextCol
      nextCol <- nextCol + 1
      obj$tree <- cbind(obj$tree, c(value,NA,NA))
      return(obj$tree)
    }
    # Otherwise, next index is the value at row 3 so recursively call with that index
    nextIndex <- obj$tree[3,col]
    obj$tree <- push.bintree(obj, value, nextIndex)
    return(obj$tree)
  }
}

pop.bintree(obj,value,col=1){
  # Look at your left index's value
  leftIndex <- obj$tree[2,col]
  # If value to pop is equal to left inex's value, your left index becomes your
  #   left index's right index
  if(value == obj$tree[1,leftIndex]){
    obj$tree[2,col] <- obj$tree[3,leftIndex]
    return(obj$tree)
  }
  obj$tree <- pop.bintree(obj,value,leftIndex)
  return(obj$tree)
}
