


newstack <- function()
{

    rtrn <- list()
    rtrn$arr <- NA
    ## Set the name for the class

    class(rtrn) <- "stack"

    return(rtrn)
}

push <- function(obj, newValue){
  UseMethod("push", obj)
}

pop <- function(obj){
  UseMethod("pop", obj)
}

push.stack <- function(obj, newValue)
{
    if(is.na(obj$arr[1])){
      obj$arr[1] <- newValue
      return(obj)
    }
    obj$arr <- c(obj$arr, newValue)
    return(obj)
}

pop.stack <- function(obj)
{
    val <- obj$arr[length(obj$arr)]
    obj$arr <- obj$arr[-length(obj$arr)]
    return(val)
}

print.stack <- function(obj){
  if(!NA %in% obj$arr){
    cat(obj$arr, "\n")
  }
}


# v <- newstack()
#
# v <- push(v,1)
# v <- push(v,2)
# v <- push(v,3)
# v <- push(v,4)
# v <- push(v,5)
# v <- push(v,6)
# v <- push(v,7)
# pop(v)
# print(v)
