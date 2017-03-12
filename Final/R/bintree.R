


bintree <- function() {
  arg <- list(tree = matrix(, ncol = 3))
  
  attr(arg, "class") <- "bintree"
  arg
}


push <- function(obj, value, row = 1) {
  UseMethod("push", obj)
}

push.bintree <- function(obj, value, row = 1) {
  
  modifyMatrix <-  function (obj, row, col, value) {
    newIndex <- nrow(obj$tree) + 1
    obj$tree[row, col] <- newIndex
    if (newIndex > nrow(obj$tree)){
      obj$tree <- rbind(obj$tree, c(NA, NA, NA))
    }
    obj$tree[newIndex, 1] <- value
    return(obj)
  }
  
  
  # check whether head is NA
  if (is.na(obj$tree[1, 1])) {
    obj$tree[1, 1] <- value
    return(obj)
  } 
  
  # if first index is less than or equal to
  if (value <= obj$tree[row, 1]) {
    # if left child is na , set it
    if (is.na(obj$tree[row, 2])) {
      obj <- modifyMatrix(obj, row, 2, value)
    } else{
      # if left child is not na, then find the index recusively
      obj <- push(obj, value, obj$tree[row, 2])
    }
    # if first index is greater tha, the similar approach as above
  } else if (value > obj$tree[row, 1]) {
    if (is.na(obj$tree[row, 3])) {
      obj <- modifyMatrix(obj, row, 3, value)
    } else{
      obj <- push(obj, value, obj$tree[row, 3])
    }
  }
  
  return (obj)
  
}

pop <- function(obj,row = 1,crow = 1) {
  UseMethod("pop", obj)
}

pop.bintree <- function(obj,row = 1,crow = 1){
  #if the head is now na
  if(is.na(obj$tree[row,1])){
    
  }
  #there is no more left child
  if(is.na(obj$tree[row,2])){
    
    obj$tree[row,1]  <- NA
    
    if (row == 1){
      if (!is.na(obj$tree[row,3])){
        rightchildIndex  <- obj$tree[row,3]
        obj$tree[row,] <- obj$tree[rightchildIndex,]
        obj$tree[rightchildIndex,] <- NA
        return(obj)
      }
      
    }
    
    
    if(!is.na(obj$tree[row,3])){
      obj$tree[crow,2] <- obj$tree[row,3]
      obj$tree[row, 3] <- NA
      
    }else{
      
      obj$tree[crow,2] <- NA
    }
    #obj$tree <- rbind(obj$tree,c(NA,NA,NA))
  }else{
    #there is left chile
    #current row of the node that have left child
    crow <- row
    obj <- pop(obj,obj$tree[row,2],crow)
  }
  return(obj)
}

print <- function(obj){
  UseMethod("print", obj)
}
print.bintree <- function(obj){
  print(obj$tree)
}



t <- bintree()
t <- push(t, 5)
t <- push(t, 3)
t <- push(t, 6)
t <- push(t, 2)
t <- push(t, 4)
t <- pop(t)
t <- push(t, 10)
t <- push(t, 7)
t <- push(t, 1)
t <- push(t, 11)
print(t)
t <- pop(t)
print(t)
t <- push(t, 100)
t <- pop(t)
t <- pop(t)
print(t)
t <- pop(t)
t <- push(t,2)

print(t)