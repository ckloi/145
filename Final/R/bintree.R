


newbintree <- function() {
  rtrn <- list()
  rtrn$tree <- rbind(c(NA,NA,NA))
  class(rtrn) <- "bintree"
  return(rtrn)
}

push.bintree <- function(obj, value, row = 1) {
  # Check if first value is NA. If it is, place the value to be pushed in column 1
  #   Only triggers on first push
  if(is.na(obj$tree[1,1])){
    obj$tree[1,1] <- value
    return(obj)
  }

  nextIndex <- nrow(obj$tree) + 1
  # If value to insert is less than current value, follow left pointer (column 2)
  if(value <= obj$tree[row,1]) {
    # If left pointer is NA, insert value at next row, with pointers of NA
    if(is.na(obj$tree[row,2])) {
      obj$tree[row,2] <- nextIndex
      obj$tree <- rbind(obj$tree, c(value,NA,NA))
      return(obj)
    }
    # Otherwise recursively call on left node to find the right index
    row <- obj$tree[row,2]
    return(push(obj,value,row))
  }

  # If value to be pushed is greater than current value, follow right pointer
  #   (column 3)
  if(value > obj$tree[row,1]) {
    # If right pointer is NA, make it nextIndex and add new row with value and
    #   NA indices
    if(is.na(obj$tree[row,3])) {
      obj$tree[row,3] <- nextIndex
      obj$tree <- rbind(obj$tree, c(value,NA,NA))
      return(obj)
    }
    # Otherwise, recursively call on right pointer to find appropriate index
    row <- obj$tree[row,3]
    return(push(obj,value,row))
  }
  return(obj)
}

pop.bintree <- function(obj,row = 1){
  # Check if head is the leftmost node
  if(is.na(obj$tree[1,2])){
    right <- obj$tree[row,3]
    obj$tree[row,] <- obj$tree[right,]
    return (obj)
  }

  # Look ahead one node to the left. If that node's left pointer is NA, pop that
  #   node (change left pointer of current node to right node of child, which
  #   will either be an index or NA)
  left <- obj$tree[row,2]
  if(is.na(obj$tree[left,2])){
    obj$tree[row,2] <- obj$tree[left,3]
    return(obj)
  }
  # If not at leftmost node, recurse until you are
  return(pop(obj,left))
}


print.bintree <- function(obj, row=1){
    # Print left subtree
    left <- obj$tree[row,2]
    if(!is.na(left)){
        print.bintree(obj,left)
    }

    # Print your value
    if(!is.na(obj$tree[row,1])){
      cat(obj$tree[row,1], " ")
    }

    # Print right subtree
    right <- obj$tree[row,3]
    if(!is.na(right)){
        print.bintree(obj,right)
    }
    # Print newline once done
    if(row == 1){
      cat('\n')
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
print(t)
print("Popping (100 should be gone)")
t <- pop(t)
print(t)
print("Pushing 2")
t <- push(t,2)
print(t)
