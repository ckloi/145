


Queue <- function()
{
    
    args <- list(
    arr <- vector(length=0)
    )
    
    ## Set the name for the class
    
    
    class(args) <- append(class(args),"Queue")
    
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

print <- function(obj){
  UseMethod("print",obj)
}

push.Queue <- function(obj, newValue)
{
    obj$arr <- c(obj$arr, newValue)
    return(obj)
}

pop.Queue <- function(obj)
{
    obj$arr <- obj$arr[-1]
    return (obj)
}

print.Queue <- function(obj){
  print(obj$arr)
}


v <- Queue()

v <- push(v,1)
v <- push(v,2)
v <- push(v,3)
v <- push(v,4)
v <- push(v,5)
v <- push(v,6)
v <- push(v,7)

v <- pop(v)
print(v)
