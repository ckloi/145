


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
        
        newIndex <- NA
        # if lower two row is not created , then create two new row
        if (row + 2 > nrow(obj$tree)){
             obj$tree <- rbind(obj$tree, c(NA, NA, NA))
             obj$tree <- rbind(obj$tree, c(NA, NA, NA))
        }
        # search for lower 2 unused row
        # if left child start from row + 1
        # if right child start from row + 2
        for (i in  (row + col - 1):nrow(obj$tree)){
            if (is.na(obj$tree[i,1])){
                newIndex <- i
                break
            }
        }
        
        # if cannot find lower 2 unused row , then append to the end of the matrix
        if (is.na(newIndex)){
            newIndex <- nrow(obj$tree) + 1
        }
        
        if (newIndex > nrow(obj$tree)){
            obj$tree <- rbind(obj$tree, c(NA, NA, NA))
        }
        
        obj$tree[row, col] <- newIndex
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


print.bintree <- function(obj, row=1){
  # Print left subtree
  left <- obj$tree[row,2]
  if(!is.na(left)){
    print.bintree(obj,left)
  }

  # Print your value
  print(obj$tree[row,1])

  # Print right subtree
  right <- obj$tree[row,3]
  if(!is.na(right)){
    print.bintree(obj,right)
  }
}


t <- bintree()
print("Pushing 2")
t <- push(t, 2)
print("Pushing 4")
t <- push(t, 4)
t <- pop(t)
print("Popping (2 should be gone)")
print(t)
print("Pushing 10")
t <- push(t, 10)
print("Pushing 7")
t <- push(t, 7)
print("Pushing 1")
t <- push(t, 1)
print("Pushing 11")
t <- push(t, 11)
print("Popping (1 should be gone)")
t <- pop(t)
print(t)
print("Pushing 100")
t <- push(t, 100)
print("Popping (4 should be gone)")
t <- pop(t)
print(t)
print("Popping (7 should be gone)")
t <- pop(t)
print(t)
print("Popping (10 should be gone, 11 should be head)")
t <- pop(t)
print(t)
print("Pushing 2")
t <- push(t,2)
print("Popping (2 should be gone)")
t <- pop(t)
print(t)
print("Popping (11 should be gone, 100 should be head)")
t <- pop(t)
print(t$tree)
print("Popping (100 should be gone)")
t <- pop(t)
print(t)

