


Stack <- function()
{
    
    args <- list(
    arr <- vector(length=0)
    )
    
    ## Set the name for the class
    
    
    class(args) <- append(class(args),"Stack")
    
    return(args)
}


push <- function(obj, newValue)
{
    UseMethod("push",obj)
}

pop <- function(obj)
{
    UseMethod("pop",obj)
}


push.Stack <- function(obj, newValue)
{
    obj$arr <- c(obj$arr, newValue)
    return(obj)
}

pop.Stack <- function(obj)
{
    obj$arr <- obj$arr[-length(obj$arr)]
    return(obj)
}




v <- Stack()

v <- push(v,1)
v <- push(v,2)
v <- push(v,3)
v <- push(v,4)
v <- push(v,5)
v <- push(v,6)
v <- push(v,7)
v <- pop(v)
