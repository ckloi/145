


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
    
    
    # check whether first index is NA
    if (is.na(obj$tree[row, 1])) {
        obj$tree[row, 1] <- value
        # check if first index is not NA, then check the value is less than to or greater than
        # if first index is less than or equal to
    } else if (value <= obj$tree[row, 1]) {
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




t <- bintree()
t <- push(t, 5)
t <- push(t, 3)
t <- push(t, 6)
t <- push(t, 2)
t <- push(t, 10)
t <- push(t, 11)
t <- push(t, 100)
t <- push(t, -22)



print(t$tree)
