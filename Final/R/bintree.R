

bintree <- function() {
    arg <- list(tree = matrix(, ncol = 3))
    
    attr(arg, "class") <- "bintree"
    arg
}


push <- function(obj, value, row = 1) {
    UseMethod("push", obj)
}

push.bintree <- function(obj, value, row = 1) {
    modifyMatrix <-  function (row, col, value) {
        newIndex <- nrow(obj$tree) + 1
        obj$tree[row, col] <<- newIndex
        obj$tree <<- rbind(obj$tree, c(NA, NA, NA))
        obj$tree[newIndex, 1] <<- value
    }
    
    
    # check whether first index is NA
    if (is.na(obj$tree[row, 1])) {
        obj$tree[row, 1] <- value
        return(obj)
    }
    
    
    if (obj$tree[row, 1] > value) {
        if (is.na(obj$tree[row, 2])) {
            modifyMatrix(row, 2, value)
            return(obj)
        } else{
            obj <- push(obj, value, obj$tree[row, 2])
        }
    } else if (obj$tree[row, 1] <= value) {
        if (is.na(obj$tree[row, 3])) {
            modifyMatrix(row, 3, value)
            return(obj)
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

print(t$tree)
