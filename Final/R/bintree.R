


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

pop <- function(obj,row = 1) {
  UseMethod("pop", obj)
}

pop.bintree <- function(obj,row = 1){

  left <- obj$tree[row,2]

  # This will only trigger if the head node has no left node
  if(is.na(left) && row == 1){
    # Move value and pointers of right node to head node
    right <- obj$tree[row,3]
    obj$tree[row,1:3] <- obj$tree[right,1:3]
    return(obj)
  }

  # If left node has no left node, then delete left node. We are looking at the
  #   left node pointer of the current node's left node here (e.g. if 5 has 2 as
  #   it's left node, we would be looking at 2's left node)
  if(is.na(obj$tree[left,2])){
    # Current node's left pointer becomes deleted nodes right pointer
    obj$tree[row,2] <- obj$tree[left,3]
    return(obj)
  }

  return(obj <- pop.bintree(obj,left))
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
print("Pushing 5")
t <- push(t, 5)
print("Pushing 3")
t <- push(t, 3)
print("Pushing 6")
t <- push(t, 6)
print("Pushing 2")
t <- push(t, 2)
print("Pushing 4")
t <- push(t, 4)
print("Popping (2 should be gone)")
t <- pop(t)
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
print("Popping (3 should be gone)")
t <- pop(t)
print(t)
print("Popping (4 should be gone)")
t <- pop(t)
print(t)
print("Popping (5 should be gone, 6 should be head)")
t <- pop(t)
print(t)
print("Pushing 2")
t <- push(t,2)
print("Popping (2 should be gone)")
t <- pop(t)
print(t)
print("Popping (6 should be gone, 10 should be head)")
t <- pop(t)
print(t)
print("Popping (7 should be gone)")
t <- pop(t)
print(t)
print("Popping (10 should be gone, 11 should be head)")
t <- pop(t)
print(t)
print( "Popping (11 should be gone, 100 should be head)")
t <- pop(t)
print(t)
print("Popping 100")
t <- pop(t)

print(t)
